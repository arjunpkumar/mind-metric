# Agent.md

## Project Overview
**Name**: FlutterBase
**Description**: A robust, feature-rich Flutter application template/base designed for scalability and maintainability. It employs Clean Architecture, ensuring separation of concerns between the UI, business logic, and data layers.
**State**: Active development, with support for multiple environments (Dev, QA, Staging, Production).

## Architecture
The project follows **Clean Architecture** principles, organized into three main layers:

1.  **Presentation Layer** (`lib/src/presentation`)
    *   **Responsibility**: UI rendering and user interaction.
    *   **Components**: Widgets, Pages, Themes.
    *   **State Management**: Uses `flutter_bloc`. Pages typically consume states from BLoCs and dispatch events.
    *   **Routing**: Named routes defined in `lib/src/core/routes.dart`.

2.  **Application Layer** (`lib/src/application`)
    *   **Responsibility**: Application-specific business logic, bridging Presentation and Data.
    *   **Components**:
        *   **BLuCs**: Manage state using `flutter_bloc`.
        *   **Events/States**: Defined alongside BLoCs.
        *   **Sync Logic**: Job managers and connectivity handlers (`lib/src/application/sync`).

3.  **Data Layer** (`lib/src/data`)
    *   **Responsibility**: Data retrieval, storage, and management.
    *   **Components**:
        *   **Repositories**: Abstract business logic from data sources (e.g., `AuthRepository`).
        *   **Data Sources**: Remote (API via Dio/Rest) and Local (Drift, Hive, Secure Storage).
        *   **Models/DTOs**: Data transfer objects.

4.  **Core & Utils** (`lib/src/core`, `lib/src/utils`)
    *   **Responsibility**: Cross-cutting concerns.
    *   **Components**: Constants, initializers (`app.dart`), error handling, logging, and helpers.

## Key Technologies & Libraries
*   **Framework**: Flutter
*   **Language**: Dart
*   **State Management**: `flutter_bloc`
*   **Dependency Injection**: Manual Service Locator pattern (Global `provide...` functions in `repository_provider.dart` and `bloc_provider.dart`).
*   **Local Database**: `drift` (running in a background isolate for performance).
*   **Key-Value Storage**: `hive`, `flutter_secure_storage`.
*   **Networking**: `dio` (implied standard), `connectivity_plus`.
*   **Firebase**: Analytics, Crashlytics, Messaging, Remote Config.
*   **Navigation**: Named Routes + Deep Linking (`deeplink_handler.dart`).
*   **Environment Config**: Flavor-based (`main_dev.dart`, `main_prod.dart`, etc.).

## Project Structure
```
lib/
├── main_*.dart             # Entry points for different flavors (dev, prod, qa...)
├── config.dart             # Environment configuration
├── src/
│   ├── application/        # Business Logic (BLoCs, Sync managers)
│   ├── core/               # App initialization, routes, constants
│   ├── data/               # Repositories, DAOs, API services, Database
│   ├── presentation/       # UI Pages, Widgets, Themes
│   └── utils/              # Helpers, Error Logger, Extensions
└── ...
```

## Conventions
*   **Naming**:
    *   Files: Snake case (`home_page.dart`).
    *   Classes: Pascal case (`HomePage`).
    *   Variables/Functions: Camel case (`fetchData`).
*   **Directories**: Feature-first within presentation (e.g., `presentation/home`, `presentation/splash`), but Layer-first at the root (`application`, `data`, `presentation`).
*   **DI**: Do not use `GetIt` or `Riverpod`. Use the global `provide[RepositoryName]()` functions defined in `repository_provider.dart`.
*   **State**: Always use `BlocConsumer` or `BlocBuilder` to react to state changes.

## Development Workflows
*   **Running**: Use `flutter run -t lib/main_[flavor].dart` (e.g., `lib/main_dev.dart`).
*   **Build Scripts**: Use `scripts/build.sh` for generating binaries (APK, IPA, Web, macOS).
*   **Database**: Run `dart run build_runner build` to generate Drift files if schema changes.

## Critical Files
*   `lib/src/core/app.dart`: App entry logic and initialization (`initApp`).
*   `lib/src/core/routes.dart`: Route definitions.
*   `lib/src/data/core/repository_provider.dart`: Central DI registry.
*   `lib/src/data/database/core/app_database.dart`: Main Drift database definition.
*   `pubspec.yaml`: Dependency management.

## Custom BLoC Architecture
The project extends the standard `flutter_bloc` pattern with a custom layer to handle side effects (like toasts and navigation) and common state properties.

