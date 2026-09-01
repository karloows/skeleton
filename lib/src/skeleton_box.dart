import 'package:flutter/widgets.dart'
    show BorderRadius, BuildContext, Color, StatelessWidget, Widget;

import 'skeleton_bone.dart' show SkeletonBone;
import 'skeleton_scope.dart' show Skeleton;

/// A drop-in wrapper for a fill widget (`Container`, `Card`, ...) that
/// renders a skeleton bone painted with [color] while the nearest
/// [Skeleton] is loading.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    required this.child,
    required this.color,
    this.width,
    this.height,
    this.borderRadius = BorderRadius.zero,
  });

  final Widget child;

  /// The bone's color while loading, normally the same fill color [child]
  /// uses once loaded.
  final Color color;
  final double? width;
  final double? height;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    if (!Skeleton.of(context)) {
      return child;
    }

    return SkeletonBone(
      color: color,
      width: width ?? 100,
      height: height ?? 100,
      borderRadius: borderRadius,
    );
  }
}
