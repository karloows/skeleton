import 'dart:ui' as ui;

import 'package:flutter/widgets.dart'
    show
        BorderRadius,
        BoxFit,
        BuildContext,
        ClipRRect,
        Color,
        Image,
        ImageConfiguration,
        ImageInfo,
        ImageProvider,
        ImageStream,
        ImageStreamListener,
        Size,
        State,
        StatefulWidget,
        Widget;

import 'skeleton_bone.dart' show SkeletonBone;
import 'skeleton_scope.dart' show Skeleton;

const _fallbackColor = Color(0xFFBDBDBD);

/// A drop-in replacement for [Image] that renders a skeleton bone painted
/// with the image's own average color while the nearest [Skeleton] is
/// loading.
///
/// The average color is sampled once per [image] (decoded via `dart:ui`,
/// no extra dependency) and cached for the widget's lifetime. Until the
/// sample resolves, the bone falls back to a neutral gray.
class SkeletonImage extends StatefulWidget {
  const SkeletonImage({
    super.key,
    required this.image,
    this.width,
    this.height,
    this.fit,
    this.borderRadius = BorderRadius.zero,
  });

  final ImageProvider image;

  /// Bone size while loading. When omitted, matches [image]'s own decoded
  /// pixel dimensions once known; until then, falls back to filling the
  /// space the parent gives it, same as [SkeletonBone].
  final double? width;
  final double? height;
  final BoxFit? fit;
  final BorderRadius borderRadius;

  @override
  State<SkeletonImage> createState() => _SkeletonImageState();
}

class _SkeletonImageState extends State<SkeletonImage> {
  Color? _averageColor;
  Size? _naturalSize;
  ImageStream? _stream;
  Object? _activeImageKey;
  late ImageStreamListener _listener;

  @override
  void initState() {
    super.initState();
    _listener = ImageStreamListener(_onFrame);
    _subscribe();
  }

  @override
  void didUpdateWidget(covariant SkeletonImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.image != widget.image) {
      _averageColor = null;
      _naturalSize = null;
      _subscribe();
    }
  }

  void _subscribe() {
    _stream?.removeListener(_listener);
    _activeImageKey = widget.image;
    _stream = widget.image.resolve(const ImageConfiguration());
    _stream!.addListener(_listener);
  }

  void _onFrame(ImageInfo info, bool _) {
    final key = _activeImageKey;
    final size = Size(
      info.image.width.toDouble(),
      info.image.height.toDouble(),
    );
    if (mounted && _activeImageKey == key) {
      setState(() => _naturalSize = size);
    }
    _averageColorOf(info.image).then((color) {
      if (mounted && _activeImageKey == key) {
        setState(() => _averageColor = color);
      }
    });
  }

  static Future<Color> _averageColorOf(ui.Image image) async {
    final bytes = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (bytes == null) return _fallbackColor;

    final pixels = bytes.buffer.asUint8List();
    const stride = 4 * 8; // sample every 8th pixel for speed.
    var r = 0, g = 0, b = 0, count = 0;
    for (var i = 0; i + 3 < pixels.length; i += stride) {
      r += pixels[i];
      g += pixels[i + 1];
      b += pixels[i + 2];
      count++;
    }
    if (count == 0) return _fallbackColor;
    return Color.fromARGB(255, r ~/ count, g ~/ count, b ~/ count);
  }

  @override
  void dispose() {
    _stream?.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!Skeleton.of(context)) {
      final image = Image(
        image: widget.image,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
      );
      if (widget.borderRadius == BorderRadius.zero) return image;
      return ClipRRect(borderRadius: widget.borderRadius, child: image);
    }

    return SkeletonBone(
      color: _averageColor ?? _fallbackColor,
      width: widget.width ?? _naturalSize?.width,
      height: widget.height ?? _naturalSize?.height,
      borderRadius: widget.borderRadius,
    );
  }
}
