abstract class ThemeEvent {}

// ADDED: An event to load the saved theme on startup
class ThemeInitialized extends ThemeEvent {}

class ThemeToggled extends ThemeEvent {}