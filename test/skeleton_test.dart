import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:skeleton/skeleton.dart';

class _TestImageProvider extends ImageProvider<String> {
  const _TestImageProvider();

  @override
  Future<String> obtainKey(ImageConfiguration configuration) async => '';

  @override
  ImageStreamCompleter loadImage(String key, ImageDecoderCallback decode) =>
      OneFrameImageStreamCompleter(_loadFrame());

  Future<ImageInfo> _loadFrame() async {
    const size = Size(100, 100);
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    canvas.drawRect(const Rect.fromLTWH(0, 0, 100, 100),
        ui.Paint()..color = const Color(0xFFEE1111));
    final picture = recorder.endRecording();
    final image =
        await picture.toImage(size.width.toInt(), size.height.toInt());
    return ImageInfo(image: image);
  }
}

void main() {
  testWidgets('SkeletonText renders the real text when not loading', (
    tester,
  ) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Skeleton(loading: false, child: SkeletonText('hello')),
      ),
    );

    expect(find.text('hello'), findsOneWidget);
    expect(find.byType(SkeletonBone), findsNothing);
  });

  testWidgets('SkeletonText renders a color-matched bone when loading', (
    tester,
  ) async {
    const style = TextStyle(color: Color(0xFF112233), fontSize: 20);

    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Skeleton(
          loading: true,
          child: SkeletonText('hello', style: style),
        ),
      ),
    );

    expect(find.text('hello'), findsNothing);
    final bone = tester.widget<SkeletonBone>(find.byType(SkeletonBone));
    expect(bone.color, const Color(0xFF112233));
  });

  testWidgets('SkeletonBox swaps between child and color-matched bone', (
    tester,
  ) async {
    Widget buildFor({required bool loading}) => Directionality(
      textDirection: TextDirection.ltr,
      child: Skeleton(
        loading: loading,
        child: const SkeletonBox(
          color: Color(0xFFAA00AA),
          width: 40,
          height: 40,
          child: SizedBox(key: Key('real-child')),
        ),
      ),
    );

    await tester.pumpWidget(buildFor(loading: false));
    expect(find.byKey(const Key('real-child')), findsOneWidget);
    expect(find.byType(SkeletonBone), findsNothing);

    await tester.pumpWidget(buildFor(loading: true));
    expect(find.byKey(const Key('real-child')), findsNothing);
    final bone = tester.widget<SkeletonBone>(find.byType(SkeletonBone));
    expect(bone.color, const Color(0xFFAA00AA));
  });

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
}
