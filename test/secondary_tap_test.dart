import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:twinui/twinui.dart';

Widget _host(Widget w) =>
    Directionality(textDirection: TextDirection.ltr, child: Center(child: w));

void main() {
  testWidgets('a secondary-button tap fires down and tap, not onTap',
      (tester) async {
    var primary = 0, down = 0, up = 0;
    await tester.pumpWidget(_host(const SizedBox(width: 50, height: 50).gestures(
      onTap: () => primary++,
      onSecondaryTapDown: (_) => down++,
      onSecondaryTap: () => up++,
      behavior: HitTestBehavior.opaque,
    )));
    await tester.tap(find.byType(GestureDetector), buttons: kSecondaryButton);
    expect([primary, down, up], [0, 1, 1]);
  });

  testWidgets('a primary tap does not fire the secondary callbacks',
      (tester) async {
    var primary = 0, down = 0, up = 0;
    await tester.pumpWidget(_host(const SizedBox(width: 50, height: 50).gestures(
      onTap: () => primary++,
      onSecondaryTapDown: (_) => down++,
      onSecondaryTap: () => up++,
      behavior: HitTestBehavior.opaque,
    )));
    await tester.tap(find.byType(GestureDetector));
    expect([primary, down, up], [1, 0, 0]);
  });
}
