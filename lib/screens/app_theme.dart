import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const LinearGradient lightAppBarGradient = LinearGradient(
    colors: [Color(0xFF3F51B5), Color(0xFF5C6BC0)], // Indigo to a lighter Indigo
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient lightDrawerHeaderGradient = LinearGradient(
    colors: [Color(0xFF5C6BC0), Color(0xFF3F51B5)], // Lighter Indigo to Indigo
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkAppBarGradient = LinearGradient(
    colors: [Color(0xFF00796B), Color(0xFF26A69A)], // Deep Teal to a lighter Teal
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient darkDrawerHeaderGradient = LinearGradient(
    colors: [Color(0xFF26A69A), Color(0xFF00796B)], // Lighter Teal to Deep Teal
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );


  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFFFAFAFA),
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Color(0xFFFAFAFA),
    ),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF3F51B5),
      secondary: Color(0xFFFFC107),
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      background: Color(0xFFFAFAFA),
    ),
    iconTheme: const IconThemeData(color: Color(0xFF3F51B5)),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFF212121),
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Color(0xFF303030),
    ),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF00796B),
      secondary: Color(0xFFE91E63),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      background: Color(0xFF212121),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
    ),
  );
}
