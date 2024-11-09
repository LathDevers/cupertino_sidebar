import 'package:flutter/cupertino.dart';

// Code by https://github.com/flutter/flutter/issues/153937

/// The duration of the animation used to expand or collapse the
/// [CupertinoCollapsible].
///
/// The same duration is used for both expansion and collapse animations.
///
/// Based on iOS 17 manual testing.
const Duration kCupertinoCollapsibleAnimationDuration =
    Duration(milliseconds: 200);

/// The curve of the animation used to expand or collapse the
/// [CupertinoCollapsible].
///
/// The same curve is used for both expansion and collapse animations.
///
/// Based on iOS 17 manual testing.
const Curve kCupertinoCollapsibleAnimationCurve = Curves.easeInOut;

/// iOS-style collapsible widget.
///
/// This widget is a wrapper around [AnimatedCrossFade] that animates the
/// height of the child widget, and clips it to fit the parent when collapsed.
///
/// When collapsing/expanding, the height animates between 0 and the height of the child,
/// while the child is still laid out and painted. During the animation,
/// the size of the child doesn't change, it only gets clipped to fit the parent
class CupertinoCollapsible extends StatelessWidget {
  /// Creates an iOS-style collapsible widget.
  const CupertinoCollapsible({
    required this.child,
    super.key,
    this.isExpanded = true,
    this.animationStyle,
  }) : super();

  /// The child widget to be collapsed or expanded.
  final Widget child;

  /// Whether the child is expanded.
  ///
  /// Defaults to true.
  final bool isExpanded;

  /// Used to override the expansion animation curve and duration.
  ///
  /// If [AnimationStyle.duration] is provided, it will be used to override
  /// the expansion animation duration. If it is null, then
  /// [kCupertinoCollapsibleAnimationDuration] will be used.
  ///
  /// If [AnimationStyle.curve] is provided, it will be used to override
  /// the expansion animation curve. If it is null, then
  /// [kCupertinoCollapsibleAnimationCurve] will be used.
  ///
  /// The same curve will be used for expansion and collapse animations.
  ///
  /// To disable the animation, use [AnimationStyle.noAnimation].
  final AnimationStyle? animationStyle;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      crossFadeState:
          isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration:
          animationStyle?.duration ?? kCupertinoCollapsibleAnimationDuration,
      firstCurve: animationStyle?.curve ?? kCupertinoCollapsibleAnimationCurve,
      secondCurve: animationStyle?.curve ?? kCupertinoCollapsibleAnimationCurve,
      sizeCurve: animationStyle?.curve ?? kCupertinoCollapsibleAnimationCurve,
      alignment: Alignment.bottomLeft,
      firstChild: const SizedBox(
        width: double.infinity,
        height: 0,
      ),
      secondChild: child,
      layoutBuilder: (
        Widget topChild,
        Key topChildKey,
        Widget bottomChild,
        Key bottomChildKey,
      ) =>
          Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned(
            key: bottomChildKey,
            left: 0,
            right: 0,
            bottom: 0,
            child: bottomChild,
          ),
          Positioned(
            key: topChildKey,
            child: topChild,
          ),
        ],
      ),
    );
  }
}

/// The duration of the animation used to expand or collapse the
/// [CupertinoSidebarCollapsible].
///
/// Based on manual testing.
const kCupertinoSidebarCollapsibleDuration = Duration(milliseconds: 500);

/// The curve of the animation used to expand or collapse the
/// [CupertinoSidebarCollapsible].
///
/// Based on manual testing.
const kCupertinoSidebarCollapsibleCurve = Curves.fastEaseInToSlowEaseOut;

/// A widget that applies a collapse effect to a [CupertinoSidebar].
///
/// See also:
/// - [CupertinoSidebar] a iOS-style sidebar widget.
/// - [CupertinoCollapsible] a widget that applies a collapse effect to a widget
class CupertinoSidebarCollapsible extends StatelessWidget {
  /// Creates a [CupertinoSidebarCollapsible].
  const CupertinoSidebarCollapsible({
    required this.isExpanded,
    required this.child,
    this.animationStyle,
    super.key,
  });

  /// The duration and curve of the animation used to expand or collapse
  /// the [child].
  final AnimationStyle? animationStyle;

  /// Whether the child is expanded.
  final bool isExpanded;

  /// The child widget to be collapsed or expanded.
  ///
  /// When collapsed, the child is not laid out or painted.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration:
          animationStyle?.duration ?? kCupertinoSidebarCollapsibleDuration,
      reverseDuration: animationStyle?.duration,
      switchInCurve: animationStyle?.curve ?? kCupertinoSidebarCollapsibleCurve,
      switchOutCurve: animationStyle?.reverseCurve ??
          Curves.fastEaseInToSlowEaseOut.flipped,
      transitionBuilder: (child, animation) {
        return SizeTransition(
          axis: Axis.horizontal,
          sizeFactor: animation,
          child: child,
        );
      },
      child: isExpanded ? child : const SizedBox.shrink(),
    );
  }
}
