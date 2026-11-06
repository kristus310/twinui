import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:twinui/twinui.dart';

void main() {
  group('visibleIf', () {
    test('true returns the very same widget', () {
      const w = Text('x');
      expect(identical(w.visibleIf(true), w), isTrue);
    });

    test('false returns an empty box', () {
      final w = const Text('x').visibleIf(false);
      expect(w, isA<SizedBox>());
      expect((w as SizedBox).width, 0);
      expect(w.height, 0);
    });
  });

  group('onTap', () {
    testWidgets('fires when tapped', (tester) async {
      var taps = 0;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: Center(child: const Text('hit').onTap(() => taps++))),
      ));
      await tester.tap(find.text('hit'));
      expect(taps, 1);
    });

    test('keeps key and behavior', () {
      final g = const Text('x').onTap(() {},
          key: const ValueKey('k'), behavior: HitTestBehavior.opaque) as GestureDetector;
      expect(g.key, const ValueKey('k'));
      expect(g.behavior, HitTestBehavior.opaque);
    });
  });
}
