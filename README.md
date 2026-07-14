# Flex Time

Flex Time 3.0 is a modern, cross-platform productivity application built with Flutter. It combines a calendar, task manager, and habit tracker into a single unified experience, featuring seamless Google Calendar synchronization and local data persistence.

## 🚀 Key Features

-   **Advanced Calendar:** Interactive scheduling using `Syncfusion Calendar` with support for various views and event management.
-   **Google Calendar Sync:** Two-way synchronization with Google Calendar to keep your schedule consistent across devices.
-   **Task & Habit Tracking:** Manage your daily routines with progress indicators and persistent storage.
-   **Built-in Timer:** Integrated stopwatch/timer for focused work sessions and time tracking.
-   **Smart Notifications:** Local reminders for upcoming events and tasks using `flutter_local_notifications`.
-   **Analytics & Insights:** Data visualization with `fl_chart` to track your productivity and habit consistency.
-   **Personalization:** 
    -   Dynamic Light/Dark mode support.
    -   Customizable accent colors with a built-in color picker.
-   **Localization:** Full support for English and Russian languages.

## 🛠 Tech Stack

-   **Framework:** [Flutter](https://flutter.dev) (Dart)
-   **State Management:** [Riverpod](https://riverpod.dev) (Functional & Reactive)
-   **Local Database:** [Isar](https://isar.dev) (High-performance NoSQL database)
-   **Navigation:** [GoRouter](https://pub.dev/packages/go_router)
-   **Local Storage:** `shared_preferences` for app settings and theme.
-   **External APIs:** Google Calendar API (via `googleapis`).

## 📦 Getting Started

### Prerequisites

-   Flutter SDK: `^3.11.1`
-   Dart SDK

### Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/your-sershocker/flex_time3_0
    cd flex_time3_0
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Generate code (Isar models):**
    This project uses `build_runner` for database schema generation.
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```

4.  **Run the application:**
    ```bash
    flutter run
    ```

## 🏗 Project Structure

-   `lib/core/`: Essential services, database initialization, navigation, and global providers.
-   `lib/features/`: Modular components (Calendar, Tasks, Habits, etc.) including models, UI, and logic.
-   `lib/theme/`: Custom UI styling and color configurations.
-   `assets/`: Images and static icons.

---
