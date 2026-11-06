import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:twinui/twinui.dart';

Widget _host(Widget w) =>
    Directionality(textDirection: TextDirection.ltr, child: Center(child: w));

const _d = Duration(milliseconds: 100);

void main() {
  testWidgets('BUG8: animated backgroundBlur builds without throwing',
      (tester) async {
    await tester.pumpWidget(_host(const SizedBox(width: 20, height: 20)
        .backgroundBlur(5, animate: true)
        .animate(_d, Curves.linear)));
    expect(tester.takeException(), isNull);
    expect(find.byType(BackdropFilter), findsOneWidget);
  });

  testWidgets('BUG9: animated overflow moves through in-between values',
      (tester) async {
    Widget build(double maxW) => _host(const SizedBox(width: 20, height: 20)
        .overflow(maxWidth: maxW, animate: true)
        .animate(_d, Curves.linear));
    await tester.pumpWidget(build(100));
    await tester.pumpWidget(build(200));
    await tester.pump(const Duration(milliseconds: 50));
    final mid = tester.widget<OverflowBox>(find.byType(OverflowBox)).maxWidth;
    expect(mid, greaterThan(100));
    expect(mid, lessThan(200));
    await tester.pumpAndSettle();
    expect(tester.widget<OverflowBox>(find.byType(OverflowBox)).maxWidth, 200);
  });

  testWidgets('other animated variants build and settle without errors',
      (tester) async {
    final widgets = <Widget>[
      const SizedBox(width: 20, height: 20).scale(all: 2, animate: true),
      const SizedBox(width: 20, height: 20).rotate(angle: 1, animate: true),
      const SizedBox(width: 20, height: 20)
          .translate(offset: const Offset(5, 5), animate: true),
      const SizedBox(width: 20, height: 20).clipRRect(all: 4, animate: true),
      const SizedBox(width: 20, height: 20)
          .constrained(width: 50, animate: true),
      const Text('x').width(30, animate: true),
      const SizedBox(width: 20, height: 20)
          .border(all: 1, animate: true),
      const SizedBox(width: 20, height: 20)
          .boxShadow(blurRadius: 3, animate: true),
      const SizedBox(width: 20, height: 20).opacity(0.5, animate: true),
      const SizedBox(width: 20, height: 20)
          .alignment(Alignment.topLeft, animate: true),
      Styled.text('x', animate: true),
      Styled.icon(Icons.add, animate: true),
    ];
    for (final w in widgets) {
      await tester.pumpWidget(_host(w.animate(_d, Curves.linear)));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: '$w');
    }
  });

  testWidgets('animate: true without an animate() ancestor asserts in debug',
      (tester) async {
    await tester.pumpWidget(
        _host(const SizedBox().padding(all: 4, animate: true)));
    expect(tester.takeException(), isA<AssertionError>());
  });
}
