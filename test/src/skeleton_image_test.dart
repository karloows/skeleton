import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:skeleton_tint/skeleton_tint.dart';

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

class _ConfigSensitiveImageProvider extends ImageProvider<String> {
  const _ConfigSensitiveImageProvider();

  @override
  Future<String> obtainKey(ImageConfiguration configuration) async =>
      'config-image-${configuration.devicePixelRatio}';

  @override
  ImageStreamCompleter loadImage(String key, ImageDecoderCallback decode) =>
      OneFrameImageStreamCompleter(_loadFrame(key));

  Future<ImageInfo> _loadFrame(String key) async {
    final color = key.endsWith('2.0')
        ? const Color(0xFF0000FF)
        : const Color(0xFFFF0000);
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    canvas.drawRect(
      const Rect.fromLTWH(0, 0, 10, 10),
      ui.Paint()..color = color,
    );
    final picture = recorder.endRecording();
    final image = await picture.toImage(10, 10);
    return ImageInfo(image: image, scale: 1);
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

  testWidgets(
    'SkeletonImage resamples when the inherited ImageConfiguration changes '
    'variant, and ignores the stale in-flight sample',
    (tester) async {
      Widget buildFor(double devicePixelRatio) => Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: MediaQueryData(devicePixelRatio: devicePixelRatio),
          child: const Skeleton(
            loading: true,
            child: SkeletonImage(image: _ConfigSensitiveImageProvider()),
          ),
        ),
      );

      await tester.pumpWidget(buildFor(1));
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pump();
      expect(
        tester.widget<SkeletonBone>(find.byType(SkeletonBone)).color,
        const Color(0xFFFF0000),
      );

      await tester.pumpWidget(buildFor(2));
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pump();
      expect(
        tester.widget<SkeletonBone>(find.byType(SkeletonBone)).color,
        const Color(0xFF0000FF),
      );
    },
  );
}
