import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/constants/firestore_paths.dart';
import '../core/providers/firebase_providers.dart';
import '../models/user.dart';
import '../models/user_role.dart';

part 'auth_service.g.dart';

@riverpod
AuthService authService(Ref ref) {
  return AuthService(
    auth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firestoreProvider),
  );
}

class AuthService {
  final firebase_auth.FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthService({
    required firebase_auth.FirebaseAuth auth,
    required FirebaseFirestore firestore,
  }) : _auth = auth,
       _firestore = firestore;

  // 현재 로그인된 사용자
  firebase_auth.User? get currentUser => _auth.currentUser;

  // 인증 상태 스트림
  Stream<firebase_auth.User?> get authStateChanges => _auth.authStateChanges();

  // 회원가입
  Future<User> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    // 1. Firebase Auth 계정 생성
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user!.uid;
    final now = DateTime.now();

    // 2. User 모델 생성
    final user = User(
      id: uid,
      name: name,
      phone: phone,
      email: email,
      role: UserRole.member,
      createdAt: now,
      updatedAt: now,
    );

    // 3. Firestore에 User 문서 저장
    await _firestore
        .collection(FirestorePaths.users)
        .doc(uid)
        .set(user.toJson());

    // 4. 이메일 인증 발송
    await credential.user!.sendEmailVerification();

    return user;
  }

  /// 로그인
  /// 보안: Firebase의 구체적인 에러 메시지를 일반화하여 공격자에게 힌트를 주지 않음
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw Exception('로그인에 실패했습니다');
      }

      // Firestore에서 사용자 정보 가져오기
      final doc = await _firestore
          .collection(FirestorePaths.users)
          .doc(credential.user!.uid)
          .get();

      if (!doc.exists) {
        // 계정은 있지만 Firestore에 데이터가 없는 경우 (비정상 상태)
        await _auth.signOut();
        throw Exception('사용자 정보를 찾을 수 없습니다. 관리자에게 문의하세요.');
      }

      return User.fromJson(doc.data()!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      // 보안: 구체적인 에러 코드를 일반화된 메시지로 변환
      // 공격자가 "이메일이 존재하는지" 또는 "비밀번호가 틀린지" 알 수 없도록 함
      switch (e.code) {
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-email':
        case 'invalid-credential':
          throw Exception('이메일 또는 비밀번호가 올바르지 않습니다');
        case 'user-disabled':
          throw Exception('비활성화된 계정입니다. 관리자에게 문의하세요.');
        case 'too-many-requests':
          throw Exception('로그인 시도가 너무 많습니다. 잠시 후 다시 시도해주세요.');
        default:
          throw Exception('로그인에 실패했습니다. 다시 시도해주세요.');
      }
    }
  }

  // 로그아웃
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// 이메일 인증 여부 확인
  bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;

  /// 이메일 인증 재발송
  Future<void> resendEmailVerification() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  /// 사용자 정보 새로고침 (이메일 인증 상태 업데이트용)
  Future<void> reloadUser() async {
    await _auth.currentUser?.reload();
  }
}
