import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Define your app's color palette
const Color primaryColor = Color(0xFF003366); // Dark Blue for buttons
const Color backgroundColor = Color(0xFFFFFFFF); // Light Green for background
const Color accentColor = Colors.redAccent;

// Define the global theme for the application
final ThemeData appTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,

    // Define the color scheme
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: primaryColor,
      secondary: accentColor,
      background: backgroundColor,
    ),

    // Apply the Lora font globally
    textTheme: GoogleFonts.loraTextTheme(),

    // Define the global style for ElevatedButton
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white, // Text color for ElevatedButton
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: GoogleFonts.lora(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),

    // Define the global style for OutlinedButton
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black87, // Text color for OutlinedButton
        padding: const EdgeInsets.symmetric(vertical: 18),
        side: BorderSide(color: Colors.grey.shade400),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: GoogleFonts.lora(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),

    // Define the global style for text fields
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: GoogleFonts.lora(color: Colors.grey[600]),
      filled: true,
      fillColor: Colors.white, // Keeping text fields white for better readability
      contentPadding:
      const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: primaryColor, width: 2.0),
      ),
    ),

    // Define the global style for TextButton
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.black87,
          textStyle: GoogleFonts.lora(),
        )
    )
);
