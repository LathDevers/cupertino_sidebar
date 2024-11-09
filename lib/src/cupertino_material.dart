import 'dart:ui';

import 'package:cupertino_sidebar/src/util/color_dodge.dart';
import 'package:flutter/cupertino.dart';

/// A layer in a [CupertinoMaterial] widget.
///
/// The [CupertinoMaterialLayer] class represents a single layer in a Cupertino
/// material widget.
/// It defines the color, background color, and blend mode for the layer.
///
/// The [resolve] method returns the resolved color for the layer based on
/// the specified blend mode.
///
/// The following blend modes are supported:
/// - [BlendMode.colorDodge]
/// - [BlendMode.overlay]
class CupertinoMaterialLayer {
  /// Creates a [CupertinoMaterialLayer].
  ///
  /// The following blend modes are supported:
  /// - [BlendMode.colorDodge]
  /// - [BlendMode.overlay]
  CupertinoMaterialLayer({
    required this.color,
    required this.backgroundColor,
    required this.blendMode,
  });

  /// The color of the layer.
  final Color color;

  /// The background color of the layer.
  final Color backgroundColor;

  /// The blend mode to used for [color] and [backgroundColor].
  final BlendMode blendMode;

  /// Returns the resolved color for the layer based on the
  /// specified blend mode.
  Color get resolve {
    if (blendMode == BlendMode.colorDodge) {
      return color.colorDodge(backgroundColor);
    }
    if (blendMode == BlendMode.overlay) {
      return color.overlay(backgroundColor);
    }
    throw UnimplementedError('$blendMode is not yet implemented.');
  }
}

/// A style for a [CupertinoMaterial] widget.
///
/// The [CupertinoMaterialStyle] class defines the visual style
/// of a [CupertinoMaterial] widget, including the light and dark layer
/// colors and blend modes.
class CupertinoMaterialStyle {
  /// Creates a new instance of [CupertinoMaterialStyle].
  CupertinoMaterialStyle({
    required this.lightLayer,
    required this.darkLayer,
  });

  /// The light layer color and blend mode.
  final CupertinoMaterialLayer lightLayer;

  /// The dark layer color and blend mode.
  final CupertinoMaterialLayer darkLayer;

  /// Resolves the color of this material based on the given context's
  /// brightness.
  Color resolveWith(BuildContext context) {
    final brightness = CupertinoTheme.maybeBrightnessOf(context);

    if (brightness == Brightness.light) {
      return lightLayer.resolve;
    }

    return darkLayer.resolve;
  }

  /// A regular material
  static final regular = CupertinoMaterialStyle(
    lightLayer: CupertinoMaterialLayer(
      backgroundColor: const HSLColor.fromAHSL(1, 0, 0, 0.28).toColor(),
      color: const HSLColor.fromAHSL(0.82, 0, 0, 0.7).toColor(),
      blendMode: BlendMode.colorDodge,
    ),
    darkLayer: CupertinoMaterialLayer(
      // Color handpicked to match the iOS 16 dark mode.
      color: const HSLColor.fromAHSL(0.82, 0, 0, 0.12).toColor(),
      backgroundColor: const HSLColor.fromAHSL(1, 0, 0, 0.55).toColor(),
      blendMode: BlendMode.overlay,
    ),
  );

  /// A thin material
  static final thin = CupertinoMaterialStyle(
    lightLayer: CupertinoMaterialLayer(
      backgroundColor: const HSLColor.fromAHSL(1, 0, 0, 0.2).toColor(),
      color: const HSLColor.fromAHSL(0.7, 0, 0, 0.755).toColor(),
      blendMode: BlendMode.colorDodge,
    ),
    darkLayer: CupertinoMaterialLayer(
      // Color handpicked to match the iOS 16 dark mode.
      color: const HSLColor.fromAHSL(0.7, 0, 0, 0.15).toColor(),
      backgroundColor: const HSLColor.fromAHSL(1, 0, 0, 0.61).toColor(),
      blendMode: BlendMode.overlay,
    ),
  );
}

/// A peace of material in iOS-style.
///
/// The [material](https://developer.apple.com/documentation/swiftui/material) is a nearly opaque surface, that applies a strong blur effect
/// to the background.
///
/// The type of material is determined by the [style] property.
///
/// When [isActive] is set to `false`, the material is not rendered and only
/// the [child] is displayed.
///
/// See also:
/// - [Material] the Material-design counterpart
/// - [CupertinoMaterialStyle] class that defines the style of the material.
class CupertinoMaterial extends StatelessWidget {
  /// Creates an iOS-style material.
  const CupertinoMaterial({
    required this.style,
    required this.child,
    super.key,
    this.isActive = true,
  });

  /// The style of the [CupertinoMaterial] widget.
  ///
  /// See also:
  /// - [CupertinoMaterialStyle.regular] a regular material.
  final CupertinoMaterialStyle style;

  /// The child of the [CupertinoMaterial] widget.
  final Widget child;

  /// Whether the material is active.
  ///
  /// When set to `false`, the material is not rendered and only
  /// the child is displayed.
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final material = ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 50,
          sigmaY: 50,
        ),
        child: ColoredBox(
          color: style.resolveWith(context),
          child: child,
        ),
      ),
    );
    if (isActive) return material;

    return child;
  }
}
