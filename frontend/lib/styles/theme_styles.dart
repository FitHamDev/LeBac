import 'package:flutter/material.dart';

class SongStyle {
  final Color backgroundColor;
  final List<Color> gradientColors;
  final Color buttonColor;
  final Color textColor;

  const SongStyle({
    required this.backgroundColor,
    required this.gradientColors,
    required this.buttonColor,
    this.textColor = Colors.white,
  });

  static const defaultStyle = SongStyle(
    backgroundColor: Color(0xFFFCFF61), 
      gradientColors: [
        Color(0xFFFCFF61), 
        Color(0xFFF4C34F), 
      ],
    buttonColor: Color(0xFFFFAA00), 
  );

  static final Map<String, SongStyle> _styles = {
    
    'stigma': const SongStyle(
      backgroundColor: Color(0x33000000), 
      gradientColors: [
        Color(0xFF0D1111), 
        Color(0xFF000000),
      ],
      buttonColor: Color(0xFF4F635B), 
    ),
    'leblanc': const SongStyle(
      backgroundColor: Color(0xFF1A0505),
      gradientColors: [
      Color(0xFFFF0000), 
      Color(0xFF3D0000), 
      ],
      buttonColor: Color(0xFFFF3C38),
      textColor: Colors.white,
    ),
    'legoon': const SongStyle(
      backgroundColor: Color(0xFF001524), 
      gradientColors: [
        Color(0xFF00A8E8), 
        Color(0xFF003459), 
      ],
      buttonColor: Color(0xFF00F5D4), 
      textColor: Colors.white,
    ),
      };

  static SongStyle getStyle(String themeName) {
    return _styles[themeName] ?? defaultStyle;
  }
}
