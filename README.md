# twinui

A reviewed, security-checked local fork of
[styled_widget](https://github.com/ReinBentdal/styled_widget) (MIT).
It adds chainable extension methods to Flutter widgets. It never replaces
Flutter: every method builds the normal Flutter widget, so you can mix twinui
and plain Flutter freely.

```dart
import 'package:twinui/twinui.dart';

Text('Hello')
    .bold()
    .fontSize(20)
    .padding(all: 16)
    .decorated(color: Colors.blue, borderRadius: BorderRadius.circular(8))
    .onTap(() => print('tapped'))
```

## Use it in an app

In the app's `pubspec.yaml` (path while developing, pinned commit for
releases):

```yaml
dependencies:
  twinui:
    path: ../twinui
```

Commit the app's `pubspec.lock`.

## Things to know

- **Combine styling with `decorated()`.** `.backgroundColor(...)` and
  `.borderRadius(...)` each add their own box, so a rounded corner on its own
  box does not round the colour. `decorated(color:, borderRadius:, border:,
  boxShadow:)` does it in one box.
- **`animate: true` needs an `.animate(duration, curve)` above it** in the
  chain. Without it, debug builds assert and release builds throw.
- **A widget's own members win over extensions.** For example `Text` has its
  own `semanticsLabel`, `SizedBox` has its own `width`, `Container` has its
  own `alignment`. Calling the extension on those types does not compile (a
  loud failure, never a silent one). Wrap with `Styled.widget(child: ...)` or
  use a different widget.
- **`backgroundBlendMode()` needs a `color:` or `gradient:`** (Flutter
  requires one for a blend mode to do anything). Without it, debug builds
  assert.
- **Right-click on the web:** the browser's own context menu can swallow
  `onSecondaryTap`. In testing, right-clicks were only counted some of
  the time until the menu was disabled. In your app's `main()`, add
  `if (kIsWeb) BrowserContextMenu.disableContextMenu();`
  (`kIsWeb` is in `package:flutter/foundation.dart`,
  `BrowserContextMenu` in `package:flutter/services.dart`). This hides
  the browser menu for the whole app.
- Chained calls cannot be `const`, and they do not make the widget tree
  shallower; they only make the code read flatter.

## Your own extensions

Add them to `lib/src/twinui_extras.dart` and test them in
`test/extras_test.dart`. Keep them out of the upstream files.

## Checks

```bash
scripts/check.sh            # security scan + analyzer + all tests
scripts/scan_selftest.sh    # proves the scan still catches what it should
```

After a fresh clone, turn on the pre-commit hook once (it is a local setting):

```bash
git config core.hooksPath .githooks
```

The scan fails on `dart:io`/`ffi`/`isolate`/`html`/`js`, any package import
other than Flutter, sockets, `Process`, `File(`, `Platform.`, `Uri.parse`,
hardcoded URLs, platform channels, network assets, and on any change to the
dependencies. A text scan is a safety net, not proof; reading the code is the
real protection, so read any new code before committing it.

## Provenance and license

Forked from styled_widget by Rein Gundersen Bentdal, MIT. The upstream commit
is recorded in `UPSTREAM.md`; the original code is the first import commit in
`git log`. `LICENSE` is the original license with the original copyright
notice, which must stay.
