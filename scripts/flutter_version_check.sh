#!/usr/bin/env bash
# Warns (never fails) when the local Flutter differs from the version CI uses.
cd "$(dirname "$0")/.." || exit 0
[ -f .flutter-version ] || exit 0
want=$(tr -d '[:space:]' < .flutter-version)
have=$(flutter --version 2>/dev/null | head -1 | awk '{print $2}')
if [ -n "$want" ] && [ -n "$have" ] && [ "$want" != "$have" ]; then
  echo "WARNING: local Flutter is $have, but CI uses $want (.flutter-version)."
  echo "         After a Flutter upgrade: put the new version in .flutter-version and rerun scripts/check.sh."
fi
exit 0
