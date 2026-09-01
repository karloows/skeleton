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
}
