// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/bloc/collection_bloc/collection_bloc.dart'; 
import 'package:todo/bloc/task_bloc/tasks_bloc.dart';
import 'package:todo/bloc/theme_bloc/theme_bloc.dart';
import 'package:todo/bloc/theme_bloc/theme_state.dart';
import 'screens/task_screen.dart';
import 'screens/home_screen.dart'; 
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeBloc()),
        BlocProvider(create: (context) => TasksBloc()),
        BlocProvider(
          create: (context) => CollectionBloc(),
        ), 
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
