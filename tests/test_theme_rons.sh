#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════
# tests/test_theme_rons.sh
#
# Structural RON validation for the three theme files. CLAUDE.md §6
# calls silently-broken RON "the #1 way this goes wrong" — one typo
# in a tuple and COSMIC quietly falls back to system default, with no
# error popup. The accent-palette suite never touches these three
# files, so this is the guard for the spec invariants:
#
#   §4/§6 — bracket and paren balance (a stray '(' silently breaks the
#           parse).
#   §6 Step 1 — the dark theme declares `palette: Dark((`, the light
#           theme `palette: Light((`. A mismatch loads but renders
#           wrong.
#   §4/§6 — every color float lives in [0.0, 1.0], never 0–255. A 0–255
#           value silently looks black or blown out.
#   §5/§8 — `is_frosted: false` everywhere (glassmorphism is banned).
#   §5    — `gaps: (4, 8)` and `active_hint: 3` everywhere.
#   §A    — the cosmic-term scheme uses bare hex strings and balances.
#
# Dependency-free: bash + GNU awk only (matches the CI ubuntu-latest
# setup that installs only a shell linter; gawk is the default awk
# there, as the existing accent-palette suite already assumes).
# ═══════════════════════════════════════════════════════════════════
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO="$(cd "$HERE/.." && pwd)"

DARK="$REPO/themes/candyfactory-bonfire-dark.ron"
LIGHT="$REPO/themes/candyfactory-parlor-light.ron"
TERM="$REPO/themes/candyfactory-term-bonfire.ron"

# Allow callers (the teeth-proving harness) to point the validator at a
# scratch directory of copies instead of the real themes.
THEME_DIR="${THEME_DIR:-$REPO/themes}"
DARK="$THEME_DIR/candyfactory-bonfire-dark.ron"
LIGHT="$THEME_DIR/candyfactory-parlor-light.ron"
TERM="$THEME_DIR/candyfactory-term-bonfire.ron"

PASS_COUNT=0
FAIL_COUNT=0

pass() {
    printf 'PASS %s\n' "$1"
    PASS_COUNT=$((PASS_COUNT + 1))
}

fail() {
    printf 'FAIL %s (%s)\n' "$1" "$2"
    FAIL_COUNT=$((FAIL_COUNT + 1))
}

# ── helpers ────────────────────────────────────────────────────────

# Strip RON line comments (`// ...`) so brace counting and value scans
# do not trip on the hex codes and prose that live in trailing comments.
# Echoes the comment-free body of the file on stdout.
strip_comments() {
    sed 's://.*$::' "$1"
}

# Count occurrences of a single character in the comment-free body.
# Usage: count_char <file> <char>
count_char() {
    local file="$1" ch="$2"
    strip_comments "$file" | tr -cd "$ch" | wc -c | tr -d '[:space:]'
}

# ── tests ──────────────────────────────────────────────────────────

test_files_exist() {
    local n="test_files_exist"
    local f missing=0
    for f in "$DARK" "$LIGHT" "$TERM"; do
        if [ ! -s "$f" ]; then
            fail "$n" "missing or empty: $f"
            missing=1
        fi
    done
    [ "$missing" -eq 0 ] && pass "$n"
}

# Parens and square brackets must balance, or RON cannot parse.
assert_balanced() {
    local n="$1" file="$2"
    local open_paren close_paren open_brack close_brack
    open_paren="$(count_char "$file" '(')"
    close_paren="$(count_char "$file" ')')"
    open_brack="$(count_char "$file" '[')"
    close_brack="$(count_char "$file" ']')"
    if [ "$open_paren" != "$close_paren" ]; then
        fail "$n" "paren imbalance: $open_paren '(' vs $close_paren ')'"
        return 1
    fi
    if [ "$open_brack" != "$close_brack" ]; then
        fail "$n" "bracket imbalance: $open_brack '[' vs $close_brack ']'"
        return 1
    fi
    pass "$n"
}

test_dark_balanced()  { assert_balanced "test_dark_balanced"  "$DARK"; }
test_light_balanced() { assert_balanced "test_light_balanced" "$LIGHT"; }
test_term_balanced()  { assert_balanced "test_term_balanced"  "$TERM"; }

# §6 Step 1 — the dark theme must declare a Dark(( palette, the light
# theme a Light(( palette. A mismatch loads but renders wrong.
test_dark_declares_dark_palette() {
    local n="test_dark_declares_dark_palette"
    if ! grep -Eq '^[[:space:]]*palette:[[:space:]]*Dark\(\(' "$DARK"; then
        fail "$n" "dark theme does not declare 'palette: Dark(('"
        return 1
    fi
    if grep -Eq '^[[:space:]]*palette:[[:space:]]*Light\(\(' "$DARK"; then
        fail "$n" "dark theme wrongly declares a Light(( palette"
        return 1
    fi
    pass "$n"
}

