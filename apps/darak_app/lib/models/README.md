# Darak 데이터 모델 사용 가이드

이 폴더는 Darak 프로젝트의 모든 데이터 모델을 포함합니다.

## 📋 모델 목록

### 1. User (사용자)
- **파일**: [user.dart](user.dart)
- **설명**: 교회 구성원 정보 관리
- **역할**: UserRole enum (순원, 순장, 마을장, 사역자 등)

### 2. Group (다락방)
- **파일**: [group.dart](group.dart)
- **설명**: 다락방/소그룹 정보 관리

### 3. Village (마을)
- **파일**: [village.dart](village.dart)
- **설명**: 마을 단위 그룹 관리

### 4. Club (동아리/소속)
- **파일**: [club.dart](club.dart)
- **설명**: 찬양팀, 주교부 등 동아리 관리
- **상태**: ClubStatus enum (대기, 승인, 거부)

### 5. MeetUp (번개)
- **파일**: [meetup.dart](meetup.dart)
- **설명**: 임시 모임 관리

### 6. Note (메모)
- **파일**: [note.dart](note.dart)
- **설명**: 사용자별 메모/특이사항 관리

### 7. Attendance (출석)
- **파일**: [attendance.dart](attendance.dart)
- **설명**: 출석 체크 기록 관리
- **유형**: AttendanceType enum (주일예배, 다락방, 수요기도회 등)
- **상태**: AttendanceStatus enum (출석, 결석, 지각, 사유결석)

---

## 🔧 사용 예제

### 1. User 모델 생성

```dart
import 'package:darak_app/models/user.dart';
import 'package:darak_app/models/user_role.dart';

void createUser() {
  final user = User(
    id: 'user-001',
    name: '홍길동',
    phone: '010-1234-5678',
    email: 'hong@example.com',
    role: UserRole.member,
    birthDate: DateTime(1990, 5, 15),
    registerDate: DateTime(2024, 1, 1),
    groupId: 'group-001',
    clubIds: ['club-001', 'club-002'],
    profileImageUrl: 'https://example.com/profile.jpg',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  print('User created: ${user.name}, Role: ${user.role}');
}
```

### 2. User 모델 복사 (copyWith)

```dart
void updateUser(User user) {
  // 이메일만 업데이트
  final updatedUser = user.copyWith(
    email: 'newemail@example.com',
    updatedAt: DateTime.now(),
  );

  print('Updated email: ${updatedUser.email}');
}
```

### 3. JSON 직렬화/역직렬화

```dart
void jsonExample(User user) {
  // User 객체를 JSON으로 변환
  final json = user.toJson();
  print('User JSON: $json');

  // JSON을 User 객체로 변환
  final userFromJson = User.fromJson(json);
  print('User from JSON: ${userFromJson.name}');
}
```

### 4. Attendance 생성 예제

```dart
import 'package:darak_app/models/attendance.dart';
import 'package:darak_app/models/attendance_type.dart';
import 'package:darak_app/models/attendance_status.dart';

void createAttendance() {
  final attendance = Attendance(
    id: 'attendance-001',
    userId: 'user-001',
    type: AttendanceType.sundayService,
    date: DateTime.now(),
    status: AttendanceStatus.present,
    note: null,
    groupId: null,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  print('Attendance: ${attendance.status} on ${attendance.date}');
}
```

### 5. Group 생성 예제

```dart
import 'package:darak_app/models/group.dart';

void createGroup() {
  final group = Group(
    id: 'group-001',
    name: '청년 1다락방',
    leaderId: 'user-002',
    memberIds: ['user-001', 'user-003', 'user-004'],
    villageId: 'village-001',
    description: '청년들의 다락방입니다',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  print('Group: ${group.name}, Members: ${group.memberIds?.length ?? 0}');
}
```

### 6. Club 승인 상태 관리

```dart
import 'package:darak_app/models/club.dart';
import 'package:darak_app/models/club_status.dart';

void manageClub(Club club) {
  // 클럽 승인
  final approvedClub = club.copyWith(
    status: ClubStatus.approved,
    updatedAt: DateTime.now(),
  );

  print('Club status: ${approvedClub.status}');
}
```

### 7. Note 추가 예제

```dart
import 'package:darak_app/models/note.dart';

void createNote() {
  final note = Note(
    id: 'note-001',
    userId: 'user-001',
    content: '이번 주 결석 사유: 출장',
    createdBy: 'user-002', // 순장이 작성
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  print('Note: ${note.content}');
}
```

### 8. Soft Delete (삭제 표시)

```dart
void softDeleteUser(User user) {
  // 실제 삭제하지 않고 deletedAt 필드만 설정
  final deletedUser = user.copyWith(
    deletedAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  print('User soft deleted at: ${deletedUser.deletedAt}');
}

void restoreUser(User user) {
  // 삭제 취소
  final restoredUser = user.copyWith(
    deletedAt: null,
    updatedAt: DateTime.now(),
  );

  print('User restored');
}
```

---

## 🔄 코드 재생성

모델 파일을 수정한 후에는 반드시 build_runner를 실행하여 코드를 재생성해야 합니다:

```bash
cd apps/darak_app
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 🚨 주의사항

1. **자동 생성 파일 수정 금지**
   - `.freezed.dart`, `.g.dart` 파일은 절대 직접 수정하지 마세요
   - 모델 수정 후 build_runner 재실행 필요

2. **Null Safety**
   - `?`가 붙은 필드는 optional (null 가능)
   - `required` 키워드가 있는 필드는 필수값

3. **DateTime vs Timestamp**
   - Dart 코드에서는 `DateTime` 사용
   - Firebase Firestore 저장 시 자동으로 `Timestamp`로 변환됨

4. **List 필드 제한**
   - Firebase Firestore 배열 필드는 최대 1MB 크기 제한
   - 너무 많은 ID를 배열에 저장하지 말 것 (대신 쿼리 사용)

5. **Soft Delete 활용**
   - `deletedAt` 필드로 삭제 표시
   - 실제 데이터 삭제 전 복구 가능
   - Firestore 쿼리 시 `deletedAt == null` 조건 추가

---

## 📚 참고 자료

- [Freezed 공식 문서](https://pub.dev/packages/freezed)
- [json_serializable 가이드](https://pub.dev/packages/json_serializable)
- [Firebase Firestore 데이터 모델링](https://firebase.google.com/docs/firestore/data-model)

---

**모델 사용 중 문제가 발생하면 언제든지 물어보세요!** 🚀
