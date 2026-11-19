#!/bin/sh
# Rebuilds the favicons, the apple-touch-icon and the share image.
#   sh scripts/make-images.sh
# Icons come from assets/icon.svg (the app's pot, from the app repo's
# assets/pantry.icon/Assets/pot.svg, on its olive tile); the share image is
# scripts/og.html as rendered by Chrome. Needs rsvg-convert and magick
# (brew install librsvg imagemagick) and Google Chrome.
set -eu
cd "$(dirname "$0")/.."
CHROME=${CHROME:-"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"}
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

# iOS rounds the corners itself, so the touch icon is the full square.
sed 's/ rx="228"//' assets/icon.svg | rsvg-convert -w 180 -h 180 -o apple-touch-icon.png
magick apple-touch-icon.png -alpha off "PNG24:apple-touch-icon.png"
for s in 16 32 48; do rsvg-convert -w $s -h $s assets/icon.svg -o "$TMP/$s.png"; done
magick "$TMP/16.png" "$TMP/32.png" "$TMP/48.png" favicon.ico

"$CHROME" --headless --disable-gpu --hide-scrollbars --force-device-scale-factor=1 \
  --window-size=1200,630 --screenshot="$TMP/og.png" "file://$PWD/scripts/og.html" 2>/dev/null
magick "$TMP/og.png" -crop 1200x630+0+0 +repage -strip assets/og.png
echo "wrote apple-touch-icon.png, favicon.ico, assets/og.png"
