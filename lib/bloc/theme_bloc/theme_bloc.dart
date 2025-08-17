import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo/screens/app_theme.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(themeData: AppTheme.lightTheme)) {
    on<ThemeToggled>((event, emit) {
      if (state.themeData == AppTheme.lightTheme) {
        emit(ThemeState(themeData: AppTheme.darkTheme));
      } else {
        emit(ThemeState(themeData: AppTheme.lightTheme));
      }
    });
  }
}