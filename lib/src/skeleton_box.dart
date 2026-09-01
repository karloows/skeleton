import 'package:flutter/widgets.dart'
    show
        BorderRadius,
        BuildContext,
        Color,
        Container,
        Padding,
        StatelessWidget,
        Widget;

import 'skeleton_bone.dart' show SkeletonBone;
import 'skeleton_scope.dart' show Skeleton;

const _fallbackColor = Color(0xFF9E9E9E);

/// A wrapper around a [Container] that renders a skeleton bone matching its
/// [Container.color] and size while the nearest [Skeleton] is loading, and
/// [child] itself otherwise.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    required this.child,
    this.color,
    this.width,
    this.height,
    this.borderRadius = BorderRadius.zero,
  });

  final Container child;

  /// The bone's color while loading. Defaults to [child]'s own
  /// [Container.color] so the placeholder matches the fill it replaces.
  final Color? color;

  /// Bone size while loading. Defaults to [child]'s own resolved size
  /// (from its `width`/`height`/`constraints`) when set; otherwise fills
  /// the space the parent gives it, same as [SkeletonBone].
  final double? width;
  final double? height;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    if (!Skeleton.of(context)) {
      return child;
    }

    final constraints = child.constraints;
    final bone = SkeletonBone(
      color: color ?? child.color ?? _fallbackColor,
      width:
          width ??
          (constraints?.hasTightWidth ?? false ? constraints!.maxWidth : null),
      height:
          height ??
          (constraints?.hasTightHeight ?? false
              ? constraints!.maxHeight
              : null),
      borderRadius: borderRadius,
    );
    final margin = child.margin;
    return margin == null ? bone : Padding(padding: margin, child: bone);
  }
}
