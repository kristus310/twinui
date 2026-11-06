import 'package:flutter/widgets.dart';

/// Your own extensions live here, separate from the upstream styled_widget
/// code so that `git diff` against upstream stays clean.
///
/// Rules for adding to this file:
/// - Flutter imports only (the security scan enforces this).
/// - Check that the method name is not already a member of a common widget:
///   a widget's own members always win over extension methods.
/// - Add a test in `test/extras_test.dart` for every extension.
extension TwinuiExtras on Widget {
  /// Shows this widget when [visible] is true, otherwise an empty box that
  /// takes no space.
  Widget visibleIf(bool visible) => visible ? this : const SizedBox.shrink();

  /// Calls [onTap] when this widget is tapped.
  ///
  /// By default only the painted parts of the child react to taps. Pass
  /// `behavior: HitTestBehavior.opaque` to make the whole area tappable.
  Widget onTap(
    VoidCallback? onTap, {
    Key? key,
    HitTestBehavior? behavior,
  }) =>
      GestureDetector(
        key: key,
        onTap: onTap,
        behavior: behavior,
        child: this,
      );
}
