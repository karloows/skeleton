import 'package:flutter/widgets.dart'
    show
        BorderRadius,
        BuildContext,
        Color,
        Column,
        CrossAxisAlignment,
        DefaultTextStyle,
        Directionality,
        LayoutBuilder,
        MainAxisSize,
        MediaQuery,
        SizedBox,
        StatelessWidget,
        Text,
        TextPainter,
        TextSpan,
        TextStyle,
        Widget;

import 'skeleton_bone.dart' show SkeletonBone;
import 'skeleton_scope.dart' show Skeleton;

const _fallbackColor = Color(0xFF9E9E9E);
const _fallbackFontSize = 14.0;
const _lineGap = 6.0;

/// A wrapper around [child] that renders a color-matched skeleton bone
/// while the nearest [Skeleton] is loading, and [child] itself otherwise.
///
/// The bone is measured with the same [TextPainter] Flutter uses to lay
/// out real text, so it mirrors [child]'s wrapped line count and each
/// line's width — not just its color. Bar height and inter-line spacing
/// are fixed, readable defaults rather than exact font metrics.
class SkeletonText extends StatelessWidget {
  const SkeletonText({super.key, required this.child, this.width});

  final Text child;

  /// Max width available for wrapping, matching how [child] would wrap.
  /// When omitted, uses the space the parent gives it.
  final double? width;

  @override
  Widget build(BuildContext context) {
    if (!Skeleton.of(context)) {
      return child;
    }

    final style = DefaultTextStyle.of(context).style.merge(child.style);
    final color = style.color ?? _fallbackColor;

    if (width != null) {
      return _bones(context, style, color, width!);
    }
    return LayoutBuilder(
      builder: (context, constraints) => _bones(
        context,
        style,
        color,
        constraints.hasBoundedWidth ? constraints.maxWidth : double.infinity,
      ),
    );
  }

  Widget _bones(
    BuildContext context,
    TextStyle style,
    Color color,
    double maxWidth,
  ) {
    final painter = TextPainter(
      text: TextSpan(
        style: style,
        text: child.data,
        children: child.textSpan != null ? [child.textSpan!] : null,
      ),
      textDirection: Directionality.of(context),
      textScaler: child.textScaler ?? MediaQuery.textScalerOf(context),
      maxLines: child.maxLines,
    )..layout(maxWidth: (child.softWrap ?? true) ? maxWidth : double.infinity);
    final lines = painter.computeLineMetrics();
    painter.dispose();

    final fontSize = style.fontSize ?? _fallbackFontSize;
    final radius = BorderRadius.circular(fontSize / 3);
    if (lines.isEmpty) {
      return SkeletonBone(
        color: color,
        width: 0,
        height: fontSize,
        borderRadius: radius,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < lines.length; i++) ...[
          if (i > 0) const SizedBox(height: _lineGap),
          SkeletonBone(
            color: color,
            width: lines[i].width,
            height: fontSize * 1.2,
            borderRadius: radius,
          ),
        ],
      ],
    );
  }
}
