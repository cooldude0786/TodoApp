// lib/widget/app_drawer.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/bloc/collection_bloc/collection_bloc.dart';
import 'package:todo/bloc/collection_bloc/collection_event.dart';
import 'package:todo/bloc/collection_bloc/collection_state.dart';
import 'package:todo/bloc/task_bloc/tasks_bloc.dart';
import 'package:todo/bloc/task_bloc/tasks_event.dart';
import 'package:todo/screens/home_screen.dart';
import '../models/collection.dart';
import 'package:todo/bloc/theme_bloc/theme_bloc.dart';
import 'package:todo/bloc/theme_bloc/theme_event.dart';
import '../screens/app_theme.dart';
import '../screens/task_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _showAddCollectionDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('New Collection'),
            content: TextField(
              controller: nameController,
              autofocus: true,
              decoration: const InputDecoration(hintText: 'Enter collection name...'),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty) {
                    final collection = Collection(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: nameController.text,
                    );
                    context.read<CollectionBloc>().add(AddCollection(collection: collection));
                    Navigator.pop(dialogContext);
                  }
                },
                child: const Text('Create'),
              ),
            ],
          );
        });
  }

  void _showDeleteConfirmationDialog(BuildContext context, Collection collection) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Collection?'),
          content: Text('This will also delete all tasks within "${collection.name}". This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                context.read<TasksBloc>().add(DeleteTasksByCollection(collectionId: collection.id));
                context.read<CollectionBloc>().add(DeleteCollection(collectionId: collection.id));
                Navigator.of(dialogContext).pop(); // Close dialog
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Drawer(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    gradient: isDarkMode ? AppTheme.darkDrawerHeaderGradient : AppTheme.lightDrawerHeaderGradient,
                  ),
                  child: Text('Menu', style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: 24)),
                ),
                ListTile(
                  leading: Icon(Icons.dashboard_outlined, color: theme.iconTheme.color),
                  title: Text('Home', style: theme.textTheme.bodyLarge),
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.checklist_rtl_outlined, color: theme.iconTheme.color),
                  title: Text('General', style: theme.textTheme.bodyLarge),
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (_) => const TaskScreen(
                        collectionId: 'general',
                        collectionName: 'General Todos',
                      ),
                    ));
                  },
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('My Collections', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.secondary)),
                      IconButton(
                        icon: Icon(Icons.add, color: theme.colorScheme.secondary),
                        onPressed: () => _showAddCollectionDialog(context),
                        tooltip: 'Create New Collection',
                      ),
                    ],
                  ),
                ),
                BlocBuilder<CollectionBloc, CollectionState>(
                  builder: (context, state) {
                    if (state.collections.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Text('No collections yet.'),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.collections.length,
                      itemBuilder: (context, index) {
                        final collection = state.collections[index];
                        return ListTile(
                          leading: Icon(Icons.folder_outlined, color: theme.iconTheme.color),
                          title: Text(collection.name, style: theme.textTheme.bodyLarge),
                          trailing: IconButton(
                            icon: Icon(Icons.delete_outline, color: Colors.red.shade300),
                            tooltip: 'Delete Collection',
                            onPressed: () {
                              _showDeleteConfirmationDialog(context, collection);
                            },
                          ),
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => TaskScreen(
                                  collectionId: collection.id,
                                  collectionName: collection.name,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          SwitchListTile(
            title: Text('Dark Mode', style: theme.textTheme.bodyLarge),
            value: isDarkMode,
            onChanged: (bool value) => context.read<ThemeBloc>().add(ThemeToggled()),
            secondary: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode, color: theme.iconTheme.color),
          ),
        ],
      ),
    );
  }
}