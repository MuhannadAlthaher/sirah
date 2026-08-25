import 'package:flutter/material.dart';

/// Shared color palette for the app, so every widget pulls colors
/// from one place instead of repeating hex literals or importing
/// each other just for a constant.
class AppPalette {
  const AppPalette._();

  static const screenBackground = Color(0xfff2f4f3);
  static const accent = Color(0xff4caf50);
  static const accentSoft = Color(0xffe6f4ea);
  static const blob = Color(0xffd7ecdf);
  static const border = Color(0xffe4ebe7);
  static const placeholder = Color(0xffe6eae8);
  static const titleBar = Color(0xff3f4744);
  static const previewBackground = Color(0xfff7f9f8);
  static const scanRowBackground = Color(0xffeef7f1);
  static const scanRowInnerBar = Color(0xffdcece1);
}
