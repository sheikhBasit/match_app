import 'package:flutter/material.dart';

const primaryColor = Color(0xFF0C2F59);
const secondaryColor = Color(0xFFFFFFFF);
const selectionColor = Color(0xFFB72751);
const backgroundColor = Color(0xFF15131C);

Color cardBackgroundColor(BuildContext context) {
  final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
  return isDarkTheme ? Color(0xFF0C2F59) : Color(0xFFB72751);
}

const defaultPadding = 20.0;

double cardWidth(BuildContext context) {
  return MediaQuery.of(context).size.width * 0.9;
}

double cardHeight(BuildContext context) {
  return MediaQuery.of(context).size.height * 0.9;
}

double navBarWidth(BuildContext context) {
  return MediaQuery.of(context).size.width * 1;
}
