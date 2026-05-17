# Today Poor

Flutter 기반 개인 지출 관리 앱입니다. 하루 예산, 월 예산 사용률, 최근 지출 기록을 중심으로 빠르게 확장할 수 있도록 기본 구조를 잡아두었습니다.

## Project Structure

```text
lib/
  app/                         # 앱 진입점, 라우팅/테마 연결
  core/theme/                  # 공통 디자인 토큰과 테마
  features/home/presentation/  # 홈 화면 UI
```

## Commands

```sh
flutter pub get
flutter analyze
flutter test
flutter run
```

## Notes

Flutter 생성 중 Java와 Gradle 버전 호환 경고가 표시되었습니다. Android 빌드에서 문제가 나면 Java 17 이상 25 미만 버전을 Flutter JDK로 지정하거나 Gradle wrapper 버전을 맞춰야 합니다.
