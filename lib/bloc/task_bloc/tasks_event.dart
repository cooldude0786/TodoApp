
import 'package:todo/models/task.dart';
abstract class TasksEvent {}

class AddTask extends TasksEvent {
  final Task task;
  AddTask({required this.task});
}

class DeleteTask extends TasksEvent {
  final String taskId;
  DeleteTask({required this.taskId});
}

class EditTask extends TasksEvent {
  final String taskId;
  final String newTitle;

  EditTask({required this.taskId, required this.newTitle});
}

class ToggleTaskCompletion extends TasksEvent {
  final String taskId;

  ToggleTaskCompletion({required this.taskId});
}


class MoveTaskUp extends TasksEvent {
  final String taskId;
  MoveTaskUp({required this.taskId});
}

class MoveTaskDown extends TasksEvent {
  final String taskId;
  MoveTaskDown({required this.taskId});
}

class DeleteTasksByCollection extends TasksEvent {
  final String collectionId;

  DeleteTasksByCollection({required this.collectionId});
}
