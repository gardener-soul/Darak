import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/constants/firestore_paths.dart';
import '../core/providers/firebase_providers.dart';
import '../models/village.dart';

part 'village_repository.g.dart';

/// Firestore `villages` 컬렉션 전담 Repository
@riverpod
VillageRepository villageRepository(Ref ref) {
  return VillageRepository(firestore: ref.watch(firestoreProvider));
}

class VillageRepository {
  final FirebaseFirestore _firestore;

  VillageRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  // ─── 교회별 마을 목록 실시간 스트림 ───────────────────────────
  /// [churchId] 교회에 속한 마을 목록을 실시간으로 구독합니다.
  /// Soft Delete된 마을은 제외합니다.
  Stream<List<Village>> watchVillagesByChurch({required String churchId}) {
    return _firestore
        .collection(FirestorePaths.villages)
        .where('churchId', isEqualTo: churchId)
        .where('deletedAt', isNull: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map(
                (doc) => Village.fromJson(
                  _fromFirestore({...doc.data(), 'id': doc.id}),
                ),
              )
              .toList(),
        );
  }

  // ─── 마을 생성 ───────────────────────────────────────────────
  /// 새 마을 문서를 Firestore에 생성합니다.
  /// [village.churchId]가 null이면 예외를 던집니다.
  Future<void> createVillage({required Village village}) async {
    try {
      if (village.churchId == null) throw Exception('churchId는 필수입니다.');
      final doc = _firestore.collection(FirestorePaths.villages).doc();
      final data = village.toJson();
      data['id'] = doc.id;
      // DateTime → ISO 8601 문자열 변환 (Freezed toJson은 DateTime 그대로 반환)
      data['createdAt'] = village.createdAt.toIso8601String();
      data['updatedAt'] = village.updatedAt.toIso8601String();
      if (village.deletedAt != null) {
        data['deletedAt'] = village.deletedAt!.toIso8601String();
      }
      await doc.set(data);
    } catch (e) {
      throw Exception('마을 생성에 실패했습니다: $e');
    }
  }

  // ─── Firestore 날짜 타입 변환 헬퍼 ─────────────────────────
  /// Timestamp → ISO 8601 문자열로 변환하여 Freezed 모델과의 호환성 확보
  Map<String, dynamic> _fromFirestore(Map<String, dynamic> data) {
    return data.map((key, value) {
      if (value is Timestamp) {
        return MapEntry(key, value.toDate().toIso8601String());
      }
      return MapEntry(key, value);
    });
  }
}
