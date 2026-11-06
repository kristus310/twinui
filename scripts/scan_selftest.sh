#!/usr/bin/env bash
# Proves the scan catches what it should, and does not flag harmless code.
set -u
cd "$(dirname "$0")/.."
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
bad=0; n=0

fresh() { d="$tmp/c$n"; mkdir "$d"; cp -r lib pubspec.yaml "$d/"; }

fresh; n=$((n+1))
scripts/security_scan.sh "$d" >/dev/null || { echo "SELFTEST FAIL: clean copy rejected"; bad=1; }

expect_fail() { # name, dart line
  fresh; n=$((n+1)); printf '\n%s\n' "$2" >> "$d/lib/styled_widget.dart"
  scripts/security_scan.sh "$d" >/dev/null 2>&1 && { echo "SELFTEST FAIL: not caught: $1"; bad=1; }
}
expect_pass() {
  fresh; n=$((n+1)); printf '\n%s\n' "$2" >> "$d/lib/styled_widget.dart"
  scripts/security_scan.sh "$d" >/dev/null 2>&1 || { echo "SELFTEST FAIL: false positive: $1"; bad=1; }
}

expect_fail "dart:io"        "import 'dart:io';"
expect_fail "dart:ffi"       "import 'dart:ffi';"
expect_fail "http package"   "import 'package:http/http.dart';"
expect_fail "Platform"       "final p = Platform.isAndroid;"
expect_fail "Uri.parse"      "final u = Uri.parse('x');"
expect_fail "hardcoded URL"  "const u = 'https://evil.example';"
expect_fail "Socket"         "Socket? s;"
expect_fail "File("          "final f = File('x');"
expect_fail "MethodChannel"  "const m = MethodChannel('x');"
expect_pass "TargetPlatform" "const t = TargetPlatform.android;"
expect_pass "URL in comment" "// see https://example.com"

fresh; n=$((n+1)); sed -i '/^dependencies:/a\  http: ^1.0.0' "$d/pubspec.yaml"
scripts/security_scan.sh "$d" >/dev/null 2>&1 && { echo "SELFTEST FAIL: new dependency not caught"; bad=1; }

[ "$bad" -eq 0 ] && echo "scan selftest: OK ($n cases)"
exit "$bad"
