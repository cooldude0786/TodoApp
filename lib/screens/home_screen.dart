// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/bloc/collection_bloc/collection_bloc.dart';
import 'package:todo/bloc/collection_bloc/collection_event.dart';
import 'package:todo/bloc/collection_bloc/collection_state.dart';
import '../models/collection.dart';
import '../screens/task_screen.dart';
import 'package:todo/bloc/task_bloc/tasks_bloc.dart';
import 'package:todo/bloc/task_bloc/tasks_state.dart';
import 'package:todo/widgets/app_drawer.dart';
import 'app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Collections'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: isDarkMode ? AppTheme.darkAppBarGradient : AppTheme.lightAppBarGradient,
          ),
        ),
      ),
      drawer: const AppDrawer(),
      body: BlocBuilder<CollectionBloc, CollectionState>(
        builder: (context, collectionState) {
          if (collectionState.collections.isEmpty) {
            return const Center(child: Text('No collections. Create one!'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,  
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              mainAxisExtent: 140, 
            ),
            itemCount: collectionState.collections.length,
            itemBuilder: (context, index) {
              final collection = collectionState.collections[index];
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => TaskScreen(
                        collectionId: collection.id,
                        collectionName: collection.name,
                      ),
                    ));
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          collection.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        BlocBuilder<TasksBloc, TasksState>(
                          builder: (context, tasksState) {
                            final taskCount = tasksState.tasks
                                .where((task) => task.collectionId == collection.id)
                                .length;
                            return Text('$taskCount Tasks');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddCollectionDialog(context),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        icon: Icon(Icons.add, color: Theme.of(context).colorScheme.onSecondary),
        label: Text("New Collection", style: TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
      ),
    );
  }
}






