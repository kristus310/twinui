import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:twinui/twinui.dart';

double _opacity(double x) =>
    math.pow(x, 1 / 16) / math.sqrt(math.pow(x, 2) + 2) + 0.2;

void main() {
  group('textElevation shadow colour', () {
    test('Text: alpha follows the curve, offset follows the angle', () {
      final s = const Text('x').textElevation(4).style!.shadows!.single;
      expect(s.color.a, closeTo(_opacity(4), 0.004));
      expect(s.blurRadius, 4);
      expect(s.offset.dx, closeTo(0, 1e-9));
      expect(s.offset.dy, closeTo(4, 1e-9));
    });

    test('Text: opacityRatio scales the alpha', () {
      final s = const Text('x')
          .textElevation(4, opacityRatio: 0.5)
          .style!
          .shadows!
          .single;
      expect(s.color.a, closeTo(_opacity(4) * 0.5, 0.004));
    });

    test('Text: base colour channels are kept', () {
      final s = const Text('x')
          .textElevation(4, color: const Color(0xFF336699))
          .style!
          .shadows!
          .single;
      expect(s.color.r, closeTo(0x33 / 255, 0.004));
      expect(s.color.g, closeTo(0x66 / 255, 0.004));
      expect(s.color.b, closeTo(0x99 / 255, 0.004));
    });

    test('TextSpan: alpha follows the curve', () {
      final s = const TextSpan(text: 'x')
          .textElevation(4)
          .style!
          .shadows!
          .single;
      expect(s.color.a, closeTo(_opacity(4), 0.004));
    });
  });
}
