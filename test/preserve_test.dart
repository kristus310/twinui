import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:twinui/twinui.dart';

void main() {
  group('Text copies keep every property', () {
    test('key, selectionColor, heightBehavior, identifier, scaler', () {
      const behavior = TextHeightBehavior(applyHeightToFirstAscent: false);
      final copy = const Text(
        'a',
        key: ValueKey('k'),
        selectionColor: Colors.red,
        textHeightBehavior: behavior,
        semanticsIdentifier: 'id',
        textScaler: TextScaler.linear(2),
      ).bold();
      expect(copy.key, const ValueKey('k'));
      expect(copy.selectionColor, Colors.red);
      expect(copy.textHeightBehavior, behavior);
      expect(copy.semanticsIdentifier, 'id');
      expect(copy.textScaler!.scale(10), 20);
    });

    test('Text.rich keeps key and textSpan', () {
      const span = TextSpan(text: 'r');
      final copy = const Text.rich(span, key: ValueKey('k')).italic();
      expect(copy.textSpan, same(span));
      expect(copy.key, const ValueKey('k'));
    });

    test('textScale sets a linear scaler', () {
      expect(const Text('a').textScale(2).textScaler!.scale(10), 20);
    });

    test('legacy textScaleFactor survives a copy', () {
      // ignore: deprecated_member_use
      final t = const Text('a', textScaleFactor: 2).bold();
      expect(t.textScaler!.scale(10), 20);
    });

    test('textStyle copies fontVariations', () {
      const v = [FontVariation('wght', 700)];
      final t = const Text('a').textStyle(const TextStyle(fontVariations: v));
      expect(t.style?.fontVariations, v);
    });
  });

  group('TextSpan copies keep every property', () {
    test('identifier, locale, spellOut, hover handler', () {
      void enter(PointerEnterEvent e) {}
      final s = TextSpan(
        text: 'a',
        semanticsIdentifier: 'id',
        locale: const Locale('en'),
        spellOut: true,
        onEnter: enter,
      ).bold();
      expect(s.semanticsIdentifier, 'id');
      expect(s.locale, const Locale('en'));
      expect(s.spellOut, true);
      expect(s.onEnter, enter);
    });

    test('recognizer and its click cursor survive', () {
      final r = TapGestureRecognizer();
      final s = TextSpan(text: 'a', recognizer: r).bold();
      expect(s.recognizer, same(r));
      expect(s.mouseCursor, SystemMouseCursors.click);
      r.dispose();
    });

    test('textStyle copies fontVariations', () {
      const v = [FontVariation('wght', 700)];
      final s = const TextSpan(text: 'a')
          .textStyle(const TextStyle(fontVariations: v));
      expect(s.style?.fontVariations, v);
    });
  });

  group('Icon copies keep every property', () {
    test('iconColor keeps all other Icon properties', () {
      const shadows = [Shadow(blurRadius: 2)];
      final i = const Icon(
        Icons.add,
        key: ValueKey('k'),
        size: 10,
        fill: 0.5,
        weight: 700,
        grade: 25,
        opticalSize: 24,
        shadows: shadows,
        applyTextScaling: true,
        blendMode: BlendMode.srcIn,
        fontWeight: FontWeight.w700,
      ).iconColor(Colors.red);
      expect(i.color, Colors.red);
      expect(i.key, const ValueKey('k'));
      expect(i.size, 10);
      expect(i.fill, 0.5);
      expect(i.weight, 700);
      expect(i.grade, 25);
      expect(i.opticalSize, 24);
      expect(i.shadows, shadows);
      expect(i.applyTextScaling, true);
      expect(i.blendMode, BlendMode.srcIn);
      expect(i.fontWeight, FontWeight.w700);
    });

    test('Styled.icon uses its key', () {
      final i = Styled.icon(Icons.add, key: const ValueKey('k'));
      expect(i.key, const ValueKey('k'));
    });
  });
}
