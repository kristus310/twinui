# Changelog

## 0.1.0

First release of twinui: a reviewed local fork of styled_widget (MIT).

Source: https://github.com/ReinBentdal/styled_widget at commit
`5a7c2896...` (master, 2023-05-19; see UPSTREAM.md for the full hash).
The original code was imported unchanged in its own commit, so
`git diff` shows exactly what was changed afterwards.

### Security
- Every line of `lib/` was read. No file, network, platform, FFI or isolate code.
- Flutter is the only dependency (upstream's `lint` package was dropped).
- `scripts/security_scan.sh` fails on risky imports/APIs and on new
  dependencies; `scripts/scan_selftest.sh` proves it still catches them.
- A pre-commit hook runs scan, analyzer and tests before every commit.

### Fixed (each has a test)
- `Text.rich(...)` lost its content when any text extension was applied.
- `TextSpan.textStyle()` did nothing on a span without a style.
- `copyWith` on `Text`, `TextSpan` and `Icon` dropped properties (key,
  selectionColor, textHeightBehavior, weight, fill, shadows, ...).
- `scale()` collapsed the widget when only one axis (or none) was given.
- `overflow()` ignored `maxWidth`.
- `gestures()` ignored the secondary-tap callbacks, and always registered
  tap handlers even when none were given.
- Animated `scale()` ignored `origin`.
- Animated `backgroundBlur()` crashed; animated `backgroundBlur()` and
  `overflow()` did not animate smoothly.
- `Styled.icon()` ignored its `key`.

### Added
- `gestures()`: secondary/tertiary taps and long presses, `onDoubleTapDown`,
  `onDoubleTapCancel`, `onLongPressDown`, `onLongPressCancel`,
  `supportedDevices`.
- `TwinuiExtras`: `visibleIf()` and `onTap()` (own extensions).
- `backgroundBlendMode()`: optional `color:` and `gradient:`, so it can work.

### Changed
- Minimum versions are what is tested: Dart 3.13, Flutter 3.47.
- Deprecated Flutter APIs replaced (`textScaleFactor` -> `TextScaler`,
  `withOpacity` -> `withValues`, `Color.red/green/blue`). Public parameter
  names are unchanged.

### Known limitations
- `backgroundBlendMode()` needs a `color:` or `gradient:` (Flutter requires
  one); without it debug builds assert.
- Animated `Styled.text` / `Styled.icon` support only a subset of the
  properties of `Text` / `Icon`.
- Chained calls cannot be `const`.
