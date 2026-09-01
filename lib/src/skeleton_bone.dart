import 'package:flutter/widgets.dart'
    show
        Alignment,
        AnimatedBuilder,
        AnimationController,
        BorderRadius,
        BoxDecoration,
        BuildContext,
        Color,
        DecoratedBox,
        LinearGradient,
        Radius,
        SingleTickerProviderStateMixin,
        SizedBox,
        State,
        StatefulWidget,
        Widget;

/// The shared low-level skeleton placeholder: a shimmering box painted in
/// [color].
///
/// Typed widgets like `SkeletonText` and `SkeletonImage` sample a color
/// from the real content and render it through this bone. Use it directly
/// only when building a custom color-matched bone of your own.
class SkeletonBone extends StatefulWidget {
  const SkeletonBone({
    super.key,
    required this.color,
    this.width,
    this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
  });

  /// The bone's base color, normally sampled from the content it replaces.
  final Color color;
  final double? width;
  final double? height;
  final BorderRadius borderRadius;

  @override
  State<SkeletonBone> createState() => _SkeletonBoneState();
}

class _SkeletonBoneState extends State<SkeletonBone>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            gradient: LinearGradient(
              begin: Alignment(-1 - t * 2, 0),
              end: Alignment(1 - t * 2, 0),
              colors: [widget.color, widget.color.withAlpha(102), widget.color],
            ),
          ),
          child: SizedBox(width: widget.width, height: widget.height),
        );
      },
    );
  }
}
