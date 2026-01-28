import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_providers.g.dart';

/// Firestore 인스턴스 Provider
/// 앱 전체에서 동일한 Firestore 인스턴스를 공유
@riverpod
FirebaseFirestore firestore(Ref ref) {
  return FirebaseFirestore.instance;
}

/// Firebase Auth 인스턴스 Provider
/// 앱 전체에서 동일한 FirebaseAuth 인스턴스를 공유
@riverpod
FirebaseAuth firebaseAuth(Ref ref) {
  return FirebaseAuth.instance;
}

/// 현재 인증된 Firebase User 스트림 Provider
/// 인증 상태 변화를 실시간으로 감시
@riverpod
Stream<User?> authStateChanges(Ref ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return auth.authStateChanges();
}
