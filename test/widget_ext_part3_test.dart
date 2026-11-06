import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:twinui/twinui.dart';

Widget _host(Widget w) =>
    Directionality(textDirection: TextDirection.ltr, child: Center(child: w));

void main() {
  group('transform family', () {
    test('translate', () {
      final w = const Text('x').translate(offset: const Offset(3, 4));
      expect(w, isA<Transform>());
    });

    test('transform keeps matrix and alignment', () {
      final m = Matrix4.identity();
      final w = const Text('x')
          .transform(transform: m, alignment: Alignment.topLeft) as Transform;
      expect(w.transform, m);
      expect(w.alignment, Alignment.topLeft);
    });

    testWidgets('BUG5: animated scale keeps origin', (tester) async {
      final w = const SizedBox(width: 10, height: 10)
          .scale(all: 2, origin: const Offset(3, 4), animate: true)
          .animate(const Duration(milliseconds: 100), Curves.linear);
      await tester.pumpWidget(_host(w));
      final transforms = tester.widgetList<Transform>(find.byType(Transform));
      expect(transforms.any((t) => t.origin == const Offset(3, 4)), isTrue);
    });
  });

  group('overflow', () {
    test('BUG6: maxWidth and minWidth are independent', () {
      final w = const SizedBox().overflow(minWidth: 10, maxWidth: 50)
          as OverflowBox;
      expect(w.minWidth, 10);
      expect(w.maxWidth, 50);
    });

    test('BUG6: maxWidth alone is respected', () {
      final w = const SizedBox().overflow(maxWidth: 50) as OverflowBox;
      expect(w.maxWidth, 50);
      expect(w.minWidth, isNull);
    });
  });

  group('simple wrappers', () {
    test('expanded and flexible keep flex and fit', () {
      expect((const Text('x').expanded(flex: 3) as Expanded).flex, 3);
      final f = const Text('x').flexible(flex: 2, fit: FlexFit.tight)
          as Flexible;
      expect(f.flex, 2);
      expect(f.fit, FlexFit.tight);
    });

    test('positioned keeps all six values', () {
      // Flutter forbids left+right+width together, so test in two groups.
      final a = const Text('x')
          .positioned(left: 1, top: 2, right: 3, bottom: 4) as Positioned;
      expect([a.left, a.top, a.right, a.bottom], [1, 2, 3, 4]);
      final b = const Text('x')
          .positioned(left: 1, top: 2, width: 5, height: 6) as Positioned;
      expect([b.width, b.height], [5, 6]);
    });

    test('positionedDirectional', () {
      final p = const Text('x').positionedDirectional(start: 1, end: 2)
          as PositionedDirectional;
      expect(p.start, 1);
      expect(p.end, 2);
    });

    test('scrollable keeps direction and padding', () {
      final s = const Text('x').scrollable(
              scrollDirection: Axis.horizontal, padding: const EdgeInsets.all(4))
          as SingleChildScrollView;
      expect(s.scrollDirection, Axis.horizontal);
      expect(s.padding, const EdgeInsets.all(4));
    });

    test('safeArea, aspectRatio, center, fittedBox, limitedBox', () {
      expect((const Text('x').safeArea(top: false) as SafeArea).top, false);
      expect((const Text('x').aspectRatio(aspectRatio: 2) as AspectRatio)
          .aspectRatio, 2);
      expect((const Text('x').center(widthFactor: 2) as Center).widthFactor, 2);
      expect((const Text('x').fittedBox(fit: BoxFit.fill) as FittedBox).fit,
          BoxFit.fill);
      expect((const Text('x').limitedBox(maxWidth: 9) as LimitedBox).maxWidth,
          9);
    });

    test('card, material, mouseRegion, semanticsLabel', () {
      expect((const Text('x').card(elevation: 3) as Card).elevation, 3);
      expect((const Text('x').material(elevation: 2) as Material).elevation, 2);
      expect((const Text('x').mouseRegion(opaque: false) as MouseRegion).opaque,
          false);
      expect(const SizedBox().semanticsLabel('hello'), isA<Semantics>());
    });
  });

  group('gestures', () {
    test('only registers the handlers you asked for', () {
      final g = const SizedBox().gestures(onLongPress: () {}) as GestureDetector;
      expect(g.onLongPress, isNotNull);
      expect(g.onTap, isNull);
      expect(g.onTapDown, isNull);
      expect(g.onTapCancel, isNull);
    });

    test('BUG7: secondary tap callbacks are passed through', () {
      final g = const SizedBox().gestures(
        onSecondaryTapDown: (_) {},
        onSecondaryTapUp: (_) {},
        onSecondaryTapCancel: () {},
      ) as GestureDetector;
      expect(g.onSecondaryTapDown, isNotNull);
      expect(g.onSecondaryTapUp, isNotNull);
      expect(g.onSecondaryTapCancel, isNotNull);
    });

    testWidgets('onTap fires on tap', (tester) async {
      var taps = 0;
      await tester.pumpWidget(_host(const SizedBox(width: 50, height: 50)
          .gestures(onTap: () => taps++, behavior: HitTestBehavior.opaque)));
      await tester.tap(find.byType(GestureDetector));
      expect(taps, 1);
    });

    testWidgets('onTapChange reports true on press, false on release',
        (tester) async {
      final log = <bool>[];
      await tester.pumpWidget(_host(const SizedBox(width: 50, height: 50)
          .gestures(onTapChange: log.add, behavior: HitTestBehavior.opaque)));
      await tester.tap(find.byType(GestureDetector));
      expect(log, [true, false]);
    });

    testWidgets('onTapChange reports false when the tap is cancelled',
        (tester) async {
      final log = <bool>[];
      await tester.pumpWidget(_host(const SizedBox(width: 50, height: 50)
          .gestures(onTapChange: log.add, behavior: HitTestBehavior.opaque)));
      final g = await tester.startGesture(
          tester.getCenter(find.byType(GestureDetector)));
      await g.moveBy(const Offset(200, 0));
      await g.up();
      expect(log, [true, false]);
    });
  });
}
