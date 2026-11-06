import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:twinui/twinui.dart';

const _d = Duration(milliseconds: 100);

Widget _host(Widget w) => MaterialApp(home: Scaffold(body: Center(child: w)));

/// The plain Text/Icon that an animated container renders internally.
Finder get _plainText => find.byWidgetPredicate((w) => w.runtimeType == Text);
Finder get _plainIcon => find.byWidgetPredicate((w) => w.runtimeType == Icon);

double? _factorOf(Text t) =>
    t.textScaler?.scale(1.0) ??
    // ignore: deprecated_member_use
    t.textScaleFactor;

void main() {
  group('animated text', () {
    testWidgets('without an animate() ancestor it renders as plain text',
        (tester) async {
      await tester.pumpWidget(_host(Styled.text('x', animate: true)));
      expect(find.text('x'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('fontSize animates between the old and new value',
        (tester) async {
      Widget build(double s) => _host(Styled.text('x',
              style: TextStyle(fontSize: s), animate: true)
          .animate(_d, Curves.linear));
      await tester.pumpWidget(build(10));
      await tester.pumpWidget(build(30));
      await tester.pump(const Duration(milliseconds: 50));
      final mid = tester.widget<Text>(_plainText).style!.fontSize!;
      expect(mid, greaterThan(10));
      expect(mid, lessThan(30));
      await tester.pumpAndSettle();
      expect(tester.widget<Text>(_plainText).style!.fontSize, 30);
    });

    testWidgets('color animates between the old and new value',
        (tester) async {
      Widget build(Color c) => _host(Styled.text('x',
              style: TextStyle(color: c), animate: true)
          .animate(_d, Curves.linear));
      await tester.pumpWidget(build(Colors.red));
      await tester.pumpWidget(build(Colors.blue));
      await tester.pump(const Duration(milliseconds: 50));
      final mid = tester.widget<Text>(_plainText).style!.color;
      expect(mid, isNot(Colors.red));
      expect(mid, isNot(Colors.blue));
      await tester.pumpAndSettle();
      expect(tester.widget<Text>(_plainText).style!.color, Colors.blue);
    });

    testWidgets('text scale factor animates', (tester) async {
      Widget build(double f) => _host(
          Styled.text('x', textScaleFactor: f, animate: true)
              .animate(_d, Curves.linear));
      await tester.pumpWidget(build(1));
      await tester.pumpWidget(build(3));
      await tester.pump(const Duration(milliseconds: 50));
      final mid = _factorOf(tester.widget<Text>(_plainText))!;
      expect(mid, greaterThan(1));
      expect(mid, lessThan(3));
      await tester.pumpAndSettle();
      expect(_factorOf(tester.widget<Text>(_plainText)), 3);
    });

    test('a copy of an animated text is still animated and keeps changes', () {
      final w = Styled.text('x', animate: true).bold();
      expect(w.runtimeType.toString(), contains('Animated'));
      expect(w.style?.fontWeight, FontWeight.bold);
    });

    test('plain Styled.text keeps textScaleFactor', () {
      expect(_factorOf(Styled.text('x', textScaleFactor: 2)), 2);
    });
  });

  group('animated icon', () {
    testWidgets('without an animate() ancestor it renders as a plain icon',
        (tester) async {
      await tester.pumpWidget(_host(Styled.icon(Icons.add, animate: true)));
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('size animates between the old and new value', (tester) async {
      Widget build(double s) => _host(
          Styled.icon(Icons.add, size: s, animate: true)
              .animate(_d, Curves.linear));
      await tester.pumpWidget(build(10));
      await tester.pumpWidget(build(30));
      await tester.pump(const Duration(milliseconds: 50));
      final mid = tester.widget<Icon>(_plainIcon).size!;
      expect(mid, greaterThan(10));
      expect(mid, lessThan(30));
      await tester.pumpAndSettle();
      expect(tester.widget<Icon>(_plainIcon).size, 30);
    });

    testWidgets('color animates between the old and new value',
        (tester) async {
      Widget build(Color c) => _host(
          Styled.icon(Icons.add, color: c, animate: true)
              .animate(_d, Curves.linear));
      await tester.pumpWidget(build(Colors.red));
      await tester.pumpWidget(build(Colors.blue));
      await tester.pump(const Duration(milliseconds: 50));
      final mid = tester.widget<Icon>(_plainIcon).color;
      expect(mid, isNot(Colors.red));
      expect(mid, isNot(Colors.blue));
      await tester.pumpAndSettle();
      expect(tester.widget<Icon>(_plainIcon).color, Colors.blue);
    });

    test('a copy of an animated icon is still animated and keeps changes', () {
      final w = Styled.icon(Icons.add, animate: true).iconSize(20);
      expect(w.runtimeType.toString(), contains('Animated'));
      expect(w.size, 20);
    });
  });
}
