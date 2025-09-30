import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/main.dart';
import 'package:todo/services/notification_service.dart';
import '../models/task.dart';
import '../bloc/task_bloc/tasks_bloc.dart';
import '../bloc/task_bloc/tasks_event.dart';
import '../bloc/task_bloc/tasks_state.dart';
import 'app_theme.dart';
import '../widgets/app_drawer.dart';

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
  // REMOVED: initState and _updateWidget function

  void _showAddTaskDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Add a New Task'),
          content: TextField(
            controller: titleController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Enter task title...',
              filled: true,
              fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
            ElevatedButton.icon(
              icon: const Icon(Icons.check),
              label: const Text('Add'),
              style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  final task = Task(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: titleController.text,
                    collectionId: widget.collectionId,
                  );
                  context.read<TasksBloc>().add(AddTask(task: task));
                  // REMOVED: _updateWidget() call
                  Navigator.pop(dialogContext);
                }
              },
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
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
            ElevatedButton.icon(
              icon: const Icon(Icons.check),
              label: const Text('Save'),
              style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  context.read<TasksBloc>().add(EditTask(taskId: task.id, newTitle: titleController.text, newReminderTime: task.reminderTime));
                  // REMOVED: _updateWidget() call
                  Navigator.pop(dialogContext);
                }
              },
            ),
          ],
        );
      },
    );
  }
  
  Future<void> _selectReminderDateTime(BuildContext context, Task task) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: task.reminderTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && context.mounted) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(task.reminderTime ?? DateTime.now()),
      );

      if (pickedTime != null) {
        final DateTime fullDateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);
        final updatedTask = task.copyWith(reminderTime: fullDateTime);
        
        context.read<TasksBloc>().add(EditTask(taskId: task.id, newTitle: task.title, newReminderTime: fullDateTime));
        await notificationService.scheduleNotification(updatedTask);
      }
    }
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
          decoration: BoxDecoration(gradient: isDarkMode ? AppTheme.darkAppBarGradient : AppTheme.lightAppBarGradient),
        ),
      ),
      drawer: const AppDrawer(),
      // CHANGED: BlocConsumer is no longer needed, back to BlocBuilder
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
                // ... (Card and ListTile code is the same as before)
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