### Base Classes
1.  **`BaseBloc<Event, State, UIEvent>`** (`lib/src/application/core/base_bloc.dart`)
    *   Extends `Bloc<Event, State>`.
    *   **Side Effects**: Uses `rxdart`'s `PublishSubject` to handle one-off events that shouldn't be part of the persisted state:
        *   `message`: Stream<String> for showing SnackBars/Toasts using `showMessage()`.
        *   `dialogMessage`: Stream<String> for showing Alert Dialogs using `showMessageDialog()`.
        *   `eventStream`: Stream<UIEvent> for other UI-specific actions.
    *   **Lifecycle**: Includes a `dispose()` method to close these subjects.

2.  **`BaseBlocState`** (`lib/src/application/core/base_bloc_state.dart`)
    *   Base class for all BLoC states.
    *   **Common Fields**:
        *   `processState`: Enum (`ProcessState`) tracking status (initial, busy, completed, error).
        *   `isInitCompleted`: Boolean flag for initialization checks.
        *   `canPop`: Boolean to control navigation popping.

3.  **`BaseState<T>`** (`lib/src/presentation/core/base_state.dart`)
    *   Extends `State<T>` for `StatefulWidget`s.
    *   **Utilities**:
        *   `showMessage(String)`: Wraps `ScaffoldMessenger` to show SnackBars.
        *   `showMessageDialog(String)`: Helper to show application dialogs.
        *   `focusChange`: Helper to move focus between nodes.

### Usage Pattern
*   **BLoCs**: specific BLoCs extend `BaseBloc`. They emit standard state changes for UI rendering but use `showMessage` or `publish(UIEvent)` for ephemeral feedback.
*   **UI**: Pages extend `StatefulWidget` and their state extends `BaseState`. They consume the BLoC's `state` stream for building the UI and listen to `message`/`dialogMessage` streams (often via `StreamSubscription` in `initState` or `didChangeDependencies`) to trigger side effects.

## Naming Conventions
The codebase follows standard Dart/Flutter conventions with specific project-level rules:

### Classes & Types
*   **PascalCase**: Used for Classes, Enums, Mixins, and Typedefs.
    *   *Examples*: `HomePage`, `SplashBloc`, `ProcessState`, `APIEndpoints`.

### Files & Directories
*   **snake_case**: Used for all file names and directory names.
    *   *Examples*: `home_page.dart`, `app_constants.dart`, `lib/src/data/auth`.

### features & Modules
*   **snake_case**: Feature directories within `presentation` and `application` layers are named in `snake_case`.
    *   *Examples*: `web_view`, `splash`, `home`.

### Variables & Functions
*   **lowerCamelCase**: Used for variable names, function names, method names, and arguments.
    *   *Examples*: `fetchData()`, `userRepository`, `build(BuildContext context)`.

### Private Members
*   **_lowerCamelCase**: Prefix with an underscore `_`.
    *   *Examples*: `_authBaseUrl`, `_dio`, `_init()`.

### Constants
*   **kPascalCase**: Used consistently for static class-level constants and configuration constants.
    *   *Examples*: `AppIcons.kBgImage`, `Units.kPaddingUnit`, `kUriPrefix`.
*   **lowerCamelCase**: Used for some top-level list constants (whitelist configurations).
    *   *Examples*: `whiteListDocumentExtensions`, `androidPlayStoreUrl`.

### specific Suffixes
*   **Bloc**: Classes ending in `Bloc` (e.g., `SplashBloc`).
*   **Page/Screen**: Widget classes ending in `Page` (e.g., `HomePage`, `SplashPage`).
*   **Repository**: Data layer classes ending in `Repository` (e.g., `AuthRepository`).
*   **Service**: API/Local services ending in `Service` (e.g., `AuthService`).

### Localization Keys (ARB)
*   **prefixPascalCase**: Keys should be prefixed with their UI element type followed by a meaningful description.
    *   **`label`**: General text labels (e.g., `labelFlutterBase`, `labelNoData`).
    *   **`title`**: Screen or dialog titles (e.g., `titleHome`, `titleLogin`).
    *   **`message`**: Long-form messages or instructions (e.g., `messageImmediateUpdate`).
    *   **`btn`**: Button labels (e.g., `btnOk`, `btnCancel`).
    *   **`hint`**: Input field placeholders/hints (e.g., `hintDefaultSearch`).
    *   **`err`**: Error messages (e.g., `errWebView`).

## Data Layer Details

### Database
The project uses a hybrid storage approach:
1.  **Drift (SQLite)**: Used for complex, relational data (Users, AuthTokens, Notifications, Jobs).
    *   **Architecture**: Runs in a separate background isolate (`DriftIsolate`) to prevent UI jank during heavy DB operations.
    *   **Files**: `lib/src/data/database/core/app_database.dart` (Definition), `shared_db.dart` (Platform abstraction).
    *   **Access**: Through DAOs (e.g., `UserDao`, `AuthTokenDao`).
