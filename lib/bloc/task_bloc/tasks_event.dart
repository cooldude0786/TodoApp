import '../../models/task.dart';

abstract class TasksEvent {}

class AddTask extends TasksEvent {
  final Task task;
  AddTask({required this.task});
}

class EditTask extends TasksEvent {
  final String taskId;
  final String newTitle;
  final DateTime? newReminderTime;

  EditTask({
    required this.taskId,
    required this.newTitle,
    this.newReminderTime,
  });
}

class DeleteTask extends TasksEvent {
  final String taskId;
  DeleteTask({required this.taskId});
}

class ToggleTaskCompletion extends TasksEvent {
  final String taskId;
  ToggleTaskCompletion({required this.taskId});
}

class DeleteTasksByCollection extends TasksEvent {
  final String collectionId;
  DeleteTasksByCollection({required this.collectionId});
}

class MoveTaskUp extends TasksEvent {
  final String taskId;
  MoveTaskUp({required this.taskId});
}

class MoveTaskDown extends TasksEvent {
  final String taskId;
  MoveTaskDown({required this.taskId});
}