test_light_declares_light_palette() {
    local n="test_light_declares_light_palette"
    if ! grep -Eq '^[[:space:]]*palette:[[:space:]]*Light\(\(' "$LIGHT"; then
        fail "$n" "light theme does not declare 'palette: Light(('"
        return 1
    fi
    if grep -Eq '^[[:space:]]*palette:[[:space:]]*Dark\(\(' "$LIGHT"; then
        fail "$n" "light theme wrongly declares a Dark(( palette"
        return 1
    fi
    pass "$n"
}

# §4/§6 — every red:/green:/blue:/alpha: float must be in [0.0, 1.0].
# A 0–255 value (e.g. red: 255) silently looks black or blown out.
# Reports the first offending value for a useful failure message.
assert_floats_in_unit_range() {
    local n="$1" file="$2"
    local bad
    bad="$(strip_comments "$file" | gawk '
        {
            # Scan every "key: number" where key is a color channel.
            while (match($0, /(red|green|blue|alpha):[[:space:]]*([0-9]+\.?[0-9]*)/, m)) {
                key = m[1]; val = m[2] + 0
                if (val < 0.0 || val > 1.0) {
                    printf "%s=%s", key, m[2]
                    exit
                }
                # advance past this match to find the next on the line
                $0 = substr($0, RSTART + RLENGTH)
            }
        }
    ')"
    if [ -n "$bad" ]; then
        fail "$n" "color channel out of [0.0,1.0] range (0-255 scale?): $bad"
        return 1
    fi
    pass "$n"
}

test_dark_floats_in_range()  { assert_floats_in_unit_range "test_dark_floats_in_range"  "$DARK"; }
test_light_floats_in_range() { assert_floats_in_unit_range "test_light_floats_in_range" "$LIGHT"; }

# §5/§8 — is_frosted must be false (glassmorphism is banned). Asserted
# on both libcosmic theme files.
assert_is_frosted_false() {
    local n="$1" file="$2"
    if ! grep -Eq '^[[:space:]]*is_frosted:[[:space:]]*false' "$file"; then
        fail "$n" "is_frosted is not 'false' (must never be true per §8)"
        return 1
    fi
    if grep -Eq '^[[:space:]]*is_frosted:[[:space:]]*true' "$file"; then
        fail "$n" "is_frosted: true found — glassmorphism is banned (§8)"
        return 1
    fi
    pass "$n"
}

test_dark_is_frosted_false()  { assert_is_frosted_false "test_dark_is_frosted_false"  "$DARK"; }
test_light_is_frosted_false() { assert_is_frosted_false "test_light_is_frosted_false" "$LIGHT"; }

# §5 — gaps: (4, 8) and active_hint: 3 everywhere.
assert_gaps_and_hint() {
    local n="$1" file="$2"
    if ! grep -Eq '^[[:space:]]*gaps:[[:space:]]*\([[:space:]]*4[[:space:]]*,[[:space:]]*8[[:space:]]*\)' "$file"; then
        fail "$n" "gaps is not '(4, 8)' as required by §5"
        return 1
    fi
    if ! grep -Eq '^[[:space:]]*active_hint:[[:space:]]*3[[:space:]]*,?' "$file"; then
        fail "$n" "active_hint is not 3 as required by §5"
        return 1
    fi
    pass "$n"
}

test_dark_gaps_and_hint()  { assert_gaps_and_hint "test_dark_gaps_and_hint"  "$DARK"; }
test_light_gaps_and_hint() { assert_gaps_and_hint "test_light_gaps_and_hint" "$LIGHT"; }

# §A — the cosmic-term scheme uses bare hex strings (Some(...) wrappers
# are rejected by the cosmic-term struct) and carries fg + bg.
test_term_uses_bare_hex() {
    local n="test_term_uses_bare_hex"
    if ! grep -Eq '^[[:space:]]*foreground:[[:space:]]*"#[0-9a-fA-F]{6}"' "$TERM"; then
        fail "$n" "term scheme has no bare-hex 'foreground:'"
        return 1
    fi
    if ! grep -Eq '^[[:space:]]*background:[[:space:]]*"#[0-9a-fA-F]{6}"' "$TERM"; then
        fail "$n" "term scheme has no bare-hex 'background:'"
        return 1
    fi
    # cosmic-term rejects Some(...) wrappers in the scheme struct. Check
    # the comment-free body so the header note about this very rule does
    # not trip the assertion.
    if strip_comments "$TERM" | grep -q 'Some('; then
        fail "$n" "term scheme contains a Some(...) wrapper (rejected by cosmic-term)"
        return 1
    fi
    pass "$n"
}

# ── run ────────────────────────────────────────────────────────────

test_files_exist                   || true
test_dark_balanced                 || true
test_light_balanced                || true
test_term_balanced                 || true
test_dark_declares_dark_palette    || true
test_light_declares_light_palette  || true
test_dark_floats_in_range          || true
test_light_floats_in_range         || true
test_dark_is_frosted_false         || true
test_light_is_frosted_false        || true
test_dark_gaps_and_hint            || true
test_light_gaps_and_hint           || true
test_term_uses_bare_hex            || true

printf '\nPASSED: %d / FAILED: %d\n' "$PASS_COUNT" "$FAIL_COUNT"

if [ "$FAIL_COUNT" -gt 0 ]; then
    exit 1
fi
exit 0