2.  **Flutter Secure Storage**: Used for sensitive data like OAuth credentials and verifying codes.
3.  **Hive**: Used for lightweight key-value pairs (as seen in initialization logic).

### Network Layer
*   **Client**: `Dio` is the underlying HTTP client, configured in `lib/src/core/app_constants.dart` (`NetworkClient`).
*   **Interceptors**:
    *   `NetworkAuthInterceptor`: Handles `401 Unauthorized` errors by automatically triggering the token refresh flow (`processAuthError` in `AuthRepository`) or logging the user out if refresh fails.
    *   `NetworkUsageInterceptor`: Logs network usage stats.
*   **Services**: API calls are encapsulated in "Service" classes (e.g., `AuthService`) which use `NetworkClient.dioInstance`.

### Repository Pattern
*   **Role**: Repositories act as the single source of truth, orchestrating between Remote (API) and Local (DB/Storage) data sources.
*   **Implementation**:
    *   They are **concrete classes** (e.g., `AuthRepository`), not abstract interfaces.
    *   **State Coordination**: They handle logic like updating the local DB after a successful API call (e.g., `_updateUser` in `AuthRepository`).
    *   **Concurrency**: Critical sections (like token refresh) are guarded using `synchronized.Lock` to prevent race conditions.
    *   **Access**: Repositories are typically exposed via global factory functions in `repository_provider.dart`.

## Localization
The project uses the **`flutter_intl`** plugin (an IDE plugin for VSCode/Android Studio) to manage localization, which simplifies the generation of Dart localization classes from ARB files.

*   **Setup**: Configured in `pubspec.yaml` via `flutter_intl: enabled: true`.
*   **Files**:
    *   **Source**: `.arb` files located in `lib/l10n/` (e.g., `intl_en.arb`).
    *   **Generated**: Dart code is generated into `lib/generated/l10n.dart` (do not edit manually).
*   **Format**: Uses Application Resource Bundle (ARB) format.
    *   **Strings**: Key-value pairs (e.g., `"titleHome": "Home"`).
    *   **Placeholders**: Supported via interpolation (e.g., `"userStatus": "{username} is {status}"`).
    *   **Metadata**: defined with `@key` (e.g., `@userStatus` to define placeholders).
*   **Usage**:
    *   **Access strings**: `S.current.titleHome` or `S.of(context).titleHome`.

## Theming & UI Constants
The UI layer relies on a set of core utility classes for consistent styling and constant management.

### Theme System
Located in `lib/src/presentation/core/theme/`:
*   **Colors**: defined in `AppColors` (file: `colors.dart`). Usage: `AppColors.primary`.
*   **Typography**: defined in `TextStyles` (file: `text_styles.dart`).
    *   **Pattern**: Static methods that generally take `BuildContext` to access the base `Theme` and override properties (e.g., `TextStyles.h1ExtraLight(context)`).
    *   **Font**: Uses **Roboto** as the primary font family.

### Constants
Located in `lib/src/core/app_constants.dart`:
*   **`Units`**: Layout constants for padding, radii, and component sizes (e.g., `Units.kStandardPadding`, `Units.kButtonHeight`).
*   **`AppIcons`**: Asset paths for images and SVGs (e.g., `AppIcons.kLogo`).
*   **`APIEndpoints`**: URLs and route definitions for the authentication server.
*   **`NetworkClient`**: Configuration for the global `Dio` instance.

## Custom Components & Utilities

### Core Widgets (`lib/src/presentation/widgets`)
*   **`AppButton`**: Standardized button component wrapping `Material` and `InkWell`. Handles disabled states, focus, and styling via `AppColors`.
*   **`AppAppbar`**: A reusable `PreferredSizeWidget` implementing the application's standard header, supporting:
    *   Search functionality.
    *   Action buttons.
    *   Hamburger/Back navigation logic.
*   **`LoaderWidget`**: Standard loading indicator.

### Utilities (`lib/src/utils`)
*   **`Guard`**: A static utility class to wrap code blocks in try-catch structures safely.
    *   **Usage**: `Guard.run(() => ...)` or `Guard.withDefault(...)`.
    *   **Features**: Automatically logs exceptions to `ErrorLogger` unless suppressed.
*   **`Extensions.dart`**: Massive collection of Dart extensions.
    *   **String**: `toCapitalized`, `toPascalCase`, `formatNumber`.
    *   **Date**: `isSameDate`, `formatDate`, `differenceInMonths`.
    *   **Number**: `formatBytes` (KB/MB/GB conversions).
*   **`ErrorLogger`**: Centralized error reporting service (likely connected to Crashlytics).
