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

  testWidgets('SkeletonText measures Text.rich via its textSpan', (
    tester,
  ) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: SizedBox(
            width: 120,
            child: Skeleton(
              loading: true,
              child: SkeletonText(
                child: Text.rich(
                  TextSpan(
                    text:
                        'Learn about the latest design patterns and best '
                        'practices for building scalable Flutter '
                        'applications.',
                    style: TextStyle(fontSize: 16, color: Color(0xFF445566)),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    final bones = tester.widgetList<SkeletonBone>(find.byType(SkeletonBone));
    expect(bones.length, greaterThan(1));
    for (final bone in bones) {
      expect(bone.color, const Color(0xFF445566));
      expect(bone.height, 16 * 1.2);
    }
  });

  testWidgets('SkeletonText respects softWrap: false as a single line', (
    tester,
  ) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: SizedBox(
            width: 120,
            child: Skeleton(
              loading: true,
              child: SkeletonText(
                child: Text(
                  'Learn about the latest design patterns and best '
                  'practices for building scalable Flutter applications.',
                  softWrap: false,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(SkeletonBone), findsOneWidget);
  });

  testWidgets('SkeletonText scales bone height with a non-default TextScaler', (
    tester,
  ) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Skeleton(
            loading: true,
            child: SkeletonText(
              child: Text('hello', style: TextStyle(fontSize: 10)),
            ),
          ),
        ),
      ),
    );

    final bone = tester.widget<SkeletonBone>(find.byType(SkeletonBone));
    expect(bone.height, 10 * 2 * 1.2);
  });

  testWidgets(
    'SkeletonText inherits ancestor fontSize into a Text.rich span with '
    'inherit: false',
    (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: DefaultTextStyle(
            style: TextStyle(fontSize: 30, color: Color(0xFF112233)),
            child: Skeleton(
              loading: true,
              child: SkeletonText(
                child: Text.rich(
                  TextSpan(
                    text: 'hello',
                    style: TextStyle(inherit: false, color: Color(0xFF445566)),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      final bone = tester.widget<SkeletonBone>(find.byType(SkeletonBone));
      expect(bone.color, const Color(0xFF445566));
      expect(bone.height, 30 * 1.2);
    },
  );

  testWidgets('SkeletonText uses an explicit textDirection without ambient '
      'Directionality', (tester) async {
    await tester.pumpWidget(
      const Skeleton(
        loading: true,
        child: SkeletonText(child: Text('', textDirection: TextDirection.rtl)),
      ),
    );

    expect(find.byType(SkeletonBone), findsOneWidget);
  });

  testWidgets(
    'SkeletonText wraps multi-line RTL text without ambient Directionality',
    (tester) async {
      await tester.pumpWidget(
        const Skeleton(
          loading: true,
          child: SkeletonText(
            width: 120,
            child: Text(
              'Learn about the latest design patterns and best practices '
              'for building scalable Flutter applications.',
              textDirection: TextDirection.rtl,
            ),
          ),
        ),
      );

      expect(find.byType(SkeletonBone), findsWidgets);
      expect(
        tester.widgetList<SkeletonBone>(find.byType(SkeletonBone)).length,
        greaterThan(1),
      );
    },
  );

  testWidgets(
    'SkeletonText inherits maxLines and softWrap from DefaultTextStyle',
    (tester) async {
      const longText =
          'Learn about the latest design patterns and best practices for '
          'building scalable Flutter applications.';

      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: SizedBox(
              width: 120,
              child: DefaultTextStyle(
                style: TextStyle(fontSize: 16),
                maxLines: 1,
                softWrap: false,
                child: Skeleton(
                  loading: true,
                  child: SkeletonText(child: Text(longText)),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(SkeletonBone), findsOneWidget);
    },
  );

  testWidgets(
    'SkeletonText reflows its bone width as preview updates, before child '
    'has real data',
    (tester) async {
      const style = TextStyle(fontSize: 16);
      final preview = ValueNotifier<String?>(null);
      addTearDown(preview.dispose);

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Skeleton(
            loading: true,
            child: SkeletonText(
              // Real content isn't known yet — only the preview is.
              preview: preview,
              child: const Text('', style: style),
            ),
          ),
        ),
      );

      final shortWidth = tester
          .widget<SkeletonBone>(find.byType(SkeletonBone))
          .width;

      preview.value = 'A much longer string than before';
      await tester.pump();

      final longWidth = tester
          .widget<SkeletonBone>(find.byType(SkeletonBone))
          .width;

      expect(longWidth, greaterThan(shortWidth ?? 0));
    },
  );

  testWidgets('SkeletonText uses an explicit borderRadius over the default', (
    tester,
  ) async {
    const pill = BorderRadius.all(Radius.circular(999));

    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Skeleton(
          loading: true,
          child: SkeletonText(
            borderRadius: pill,
            child: Text('\$9.99', style: TextStyle(fontSize: 16)),
          ),
        ),
      ),
    );

    final bone = tester.widget<SkeletonBone>(find.byType(SkeletonBone));
    expect(bone.borderRadius, pill);
  });
}
