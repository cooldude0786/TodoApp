import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'tasks_event.dart';
import 'tasks_state.dart';
import '../../models/task.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final Box<Task> _taskBox;

  TasksBloc()
      : _taskBox = Hive.box<Task>('tasks'),
        super(TasksLoaded(tasks: Hive.box<Task>('tasks').values.toList())) {
    on<AddTask>(_onAddTask);
    on<DeleteTask>(_onDeleteTask);
    on<EditTask>(_onEditTask);
    on<ToggleTaskCompletion>(_onToggleTaskCompletion);
    on<DeleteTasksByCollection>(_onDeleteTasksByCollection);
    on<MoveTaskUp>(_onMoveTaskUp);
    on<MoveTaskDown>(_onMoveTaskDown);
  }

  void _onAddTask(AddTask event, Emitter<TasksState> emit) {
    _taskBox.put(event.task.id, event.task);
    emit(TasksLoaded(tasks: _taskBox.values.toList()));
  }

  void _onDeleteTask(DeleteTask event, Emitter<TasksState> emit) {
    _taskBox.delete(event.taskId);
    emit(TasksLoaded(tasks: _taskBox.values.toList()));
  }

  void _onEditTask(EditTask event, Emitter<TasksState> emit) {
    final task = _taskBox.get(event.taskId);
    if (task != null) {
      _taskBox.put(
        event.taskId,
        task.copyWith(
          title: event.newTitle,
          reminderTime: event.newReminderTime,
        ),
      );
    }
    emit(TasksLoaded(tasks: _taskBox.values.toList()));
  }

  void _onToggleTaskCompletion(ToggleTaskCompletion event, Emitter<TasksState> emit) {
    final task = _taskBox.get(event.taskId);
    if (task != null) {
      _taskBox.put(event.taskId, task.copyWith(isCompleted: !task.isCompleted));
    }
    emit(TasksLoaded(tasks: _taskBox.values.toList()));
  }

  void _onDeleteTasksByCollection(DeleteTasksByCollection event, Emitter<TasksState> emit) {
    final tasksToDelete = _taskBox.values.where((task) => task.collectionId == event.collectionId).toList();
    for (var task in tasksToDelete) {
      _taskBox.delete(task.id);
    }
    emit(TasksLoaded(tasks: _taskBox.values.toList()));
  }

  void _onMoveTaskUp(MoveTaskUp event, Emitter<TasksState> emit) {
    final List<Task> taskList = _taskBox.values.toList();
    final int oldIndex = taskList.indexWhere((task) => task.id == event.taskId);
    if (oldIndex > 0) {
      final task = taskList.removeAt(oldIndex);
      taskList.insert(oldIndex - 1, task);
      _taskBox.clear().then((_) {
        for (var t in taskList) {
          _taskBox.put(t.id, t);
        }
        emit(TasksLoaded(tasks: _taskBox.values.toList()));
      });
    }
  }

  void _onMoveTaskDown(MoveTaskDown event, Emitter<TasksState> emit) {
    final List<Task> taskList = _taskBox.values.toList();
    final int oldIndex = taskList.indexWhere((task) => task.id == event.taskId);
    if (oldIndex != -1 && oldIndex < taskList.length - 1) {
      final task = taskList.removeAt(oldIndex);
      taskList.insert(oldIndex + 1, task);
      _taskBox.clear().then((_) {
        for (var t in taskList) {
          _taskBox.put(t.id, t);
        }
        emit(TasksLoaded(tasks: _taskBox.values.toList()));
      });
    }
  }
}