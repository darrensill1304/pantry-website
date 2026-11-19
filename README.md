# thepantryapp.ie

The website for Pantry, a shared recipe book and meal planner for households on iPhone. Plain HTML and CSS, served by GitHub Pages from `main` at the repo root (`CNAME` sets the domain, `.nojekyll` turns Jekyll off). Nothing is built to serve it, and no page loads anything from another site.

## Changing things

- **The privacy policy** is generated from the app repo's `docs/privacy-policy.md`. After that file changes, run `sh scripts/build-privacy.sh` (or pass the policy's path if the app repo isn't at `../pantry`). Needs pandoc. Every `[[PLACEHOLDER: …]]` shows as a yellow highlight until it is filled in.
- **The beta link** is in one place: the "Join the beta" button in `index.html`, with the note beside it. Swap the `mailto:` for the TestFlight public link.
- **Company details** are in each page's footer: `index.html`, `404.html` and `scripts/privacy.template.html` (then rebuild the policy).
- **Icons and the share image**: `sh scripts/make-images.sh` rebuilds `favicon.ico`, `apple-touch-icon.png` and `assets/og.png` from `assets/icon.svg` and `scripts/og.html`. Needs rsvg-convert, ImageMagick and Chrome.
- **Screenshots**: `python3 -m http.server 8765` in one shell, then `sh scripts/screenshots.sh` writes `.screenshots/` (git-ignored).

The colours, type and the three recipe covers come from the app's design system (`DESIGN.md`, `constants/theme.ts` and `components/RecipeCover.tsx` in the app repo).
