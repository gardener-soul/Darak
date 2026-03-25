import 'dart:async';
import 'dart:math' show min;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/constants/firestore_paths.dart';
import '../core/providers/firebase_providers.dart';
import '../models/feed/encouragement.dart';
import '../models/feed/feed.dart';
import '../models/feed/feed_content_type.dart';
import '../models/feed/feed_visibility.dart';
import '../models/feed/reaction_type.dart';

part 'feed_repository.g.dart';

@riverpod
FeedRepository feedRepository(Ref ref) {
  return FeedRepository(firestore: ref.watch(firestoreProvider));
}

/// feeds 컬렉션 CRUD + 타임라인 쿼리 + 반응 원자적 업데이트 전담 Repository
class FeedRepository {
  final FirebaseFirestore _firestore;

  FeedRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection(FirestorePaths.feeds);

  CollectionReference<Map<String, dynamic>> _encouragementsCol(String feedId) =>
      _firestore.collection(FirestorePaths.feedEncouragements(feedId));

  // ─── 다락방 피드 스트림 ──────────────────────────────────────────────────────

  /// 같은 다락방 교인의 최신 피드 실시간 구독
  Stream<List<Feed>> watchGroupFeeds({
    required String churchId,
    required String groupId,
    int limit = 20,
  }) {
    return _col
        .where('churchId', isEqualTo: churchId)
        .where('groupId', isEqualTo: groupId)
        .where('deletedAt', isNull: true)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(_snapToFeedList)
        .transform(_errorHandler('다락방 피드'));
  }

  /// 팔로잉 교인의 최신 피드 실시간 구독 (30개씩 청크 분할)
  Stream<List<Feed>> watchFollowingFeeds({
    required List<String> followeeIds,
    int limit = 20,
  }) {
    if (followeeIds.isEmpty) return Stream.value([]);

    final chunks = <List<String>>[];
    for (var i = 0; i < followeeIds.length; i += 30) {
      chunks.add(followeeIds.sublist(i, min(i + 30, followeeIds.length)));
    }

    final streams = chunks.map(
      (chunk) => _col
          .where('userId', whereIn: chunk)
          .where('deletedAt', isNull: true)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .snapshots()
          .map(_snapToFeedList),
    );

    if (streams.length == 1) {
      return streams.first.transform(_errorHandler('팔로잉 피드'));
    }

    return streams
        .reduce(
          (combined, stream) => combined.asyncExpand(
            (a) => stream.map(
              (b) => [...a, ...b]
                ..sort((x, y) => y.createdAt.compareTo(x.createdAt)),
            ),
          ),
        )
        .transform(_errorHandler('팔로잉 피드'));
  }

  // ─── 피드 타임라인 페이지네이션 ──────────────────────────────────────────────

  /// 다락방 피드 페이지네이션 조회
  Future<({List<Feed> feeds, DocumentSnapshot? lastDoc})> getGroupFeedPage({
    required String churchId,
    required String groupId,
    DocumentSnapshot? lastDoc,
    int pageSize = 20,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _col
          .where('churchId', isEqualTo: churchId)
          .where('groupId', isEqualTo: groupId)
          .where('deletedAt', isNull: true)
          .orderBy('createdAt', descending: true)
          .limit(pageSize);

      if (lastDoc != null) query = query.startAfterDocument(lastDoc);

      final snap = await query.get();
      return (
        feeds: _snapToFeedList(snap),
        lastDoc: snap.docs.isNotEmpty ? snap.docs.last : null,
      );
    } catch (e) {
      debugPrint('다락방 피드 페이지 조회 실패: $e');
      return (feeds: <Feed>[], lastDoc: null);
    }
  }

  /// 팔로잉 피드 페이지네이션 조회
  Future<({List<Feed> feeds, DocumentSnapshot? lastDoc})> getFollowingFeedPage({
    required List<String> followeeIds,
    DocumentSnapshot? lastDoc,
    int pageSize = 20,
  }) async {
    if (followeeIds.isEmpty) return (feeds: <Feed>[], lastDoc: null);

    try {
      final allFeeds = <Feed>[];
      DocumentSnapshot? newLastDoc;

      for (var i = 0; i < followeeIds.length; i += 30) {
        final chunk =
            followeeIds.sublist(i, min(i + 30, followeeIds.length));

        Query<Map<String, dynamic>> query = _col
            .where('userId', whereIn: chunk)
            .where('deletedAt', isNull: true)
            .orderBy('createdAt', descending: true)
            .limit(pageSize);

        if (lastDoc != null) query = query.startAfterDocument(lastDoc);

        final snap = await query.get();
        allFeeds.addAll(_snapToFeedList(snap));
        if (snap.docs.isNotEmpty) newLastDoc = snap.docs.last;
      }

      allFeeds.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return (feeds: allFeeds, lastDoc: newLastDoc);
    } catch (e) {
      debugPrint('팔로잉 피드 페이지 조회 실패: $e');
      return (feeds: <Feed>[], lastDoc: null);
    }
  }

