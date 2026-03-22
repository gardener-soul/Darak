import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/constants/firestore_paths.dart';
import '../core/providers/firebase_providers.dart';
import '../core/utils/input_sanitizer.dart';
import '../models/member_note.dart';

part 'member_note_repository.g.dart';

@riverpod
MemberNoteRepository memberNoteRepository(Ref ref) {
  return MemberNoteRepository(firestore: ref.watch(firestoreProvider));
}

/// users/{userId}/notes/ 서브컬렉션 전담 Repository
/// 순장이 순원에 대해 작성하는 비공개 메모 CRUD 처리
class MemberNoteRepository {
  final FirebaseFirestore _firestore;

  MemberNoteRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference<Map<String, dynamic>> _notesRef(String userId) =>
      _firestore.collection(FirestorePaths.userNotes(userId));

  // ─── 비공개 메모 실시간 스트림 ──────────────────────────────────
  /// deletedAt == null인 메모를 createdAt DESC로 정렬하여 실시간 구독합니다.
  /// MVP 단계에서는 클라이언트 사이드 Soft Delete 필터를 적용합니다.
  Stream<List<MemberNote>> watchNotes(String userId) {
    return _notesRef(userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => MemberNote.fromJson(_fromFirestore(doc.data(), doc.id)))
              .where((n) => n.deletedAt == null) // 클라이언트 사이드 Soft Delete 필터
              .toList(),
        );
  }

  // ─── 메모 생성 ────────────────────────────────────────────────
  /// 새 메모 문서를 Firestore에 생성합니다.
  /// [content]는 최대 500자로 sanitize됩니다.
  Future<void> createNote({
    required String userId,
    required String content,
    required String createdBy,
  }) async {
    try {
      final docRef = _notesRef(userId).doc();
      await docRef.set({
        'id': docRef.id,
        'userId': userId,
        'content': sanitizeInput(content, maxLength: 500),
        'createdBy': createdBy,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        // deletedAt: null → 저장하지 않음 (isNull 쿼리 호환)
      });
    } on FirebaseException catch (e) {
      throw Exception('메모 저장에 실패했습니다: ${e.message}');
    } catch (e) {
      throw Exception('메모 저장에 실패했습니다: $e');
    }
  }

  // ─── 메모 수정 ────────────────────────────────────────────────
  /// 기존 메모의 content를 업데이트합니다.
  /// 본인이 작성한 메모만 수정 가능 (Security Rules에서 강제).
  Future<void> updateNote({
    required String userId,
    required String noteId,
    required String content,
  }) async {
    try {
      await _notesRef(userId).doc(noteId).update({
        'content': sanitizeInput(content, maxLength: 500),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw Exception('메모 수정에 실패했습니다: ${e.message}');
    } catch (e) {
      throw Exception('메모 수정에 실패했습니다: $e');
    }
  }

  // ─── 메모 Soft Delete ─────────────────────────────────────────
  /// deletedAt 필드를 서버 타임스탬프로 설정하여 논리 삭제합니다.
  Future<void> softDeleteNote({
    required String userId,
    required String noteId,
  }) async {
    try {
      await _notesRef(userId).doc(noteId).update({
        'deletedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw Exception('메모 삭제에 실패했습니다: ${e.message}');
    } catch (e) {
      throw Exception('메모 삭제에 실패했습니다: $e');
    }
  }

  // ─── 내부 헬퍼: Timestamp → ISO 8601 변환 ──────────────────────
  Map<String, dynamic> _fromFirestore(Map<String, dynamic> data, String docId) {
    return {
      ...data,
      'id': docId,
      // null은 그대로 null로 전달 — serverTimestamp() 대기 상태를 모델이 그대로 수용
      if (_toIso8601(data['createdAt']) != null)
        'createdAt': _toIso8601(data['createdAt']),
      if (_toIso8601(data['updatedAt']) != null)
        'updatedAt': _toIso8601(data['updatedAt']),
      if (data['deletedAt'] != null) 'deletedAt': _toIso8601(data['deletedAt']),
    };
  }

  /// Firestore 타임스탬프를 ISO 8601 문자열로 변환합니다.
  /// serverTimestamp() 저장 직후 null이 내려올 수 있으므로 null을 그대로 반환합니다.
  /// 현재 시각으로 임의 대체하면 데이터 오염이 발생합니다.
  String? _toIso8601(dynamic value) {
    if (value is Timestamp) return value.toDate().toIso8601String();
    if (value is String) return value;
    return null; // serverTimestamp() 대기 중 — null 안전 처리
  }
}
