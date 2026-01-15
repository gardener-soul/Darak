# Darak 프로젝트 진행 상황

## 📅 최종 업데이트: 2026-01-15

---

## ✅ 완료된 작업 (Step 1~2)

### 1. 프로젝트 초기 설정
- [x] Git 저장소 초기화
- [x] Flutter SDK 설치 (C:\flutter)
- [x] 모노레포 폴더 구조 설계

### 2. Flutter 프로젝트 생성
- [x] `apps/darak_app` 프로젝트 생성
- [x] 플랫폼 설정: Web, Android, iOS
- [x] 프로젝트 설명 한글화

### 3. 필수 패키지 설치
- [x] **상태 관리**: flutter_riverpod ^2.5.1, riverpod_annotation ^2.3.5
- [x] **네비게이션**: go_router ^14.2.7
- [x] **데이터 모델링**: freezed_annotation ^2.4.4, json_annotation ^4.9.0
- [x] **Code Generation**: build_runner, riverpod_generator, freezed, json_serializable
- [x] **UI/UX**: flutter_localizations, intl
- [ ] **Firebase**: 버전 호환 문제로 보류 (나중에 추가 예정)

### 4. 기본 앱 UI 구현
- [x] Riverpod ProviderScope 설정
- [x] Material 3 디자인 테마 적용
- [x] 홈 화면 구현 (교회 아이콘, 4가지 기능 소개 카드)
- [x] 한글 주석 작성

### 5. 프로젝트 설정 파일
- [x] .gitignore 생성 (Flutter, Firebase, IDE 설정 포함)
- [x] pubspec.yaml 설정 완료

### 6. 실행 확인
- [x] Chrome 웹 브라우저에서 앱 실행 성공

---

## 📁 현재 프로젝트 구조

```
Darak/
├── .git/                           # Git 저장소
├── .gitignore                      # Git 무시 파일
├── README.md                       # 프로젝트 소개
├── PROJECT_STATUS.md               # 이 파일 (진행 상황)
│
└── apps/
    └── darak_app/                  # Flutter 앱
        ├── lib/
        │   └── main.dart           # 메인 앱 코드
        ├── web/                    # 웹 플랫폼 설정
        ├── android/                # 안드로이드 플랫폼 설정
        ├── ios/                    # iOS 플랫폼 설정
        ├── test/                   # 테스트 파일
        ├── pubspec.yaml            # 패키지 의존성
        ├── analysis_options.yaml   # Dart 분석 옵션
        └── README.md               # Flutter 프로젝트 설명
```

---

## 🎯 다음 단계 (우선순위 순)

### Step 3: 데이터 모델 구현 (Freezed)

#### 3.1 User 모델 생성
- [ ] `lib/models/user.dart` 파일 생성
- [ ] Freezed를 사용한 User 클래스 정의
- [ ] 필드 정의:
  - `id`: 사용자 고유 ID
  - `name`: 이름
  - `email`: 이메일
  - `phone`: 전화번호
  - `role`: 역할 (순원, 순장, 관리자)
  - `birthDate`: 생년월일
  - `joinDate`: 등록일
  - `groupId`: 소속 다락방 ID
- [ ] `build_runner` 실행으로 코드 생성

#### 3.2 Attendance 모델 생성
- [ ] `lib/models/attendance.dart` 파일 생성
- [ ] Freezed를 사용한 Attendance 클래스 정의
- [ ] 필드 정의:
  - `id`: 출석 기록 ID
  - `userId`: 사용자 ID
  - `attendanceType`: 출석 유형 (주일예배, 다락방)
  - `date`: 날짜
  - `status`: 상태 (출석, 결석, 지각)
  - `note`: 비고
- [ ] `build_runner` 실행으로 코드 생성

#### 3.3 추가 모델 (선택)
- [ ] `Group` 모델 (다락방/소그룹)
- [ ] `Prayer` 모델 (기도 제목)
- [ ] `Event` 모델 (행사/알림)
- [ ] `DevotionalRecord` 모델 (경건생활 기록)

---

### Step 4: Firebase 설정

#### 4.1 Firebase 프로젝트 생성
- [ ] Firebase Console에서 프로젝트 생성
- [ ] 웹 앱 추가
- [ ] Android 앱 추가 (나중에)
- [ ] iOS 앱 추가 (나중에)

#### 4.2 FlutterFire CLI 설정
- [ ] FlutterFire CLI 설치: `dart pub global activate flutterfire_cli`
- [ ] `flutterfire configure` 실행
- [ ] `firebase_options.dart` 자동 생성

#### 4.3 Firebase 패키지 추가
- [ ] pubspec.yaml에 Firebase 패키지 추가 (버전 확인 후)
  - firebase_core
  - firebase_auth
  - firebase_firestore
  - firebase_storage
  - firebase_messaging
- [ ] `main.dart`에 Firebase 초기화 코드 추가

#### 4.4 Firestore 데이터베이스 스키마 설계
- [ ] Collections 구조 정의:
  - `users` - 사용자 정보
  - `attendances` - 출석 기록
  - `groups` - 다락방/소그룹
  - `prayers` - 기도 제목
  - `events` - 행사/알림
- [ ] Firestore Rules 작성 (보안 규칙)
- [ ] Indexes 설정 (복합 쿼리용)

