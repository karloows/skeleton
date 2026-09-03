import 'package:flutter/widgets.dart' show BuildContext, InheritedWidget;

/// Carries the ambient loading state for [Skeleton]-aware widgets below it.
///
/// Wrap a screen or section once with `Skeleton(loading: ..., child: ...)`;
/// descendants like `SkeletonText` read the flag via [Skeleton.of].
class Skeleton extends InheritedWidget {
  /// Creates a scope that marks [child]'s subtree as loading or not.
  const Skeleton({super.key, required this.loading, required super.child});

  /// Whether descendants should render their skeleton bone instead of the
  /// real content.
  final bool loading;

  /// Reads the nearest [Skeleton]'s [loading] flag.
  static bool of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<Skeleton>();
    assert(scope != null, 'No Skeleton found in context.');
    return scope!.loading;
  }

  @override
  bool updateShouldNotify(Skeleton oldWidget) => loading != oldWidget.loading;
}
