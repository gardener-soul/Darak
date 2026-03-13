import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/constants/firestore_paths.dart';
import '../core/providers/firebase_providers.dart';
import '../models/announcement.dart';

part 'announcement_repository.g.dart';

/// Firestore `churches/{churchId}/announcements` 서브컬렉션 전담 Repository
@riverpod
AnnouncementRepository announcementRepository(Ref ref) {
  return AnnouncementRepository(firestore: ref.watch(firestoreProvider));
}

class AnnouncementRepository {
  final FirebaseFirestore _firestore;

  AnnouncementRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  // ─── 최근 공지사항 실시간 스트림 ────────────────────────────
  /// 삭제되지 않은 공지사항을 고정 여부 → 최신순으로 [limit]개 실시간 구독합니다.
  /// 홈 화면 미리보기 등에서 활용합니다.
  Stream<List<Announcement>> watchRecentAnnouncements({
    required String churchId,
    int limit = 3,
  }) {
    return _firestore
        .collection(FirestorePaths.churchAnnouncements(churchId))
        .where('deletedAt', isNull: true)
        .orderBy('isPinned', descending: true)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map(
                (doc) => Announcement.fromJson(
                  _fromFirestore({...doc.data(), 'id': doc.id}),
                ),
              )
              .toList(),
        )
        // Firestore 에러 발생 시 빈 리스트를 반환하여 스트림이 끊기지 않도록 방어
        .handleError((Object _) => <Announcement>[]);
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
