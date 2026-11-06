import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:twinui/twinui.dart';

Widget _host(Widget w) =>
    Directionality(textDirection: TextDirection.ltr, child: w);

void main() {
  blendModeTests();
  group('padding', () {
    test('all', () {
      final w = const Text('x').padding(all: 16) as Padding;
      expect(w.padding, const EdgeInsets.all(16));
      expect(w.child, isA<Text>());
    });

    test('specific sides override horizontal/vertical, which override all', () {
      final w = const Text('x')
          .padding(all: 10, horizontal: 20, vertical: 30, left: 1) as Padding;
      expect(w.padding, const EdgeInsets.only(left: 1, right: 20, top: 30, bottom: 30));
    });

    test('no arguments means zero padding', () {
      final w = const Text('x').padding() as Padding;
      expect(w.padding, EdgeInsets.zero);
    });

    test('key is applied', () {
      final w = const Text('x').padding(all: 1, key: const ValueKey('k'));
      expect(w.key, const ValueKey('k'));
    });

    test('paddingDirectional uses start/end', () {
      final w = const Text('x').paddingDirectional(all: 4, start: 9) as Padding;
      expect(w.padding,
          const EdgeInsetsDirectional.only(start: 9, end: 4, top: 4, bottom: 4));
    });

    testWidgets('animate: true builds an AnimatedPadding', (tester) async {
      final w = const Text('x')
          .padding(all: 8, animate: true)
          .animate(const Duration(milliseconds: 100), Curves.linear);
      await tester.pumpWidget(_host(w));
      expect(find.byType(AnimatedPadding), findsOneWidget);
      expect(find.text('x'), findsOneWidget);
    });
  });

  group('opacity, offstage, alignment, parent', () {
    test('opacity', () {
      final w = const Text('x').opacity(0.5) as Opacity;
      expect(w.opacity, 0.5);
    });

    test('offstage defaults to true', () {
      final w = const Text('x').offstage() as Offstage;
      expect(w.offstage, true);
    });

    test('alignment', () {
      final w = const Text('x').alignment(Alignment.bottomRight) as Align;
      expect(w.alignment, Alignment.bottomRight);
    });

    test('parent wraps the child', () {
      final w = const Text('x').parent(({required Widget child}) => Center(child: child));
      expect(w, isA<Center>());
      expect(((w as Center).child), isA<Text>());
    });
  });

  group('backgrounds', () {
    test('backgroundColor', () {
      final w = const Text('x').backgroundColor(Colors.red) as DecoratedBox;
      expect(w.decoration, const BoxDecoration(color: Colors.red));
    });

    test('backgroundLinearGradient with two colors', () {
      final w = const Text('x')
          .backgroundLinearGradient(colors: [Colors.red, Colors.blue]) as DecoratedBox;
      final g = (w.decoration as BoxDecoration).gradient as LinearGradient;
      expect(g.colors, [Colors.red, Colors.blue]);
    });

    test('borderRadius sets only the radius (no color of its own)', () {
      final w = const Text('x').borderRadius(all: 8) as DecoratedBox;
      final d = w.decoration as BoxDecoration;
      expect(d.borderRadius, BorderRadius.circular(8));
      expect(d.color, isNull);
    });

    testWidgets('animated background builds with animate() above',
        (tester) async {
      final w = const Text('x')
          .backgroundColor(Colors.red, animate: true)
          .animate(const Duration(milliseconds: 100), Curves.linear);
      await tester.pumpWidget(_host(w));
      expect(find.text('x'), findsOneWidget);
    });
  });

  group('known upstream limitations (pinned until we decide)', () {
    test('backgroundBlendMode alone asserts in debug', () {
      expect(
        () => const SizedBox().backgroundBlendMode(BlendMode.multiply),
        throwsA(isA<AssertionError>()),
      );
    });

    testWidgets('gradient with no colors throws when painted', (tester) async {
      await tester.pumpWidget(_host(
          const SizedBox(width: 10, height: 10).backgroundLinearGradient()));
      expect(tester.takeException(), isNotNull);
    });
  });
}

void blendModeTests() {
  group('backgroundBlendMode with colour or gradient', () {
    test('with a colour it builds one box with colour and blend mode', () {
      final w = const SizedBox()
          .backgroundBlendMode(BlendMode.multiply, color: Colors.red)
          as DecoratedBox;
      final d = w.decoration as BoxDecoration;
      expect(d.color, Colors.red);
      expect(d.backgroundBlendMode, BlendMode.multiply);
    });

    test('with a gradient it keeps the gradient', () {
      const g = LinearGradient(colors: [Colors.red, Colors.blue]);
      final w = const SizedBox()
          .backgroundBlendMode(BlendMode.screen, gradient: g) as DecoratedBox;
      expect((w.decoration as BoxDecoration).gradient, g);
    });

    testWidgets('animated version with a colour builds', (tester) async {
      await tester.pumpWidget(_host(const SizedBox(width: 10, height: 10)
          .backgroundBlendMode(BlendMode.multiply,
              color: Colors.red, animate: true)
          .animate(const Duration(milliseconds: 100), Curves.linear)));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });
}
