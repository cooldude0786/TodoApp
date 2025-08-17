# Flutter Task Management App

A sleek and functional to-do list application built with Flutter and the BLoC pattern. It allows users to organize tasks into different collections, supports both light and dark modes, and features a rich, intuitive user interface.
---
## Features

- **Collection Management**: Organize tasks by creating and deleting custom collections (e.g., "Work," "Personal").
- **Task Management**:
    - **Add, Edit, and Delete** tasks within any collection.
    - **Mark as Complete** with a satisfying checkbox and visual feedback.
    - **Reorder Tasks** using up and down arrows to prioritize your work.
- **Dashboard View**: A beautiful grid-based home screen that provides an overview of all your collections and the number of tasks in each.
- **Stunning UI**:
    - **Light & Dark Mode**: A theme switcher that adapts the entire app's aesthetic.
    - **Gradient Colors**: Rich, gradient-based `AppBar` and `Drawer` headers.
    - **Material Design**: Built with modern Material You components for a clean look and feel.
- **State Management**: Robust and scalable state management using the **BLoC (Business Logic Component)** pattern.

---

## Tools & Technologies

- **Framework**: Flutter (Dart)
- **State Management**: `flutter_bloc`
- **UI**: Material Design
- **Local Storage**: (Currently in-memory; easily extendable with `Hive` or `SharedPreferences`)

---

## File Structure

The project is organized into logical directories to maintain a clean and scalable codebase.

lib/
|-- bloc/                 # BLoC files for state management
|   |-- collection_bloc/    # BLoC for managing collections
|   |-- task_bloc/          # BLoC for managing tasks
|   -- theme_bloc/         # BLoC for theme switching | |-- models/               # Data models (Task, Collection) |   |-- collection.dart |   -- task.dart
|
|-- screens/              # UI screens for the app
|   |-- app_theme.dart      # Theme definitions and color palettes
|   |-- home_screen.dart    # The main dashboard screen showing collections
|   -- task_screen.dart    # The screen showing tasks for a specific collection | -- widgets/              # Reusable UI components
`-- app_drawer.dart     # The main navigation drawer for the app

---

## Setup and Installation

1.  **Clone the repository**:
    ```sh
    git clone <your-repository-url>
    cd <your-project-directory>
    ```

2.  **Install dependencies**:
    ```sh
    flutter pub get
    ```

3.  **Run the application**:
    ```sh
    flutter run
    ```
