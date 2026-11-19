#!/bin/sh
# Full-page screenshots of / and /privacy/ at phone and desktop widths, light and dark.
#   python3 -m http.server 8765 & sh scripts/screenshots.sh http://127.0.0.1:8765
# Writes .screenshots/ (git-ignored). Uses Playwright's CLI through npx.
set -eu
cd "$(dirname "$0")/.."
BASE=${1:-http://127.0.0.1:8765}
PW="npx -y playwright@1.62.0"
mkdir -p .screenshots
for page in home:/ privacy:/privacy/ 404:/404.html; do
  name=${page%%:*} path=${page#*:}
  for size in 390,844 1440,900; do
    for scheme in light dark; do
      out=".screenshots/$name-${size%%,*}-$scheme.png"
      $PW screenshot --full-page --viewport-size="$size" --color-scheme="$scheme" \
        --wait-for-timeout=1200 "$BASE$path" "$out" >/dev/null
      echo "$out"
    done
  done
done
