import 'dart:math' as math;

import 'package:flutter/widgets.dart'
    show
        Alignment,
        AnimatedBuilder,
        AnimationController,
        BorderRadius,
        BoxDecoration,
        BuildContext,
        Color,
        Decoration,
        DecoratedBox,
        LayoutBuilder,
        LinearGradient,
        RadialGradient,
        Radius,
        SingleTickerProviderStateMixin,
        SizedBox,
        State,
        StatefulWidget,
        Widget;

const _fallbackExtent = 100.0;

/// Visual animation style for a [SkeletonBone].
enum SkeletonStyle {
  /// Gradient highlight sweeping left to right (default).
  shimmer,

  /// Gradient highlight sweeping top to bottom.
  wave,

  /// A narrow, brighter band sweeping diagonally.
  sheen,

  /// Opacity fades in and out.
  pulse,

  /// A soft glow that grows and shrinks from the center.
  breathe,

  /// A flat, unanimated fill.
  solid,
}

/// The shared low-level skeleton placeholder: a bone painted in [color],
/// animated per [style].
///
/// Typed widgets like `SkeletonText` and `SkeletonImage` sample a color
/// from the real content and render it through this bone. Use it directly
/// only when building a custom color-matched bone of your own.
class SkeletonBone extends StatefulWidget {
  /// Creates a bone in [color], sized by [width]/[height] and animated
  /// per [style].
  const SkeletonBone({
    super.key,
    required this.color,
    this.width,
    this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
    this.style = SkeletonStyle.shimmer,
  });

  /// The bone's base color, normally sampled from the content it replaces.
  final Color color;

  /// Bone width. When omitted, fills the parent's bounded width, or falls
  /// back to a fixed extent under unbounded constraints.
  final double? width;

  /// Bone height. Same fallback behavior as [width].
  final double? height;

  /// Bone corner radius.
  final BorderRadius borderRadius;

  /// The bone's animation style. Defaults to [SkeletonStyle.shimmer].
  final SkeletonStyle style;

  @override
  State<SkeletonBone> createState() => _SkeletonBoneState();
}

class _SkeletonBoneState extends State<SkeletonBone>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  );

  @override
  void initState() {
    super.initState();
    if (widget.style != SkeletonStyle.solid) _controller.repeat();
  }

  @override
  void didUpdateWidget(covariant SkeletonBone oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.style == oldWidget.style) return;
    if (widget.style == SkeletonStyle.solid) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.width != null && widget.height != null) {
      return _bone(widget.width, widget.height);
    }
    return LayoutBuilder(
      builder: (context, constraints) => _bone(
        widget.width ??
            _extentOrFallback(
              constraints.hasBoundedWidth,
              constraints.maxWidth,
            ),
        widget.height ??
            _extentOrFallback(
              constraints.hasBoundedHeight,
              constraints.maxHeight,
            ),
      ),
    );
  }

  static double _extentOrFallback(bool bounded, double extent) =>
      bounded ? extent : _fallbackExtent;

  Widget _bone(double? width, double? height) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return DecoratedBox(
          decoration: _decorationFor(_controller.value),
          child: SizedBox(width: width, height: height),
        );
      },
    );
  }

  Decoration _decorationFor(double t) {
    final color = widget.color;
    switch (widget.style) {
      case SkeletonStyle.solid:
        return BoxDecoration(borderRadius: widget.borderRadius, color: color);

      case SkeletonStyle.shimmer:
        return BoxDecoration(
          borderRadius: widget.borderRadius,
          gradient: LinearGradient(
            begin: Alignment(-3 + t * 4, 0),
            end: Alignment(-1 + t * 4, 0),
            colors: [color, color.withAlpha(102), color],
          ),
        );

      case SkeletonStyle.wave:
        return BoxDecoration(
          borderRadius: widget.borderRadius,
          gradient: LinearGradient(
            begin: Alignment(0, -3 + t * 4),
            end: Alignment(0, -1 + t * 4),
            colors: [color, color.withAlpha(102), color],
          ),
        );

      case SkeletonStyle.sheen:
        return BoxDecoration(
          borderRadius: widget.borderRadius,
          gradient: LinearGradient(
            begin: Alignment(-3 + t * 4, -1),
            end: Alignment(-1 + t * 4, 1),
            stops: const [0.35, 0.5, 0.65],
            colors: [color, color.withAlpha(217), color],
          ),
        );

      case SkeletonStyle.pulse:
        final phase = 0.5 + 0.5 * math.sin(t * 2 * math.pi);
        return BoxDecoration(
          borderRadius: widget.borderRadius,
          color: Color.lerp(color.withAlpha(97), color, phase),
        );

      case SkeletonStyle.breathe:
        final phase = 0.5 + 0.5 * math.sin(t * 2 * math.pi);
        return BoxDecoration(
          borderRadius: widget.borderRadius,
          gradient: RadialGradient(
            radius: 0.7 + 0.3 * phase,
            colors: [color, color.withAlpha(115)],
          ),
        );
    }
  }
}
