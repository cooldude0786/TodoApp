// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/task.dart';
import 'package:todo/bloc/task_bloc/tasks_bloc.dart';
import 'package:todo/bloc/task_bloc/tasks_event.dart';
import 'package:todo/bloc/task_bloc/tasks_state.dart';
import 'app_theme.dart';
import 'package:todo/widgets/app_drawer.dart';

class TaskScreen extends StatefulWidget {
  final String collectionId;
  final String collectionName;

  const TaskScreen({
    super.key,
    required this.collectionId,
    required this.collectionName,
  });

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  void _showAddTaskDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Add a New Task'),
          content: TextField(
            controller: titleController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Enter task title...',
              filled: true,
              fillColor: Theme.of(
                context,
              ).colorScheme.surfaceVariant.withOpacity(0.3),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.check),
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  final task = Task(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: titleController.text,
                    collectionId: widget.collectionId,
                  );
                  context.read<TasksBloc>().add(AddTask(task: task));
                  Navigator.pop(dialogContext);
                }
              },
              label: const Text('Add'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
void _showEditTaskDialog(BuildContext context, Task task) {
    final TextEditingController titleController = TextEditingController(text: task.title);
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Edit Task'),
          content: TextField(
            controller: titleController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Enter new task title...',
              filled: true,
              fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.check),
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  context.read<TasksBloc>().add(EditTask(taskId: task.id, newTitle: titleController.text));
                  Navigator.pop(dialogContext);
                }
              },
              label: const Text('Save'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.collectionName),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: isDarkMode ? AppTheme.darkAppBarGradient : AppTheme.lightAppBarGradient,
          ),
        ),
      ),
      drawer: const AppDrawer(),
      body: BlocBuilder<TasksBloc, TasksState>(
        builder: (context, state) {
          final displayedTasks = state.tasks.where((task) => task.collectionId == widget.collectionId).toList();

          if (displayedTasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.task_alt, size: 80, color: Theme.of(context).colorScheme.secondary),
                  const SizedBox(height: 16),
                  Text("No tasks yet", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text("Tap '+' to add your first task", style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            itemCount: displayedTasks.length,
            itemBuilder: (context, index) {
              final task = displayedTasks[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6.0),
                elevation: task.isCompleted ? 1 : 4,
                shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  leading: Checkbox(
                    value: task.isCompleted,
                    onChanged: (_) {
                      context.read<TasksBloc>().add(ToggleTaskCompletion(taskId: task.id));
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  title: Text(
                    '${index + 1}. ${task.title}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                          color: task.isCompleted
                              ? Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.5)
                              : Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                  ),
                  trailing: Wrap(
                    spacing: 0,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        tooltip: "Edit Task",
                        onPressed: () => _showEditTaskDialog(context, task),
                      ),
                      // ARROWS ADDED BACK
                      IconButton(
                        icon: const Icon(Icons.arrow_upward, size: 20),
                        tooltip: "Move Up",
                        // Disable button if it's the first item
                        onPressed: index == 0
                            ? null
                            : () => context.read<TasksBloc>().add(MoveTaskUp(taskId: task.id)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_downward, size: 20),
                        tooltip: "Move Down",
                        onPressed: index == displayedTasks.length - 1
                            ? null
                            : () => context.read<TasksBloc>().add(MoveTaskDown(taskId: task.id)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                        tooltip: "Delete Task",
                        onPressed: () => context.read<TasksBloc>().add(DeleteTask(taskId: task.id)),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}