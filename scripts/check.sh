#!/usr/bin/env bash
# One command: security scan + analyzer (errors/warnings fatal) + all tests.
set -e
cd "$(dirname "$0")/.."
scripts/security_scan.sh
flutter analyze --no-fatal-infos
flutter test
