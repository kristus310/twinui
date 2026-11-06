#!/usr/bin/env bash
# twinui security scan.  Usage: scripts/security_scan.sh [root-dir]
# Exit 1 if lib/ contains risky imports/APIs or pubspec.yaml gained dependencies.
# A text scan is a safety net, not proof. Reading the code is the real protection.
set -u
ROOT="${1:-$(cd "$(dirname "$0")/.." && pwd)}"
cd "$ROOT" || exit 2
fail=0

report() { echo "FAIL: $1"; fail=1; }

scan() { # description, regex, [skipcomments]
  local out
  out=$(grep -rnE --include='*.dart' -e "$2" lib || true)
  if [ "${3:-}" = "skipcomments" ]; then
    out=$(printf '%s\n' "$out" | grep -vE '^[^:]+:[0-9]+:[[:space:]]*//' || true)
  fi
  if [ -n "$out" ]; then
    report "$1"
    printf '%s\n' "$out" | sed 's/^/    /'
  fi
}

scan "forbidden dart: library" \
  "dart:(io|ffi|isolate|html|js|js_interop|js_interop_unsafe|js_util|mirrors|web_gl)"
scan "network / socket / process / file APIs" \
  "\b(Socket|ServerSocket|WebSocket|RawSocket|HttpClient|HttpServer|HttpOverrides)\b|\bProcess\.|\b(File|Directory|Link)\("
scan "Platform class (dart:io)" "(^|[^A-Za-z_])Platform\."
scan "URI construction" "\bUri\.(parse|http|https)\b"
scan "hardcoded URL" "https?://" skipcomments
scan "native code / isolates" "\b(DynamicLibrary|NativeFunction|Isolate\.|compute\()|Pointer<|@Native"
scan "platform channels" "\b(MethodChannel|EventChannel|BasicMessageChannel)\b"
scan "network assets" "\b(NetworkImage|NetworkAssetBundle)\b|Image\.network"

bad_imports=$(grep -rnE --include='*.dart' "^[[:space:]]*(import|export)[[:space:]]+['\"]package:" lib \
  | grep -vE "['\"]package:flutter/" || true)
if [ -n "$bad_imports" ]; then
  report "import of a package other than Flutter"
  printf '%s\n' "$bad_imports" | sed 's/^/    /'
fi

block() { # print the cleaned lines of a top-level pubspec section
  awk -v k="$1:" '
    $0 ~ "^"k {on=1; next}
    on && /^[^[:space:]#]/ {on=0}
    on {sub(/^[ \t]+/,""); sub(/[ \t]+$/,""); if ($0!="" && $0 !~ /^#/) print}
  ' pubspec.yaml
}

expect_deps=$'flutter:\nsdk: flutter'
expect_dev=$'flutter_test:\nsdk: flutter\nflutter_lints: ^6.0.0'

[ "$(block dependencies)" = "$expect_deps" ] || report "pubspec.yaml: 'dependencies' changed (only Flutter is allowed)"
[ "$(block dev_dependencies)" = "$expect_dev" ] || report "pubspec.yaml: 'dev_dependencies' changed (update scripts/security_scan.sh on purpose if intended)"
grep -q '^dependency_overrides:' pubspec.yaml && report "pubspec.yaml: dependency_overrides is not allowed"
grep -q '^publish_to: none' pubspec.yaml || report "pubspec.yaml: 'publish_to: none' is missing"

[ "$fail" -eq 0 ] && echo "security scan: OK"
exit "$fail"
