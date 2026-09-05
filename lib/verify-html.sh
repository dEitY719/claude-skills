#!/usr/bin/env bash
# Shared post-write verifier for the visualize and md-to-scrolldeck skills.
# Encodes the machine-checkable items of their pre-flight checklists; the
# judgement calls (curation, typography, delivery hygiene) stay with the human.
#
#   bash lib/verify-html.sh --profile viz  <file.html>
#   bash lib/verify-html.sh --profile deck <file.html>
#
# Exit 0 = every item OK, 1 = at least one item failed, 2 = usage/file error.
set -euo pipefail

usage() {
  printf 'usage: verify-html.sh --profile viz|deck <file.html>\n' >&2
  exit 2
}

PROFILE=""
FILE=""
while [ $# -gt 0 ]; do
  case "$1" in
    --profile) [ $# -ge 2 ] || usage; PROFILE="$2"; shift 2 ;;
    -*) usage ;;
    *) [ -z "$FILE" ] || usage; FILE="$1"; shift ;;
  esac
done

case "$PROFILE" in viz|deck) ;; *) usage ;; esac
[ -n "$FILE" ] || usage
if [ ! -f "$FILE" ] || [ ! -r "$FILE" ]; then
  printf 'verify-html.sh: cannot read file: %s\n' "$FILE" >&2
  exit 2
fi

PASSED=0
FAILED=0
ok()  { printf '[OK] %s\n' "$1"; PASSED=$((PASSED + 1)); }
bad() { printf '[FAIL] %s: %s\n' "$1" "$2"; FAILED=$((FAILED + 1)); }

# grep -c exits 1 when the count is 0, which set -e would treat as fatal.
count_lines() { local n; n=$(grep -cF -- "$1" "$FILE" || true); printf '%s\n' "${n:-0}"; }
count_lines_re() { local n; n=$(grep -cE -- "$1" "$FILE" || true); printf '%s\n' "${n:-0}"; }
# -o counts occurrences rather than lines; grep -c cannot do that.
count_hits() {
  local n
  n=$(grep -oF -- "$1" "$FILE" | wc -l | tr -d '[:space:]' || true)
  printf '%s\n' "${n:-0}"
}
# present <label> <fixed-string>; count_eq <label> <fixed-string> <expected-lines>
present() { if grep -qF -- "$2" "$FILE"; then ok "$1"; else bad "$1" "'$2' not found"; fi; }
count_eq() {
  local got
  got=$(count_lines "$2")
  if [ "$got" -eq "$3" ]; then ok "$1 ($got)"; else bad "$1" "$got, expected $3 (one per slide)"; fi
}

check_viz() {
  local miss n p dark light hits canvases imgroles

  dark=$(count_lines 'theme-dark')
  light=$(count_lines 'theme-light')
  if [ "$dark" -gt 0 ] && [ "$light" -gt 0 ]; then
    ok "theme classes"
  else
    miss=""
    [ "$dark" -gt 0 ] || miss="$miss theme-dark"
    [ "$light" -gt 0 ] || miss="$miss theme-light"
    bad "theme classes" "missing:$miss"
  fi

  # Theming is class-based only; a media query defeats the manual toggle.
  n=$(count_lines 'prefers-color-scheme')
  if [ "$n" -eq 0 ]; then
    ok "no prefers-color-scheme"
  else
    bad "no prefers-color-scheme" "$n line(s) use it; theming must be class-based"
  fi

  present "viz-menu" '.viz-menu'
  present "cycleTheme()" 'cycleTheme('
  present "toggleMenu()" 'toggleMenu('
  present "downloadImage()" 'downloadImage('
  present "@media print" '@media print'
  present "@media (prefers-reduced-motion)" '@media (prefers-reduced-motion'
  # Attribute order varies; the skip-link spells it href="#main-content", so a
  # plain search for the id attribute cannot false-positive on it.
  present "<main id=main-content>" 'id="main-content"'

  # Match declarations ("--text:") so --text-secondary: cannot satisfy --text.
  miss=""
  for p in --bg --surface --surface-hover --border --text --text-secondary \
           --accent --accent-secondary --positive --negative --warning; do
    grep -qF -- "$p:" "$FILE" || miss="$miss $p"
  done
  if [ -z "$miss" ]; then
    ok "css custom properties"
  else
    bad "css custom properties" "missing:$miss"
  fi

  if [ "$(count_lines 'Chart')" -eq 0 ]; then
    ok "charts: none present (skipped)"
  else
    if grep -qE 'Chart\.defaults\.animation[[:space:]]*=[[:space:]]*false' "$FILE"; then
      ok "charts: animation disabled"
    else
      bad "charts: animation disabled" "'Chart.defaults.animation = false' not found"
    fi
    # ponytail: count heuristic, not an HTML parse - every <canvas> is supposed
    # to sit inside a role="img" wrapper, so fewer role="img" than <canvas>
    # proves at least one chart is unlabelled. Upgrade path is a real parse if
    # a file ever carries role="img" on unrelated elements.
    canvases=$(count_hits '<canvas')
    imgroles=$(count_hits 'role="img"')
    if [ "$imgroles" -ge "$canvases" ]; then
      ok "charts: role=img wrappers"
    else
      bad "charts: role=img wrappers" \
        "$imgroles role=\"img\" vs $canvases <canvas (count heuristic)"
    fi
  fi

  # ponytail: indentation heuristic - a declaration indented 0-4 spaces is
  # treated as top-level. Upgrade path is a real JS parse if it false-positives.
  n=$(count_lines_re '^[[:space:]]{0,4}(let|const)[[:space:]]')
  if [ "$n" -eq 0 ]; then
    ok "no top-level let/const"
  else
    hits=$(grep -nE '^[[:space:]]{0,4}(let|const)[[:space:]]' "$FILE" |
      head -5 | cut -d: -f1 | tr '\n' ' ' || true)
    bad "no top-level let/const" "$n occurrence(s); lines: ${hits% }"
  fi
}

