import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:skeleton/skeleton.dart';

class _TestImageProvider extends ImageProvider<String> {
  const _TestImageProvider({this.size = const Size(100, 100), this.scale = 1});

  final Size size;
  final double scale;

  @override
  Future<String> obtainKey(ImageConfiguration configuration) async =>
      'test-image-${size.width}x${size.height}x$scale';

  @override
  ImageStreamCompleter loadImage(String key, ImageDecoderCallback decode) =>
      OneFrameImageStreamCompleter(_loadFrame());

  Future<ImageInfo> _loadFrame() async {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      ui.Paint()..color = const Color(0xFFEE1111),
    );
    final picture = recorder.endRecording();
    final image = await picture.toImage(
      size.width.toInt(),
      size.height.toInt(),
    );
    return ImageInfo(image: image, scale: scale);
  }
}

void main() {
  testWidgets('SkeletonImage uses fallback color on first frame', (
    tester,
  ) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Skeleton(
          loading: true,
          child: SkeletonImage(
            image: _TestImageProvider(),
            width: 100,
            height: 100,
          ),
        ),
      ),
    );

    final bone = tester.widget<SkeletonBone>(find.byType(SkeletonBone));
    expect(bone.color, const Color(0xFFBDBDBD));
  });

  testWidgets('SkeletonImage matches the decoded image size when width and '
      'height are omitted', (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: Skeleton(
            loading: true,
            child: SkeletonImage(image: _TestImageProvider(size: Size(60, 40))),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.getSize(find.byType(SkeletonBone)), const Size(60, 40));
  });

  testWidgets('SkeletonImage divides natural size by ImageInfo.scale', (
    tester,
  ) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: Skeleton(
            loading: true,
            child: SkeletonImage(
              image: _TestImageProvider(size: Size(120, 80), scale: 2),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.getSize(find.byType(SkeletonBone)), const Size(60, 40));
  });
}
