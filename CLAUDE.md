# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Flutter POS (Point of Sale) application for the "falsisters" business. Targets Android primarily but supports web, iOS, Windows, Linux, macOS. Landscape-only orientation with kiosk mode support.

## Common Commands

```bash
flutter pub get                          # Install dependencies
flutter analyze                          # Run linter (uses flutter_lints)
flutter test                             # Run tests
flutter run                              # Run in development
flutter build apk                        # Build Android APK
flutter pub run build_runner build       # Generate freezed models & JSON serialization
flutter pub run build_runner watch       # Watch mode for code generation
```

After modifying any `*.freezed.dart` or `*.g.dart` model, run `build_runner build` to regenerate.

## Architecture

**Pattern:** Feature-first Clean Architecture with Riverpod state management.

```
lib/
├── core/              # Shared infrastructure
│   ├── constants/     # Theme colors, app constants
│   ├── handlers/      # DioClient (singleton HTTP), secure storage, error parsing
│   ├── services/      # Cross-feature services (secure code bypass)
│   └── utils/         # Currency formatting, decimal converters, API response parsing
└── features/          # Feature modules (auth, sales, products, orders, etc.)
    └── [feature]/
        ├── data/
        │   ├── models/       # Freezed immutable data classes + JSON serialization
        │   ├── providers/    # Riverpod AsyncNotifierProviders + state classes
        │   ├── repository/   # API data access via DioClient
        │   └── services/     # Feature-specific business logic (optional)
        └── presentation/
            ├── screens/      # Page-level widgets
            └── widgets/      # Feature-scoped UI components
```

### Data Flow

Repository (Dio HTTP) → AsyncNotifier (state management) → Provider → ConsumerWidget

### Key Patterns

- **State management:** `AsyncNotifierProvider` with freezed state classes (`AsyncLoading`/`AsyncData`/`AsyncError`)
- **Data models:** All use `freezed` + `json_serializable`. Currency fields use `Decimal` type with custom `DecimalConverter`
- **HTTP client:** Singleton `DioClient` with automatic Bearer token injection from `FlutterSecureStorage` and 401 → logout handling
- **Error handling:** Centralized `parseDioError()` extracts user-friendly messages from API responses
- **Navigation:** Index-based drawer navigation via `drawerIndexProvider` on home screen (no routing library)
- **API response parsing:** `ApiResponseHandler.parseList()` handles multiple JSON response shapes

### Hardware Integration

- Thermal receipt printing via Bluetooth (`flutter_thermal_printer`) — 57mm paper, 20-byte chunked transmission
- Location services required for Bluetooth permissions
- Kiosk mode for locked retail deployment

## Environment

API base URL is configured in `.env` file and loaded via `flutter_dotenv`. JWT tokens are stored in `FlutterSecureStorage`, not SharedPreferences.
