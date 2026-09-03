import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:skeleton/skeleton.dart';

void main() {
  testWidgets('SkeletonBone fills bounded constraints when size is omitted', (
    tester,
  ) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: SizedBox(
            width: 120,
            height: 80,
            child: SkeletonBone(color: const Color(0xFF000000)),
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byType(SkeletonBone)), const Size(120, 80));
  });

  testWidgets('SkeletonBone falls back to a fixed extent under unbounded '
      'constraints', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: OverflowBox(
          minWidth: 0,
          maxWidth: double.infinity,
          minHeight: 0,
          maxHeight: double.infinity,
          child: SkeletonBone(color: const Color(0xFF000000)),
        ),
      ),
    );

    expect(tester.getSize(find.byType(SkeletonBone)), const Size(100, 100));
  });

  testWidgets('SkeletonBone honors an explicit size over the bounded '
      'constraint', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: SkeletonBone(
            color: const Color(0xFF000000),
            width: 30,
            height: 20,
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byType(SkeletonBone)), const Size(30, 20));
  });
}
