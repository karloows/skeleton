import 'package:flutter/widgets.dart' show BuildContext, InheritedWidget;

import 'skeleton_bone.dart' show SkeletonStyle;

/// Carries the ambient loading state for [Skeleton]-aware widgets below it.
///
/// Wrap a screen or section once with `Skeleton(loading: ..., child: ...)`;
/// descendants like `SkeletonText` read the flag via [Skeleton.of].
class Skeleton extends InheritedWidget {
  /// Creates a scope that marks [child]'s subtree as loading or not.
  const Skeleton({
    super.key,
    required this.loading,
    this.style = SkeletonStyle.shimmer,
    required super.child,
  });

  /// Whether descendants should render their skeleton bone instead of the
  /// real content.
  final bool loading;

  /// The default bone animation style for descendants that don't set their
  /// own `style`.
  final SkeletonStyle style;

  /// Reads the nearest [Skeleton]'s [loading] flag.
  static bool of(BuildContext context) => _scopeOf(context).loading;

  /// Reads the nearest [Skeleton]'s [style].
  static SkeletonStyle styleOf(BuildContext context) => _scopeOf(context).style;

  static Skeleton _scopeOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<Skeleton>();
    assert(scope != null, 'No Skeleton found in context.');
    return scope!;
  }

  @override
  bool updateShouldNotify(Skeleton oldWidget) =>
      loading != oldWidget.loading || style != oldWidget.style;
}
