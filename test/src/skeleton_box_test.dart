import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:skeleton/skeleton.dart';

void main() {
  testWidgets('SkeletonBox swaps between child and color-matched bone', (
    tester,
  ) async {
    Widget buildFor({required bool loading}) => Directionality(
      textDirection: TextDirection.ltr,
      child: Skeleton(
        loading: loading,
        child: SkeletonBox(
          child: Container(
            key: Key('real-child'),
            color: Color(0xFFAA00AA),
            width: 40,
            height: 40,
          ),
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

  testWidgets('SkeletonBox matches the child Container size when width and '
      'height are omitted', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: Skeleton(
            loading: true,
            child: SkeletonBox(
              child: Container(
                color: const Color(0xFFAA00AA),
                width: 60,
                height: 30,
              ),
            ),
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byType(SkeletonBone)), const Size(60, 30));
  });
}
