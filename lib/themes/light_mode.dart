import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade300,
    primary: Colors.grey.shade500,
    secondary: Colors.grey.shade100,
    tertiary: Colors.white,
    // inversePrimary定义反向的主颜色
    inversePrimary: Colors.grey.shade700,
  ),
);
