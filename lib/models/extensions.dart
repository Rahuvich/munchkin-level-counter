import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  ThemeData theme() => Theme.of(this);
}
