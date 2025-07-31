import 'package:flutter/material.dart';

import '../widget-x/colors_x.dart';

class MbxAppThemes {
  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primarySwatch: _createMaterialColor(ColorX.theme),
      primaryColor: ColorX.theme,
      scaffoldBackgroundColor: const Color(0xfff5f5f5),
      cardColor: Colors.white,
      dividerColor: const Color(0xffd3d3d3),

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Color(0xff343a40),
        elevation: 1,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Color(0xff343a40),
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: Color(0xff343a40)),
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: Color(0xff343a40)),
        displayMedium: TextStyle(color: Color(0xff343a40)),
        displaySmall: TextStyle(color: Color(0xff343a40)),
        headlineLarge: TextStyle(color: Color(0xff343a40)),
        headlineMedium: TextStyle(color: Color(0xff343a40)),
        headlineSmall: TextStyle(color: Color(0xff343a40)),
        titleLarge: TextStyle(color: Color(0xff343a40)),
        titleMedium: TextStyle(color: Color(0xff343a40)),
        titleSmall: TextStyle(color: Color(0xff343a40)),
        bodyLarge: TextStyle(color: Color(0xff343a40)),
        bodyMedium: TextStyle(color: Color(0xff343a40)),
        bodySmall: TextStyle(color: Color(0xff6c757d)),
        labelLarge: TextStyle(color: Color(0xff343a40)),
        labelMedium: TextStyle(color: Color(0xff343a40)),
        labelSmall: TextStyle(color: Color(0xff6c757d)),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xffd3d3d3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xffd3d3d3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: ColorX.theme),
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorX.theme,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: Color(0xff343a40)),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primarySwatch: _createMaterialColor(ColorX.theme),
      primaryColor: ColorX.theme,
      scaffoldBackgroundColor: const Color(
        0xff1a1a1a,
      ), // Soft dark gray background
      cardColor: const Color(0xff161616), // Much darker cards
      dividerColor: const Color(0xff2a2a2a),

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xff202020), // Soft black app bar
        foregroundColor: Color(0xFFF0F0F0), // Soft white text
        elevation: 1,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Color(0xFFF0F0F0), // Soft white
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: Color(0xFFF0F0F0)), // Soft white icons
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: Color(0xFFF0F0F0)), // Soft white
        displayMedium: TextStyle(color: Color(0xFFF0F0F0)), // Soft white
        displaySmall: TextStyle(color: Color(0xFFF0F0F0)), // Soft white
        headlineLarge: TextStyle(color: Color(0xFFF0F0F0)), // Soft white
        headlineMedium: TextStyle(color: Color(0xFFF0F0F0)), // Soft white
        headlineSmall: TextStyle(color: Color(0xFFF0F0F0)), // Soft white
        titleLarge: TextStyle(color: Color(0xFFF0F0F0)), // Soft white
        titleMedium: TextStyle(color: Color(0xFFF0F0F0)), // Soft white
        titleSmall: TextStyle(color: Color(0xFFF0F0F0)), // Soft white
        bodyLarge: TextStyle(color: Color(0xFFF0F0F0)), // Soft white
        bodyMedium: TextStyle(color: Color(0xFFF0F0F0)), // Soft white
        bodySmall: TextStyle(
          color: Color(0xFFB0B0B0), // Soft gray for secondary text
        ),
        labelLarge: TextStyle(color: Color(0xFFF0F0F0)), // Soft white
        labelMedium: TextStyle(color: Color(0xFFF0F0F0)), // Soft white
        labelSmall: TextStyle(color: Color(0xFFB0B0B0)), // Soft gray
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xff161616), // Darker input fields
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xff2a2a2a)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xff2a2a2a)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: ColorX.theme),
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorX.theme,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: const Color(0xff161616), // Much darker cards
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  // Helper method to create MaterialColor from Color
  static MaterialColor _createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }

    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }

    return MaterialColor(color.value, swatch);
  }
}
