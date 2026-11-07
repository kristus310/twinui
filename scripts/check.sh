#!/usr/bin/env bash
# One command: version note + security scan + analyzer (errors/warnings fatal) + all tests.
set -e
cd "$(dirname "$0")/.."
scripts/flutter_version_check.sh
scripts/security_scan.sh
flutter analyze --no-fatal-infos
flutter test
