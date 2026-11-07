import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../example/before_after.dart';

final _root = find.byKey(const ValueKey('root'));

Widget _app(Widget w) => MaterialApp(
      home: Scaffold(
        body: Align(
          alignment: Alignment.topLeft,
          child: KeyedSubtree(key: const ValueKey('root'), child: w),
        ),
      ),
    );

Future<void> _show(WidgetTester tester, Widget w) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pumpWidget(_app(w));
}

Decoration _firstDecoration(WidgetTester tester) => tester
    .widget<DecoratedBox>(
        find.descendant(of: _root, matching: find.byType(DecoratedBox)).first)
    .decoration;

Future<double> _midOpacity(
  WidgetTester tester,
  Widget Function({required bool dimmed}) build,
) async {
  await _show(tester, build(dimmed: false));
  await tester.pumpWidget(_app(build(dimmed: true)));
  await tester.pump(const Duration(milliseconds: 150));
  final fade =
      find.descendant(of: _root, matching: find.byType(FadeTransition));
  return tester.widget<FadeTransition>(fade.last).opacity.value;
}

void main() {
  testWidgets('label: same size, text position, style and decoration',
      (tester) async {
    await _show(tester, labelBefore());
    final size = tester.getSize(_root);
    final pos = tester.getTopLeft(find.text('Hello'));
    final style = tester.widget<Text>(find.text('Hello')).style;
    final deco = _firstDecoration(tester);

    await _show(tester, labelAfter());
    expect(tester.getSize(_root), size);
    expect(tester.getTopLeft(find.text('Hello')), pos);
    expect(tester.widget<Text>(find.text('Hello')).style, style);
    expect(_firstDecoration(tester), deco);
  });

  testWidgets('like row: same size, and tapping works in both',
      (tester) async {
    var taps = 0;
    await _show(tester, likeBefore(() => taps++));
    final size = tester.getSize(_root);
    await tester.tap(find.text('Like'));
    expect(taps, 1);

    await _show(tester, likeAfter(() => taps++));
    expect(tester.getSize(_root), size);
    await tester.tap(find.text('Like'));
    expect(taps, 2);
  });

  testWidgets('list: same size and child positions', (tester) async {
    await _show(tester, listBefore());
    final size = tester.getSize(_root);
    final two = tester.getTopLeft(find.text('Two'));
    final three = tester.getTopLeft(find.text('Three'));

    await _show(tester, listAfter());
    expect(tester.getSize(_root), size);
    expect(tester.getTopLeft(find.text('Two')), two);
    expect(tester.getTopLeft(find.text('Three')), three);
  });

  testWidgets('fade: same value halfway through the animation',
      (tester) async {
    final before = await _midOpacity(tester, fadeBefore);
    final after = await _midOpacity(tester, fadeAfter);
    expect(before, greaterThan(0.3));
    expect(before, lessThan(1.0));
    expect(after, closeTo(before, 1e-9));
  });

  testWidgets('avatar: both are 48x48 with the icon in the same place',
      (tester) async {
    await _show(tester, avatarBefore());
    expect(tester.getSize(_root), const Size(48, 48));
    final icon = tester.getTopLeft(find.byType(Icon));

    await _show(tester, avatarAfter());
    expect(tester.getSize(_root), const Size(48, 48));
    expect(tester.getTopLeft(find.byType(Icon)), icon);
  });
}
