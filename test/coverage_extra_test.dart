import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:twinui/twinui.dart';

const _d = Duration(milliseconds: 100);
const _g = LinearGradient(colors: [Colors.red, Colors.blue]);

Widget _host(Widget w) =>
    Directionality(textDirection: TextDirection.ltr, child: Center(child: w));

void main() {
  group('Text helpers', () {
    test('each helper sets its own field', () {
      const t = Text('x');
      expect(t.italic().style?.fontStyle, FontStyle.italic);
      expect(t.fontWeight(FontWeight.w700).style?.fontWeight, FontWeight.w700);
      expect(t.fontFamily('Roboto').style?.fontFamily, 'Roboto');
      expect(t.letterSpacing(2).style?.letterSpacing, 2);
      expect(t.wordSpacing(3).style?.wordSpacing, 3);
      expect(t.textColor(Colors.red).style?.color, Colors.red);
      expect(t.textBaseline(TextBaseline.ideographic).style?.textBaseline,
          TextBaseline.ideographic);
      expect(t.textAlignment(TextAlign.right).textAlign, TextAlign.right);
    });

    test('textShadow sets one shadow', () {
      final s = const Text('x')
          .textShadow(blurRadius: 3, offset: const Offset(1, 2))
          .style!
          .shadows!
          .single;
      expect(s.blurRadius, 3);
      expect(s.offset, const Offset(1, 2));
    });

    test('textDirection and textWidthBasis through the explicit extension', () {
      final a = StyledText(const Text('x')).textDirection(TextDirection.rtl);
      expect(a.textDirection, TextDirection.rtl);
      final b = StyledText(const Text('x'))
          .textWidthBasis(TextWidthBasis.longestLine);
      expect(b.textWidthBasis, TextWidthBasis.longestLine);
    });
  });

  group('TextSpan helpers', () {
    test('each helper sets its own field', () {
      const s = TextSpan(text: 'x');
      expect(s.italic().style?.fontStyle, FontStyle.italic);
      expect(s.fontWeight(FontWeight.w700).style?.fontWeight, FontWeight.w700);
      expect(s.fontSize(20).style?.fontSize, 20);
      expect(s.fontFamily('Roboto').style?.fontFamily, 'Roboto');
      expect(s.letterSpacing(2).style?.letterSpacing, 2);
      expect(s.wordSpacing(3).style?.wordSpacing, 3);
      expect(s.textColor(Colors.red).style?.color, Colors.red);
      expect(s.textBaseline(TextBaseline.ideographic).style?.textBaseline,
          TextBaseline.ideographic);
    });

    test('textShadow sets one shadow', () {
      final sh = const TextSpan(text: 'x')
          .textShadow(blurRadius: 3, offset: const Offset(1, 2))
          .style!
          .shadows!
          .single;
      expect(sh.blurRadius, 3);
      expect(sh.offset, const Offset(1, 2));
    });
  });

  testWidgets('Styled.builder hands the child to the builder', (tester) async {
    await tester.pumpWidget(_host(Styled.builder(
      builder: (context, child) =>
          Padding(padding: const EdgeInsets.all(3), child: child),
      child: const Text('x'),
    )));
    expect(find.text('x'), findsOneWidget);
    expect(find.byType(Padding), findsOneWidget);
  });

  testWidgets('animated variants of the remaining methods build and settle',
      (tester) async {
    const box = SizedBox(width: 20, height: 20);
    const colors = [Colors.red, Colors.blue];
    final widgets = <Widget>[
      box.paddingDirectional(all: 4, start: 8, animate: true),
      box.backgroundGradient(_g, animate: true),
      box.backgroundLinearGradient(colors: colors, animate: true),
      box.backgroundRadialGradient(colors: colors, animate: true),
      box.backgroundSweepGradient(colors: colors, animate: true),
      box.borderRadius(all: 4, animate: true),
      box.borderRadiusDirectional(all: 4, animate: true),
      box.decorated(color: Colors.red, animate: true),
      box.neumorphism(elevation: 4, animate: true),
      const Text('x').height(20, animate: true),
      Stack(children: [box.positioned(left: 1, top: 2, animate: true)]),
      Stack(
          children: [box.positionedDirectional(start: 1, top: 2, animate: true)]),
    ];
    for (final w in widgets) {
      await tester.pumpWidget(_host(w.animate(_d, Curves.linear)));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: '$w');
    }
  });
}
