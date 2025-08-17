import 'package:flutter_bloc/flutter_bloc.dart';
import 'tasks_event.dart';
import 'tasks_state.dart';
import '../../models/task.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  TasksBloc() : super(TasksInitial()) {
    on<AddTask>(_onAddTask);
    on<DeleteTask>(_onDeleteTask);
    on<EditTask>(_onEditTask);  
    on<ToggleTaskCompletion>(_onToggleTaskCompletion);  
    on<MoveTaskUp>(_onMoveTaskUp);
    on<MoveTaskDown>(_onMoveTaskDown);
        on<DeleteTasksByCollection>(_onDeleteTasksByCollection); 

  }

  void _onEditTask(EditTask event, Emitter<TasksState> emit) {
    final List<Task> updatedTasks = state.tasks.map((task) {
      if (task.id == event.taskId) {
        return task.copyWith(title: event.newTitle);
      }
      return task;
    }).toList();
    emit(TasksLoaded(tasks: updatedTasks));
  }

  void _onToggleTaskCompletion(ToggleTaskCompletion event, Emitter<TasksState> emit) {
    final List<Task> updatedTasks = state.tasks.map((task) {
      if (task.id == event.taskId) {
        return task.copyWith(isCompleted: !task.isCompleted);
      }
      return task;
    }).toList();
    emit(TasksLoaded(tasks: updatedTasks));
  }
  
  void _onAddTask(AddTask event, Emitter<TasksState> emit) {
    final List<Task> updatedTasks = List.from(state.tasks)..add(event.task);
    emit(TasksLoaded(tasks: updatedTasks));
  }

  void _onDeleteTask(DeleteTask event, Emitter<TasksState> emit) {
    final List<Task> updatedTasks = state.tasks.where((task) => task.id != event.taskId).toList();
    emit(TasksLoaded(tasks: updatedTasks));
  }

  void _onMoveTaskUp(MoveTaskUp event, Emitter<TasksState> emit) {
    final int oldIndex = state.tasks.indexWhere((task) => task.id == event.taskId);

    if (oldIndex != -1 && oldIndex > 0) {
      final List<Task> updatedTasks = List.from(state.tasks);
      final task = updatedTasks.removeAt(oldIndex);
      updatedTasks.insert(oldIndex - 1, task);
      emit(TasksLoaded(tasks: updatedTasks));
    }
  }


  void _onMoveTaskDown(MoveTaskDown event, Emitter<TasksState> emit) {
    final int oldIndex = state.tasks.indexWhere((task) => task.id == event.taskId);

    if (oldIndex != -1 && oldIndex < state.tasks.length - 1) {
      final List<Task> updatedTasks = List.from(state.tasks);
      final task = updatedTasks.removeAt(oldIndex);
      updatedTasks.insert(oldIndex + 1, task);
      emit(TasksLoaded(tasks: updatedTasks));
    }
  }

  void _onDeleteTasksByCollection(DeleteTasksByCollection event, Emitter<TasksState> emit) {
    final List<Task> updatedTasks = state.tasks
        .where((task) => task.collectionId != event.collectionId)
        .toList();
    emit(TasksLoaded(tasks: updatedTasks));
  }

}
