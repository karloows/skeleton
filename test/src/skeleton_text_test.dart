import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:skeleton/skeleton.dart';

void main() {
  testWidgets('SkeletonText renders the real text when not loading', (
    tester,
  ) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Skeleton(
          loading: false,
          child: SkeletonText(child: Text('hello')),
        ),
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
          child: SkeletonText(child: Text('hello', style: style)),
        ),
      ),
    );

    expect(find.text('hello'), findsNothing);
    final bone = tester.widget<SkeletonBone>(find.byType(SkeletonBone));
    expect(bone.color, const Color(0xFF112233));
  });

  testWidgets('SkeletonText mirrors the real text\'s wrapped line count', (
    tester,
  ) async {
    const longText =
        'Learn about the latest design patterns and best practices for '
        'building scalable Flutter applications.';
    const style = TextStyle(fontSize: 16);

    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: SizedBox(
            width: 120,
            child: Skeleton(
              loading: true,
              child: SkeletonText(child: Text(longText, style: style)),
            ),
          ),
        ),
      ),
    );

    final realPainter = TextPainter(
      text: const TextSpan(text: longText, style: style),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 120);
    final expectedLines = realPainter.computeLineMetrics().length;
    realPainter.dispose();

    expect(expectedLines, greaterThan(1));
    expect(find.byType(SkeletonBone), findsNWidgets(expectedLines));
  });
}
