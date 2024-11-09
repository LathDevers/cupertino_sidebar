import 'package:flutter/widgets.dart';

/// A widget that rebuilds its child widget based on a [Listenable]
/// when a specified condition is met.
///
/// The condition is defined by the [buildWhen] function.
///
///
/// This widget is useful when you want to optimize rebuilds and only update the
/// UI when specific conditions are met rather than on every change of
/// the [Listenable].
///
///
/// Example usage:
/// ```dart
/// ConditionalListenableBuilder<ValueNotifier<int>>(
///   listenable: myNotifier,
///   buildWhen: () => myNotifier.value.isEven,  // Only rebuild on even values.
///   builder: (context, child) {
///     return Text('Value: ${myNotifier.value}');
///   },
/// )
/// ```
///
/// See also:
/// - [Listenable], which notifies its listeners about changes.
/// - [ValueListenableBuilder], for a simpler listenable-based builder with
///  no conditional rebuild logic.
class ConditionalListenableBuilder<T> extends StatefulWidget {
  /// Creates a [ConditionalListenableBuilder].
  ///
  /// The [listenable] and [builder] arguments must not be null.
  const ConditionalListenableBuilder({
    required this.listenable,
    required this.builder,
    super.key,
    this.buildWhen,
    this.child,
  });

  /// An optional child widget that does not change between builds.
  ///
  /// If a part of the widget subtree does not need to rebuild, it can be
  /// passed as [child].
  ///
  /// This can help optimize performance by avoiding unnecessary rebuilds.
  final Widget? child;

  /// The [Listenable] that this widget listens to.
  ///
  /// When the [listenable] changes, the widget will rebuild according
  /// to the [buildWhen] callback, if provided.
  final Listenable listenable;

  /// A function that determines whether the widget should rebuild.
  ///
  /// If [buildWhen] is provided, it is called whenever [listenable] changes.
  /// If [buildWhen] returns `true`, the widget will rebuild; otherwise,
  /// it will not.
  /// If [buildWhen] is not provided, the widget rebuilds on every change
  /// of [listenable].
  final bool Function()? buildWhen;

  /// A function that builds the widget.
  final TransitionBuilder builder;

  @override
  State<StatefulWidget> createState() =>
      _ConditionalListenableBuilderState<T>();
}

class _ConditionalListenableBuilderState<T>
    extends State<ConditionalListenableBuilder<T>> {
  late T oldValue;

  @override
  void initState() {
    super.initState();
    oldValue = widget.listenable as T;
    widget.listenable.addListener(_handleChange);
  }

  @override
  void didUpdateWidget(ConditionalListenableBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.listenable != oldWidget.listenable) {
      oldWidget.listenable.removeListener(_handleChange);
      widget.listenable.addListener(_handleChange);
    }
  }

  @override
  void dispose() {
    widget.listenable.removeListener(_handleChange);
    super.dispose();
  }

  void _handleChange() {
    if (!mounted) return;
    if (widget.buildWhen != null && !widget.buildWhen!()) return;
    setState(() {
      // The listenable's state is our build state, and it changed already.
    });
    oldValue = widget.listenable as T;
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.child);
  }
}
