import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  ThemeData theme() => Theme.of(this);
}

extension StringExtension on String {
  String capitalize() =>
      this[0].toUpperCase() + this.substring(1).toLowerCase();
}
