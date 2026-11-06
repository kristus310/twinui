import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:twinui/twinui.dart';

int _argb(int r, int g, int b) => (0xFF << 24) | (r << 16) | (g << 8) | b;

void main() {
  group('scale and rotate', () {
    test('scale(all:) scales both axes', () {
      final w = const Text('x').scale(all: 2) as Transform;
      expect(w.transform.storage[0], 2);
      expect(w.transform.storage[5], 2);
    });

    test('BUG4: scale(x:) alone leaves y unscaled', () {
      final w = const Text('x').scale(x: 2) as Transform;
      expect(w.transform.storage[0], 2);
      expect(w.transform.storage[5], 1);
    });

    test('BUG4: scale() with no arguments is the identity', () {
      final w = const Text('x').scale() as Transform;
      expect(w.transform.storage[0], 1);
      expect(w.transform.storage[5], 1);
    });

    test('rotate builds a rotation around Z', () {
      final w = const Text('x').rotate(angle: 1.0) as Transform;
      expect(w.transform.storage[0], closeTo(math.cos(1.0), 1e-9));
    });
  });

  group('border, decorated, shadows, clips, elevation', () {
    test('border(all:) draws on every side', () {
      final w = const Text('x').border(all: 2, color: Colors.red) as DecoratedBox;
      final b = (w.decoration as BoxDecoration).border! as Border;
      for (final side in [b.left, b.right, b.top, b.bottom]) {
        expect(side.width, 2);
        expect(side.color, Colors.red);
      }
    });

    test('border(top:) draws only the top', () {
      final w = const Text('x').border(top: 1) as DecoratedBox;
      final b = (w.decoration as BoxDecoration).border! as Border;
      expect(b.top.width, 1);
      expect(b.left, BorderSide.none);
      expect(b.right, BorderSide.none);
      expect(b.bottom, BorderSide.none);
    });

    test('border() with no arguments draws nothing', () {
      final w = const Text('x').border() as DecoratedBox;
      final b = (w.decoration as BoxDecoration).border! as Border;
      expect(b.top, BorderSide.none);
      expect(b.left, BorderSide.none);
    });

    test('decorated combines color, radius and border in ONE box', () {
      final w = const Text('x').decorated(
        color: Colors.red,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(width: 2),
      ) as DecoratedBox;
      final d = w.decoration as BoxDecoration;
      expect(d.color, Colors.red);
      expect(d.borderRadius, BorderRadius.circular(4));
      expect(d.border, Border.all(width: 2));
      expect(w.position, DecorationPosition.background);
    });

    test('boxShadow', () {
      final w = const Text('x')
          .boxShadow(blurRadius: 4, offset: const Offset(1, 2)) as DecoratedBox;
      final s = (w.decoration as BoxDecoration).boxShadow!.single;
      expect(s.blurRadius, 4);
      expect(s.offset, const Offset(1, 2));
    });

    test('clipRRect(all:) rounds every corner', () {
      final w = const Text('x').clipRRect(all: 8) as ClipRRect;
      expect(w.borderRadius, BorderRadius.circular(8));
      expect(w.clipBehavior, Clip.antiAlias);
    });

    test('clipRect and clipOval return the matching widgets', () {
      expect(const Text('x').clipRect(), isA<ClipRect>());
      expect(const Text('x').clipOval(), isA<ClipOval>());
    });

    test('elevation wraps in a transparent Material', () {
      final w = const Text('x').elevation(4) as Material;
      expect(w.elevation, 4);
      expect(w.color, Colors.transparent);
    });
  });

  group('sizing', () {
    test('width and height are tight constraints', () {
      expect((const Text('x').width(100) as ConstrainedBox).constraints,
          const BoxConstraints.tightFor(width: 100));
      expect((const Text('x').height(50) as ConstrainedBox).constraints,
          const BoxConstraints.tightFor(height: 50));
    });

    test('constrained mixes limits and tight sizes', () {
      final w = const Text('x').constrained(width: 50, maxHeight: 80)
          as ConstrainedBox;
      expect(
        w.constraints,
        const BoxConstraints(
            minWidth: 50, maxWidth: 50, minHeight: 0, maxHeight: 80),
      );
    });
  });

  group('neumorphism (pins current colors before the deprecation fix)', () {
    const base = Color(0xFF336699);
    List<int> colorsOf(Widget w) =>
        (((w as DecoratedBox).decoration as BoxDecoration).gradient!
                as LinearGradient)
            .colors
            .map((c) => c.toARGB32())
            .toList();

    test('curve 0 keeps the background colour on both ends', () {
      final w = const Text('x').neumorphism(elevation: 4, backgroundColor: base);
      expect(colorsOf(w), [0xFF336699, 0xFF336699]);
    });

    test('curve 1 shifts one end up and the other down by 40', () {
      final w = const Text('x')
          .neumorphism(elevation: 4, backgroundColor: base, curve: 1);
      expect(colorsOf(w), [
        _argb(0x33 + 40, 0x66 + 40, 0x99 + 40),
        _argb(0x33 - 40, 0x66 - 40, 0x99 - 40),
      ]);
    });
  });

  testWidgets('ripple adds an InkWell, enable:false does not', (tester) async {
    await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: const Text('x').ripple())));
    expect(find.byType(InkWell), findsOneWidget);
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: const Text('x').ripple(enable: false))));
    expect(find.byType(InkWell), findsNothing);
  });
}
