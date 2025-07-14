# Cherrypic

cherrypic 소개

<br>

## 📂 프로젝트 구조

```
lib/
├── core/               # 공통 유틸, 상수, 테마, DI 등
├── data/               # API 통신, 모델 DTO, 데이터 소스
├── domain/ (필요시)      # Entity 및 Repository 인터페이스
├── presentation/       # UI, ViewModel, 상태 관리
│   ├── screens/        # 각 화면 별 View + ViewModel
│   └── widgets/        # 공통 위젯
└── main.dart           # 앱 진입점
```

<br>

## 🧱 기술 스택

### 🚀 Framework & Language

-   **Flutter**: Cross-platform UI 프레임워크
-   **Dart**: 메인 프로그래밍 언어

### 🧩 Architecture

-   **MVVM**: Model - View - ViewModel 아키텍처 패턴
-   **Provider**: 상태 관리 (ViewModel 주입 및 변경 감지)

### 🌐 Networking

-   **Dio**: API 통신 및 멀티파트 이미지 업로드

### 📱 Routing

-   **go_router**: 화면 라우팅 및 딥링크 지원

### 🖼 이미지 처리

-   **photo_manager**: 갤러리 접근 및 다중 이미지 선택
-   **flutter_image_compress**: 이미지 서버 업로드 전 압축 처리
-   **cached_network_image**: 서버 이미지 캐싱 및 로딩 최적화

<br>

## ⚙️ 설치 및 실행

```bash
# 의존성 설치
flutter pub get

# 앱 실행 (기기 선택 후)
flutter run
```

<br>

## ✅ 커밋 컨벤션

-   `feat`: 새로운 기능 추가
-   `fix`: 버그 수정
-   `refactor`: 리팩토링
-   `chore`: 빌드, 설정 관련 변경
-   `docs`: 문서 변경

예시:

```bash
[#이슈번호] 타입: 커밋 메시지 요약
```

<br>

## 📌 기타

-   `.env`, `secrets.dart` 등 민감한 정보는 업로드 금지
-   코드 포맷팅은 [Flutter 공식 포맷](https://dart.dev/tools/dart-format) 기준 사용