check_deck() {
  local n slides dots cues flat miss tok want got i unresolved

  # Match on the class attribute, NOT on '<section class="slide' - a formatted
  # file wraps the attributes onto their own lines and that pattern undercounts.
  n=$(count_lines_re 'class="slide[ "]')
  if [ "$n" -ge 1 ]; then
    ok "slide count ($n)"
  else
    bad "slide count" "no elements with class=\"slide\"; every count below is vacuous"
  fi

  count_eq "nav dot count" 'class="deck-nav__dot"' "$n"
  count_eq "aria-labelledby count" 'aria-labelledby=' "$n"

  want=$((n - 1))
  [ "$want" -ge 0 ] || want=0
  got=$(count_lines 'class="next-cue"')
  if [ "$got" -eq "$want" ]; then
    ok "next-cue count ($got)"
  else
    bad "next-cue count" "$got, expected $want (slides - 1; the last slide has none)"
  fi

  # These belong to the sibling visualize skill and are deliberately out of
  # scope here - the deck is one designed theme, not a themeable page.
  got=$(count_lines_re 'viz-menu|cycleTheme|toggleMenu|downloadImage|theme-dark')
  if [ "$got" -eq 0 ]; then
    ok "no visualize-skill chrome"
  else
    bad "no visualize-skill chrome" "$got line(s) mention viz-menu/cycleTheme/toggleMenu/downloadImage/theme-dark"
  fi

  got=$(count_lines_re 'url\("data:font|url\(data:font')
  if [ "$got" -eq 0 ]; then
    ok "no base64 font"
  else
    bad "no base64 font" "$got embedded font data URI(s); only allowed when the user asked"
  fi

  miss=""
  for tok in 'scroll-snap-type: y mandatory' 'scroll-snap-align: start' \
             'scroll-snap-stop: always' 'IntersectionObserver' 'ArrowDown' \
             'ArrowUp' 'prefers-reduced-motion' '@media print'; do
    grep -qF -- "$tok" "$FILE" || miss="$miss '$tok'"
  done
  # A per-slide print break is legitimately spelled either way; accept both.
  grep -qE 'page-break-after|break-after:[[:space:]]*page' "$FILE" ||
    miss="$miss 'page-break-after / break-after: page'"
  if [ -z "$miss" ]; then
    ok "scroll/print/a11y features"
  else
    bad "scroll/print/a11y features" "missing:$miss"
  fi

  # Flatten to one tag per line: the real fixture wraps a <section>'s attributes
  # across several lines, so ids and hrefs must be read from the tag, not a line.
  flat=$(tr '\n' ' ' < "$FILE" | sed 's/</\n</g')
  slides=$(grep 'class="slide[ "]' <<<"$flat" | sed -n 's/.*[[:space:]]id="\([^"]*\)".*/\1/p' || true)
  dots=$(grep 'class="deck-nav__dot"' <<<"$flat" | sed -n 's/.*href="#\([^"]*\)".*/\1/p' || true)
  cues=$(grep 'class="next-cue"' <<<"$flat" | sed -n 's/.*href="#\([^"]*\)".*/\1/p' || true)

  unresolved=""
  while IFS= read -r tok; do
    [ -n "$tok" ] || continue
    grep -qxF -- "$tok" <<<"$slides" || unresolved="$unresolved #$tok"
  done <<<"$dots"
  if [ -z "$unresolved" ]; then
    ok "nav dot hrefs resolve"
  else
    bad "nav dot hrefs resolve" "no slide with id:$unresolved"
  fi

  if [ "$dots" = "$slides" ]; then
    ok "nav dot order"
  else
    bad "nav dot order" "dot hrefs are not the slide ids in document order"
  fi

  # Slide k's cue must point at slide k+1. An off-by-one cue chain is the most
  # common wiring bug in a hand-edited deck, which is why this check exists.
  miss=""
  i=1
  while [ "$i" -lt "$n" ]; do
    got=$(sed -n "${i}p" <<<"$cues")
    want=$(sed -n "$((i + 1))p" <<<"$slides")
    if [ "$got" != "$want" ]; then
      miss="slide $i cue points at '#$got', expected '#$want'"
      break
    fi
    i=$((i + 1))
  done
  if [ -z "$miss" ]; then
    ok "next-cue chain"
  else
    bad "next-cue chain" "$miss"
  fi
}

case "$PROFILE" in
  viz) check_viz ;;
  deck) check_deck ;;
esac

TOTAL=$((PASSED + FAILED))
if [ "$FAILED" -eq 0 ]; then
  printf '[OK] verify-html %s: %d/%d passed\n' "$PROFILE" "$PASSED" "$TOTAL"
  exit 0
fi
printf '[FAIL] verify-html %s: %d of %d failed\n' "$PROFILE" "$FAILED" "$TOTAL"
exit 1
