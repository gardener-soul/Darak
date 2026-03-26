import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
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

@riverpod
Stream<firebase_auth.User?> authStateChanges(Ref ref) {
  return ref.watch(authServiceProvider).authStateChanges;
}

class AuthService {
  final firebase_auth.FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthService({
    required firebase_auth.FirebaseAuth auth,
    required FirebaseFirestore firestore,
  }) : _auth = auth,
       _firestore = firestore;

  firebase_auth.User? get currentUser => _auth.currentUser;
  Stream<firebase_auth.User?> get authStateChanges => _auth.authStateChanges();
  bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;

  // ─── 이메일 회원가입 ─────────────────────────────────────
  Future<User> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // H-06: credential.user null 가드 — Firebase Auth 내부 오류 시 크래시 방지
    final firebaseUser = credential.user;
    if (firebaseUser == null) throw Exception('계정 생성에 실패했습니다.');

    await firebaseUser.updateDisplayName(name);

    final uid = firebaseUser.uid;
    final now = DateTime.now();

    final user = User(
      id: uid,
      name: name,
      phone: phone,
      email: email,
      role: UserRole.member,
      createdAt: now,
      updatedAt: now,
    );

    await _firestore
        .collection(FirestorePaths.users)
        .doc(uid)
        .set(user.toJson());

    await firebaseUser.sendEmailVerification();

    return user;
  }

  // ─── 이메일 로그인 ───────────────────────────────────────
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

      if (!credential.user!.emailVerified) {
        throw Exception('email-not-verified');
      }

      final doc = await _firestore
          .collection(FirestorePaths.users)
          .doc(credential.user!.uid)
          .get();

      if (!doc.exists) {
        // 데이터 정합성 문제 해결: Auth에는 있지만 Firestore에 없는 경우 복구
        final now = DateTime.now();
        final newUser = User(
          id: credential.user!.uid,
          name: credential.user!.displayName ?? '복구된 사용자', // 이름 정보가 없을 수 있음
          email: credential.user!.email ?? '',
          phone: '', // 전화번호는 다시 받아야 함
          role: UserRole.member,
          createdAt: now,
          updatedAt: now,
        );

        await _firestore
            .collection(FirestorePaths.users)
            .doc(credential.user!.uid)
            .set(newUser.toJson());

        return newUser;
      }

      return User.fromJson(_fromFirestore(doc.data()!));
    } on firebase_auth.FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw Exception('가입되지 않은 이메일입니다.');
        case 'wrong-password':
          throw Exception('비밀번호가 일치하지 않습니다.');
        case 'invalid-email':
          throw Exception('유효하지 않은 이메일 형식입니다.');
        case 'invalid-credential':
          throw Exception('인증 정보가 올바르지 않습니다.');
        case 'user-disabled':
          throw Exception('비활성화된 계정입니다. 관리자에게 문의하세요.');
        case 'too-many-requests':
          throw Exception('너무 많은 시도가 있었습니다. 잠시 후 다시 시도해주세요.');
        default:
          throw Exception('로그인에 실패했습니다. (${e.code})');
      }
    } catch (e) {
      if (e.toString().contains('email-not-verified')) rethrow;
      throw Exception('로그인 중 오류가 발생했습니다: $e');
    }
  }

  // ─── 구글 로그인 ─────────────────────────────────────────
  Future<User?> signInWithGoogle() async {
    try {
      // 1. 구글 인증 흐름 시작 (필요할 때 인스턴스 생성)
      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null; // 사용자 취소

      // 2. 구글 인증 정보 획득
      final googleAuth = await googleUser.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 3. Firebase Auth 로그인
      final userCredential = await _auth.signInWithCredential(credential);
      final firebaseUser = userCredential.user!;
      final uid = firebaseUser.uid;

      // 4. Firestore 사용자 확인
      final doc = await _firestore
          .collection(FirestorePaths.users)
          .doc(uid)
          .get();

      if (!doc.exists) {
        // 5. 신규 사용자 생성
        final now = DateTime.now();
        final newUser = User(
          id: uid,
          name: firebaseUser.displayName ?? '이름 없음',
          email: firebaseUser.email ?? '',
          phone: firebaseUser.phoneNumber ?? '',
          role: UserRole.member,
          createdAt: now,
          updatedAt: now,
        );
        await _firestore
            .collection(FirestorePaths.users)
            .doc(uid)
            .set(newUser.toJson());
        return newUser;
      }

      // 6. 성공 시 사용자 정보 갱신 (중요: AuthWrapper 감지용)
      await firebaseUser.reload();
      return User.fromJson(_fromFirestore(doc.data()!));
    } catch (e) {
      throw Exception('구글 로그인 실패: $e');
    }
  }

  // ─── Timestamp 변환 헬퍼 ──────────────────────────────────
  /// Firestore Timestamp → ISO8601 String 변환
  /// user.g.dart의 fromJson은 String 타입의 날짜를 기대하므로 변환이 필요합니다.
  Map<String, dynamic> _fromFirestore(Map<String, dynamic> data) {
    return {
      ...data,
      'createdAt': _toIso8601(data['createdAt']),
      'updatedAt': _toIso8601(data['updatedAt']),
      if (data['birthDate'] != null) 'birthDate': _toIso8601(data['birthDate']),
      if (data['registerDate'] != null)
        'registerDate': _toIso8601(data['registerDate']),
      if (data['deletedAt'] != null) 'deletedAt': _toIso8601(data['deletedAt']),
    };
  }

  String _toIso8601(dynamic value) {
    if (value is Timestamp) return value.toDate().toIso8601String();
    if (value is String) return value;
    return DateTime.now().toIso8601String();
  }

  // ─── 로그아웃 ────────────────────────────────────────────
  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();
  }

  // ─── 이메일 인증 ─────────────────────────────────────────
  Future<void> resendEmailVerification() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<void> reloadUser() async {
    await _auth.currentUser?.reload();
  }
}
