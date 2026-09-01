import 'package:flutter/widgets.dart'
    show
        BorderRadius,
        BuildContext,
        Color,
        DefaultTextStyle,
        StatelessWidget,
        Text,
        TextStyle,
        Widget;

import 'skeleton_bone.dart' show SkeletonBone;
import 'skeleton_scope.dart' show Skeleton;

/// A drop-in replacement for [Text] that renders a color-matched skeleton
/// bone while the nearest [Skeleton] is loading.
///
/// The bone color is sampled from [style]'s color, or the ambient
/// [DefaultTextStyle] color when [style] doesn't set one, so the
/// placeholder matches the text that will replace it.
class SkeletonText extends StatelessWidget {
  const SkeletonText(this.data, {super.key, this.style, this.width});

  final String data;
  final TextStyle? style;

  /// Bone width while loading. Defaults to an estimate based on [data]'s
  /// length so the placeholder roughly matches the eventual text.
  final double? width;

  @override
  Widget build(BuildContext context) {
    if (!Skeleton.of(context)) {
      return Text(data, style: style);
    }

    final defaultStyle = DefaultTextStyle.of(context).style;
    final color = style?.color ?? defaultStyle.color ?? const Color(0xFF9E9E9E);
    final fontSize = style?.fontSize ?? defaultStyle.fontSize ?? 14;

    return SkeletonBone(
      color: color,
      width: width ?? (data.length * fontSize * 0.55),
      height: fontSize * 1.2,
      borderRadius: BorderRadius.circular(fontSize / 3),
    );
  }
}
