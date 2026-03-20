import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/constants/firestore_paths.dart';
import '../core/providers/firebase_providers.dart';
import '../models/church_role.dart';

part 'church_role_repository.g.dart';

/// Firestore `churches/{churchId}/roles` 서브컬렉션 전담 Repository
@riverpod
ChurchRoleRepository churchRoleRepository(Ref ref) {
  return ChurchRoleRepository(firestore: ref.watch(firestoreProvider));
}

class ChurchRoleRepository {
  final FirebaseFirestore _firestore;

  ChurchRoleRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  // ─── 역할 목록 실시간 스트림 ────────────────────────────────
  /// [churchId] 교회의 역할 목록을 level 순으로 실시간 구독합니다.
  Stream<List<ChurchRole>> watchRoles({required String churchId}) {
    return _firestore
        .collection(FirestorePaths.churchRoles(churchId))
        .orderBy('level')
        .snapshots()
        .map(
          (snap) => snap.docs
              .map(
                (doc) => ChurchRole.fromJson(
                  _fromFirestore({...doc.data(), 'id': doc.id}),
                ),
              )
              .toList(),
        );
  }

  // ─── 역할 목록 단순 조회 ────────────────────────────────────
  /// [churchId] 교회의 역할 목록을 level 순으로 한 번 조회합니다.
  Future<List<ChurchRole>> getRoles({required String churchId}) async {
    try {
      final snap = await _firestore
          .collection(FirestorePaths.churchRoles(churchId))
          .orderBy('level')
          .get();
      return snap.docs
          .map(
            (doc) => ChurchRole.fromJson(
              _fromFirestore({...doc.data(), 'id': doc.id}),
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('역할 목록 조회에 실패했습니다: $e');
    }
  }

  // ─── 기본 역할 시드 (교회 최초 생성 시 1회 호출) ──────────────
  /// 교회 생성 직후 기본 4개 역할을 Batch로 한 번에 생성합니다.
  /// 이미 존재하는 역할은 덮어씁니다 (set 사용).
  Future<void> seedDefaultRoles({required String churchId}) async {
    try {
      final now = DateTime.now().toIso8601String();
      final roles = <Map<String, dynamic>>[
        {
          'id': 'member',
          'name': '순원',
          'level': 1,
          'permissions': ['read_church_info', 'read_own_group'],
          'isDefault': true,
          'createdAt': now,
          'updatedAt': now,
        },
        {
          'id': 'group_leader',
          'name': '순장',
          'level': 2,
          'permissions': [
            'read_members_same_village',
            'create_group',
            'invite_member',
          ],
          'isDefault': true,
          'createdAt': now,
          'updatedAt': now,
        },
        {
          'id': 'village_leader',
          'name': '마을장',
          'level': 3,
          'permissions': [
            'read_members_same_village',
            'create_village',
            'create_group',
            'invite_member',
          ],
          'isDefault': true,
          'createdAt': now,
          'updatedAt': now,
        },
        {
          'id': 'minister',
          'name': '사역자',
          'level': 4,
          'permissions': [
            'read_all_members',
            'create_village',
            'create_group',
            'invite_member',
            'manage_schedule',
          ],
          'isDefault': true,
          'createdAt': now,
          'updatedAt': now,
        },
      ];
      final batch = _firestore.batch();
      for (final role in roles) {
        batch.set(
          _firestore
              .collection(FirestorePaths.churchRoles(churchId))
              .doc(role['id'] as String),
          role,
        );
      }
      await batch.commit();
    } catch (e) {
      throw Exception('기본 역할 생성에 실패했습니다: $e');
    }
  }

  // ─── 역할 이름 변경 ─────────────────────────────────────────
  /// [roleId] 역할의 표시 이름을 [newName]으로 변경합니다.
  /// 저장 전 trim() 처리로 앞뒤 공백이 포함된 이름 저장을 방지합니다.
  Future<void> updateRoleName({
    required String churchId,
    required String roleId,
    required String newName,
  }) async {
    final sanitizedName = newName.trim();
    if (sanitizedName.isEmpty) {
      throw Exception('역할 이름은 비워둘 수 없습니다.');
    }
    try {
      await _firestore
          .collection(FirestorePaths.churchRoles(churchId))
          .doc(roleId)
          .update({
        'name': sanitizedName,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('역할 이름 변경에 실패했습니다: $e');
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
