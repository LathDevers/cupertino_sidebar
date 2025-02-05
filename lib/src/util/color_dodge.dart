import 'dart:math' as math;
import 'dart:math';
import 'dart:ui' show Color;

/// A collection of color blending functions.
extension ColorBlending on Color {
  /// Applies Color Dodge blending with another color.
  ///
  /// Color dodge is a blending mode that divides the bottom layer by the
  /// inverted top layer.
  /// This creates a brightening effect where the top layer's brightness
  /// increases the brightness
  /// of the bottom layer.
  Color colorDodge(Color other) {
    // Color dodge formula implementation
    final resultR = _dodgeComponent(r, other.r);
    final resultG = _dodgeComponent(g, other.g);
    final resultB = _dodgeComponent(b, other.b);

    // Alpha compositing
    final resultA = a + other.a - (a * other.a);

    // Convert back to 0-255 range and create new color
    return Color.fromARGB(
      (resultA * 255).round(),
      (resultR * 255).round(),
      (resultG * 255).round(),
      (resultB * 255).round(),
    );
  }

  /// Applies Overlay blending with another color.
  ///
  /// Overlay combines Multiply and Screen blend modes. The base color
  /// determines which mode to use. If the base color is light, Screen is used;
  /// if it's dark, Multiply is used. This creates contrast by darkening dark
  /// colors and lightening light colors.
  Color overlay(Color other) {
    // Overlay formula implementation
    final resultR = _overlayComponent(r, other.r);
    final resultG = _overlayComponent(g, other.g);
    final resultB = _overlayComponent(b, other.b);

    // Alpha compositing
    final double resultA = min(a, other.a);

    // Convert back to 0-255 range and create new color
    return Color.fromARGB(
      (resultA * 255).round(),
      (resultR * 255).round(),
      (resultG * 255).round(),
      (resultB * 255).round(),
    );
  }

  /// Helper function to apply the dodge operation to a single color component
  double _dodgeComponent(double base, double blend) {
    if (base == 0) return 0;
    if (blend == 1) return 1;

    final result = base / (1.0 - blend);
    return math.min(1, result);
  }

  /// Helper function to apply the overlay operation to a single color component
  double _overlayComponent(double base, double blend) {
    if (base <= 0.5) {
      // Multiply mode for darker colors
      return 2 * base * blend;
    } else {
      // Screen mode for lighter colors
      return 1 - 2 * (1 - base) * (1 - blend);
    }
  }

  /// Convenience method to create a new color with modified opacity
  Color withOpacity(double opacity) {
    return Color.fromARGB(
      (opacity * 255).round(),
      (r * 255).round(),
      (g * 255).round(),
      (b * 255).round(),
    );
  }
}
