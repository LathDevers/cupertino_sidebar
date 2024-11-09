import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// A transition builder that applies a [CupertinoTabPageTransition].
///
/// This widget can be used to transition between tab views when
/// switching between tabs in a [CupertinoTabView], [CupertinoSidebar]
/// or [CupertinoFloatingTabBar].
class CupertinoTabTransitionBuilder extends StatelessWidget {
  /// Creates a [CupertinoTabTransitionBuilder].
  const CupertinoTabTransitionBuilder({
    required this.child,
    this.duration = const Duration(milliseconds: 400),
    super.key,
  });

  /// The child widget to be animated.
  final Widget child;

  /// The duration of the animation.
  ///
  /// Defaults to 400 milliseconds.
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      transitionBuilder: (child, animation) {
        return CupertinoTabPageTransition(
          animation: animation,
          child: child,
        );
      },
      child: child,
    );
  }
}

/// Transition that Zooms and fades a new page in, zooming out the previous
/// page.
///
/// This transition matches the iOS 18 tab switch transition.
class CupertinoTabPageTransition extends StatelessWidget {
  /// Creates a [CupertinoTabPageTransition].
  ///
  /// [child] and [animation] must not be null.
  const CupertinoTabPageTransition({
    required this.animation,
    required this.child,
    super.key,
    this.ignoreReducedMotion = false,
    this.scaleFactor = 0.994,
  });

  /// The animation that drives this transition.
  final Animation<double> animation;

  /// The child widget to be animated.
  final Widget child;

  /// The scale factor to apply to the child widget.
  ///
  /// Defaults to 0.994, which is eyeballed to match the iOS 18 tab
  /// switch transition.
  final double scaleFactor;

  /// Whether to ignore the reduced motion accessibility setting.
  ///
  /// Defaults to false.
  final bool ignoreReducedMotion;

  @override
  Widget build(BuildContext context) {
    final isMotionReduced =
        ignoreReducedMotion || MediaQuery.disableAnimationsOf(context);

    if (isMotionReduced) {
      return child;
    }

    return DualTransitionBuilder(
      animation: animation,
      forwardBuilder: (context, animation, child) {
        final scaleCurve = CurvedAnimation(
          parent: animation,
          curve: const Interval(0.45, 1, curve: Curves.easeOut),
        );

        final opacityCurve = CurvedAnimation(
          parent: animation,
          curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
        );

        final opacity = Tween<double>(begin: 0, end: 1).animate(opacityCurve);
        final scale =
            Tween<double>(begin: scaleFactor, end: 1).animate(scaleCurve);
        return ScaleTransition(
          scale: scale,
          child: FadeTransition(
            opacity: opacity,
            child: child,
          ),
        );
      },
      reverseBuilder: (context, animation, child) {
        final scaleCurve = CurvedAnimation(
          parent: animation,
          curve: const Interval(0, 0.55, curve: Curves.fastEaseInToSlowEaseOut),
        );

        final opacityCurve = CurvedAnimation(
          parent: animation,
          curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
        );

        final opacity = Tween<double>(begin: 1, end: 0).animate(opacityCurve);
        final scale =
            Tween<double>(begin: 1, end: scaleFactor).animate(scaleCurve);
        return ScaleTransition(
          scale: scale,
          child: FadeTransition(
            opacity: opacity,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
