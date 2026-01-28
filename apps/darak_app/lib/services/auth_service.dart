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
  })  : _auth = auth,
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

    return user;
  }

  // 로그아웃
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
