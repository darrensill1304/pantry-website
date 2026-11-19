#!/bin/sh
# Rebuilds privacy/index.html from the app repo's privacy policy.
#   sh scripts/build-privacy.sh [path/to/privacy-policy.md]
# The default source is ../pantry/docs/privacy-policy.md, next to this repo.
# Needs pandoc (brew install pandoc) and perl (part of macOS).
set -eu
cd "$(dirname "$0")/.."
SRC=${1:-../pantry/docs/privacy-policy.md}
OUT=privacy/index.html

# The policy's first line, "# Pantry privacy policy", becomes the page's one h1,
# so the contents list starts at the policy's sections.
TITLE=$(sed -n '1s/^# //p' "$SRC")
[ -n "$TITLE" ] || { echo "$SRC: the first line must be the '# title'" >&2; exit 1; }

mkdir -p privacy
sed '1d' "$SRC" |
  pandoc -f gfm -t html5 --wrap=none --toc --toc-depth=2 \
    --template=scripts/privacy.template.html -M title="$TITLE" -M pagetitle="$TITLE" |
  perl -0pe '
    s/\[\[PLACEHOLDER:\s*(.*?)\s*\]\]/<mark class="todo">$1<\/mark>/gs;
    s/<strong>Draft\.<\/strong>/<mark class="todo">Draft<\/mark>/g;
    s/ id="toc-[^"]*"//g;
    s/href="http:\/\//href="https:\/\//g;
    s/<th>/<th scope="col">/g;
  ' >"$OUT.tmp"
# The contents list is printed twice (sidebar and phone), so its ids are dropped;
# pandoc autolinks bare "www." addresses as http, so they are moved to https;
# the policy's tables only have header rows, so every th heads a column.

# Self-check: every placeholder became a highlight, and the page has its h1.
if grep -q '\[\[PLACEHOLDER' "$OUT.tmp"; then
  echo "an unconverted [[PLACEHOLDER in $OUT; check its brackets in $SRC" >&2
  rm -f "$OUT.tmp"
  exit 1
fi
[ "$(grep -c '<h1' "$OUT.tmp")" -eq 1 ] || { echo "$OUT must have exactly one h1" >&2; rm -f "$OUT.tmp"; exit 1; }
mv "$OUT.tmp" "$OUT"
echo "wrote $OUT, $(grep -o 'class="todo"' "$OUT" | wc -l | tr -d ' ') highlighted placeholders (footer included)"
