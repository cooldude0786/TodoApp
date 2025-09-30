import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/theme_repository.dart'; // Import the new repository
import '../../screens/app_theme.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final ThemeRepository _themeRepository;

  ThemeBloc({required ThemeRepository themeRepository})
      : _themeRepository = themeRepository,
        // Start with the light theme by default before initialization
        super(ThemeState(themeData: AppTheme.lightTheme)) {
    on<ThemeInitialized>(_onThemeInitialized);
    on<ThemeToggled>(_onThemeToggled);
  }

  // ADDED: Handler to load the saved theme
  void _onThemeInitialized(ThemeInitialized event, Emitter<ThemeState> emit) async {
    final isDarkMode = await _themeRepository.getTheme();
    emit(ThemeState(themeData: isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme));
  }

  // MODIFIED: Handler now also saves the new theme preference
  void _onThemeToggled(ThemeToggled event, Emitter<ThemeState> emit) async {
    final isDarkMode = state.themeData == AppTheme.darkTheme;
    final newThemeData = isDarkMode ? AppTheme.lightTheme : AppTheme.darkTheme;
    
    // Save the new preference
    await _themeRepository.saveTheme(!isDarkMode);
    
    emit(ThemeState(themeData: newThemeData));
  }
}