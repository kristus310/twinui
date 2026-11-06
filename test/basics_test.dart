import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:twinui/twinui.dart';

void main() {
  group('Styled', () {
    test('Styled.text keeps data', () {
      expect(Styled.text('x').data, 'x');
    });

    test('Styled.widget without child is a zero-size LimitedBox', () {
      expect(Styled.widget(), isA<LimitedBox>());
    });

    test('Styled.widget returns the child it is given', () {
      const child = SizedBox();
      expect(identical(Styled.widget(child: child), child), isTrue);
    });
  });

  group('List extensions', () {
    test('toColumn with separator interleaves children', () {
      final col = <Widget>[const Text('a'), const Text('b'), const Text('c')]
          .toColumn(separator: const SizedBox(height: 4)) as Column;
      expect(col.children.length, 5);
    });

    test('toRow with separator and one child adds no separator', () {
      final row = <Widget>[const Text('a')]
          .toRow(separator: const SizedBox(width: 4)) as Row;
      expect(row.children.length, 1);
    });

    test('toColumn with separator and empty list does not crash', () {
      final col = <Widget>[].toColumn(separator: const SizedBox()) as Column;
      expect(col.children, isEmpty);
    });

    test('toWrap and toStack use the list as children', () {
      final items = <Widget>[const Text('a'), const Text('b')];
      expect((items.toWrap() as Wrap).children.length, 2);
      expect((items.toStack() as Stack).children.length, 2);
    });
  });

  group('Text extensions', () {
    testWidgets('bold() sets fontWeight and keeps the text', (tester) async {
      await tester.pumpWidget(MaterialApp(home: const Text('hi').bold()));
      final text = tester.widget<Text>(find.text('hi'));
      expect(text.style?.fontWeight, FontWeight.bold);
    });

    test('chained calls combine styles', () {
      final w = const Text('hi').bold().italic().fontSize(20);
      expect(w.style?.fontWeight, FontWeight.bold);
      expect(w.style?.fontStyle, FontStyle.italic);
      expect(w.style?.fontSize, 20);
    });

    testWidgets('BUG1: Text.rich keeps its content through bold()',
        (tester) async {
      final w = const Text.rich(TextSpan(text: 'rich')).bold();
      await tester.pumpWidget(MaterialApp(home: w));
      expect(find.text('rich', findRichText: true), findsOneWidget);
    });
  });

  group('TextSpan extensions', () {
    test('bold() sets fontWeight', () {
      final s = const TextSpan(text: 'a').bold();
      expect(s.style?.fontWeight, FontWeight.bold);
    });

    test('BUG2: textStyle() applies even when the span has no style', () {
      final s = const TextSpan(text: 'a')
          .textStyle(const TextStyle(color: Color(0xFFFF0000)));
      expect(s.style?.color, const Color(0xFFFF0000));
    });
  });

  group('Icon extensions', () {
    test('iconSize and iconColor set their values', () {
      final i = const Icon(Icons.add).iconSize(20).iconColor(Colors.red);
      expect(i.size, 20);
      expect(i.color, Colors.red);
    });

    test('BUG3: iconSize keeps properties it does not touch', () {
      final i = const Icon(Icons.add, weight: 700).iconSize(20);
      expect(i.weight, 700);
      expect(i.size, 20);
    });
  });
}
