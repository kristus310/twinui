import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:twinui/twinui.dart';

void main() {
  test('every new callback reaches the GestureDetector', () {
    final g = const SizedBox().gestures(
      onSecondaryTap: () {},
      onTertiaryTapDown: (_) {},
      onTertiaryTapUp: (_) {},
      onTertiaryTapCancel: () {},
      onDoubleTapDown: (_) {},
      onDoubleTapCancel: () {},
      onLongPressDown: (_) {},
      onLongPressCancel: () {},
      onSecondaryLongPressDown: (_) {},
      onSecondaryLongPressCancel: () {},
      onSecondaryLongPress: () {},
      onSecondaryLongPressStart: (_) {},
      onSecondaryLongPressMoveUpdate: (_) {},
      onSecondaryLongPressUp: () {},
      onSecondaryLongPressEnd: (_) {},
      onTertiaryLongPressDown: (_) {},
      onTertiaryLongPressCancel: () {},
      onTertiaryLongPress: () {},
      onTertiaryLongPressStart: (_) {},
      onTertiaryLongPressMoveUpdate: (_) {},
      onTertiaryLongPressUp: () {},
      onTertiaryLongPressEnd: (_) {},
    ) as GestureDetector;

    final reached = <String, Object?>{
      'onSecondaryTap': g.onSecondaryTap,
      'onTertiaryTapDown': g.onTertiaryTapDown,
      'onTertiaryTapUp': g.onTertiaryTapUp,
      'onTertiaryTapCancel': g.onTertiaryTapCancel,
      'onDoubleTapDown': g.onDoubleTapDown,
      'onDoubleTapCancel': g.onDoubleTapCancel,
      'onLongPressDown': g.onLongPressDown,
      'onLongPressCancel': g.onLongPressCancel,
      'onSecondaryLongPressDown': g.onSecondaryLongPressDown,
      'onSecondaryLongPressCancel': g.onSecondaryLongPressCancel,
      'onSecondaryLongPress': g.onSecondaryLongPress,
      'onSecondaryLongPressStart': g.onSecondaryLongPressStart,
      'onSecondaryLongPressMoveUpdate': g.onSecondaryLongPressMoveUpdate,
      'onSecondaryLongPressUp': g.onSecondaryLongPressUp,
      'onSecondaryLongPressEnd': g.onSecondaryLongPressEnd,
      'onTertiaryLongPressDown': g.onTertiaryLongPressDown,
      'onTertiaryLongPressCancel': g.onTertiaryLongPressCancel,
      'onTertiaryLongPress': g.onTertiaryLongPress,
      'onTertiaryLongPressStart': g.onTertiaryLongPressStart,
      'onTertiaryLongPressMoveUpdate': g.onTertiaryLongPressMoveUpdate,
      'onTertiaryLongPressUp': g.onTertiaryLongPressUp,
      'onTertiaryLongPressEnd': g.onTertiaryLongPressEnd,
    };
    final missing =
        reached.entries.where((e) => e.value == null).map((e) => e.key);
    expect(missing, isEmpty);
  });

  test('supportedDevices is passed through', () {
    final g = const SizedBox().gestures(
      onTap: () {},
      supportedDevices: {PointerDeviceKind.touch},
    ) as GestureDetector;
    expect(g.supportedDevices, {PointerDeviceKind.touch});
  });

  test('without them nothing extra is registered', () {
    final g = const SizedBox().gestures(onTap: () {}) as GestureDetector;
    expect(g.onSecondaryTap, isNull);
    expect(g.onDoubleTapDown, isNull);
    expect(g.onLongPressDown, isNull);
    expect(g.supportedDevices, isNull);
  });
}