  // ─── 내 게시물 조회 ────────────────────────────────────────────────────────

  /// 내 게시물 목록 실시간 구독 (마이페이지용)
  Stream<List<Feed>> watchMyFeeds({required String userId}) {
    return _col
        .where('userId', isEqualTo: userId)
        .where('deletedAt', isNull: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(_snapToFeedList)
        .transform(_errorHandler('내 피드'));
  }

  /// 내 게시물 수 조회 (마이페이지 통계)
  Future<int> getMyFeedCount({required String userId}) async {
    try {
      final agg = await _col
          .where('userId', isEqualTo: userId)
          .where('deletedAt', isNull: true)
          .count()
          .get();
      return agg.count ?? 0;
    } catch (e) {
      debugPrint('내 피드 수 조회 실패: $e');
      return 0;
    }
  }

  // ─── 게시물 CRUD ──────────────────────────────────────────────────────────

  /// 새 피드 게시물 생성
  Future<void> createFeed({
    required String userId,
    required String churchId,
    String? groupId,
    required FeedContentType contentType,
    required String text,
    required FeedVisibility visibility,
    String? linkedPrayerId,
  }) async {
    try {
      final docRef = _col.doc();
      final now = DateTime.now();
      final feed = Feed(
        id: docRef.id,
        userId: userId,
        churchId: churchId,
        groupId: groupId,
        contentType: contentType,
        text: text.trim(),
        visibility: visibility,
        linkedPrayerId: linkedPrayerId,
        createdAt: now,
        updatedAt: now,
      );
      final payload = _toFirestore(feed.toJson())
        ..['createdAt'] = FieldValue.serverTimestamp()
        ..['updatedAt'] = FieldValue.serverTimestamp();
      await docRef.set(payload);
    } catch (e) {
      debugPrint('피드 생성 실패: $e');
      rethrow;
    }
  }

  /// 피드 텍스트 수정 (본인만)
  Future<void> updateFeedText({
    required String feedId,
    required String text,
  }) async {
    try {
      await _col.doc(feedId).update({
        'text': text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('피드 수정 실패: $e');
      rethrow;
    }
  }

  /// 피드 Soft Delete
  Future<void> deleteFeed({required String feedId}) async {
    try {
      await _col.doc(feedId).update({
        'deletedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('피드 삭제 실패: $e');
      rethrow;
    }
  }

  /// 게시물 신고
  Future<void> reportFeed({
    required String feedId,
    required String reporterId,
  }) async {
    try {
      await _col.doc(feedId).update({
        'reportedBy': FieldValue.arrayUnion([reporterId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('피드 신고 실패: $e');
      rethrow;
    }
  }

  // ─── 반응 (Reactions) ────────────────────────────────────────────────────

  /// 반응 추가 또는 변경 (원자적 트랜잭션)
  /// - 기존 반응이 없으면 새 반응 추가
  /// - 같은 반응 재선택 시 취소
  /// - 다른 반응 선택 시 기존 반응 제거 후 새 반응 추가
  Future<void> toggleReaction({
    required String feedId,
    required String userId,
    required ReactionType reactionType,
    ReactionType? currentReactionType,
  }) async {
    try {
      final feedRef = _col.doc(feedId);
      final reactionKey = 'reactions.${reactionType.toJson()}';

      if (currentReactionType == null) {
        // 반응 없음 → 새 반응 추가
        await feedRef.update({
          reactionKey: FieldValue.arrayUnion([userId]),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else if (currentReactionType == reactionType) {
        // 같은 반응 재선택 → 취소
        await feedRef.update({
          reactionKey: FieldValue.arrayRemove([userId]),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        // 다른 반응 선택 → 기존 제거 + 새 반응 추가 (WriteBatch)
        final batch = _firestore.batch();
        final oldKey = 'reactions.${currentReactionType.toJson()}';
        batch.update(feedRef, {
          oldKey: FieldValue.arrayRemove([userId]),
          reactionKey: FieldValue.arrayUnion([userId]),
          'updatedAt': FieldValue.serverTimestamp(),
        });
        await batch.commit();
      }
    } catch (e) {
      debugPrint('반응 토글 실패: $e');
      rethrow;
    }
  }

  // ─── 격려 메시지 (Encouragements) ─────────────────────────────────────────

  /// 격려 메시지 목록 실시간 구독 (삭제된 항목 제외, 최신순)
  Stream<List<Encouragement>> watchEncouragements({required String feedId}) {
    return _encouragementsCol(feedId)
        .where('deletedAt', isNull: true)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map(
          (snap) => snap.docs.map((doc) {
            final data = Map<String, dynamic>.from(doc.data())
              ..['id'] = doc.id;
            return Encouragement.fromJson(_fromFirestore(data));
          }).toList(),
        )
        .transform(
          StreamTransformer.fromHandlers(
            handleData: (data, sink) => sink.add(data),
            handleError: (error, stackTrace, sink) {
              debugPrint('격려 메시지 로드 실패: $error');
              sink.add(<Encouragement>[]);
            },
          ),
        );
  }

  /// 격려 메시지 생성
  Future<void> createEncouragement({
    required String feedId,
    required String userId,
    required String text,
  }) async {
    try {
      final encCol = _encouragementsCol(feedId);
      final docRef = encCol.doc();
      final now = DateTime.now();
      final encouragement = Encouragement(
        id: docRef.id,
        userId: userId,
        text: text.trim(),
        createdAt: now,
      );
      final payload = _toFirestore(encouragement.toJson())
        ..['createdAt'] = FieldValue.serverTimestamp();

      // 격려 메시지 생성 + 카운트 증가를 원자적 배치로 처리
      final batch = _firestore.batch();
      batch.set(docRef, payload);
      batch.update(_col.doc(feedId), {
        'encouragementCount': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      await batch.commit();
    } catch (e) {
      debugPrint('격려 메시지 생성 실패: $e');
      rethrow;
    }
  }

  /// 격려 메시지 Soft Delete (본인만)
  Future<void> deleteEncouragement({
    required String feedId,
    required String encouragementId,
  }) async {
    try {
      // 격려 메시지 삭제 + 카운트 감소를 원자적 배치로 처리
      final batch = _firestore.batch();
      batch.update(
        _encouragementsCol(feedId).doc(encouragementId),
        {'deletedAt': FieldValue.serverTimestamp()},
      );
      batch.update(_col.doc(feedId), {
        'encouragementCount': FieldValue.increment(-1),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      await batch.commit();
    } catch (e) {
      debugPrint('격려 메시지 삭제 실패: $e');
      rethrow;
    }
  }

  // ─── 내부 헬퍼 ───────────────────────────────────────────────────────────

  static const _dateTimeFields = {
    'createdAt',
    'updatedAt',
    'deletedAt',
  };

  List<Feed> _snapToFeedList(QuerySnapshot<Map<String, dynamic>> snap) {
    return snap.docs.map((doc) {
      final data = Map<String, dynamic>.from(doc.data())..['id'] = doc.id;
      try {
        return Feed.fromJson(_fromFirestore(data));
      } catch (e) {
        debugPrint('Feed 역직렬화 실패 (${doc.id}): $e');
        rethrow;
      }
    }).toList();
  }

  /// Firestore Timestamp → ISO 8601 문자열 변환
  Map<String, dynamic> _fromFirestore(Map<String, dynamic> data) {
    return data.map((key, value) {
      if (value is Timestamp) {
        return MapEntry(key, value.toDate().toIso8601String());
      }
      // reactions Map 내부의 List<dynamic> → List<String> 변환
      if (key == 'reactions' && value is Map) {
        final reactions = <String, List<String>>{};
        value.forEach((rKey, rValue) {
          if (rValue is List) {
            reactions[rKey as String] =
                rValue.map((e) => e.toString()).toList();
          }
        });
        return MapEntry(key, reactions);
      }
      return MapEntry(key, value);
    });
  }

  /// DateTime(ISO 8601) → Firestore Timestamp 변환
  Map<String, dynamic> _toFirestore(Map<String, dynamic> data) {
    return data.map((key, value) {
      if (value is String && _dateTimeFields.contains(key)) {
        final dt = DateTime.tryParse(value);
        if (dt != null) return MapEntry(key, Timestamp.fromDate(dt));
      }
      return MapEntry(key, value);
    });
  }

  StreamTransformer<List<Feed>, List<Feed>> _errorHandler(String label) {
    return StreamTransformer.fromHandlers(
      handleData: (data, sink) => sink.add(data),
      handleError: (error, stackTrace, sink) {
        debugPrint('$label 로드 실패: $error');
        sink.add(<Feed>[]);
      },
    );
  }
}
