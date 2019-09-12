import 'package:flutter/material.dart';

/// Returns the color for a [factor].
Color computeColorByFactor(double factor) {
  factor = factor > 1 ? 1 : (factor < 0 ? 0 : factor);
  return HSVColor.lerp(
          HSVColor.fromColor(Colors.lightGreen),
          HSVColor.fromColor(Colors.red),
          factor)
      .toColor();
}

/// Returns color for active and inactive input field.
getActivityColor(bool active) {
  return active ? Colors.blue : Colors.grey;
}
