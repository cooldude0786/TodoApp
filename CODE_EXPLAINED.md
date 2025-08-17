# In-Depth Code Explanation

Welcome to the Flutter Task Management App! This document provides a deep dive into the project's architecture, state management, and key functionalities to help you get started with development.

---

## ## Core Architecture: BLoC Pattern

This application is built using the **BLoC (Business Logic Component)** pattern. The core idea is to separate the business logic from the UI.

- **Events**: User actions (like pressing a button) are dispatched from the UI as **Events**.
- **BLoC**: The BLoC receives these Events, processes them, executes business logic (like updating a list), and emits a new **State**.
- **States**: A State represents a part of your app's state (e.g., a list of tasks).
- **UI**: The UI listens for new States from the BLoC and rebuilds itself to reflect the changes.

This creates a predictable, unidirectional data flow that is easy to debug and test.

![BLoC Pattern Diagram](https://i.imgur.com/h5i0s6i.png)

We have three main BLoCs in this app:
1.  `ThemeBloc`: Manages switching between light and dark themes.
2.  `CollectionBloc`: Manages the list of all collections (add, delete).
3.  `TasksBloc`: Manages a single master list of *all* tasks from *all* collections (add, edit, delete, reorder, complete).

---

## ## Key Functionalities Explained

### ### 1. Displaying Tasks for a Specific Collection

The app maintains one master list of all tasks in `TasksBloc`. The `TaskScreen` is responsible for showing only the tasks that belong to the currently viewed collection.

- **Navigation**: When a user taps a collection in the `AppDrawer` or on the `HomeScreen`, we navigate to the `TaskScreen` and pass the `collectionId` and `collectionName` as arguments.
    ```dart
    // In app_drawer.dart
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => TaskScreen(
        collectionId: collection.id,
        collectionName: collection.name,
      ),
    ));
    ```
- **Filtering in the UI**: Inside the `TaskScreen`'s `build` method, a `BlocBuilder<TasksBloc, TasksState>` listens to the master task list. We then use `.where()` to filter this list in real-time, ensuring only the relevant tasks are displayed.
    ```dart
    // In task_screen.dart
    final displayedTasks = state.tasks.where((task) => task.collectionId == widget.collectionId).toList();
    ```
This approach keeps the BLoC simple (it doesn't need to know about filtering) and makes the UI responsible for what it displays.

### ### 2. Cascade Deleting a Collection

To prevent orphaned data (tasks without a collection), deleting a collection also deletes all tasks associated with it.

- **Confirmation Dialog**: In `app_drawer.dart`, when the delete icon is pressed, a confirmation dialog (`_showDeleteConfirmationDialog`) is shown. This improves user experience and is the central point for our logic.
- **Dispatching Two Events**: When the user confirms the deletion, the dialog dispatches two separate events to two different BLoCs:
    1.  `DeleteTasksByCollection`: Sent to the `TasksBloc` with the `collectionId`. The `TasksBloc` filters its master list and removes all matching tasks.
    2.  `DeleteCollection`: Sent to the `CollectionBloc`, which then removes the collection itself.
    ```dart
    // In _showDeleteConfirmationDialog
    onPressed: () {
      // 1. Delete all tasks in the collection
      context.read<TasksBloc>().add(DeleteTasksByCollection(collectionId: collection.id));
      // 2. Delete the collection itself
      context.read<CollectionBloc>().add(DeleteCollection(collectionId: collection.id));
      // ... then navigate away
    },
    ```
This keeps the BLoCs decoupled while ensuring data integrity.

### ### 3. Reordering Tasks by ID

Simply reordering by the `index` in a `ListView` is unreliable when the list is filtered. The index in the filtered UI (`0, 1, 2...`) does not match the task's true index in the master list.

- **Solution**: We reorder tasks using their unique `id`.
- **Events**: The `MoveTaskUp` and `MoveTaskDown` events carry the `taskId` of the item to be moved.
    ```dart
    // In task_screen.dart's IconButton
    onPressed: () => context.read<TasksBloc>().add(MoveTaskUp(taskId: task.id)),
    ```
- **BLoC Logic**: The `TasksBloc` receives the event, finds the actual index of that task in its master list (`state.tasks.indexWhere(...)`), and then performs the swap. This makes the reordering logic robust and independent of any UI-side filtering.

---

## ## How to Contribute

- **Follow the BLoC Pattern**: For any new feature involving state, create the necessary Events, States, and BLoC.
- **Keep Widgets Modular**: The `screens` directory contains top-level views, while `widgets` contains reusable components like the `AppDrawer`.
- **Centralize Theming**: All colors, gradients, and theme data are defined in `lib/screens/app_theme.dart`. Use `Theme.of(context)` to access theme properties in your UI widgets.