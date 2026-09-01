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
}