---

### Step 5: MVVM 폴더 구조 구축

#### 5.1 폴더 생성
```
lib/
├── app/                    # 앱 레벨 설정
│   ├── app.dart
│   └── theme.dart
├── core/                   # 공통 유틸리티
│   ├── constants/
│   ├── utils/
│   └── providers/
├── models/                 # 데이터 모델 (Freezed)
├── repositories/           # 데이터 레이어
├── services/               # Firebase 서비스
├── viewmodels/             # 비즈니스 로직 (Riverpod)
└── views/                  # UI (화면)
    ├── home/
    ├── auth/
    ├── attendance/
    └── common/
```

#### 5.2 각 레이어 구현
- [ ] **Services**: Firebase와 직접 통신하는 서비스 클래스
- [ ] **Repositories**: 데이터 소스 추상화
- [ ] **ViewModels**: Riverpod Provider로 상태 관리
- [ ] **Views**: UI 화면 구현

---

### Step 6: 인증 기능 구현

#### 6.1 Firebase Authentication 설정
- [ ] Firebase Console에서 이메일/비밀번호 인증 활성화
- [ ] Google 로그인 설정 (선택)

#### 6.2 AuthService 구현
- [ ] `lib/services/auth_service.dart` 생성
- [ ] 로그인, 로그아웃, 회원가입 메서드

#### 6.3 로그인 화면 구현
- [ ] `lib/views/auth/login_screen.dart`
- [ ] 이메일/비밀번호 입력 폼
- [ ] 로그인 버튼, 회원가입 링크

#### 6.4 AuthViewModel 구현
- [ ] Riverpod Provider로 인증 상태 관리
- [ ] 로그인 상태에 따른 화면 분기

---

### Step 7: 주요 기능 구현

#### 7.1 출석 체크 기능
- [ ] 출석 체크 화면 UI
- [ ] Firestore에 출석 데이터 저장
- [ ] 출석 이력 조회

#### 7.2 사용자 관리
- [ ] 순원 목록 화면
- [ ] 순원 상세 정보 화면
- [ ] 순원 추가/수정/삭제

#### 7.3 경건 생활 기록
- [ ] QT 기록 화면
- [ ] 기도 제목 작성/공유

#### 7.4 행사/알림
- [ ] 행사 목록 화면
- [ ] Push 알림 설정

---

## 🚀 실행 방법

### 웹 브라우저에서 실행
```bash
cd apps/darak_app
flutter run -d chrome
```

### Android 에뮬레이터에서 실행
```bash
flutter run -d android
```

### Hot Reload
앱 실행 중:
- **r** - Hot Reload (빠른 UI 업데이트)
- **R** - Hot Restart (앱 재시작)
- **q** - 앱 종료

---

## 📚 기술 스택

### Frontend
- **Framework**: Flutter 3.38.6
- **Language**: Dart 3.10.7
- **State Management**: Riverpod (Code Generation)
- **Navigation**: go_router
- **Data Modeling**: Freezed, json_serializable

### Backend
- **BaaS**: Firebase
  - Authentication (인증)
  - Firestore (데이터베이스)
  - Storage (파일 저장소)
  - Cloud Messaging (푸시 알림)

### Architecture
- **Pattern**: MVVM (Model-View-ViewModel)
- **Repository Pattern**: 데이터 레이어 추상화

---

## 📝 참고 문서

### Flutter 공식 문서
- [Flutter 시작하기](https://docs.flutter.dev/get-started)
- [Flutter 위젯 카탈로그](https://docs.flutter.dev/ui/widgets)

### 패키지 문서
- [Riverpod 공식 문서](https://riverpod.dev/)
- [Freezed 사용법](https://pub.dev/packages/freezed)
- [go_router 가이드](https://pub.dev/packages/go_router)

### Firebase 문서
- [FlutterFire 공식 문서](https://firebase.flutter.dev/)
- [Firestore 데이터 모델링](https://firebase.google.com/docs/firestore/data-model)

---

## ⚠️ 주의사항

1. **Firebase 패키지**: 현재 버전 호환 문제로 주석 처리됨. FlutterFire CLI로 설정 시 자동으로 호환 버전 추가됨
2. **코드 생성**: Freezed, Riverpod 사용 시 `flutter pub run build_runner build` 실행 필요
3. **웹 제약사항**: 일부 네이티브 기능은 웹에서 동작하지 않음 (카메라, Bluetooth 등)

---

## 🐛 알려진 이슈

- Firebase 패키지 버전 호환 문제 (해결 방법: FlutterFire CLI 사용)

---

## 💡 다음 작업 시작 방법

**Step 3부터 시작하려면:**
1. User 모델 생성
2. Attendance 모델 생성
3. `flutter pub run build_runner build --delete-conflicting-outputs` 실행
4. 생성된 `.freezed.dart`, `.g.dart` 파일 확인

**Firebase 연동부터 시작하려면:**
1. Firebase Console에서 프로젝트 생성
2. FlutterFire CLI 설치 및 설정
3. pubspec.yaml에 Firebase 패키지 추가
4. Firebase 초기화 코드 작성

---

**질문이나 도움이 필요하면 언제든지 물어보세요!** 🚀
