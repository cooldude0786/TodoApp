import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/bloc/collection_bloc/collection_bloc.dart';
import 'package:todo/bloc/task_bloc/tasks_bloc.dart';
import 'package:todo/bloc/theme_bloc/theme_bloc.dart';
import 'package:todo/bloc/theme_bloc/theme_event.dart';
import 'package:todo/bloc/theme_bloc/theme_state.dart';
import 'package:todo/data/theme_repository.dart';
import 'package:todo/models/collection.dart';
import 'package:todo/models/task.dart';
import 'package:todo/services/notification_service.dart';
import 'screens/home_screen.dart';

final NotificationService notificationService = NotificationService();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await notificationService.init();

  await Hive.initFlutter();

  Hive.registerAdapter(CollectionAdapter());
  Hive.registerAdapter(TaskAdapter());

  await Hive.openBox<Collection>('collections');
  await Hive.openBox<Task>('tasks');

  final themeRepository = ThemeRepository();

  runApp(MyApp(themeRepository: themeRepository));
}

class MyApp extends StatelessWidget {
  final ThemeRepository themeRepository;

  const MyApp({super.key, required this.themeRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeBloc(themeRepository: themeRepository)
            ..add(ThemeInitialized()),
        ),
        BlocProvider(create: (context) => TasksBloc()),
        BlocProvider(create: (context) => CollectionBloc()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Todo App',
            theme: state.themeData,
            home: const HomeScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}