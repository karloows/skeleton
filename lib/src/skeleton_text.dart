import 'package:flutter/foundation.dart' show ValueListenable;
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
        TextScaler,
        TextSpan,
        TextStyle,
        ValueListenableBuilder,
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
  /// Creates a bone that swaps in for [child] while loading.
  const SkeletonText({
    super.key,
    required this.child,
    this.width,
    this.preview,
  });

  /// The real [Text] widget the bone replaces.
  final Text child;

  /// Max width available for wrapping, matching how [child] would wrap.
  /// When omitted, uses the space the parent gives it.
  final double? width;

  /// A source of partial text, known before [child]'s own data is final.
  ///
  /// While loading, the bone is measured against `preview.value` instead of
  /// `child.data` whenever it's non-null, and re-measures live as the
  /// listenable updates — so the bone can narrow or grow to match the real
  /// length as soon as it's known, even before [child] itself is rebuilt
  /// with the final string.
  final ValueListenable<String?>? preview;

  @override
  Widget build(BuildContext context) {
    if (!Skeleton.of(context)) {
      return child;
    }

    final defaultTextStyle = DefaultTextStyle.of(context);
    var style = defaultTextStyle.style.merge(child.style);
    final rootSpanStyle = child.textSpan?.style;
    if (rootSpanStyle != null) {
      // TextSpan.build() pushes styles onto the native paragraph builder's
      // style stack, where unset fields always inherit from the parent
      // regardless of TextStyle.inherit — unlike TextStyle.merge(), which
      // discards the base style entirely when inherit is false. Force
      // inherit here so ancestor fields (e.g. fontSize) survive the merge
      // the same way they'd survive real rendering.
      style = style.merge(rootSpanStyle.copyWith(inherit: true));
    }
    final color = style.color ?? _fallbackColor;

    final textScaler = child.textScaler ?? MediaQuery.textScalerOf(context);
    final maxLines = child.maxLines ?? defaultTextStyle.maxLines;
    final softWrap = child.softWrap ?? defaultTextStyle.softWrap;

    final preview = this.preview;
    if (preview == null) {
      return _layout(context, style, color, textScaler, maxLines, softWrap);
    }
    return ValueListenableBuilder<String?>(
      valueListenable: preview,
      builder: (context, previewText, _) => _layout(
        context,
        style,
        color,
        textScaler,
        maxLines,
        softWrap,
        text: previewText,
      ),
    );
  }

  Widget _layout(
    BuildContext context,
    TextStyle style,
    Color color,
    TextScaler textScaler,
    int? maxLines,
    bool softWrap, {
    String? text,
  }) {
    if (width != null) {
      return _bones(
        context,
        style,
        color,
        textScaler,
        maxLines,
        softWrap,
        width!,
        text: text,
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) => _bones(
        context,
        style,
        color,
        textScaler,
        maxLines,
        softWrap,
        constraints.hasBoundedWidth ? constraints.maxWidth : double.infinity,
        text: text,
      ),
    );
  }

  Widget _bones(
    BuildContext context,
    TextStyle style,
    Color color,
    TextScaler textScaler,
    int? maxLines,
    bool softWrap,
    double maxWidth, {
    String? text,
  }) {
    final textDirection = child.textDirection ?? Directionality.of(context);
    final painter = TextPainter(
      text: TextSpan(
        style: style,
        text: text ?? child.data,
        children: text == null && child.textSpan != null
            ? [child.textSpan!]
            : null,
      ),
      textDirection: textDirection,
      textScaler: textScaler,
      maxLines: maxLines,
    )..layout(maxWidth: softWrap ? maxWidth : double.infinity);
    final lines = painter.computeLineMetrics();
    painter.dispose();

    final fontSize = textScaler.scale(style.fontSize ?? _fallbackFontSize);
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
      textDirection: textDirection,
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
