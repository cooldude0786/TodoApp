
import 'package:todo/models/task.dart';

abstract class TasksState {
  final List<Task> tasks;

  const TasksState({this.tasks = const <Task>[]});
}

class TasksInitial extends TasksState {}

class TasksLoaded extends TasksState {
  const TasksLoaded({required super.tasks});
}