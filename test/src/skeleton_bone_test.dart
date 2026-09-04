import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:skeleton_tint/skeleton_tint.dart';

void main() {
  testWidgets('SkeletonBone fills bounded constraints when size is omitted', (
    tester,
  ) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: SizedBox(
            width: 120,
            height: 80,
            child: SkeletonBone(color: Color(0xFF000000)),
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byType(SkeletonBone)), const Size(120, 80));
  });

  testWidgets('SkeletonBone falls back to a fixed extent under unbounded '
      'constraints', (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: OverflowBox(
          minWidth: 0,
          maxWidth: double.infinity,
          minHeight: 0,
          maxHeight: double.infinity,
          child: SkeletonBone(color: Color(0xFF000000)),
        ),
      ),
    );

    expect(tester.getSize(find.byType(SkeletonBone)), const Size(100, 100));
  });

  testWidgets('SkeletonBone honors an explicit size over the bounded '
      'constraint', (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: SkeletonBone(color: Color(0xFF000000), width: 30, height: 20),
        ),
      ),
    );

    expect(tester.getSize(find.byType(SkeletonBone)), const Size(30, 20));
  });

  for (final style in SkeletonStyle.values) {
    testWidgets('SkeletonBone renders and animates with style $style', (
      tester,
    ) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: SkeletonBone(
            color: const Color(0xFF336699),
            width: 40,
            height: 20,
            style: style,
          ),
        ),
      );
      expect(find.byType(SkeletonBone), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 600));
      expect(find.byType(SkeletonBone), findsOneWidget);
    });
  }

  testWidgets('SkeletonBone switching away from solid resumes animating', (
    tester,
  ) async {
    Widget build(SkeletonStyle style) => Directionality(
      textDirection: TextDirection.ltr,
      child: SkeletonBone(
        color: const Color(0xFF336699),
        width: 40,
        height: 20,
        style: style,
      ),
    );

    await tester.pumpWidget(build(SkeletonStyle.solid));
    await tester.pumpWidget(build(SkeletonStyle.pulse));

    Color? colorAt() =>
        (tester.widget<DecoratedBox>(find.byType(DecoratedBox)).decoration
                as BoxDecoration)
            .color;

    final first = colorAt();
    await tester.pump(const Duration(milliseconds: 300));
    final second = colorAt();

    expect(first, isNotNull);
    expect(second, isNotNull);
    expect(first, isNot(equals(second)));
  });
}
