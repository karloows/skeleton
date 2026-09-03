import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:skeleton/skeleton.dart';

void main() {
  testWidgets('Skeleton.of resolves to the nearest ancestor scope', (
    tester,
  ) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Skeleton(
          loading: true,
          child: Skeleton(loading: false, child: Text('hello')),
        ),
      ),
    );

    expect(find.text('hello'), findsOneWidget);
  });

  testWidgets('independent list items each keep their own loading state via a '
      'per-item Skeleton scope, keyed like normal ListView children', (
    tester,
  ) async {
    final items = [
      (id: 'a', loading: true),
      (id: 'b', loading: false),
      (id: 'c', loading: true),
    ];

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Column(
          children: [
            for (final item in items)
              Skeleton(
                key: ValueKey(item.id),
                loading: item.loading,
                child: SkeletonText(child: Text('item-${item.id}')),
              ),
          ],
        ),
      ),
    );

    expect(find.text('item-a'), findsNothing);
    expect(find.text('item-b'), findsOneWidget);
    expect(find.text('item-c'), findsNothing);
    expect(find.byType(SkeletonBone), findsNWidgets(2));
  });
}
