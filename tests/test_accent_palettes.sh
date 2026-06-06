#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════
# tests/test_accent_palettes.sh
#
# Knight tests for Slice B (BON-1236) — accent palette files.
# Asserts the dark palette matches CLAUDE.md §6 Step 2 verbatim,
# the light palette matches parlor-light.ron semantic-role
# overrides plus the deepened-sky from the palette "blue:" slot,
# and that install.sh's --dry-run / --uninstall paths cover both
# new files.
# ═══════════════════════════════════════════════════════════════════
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO="$(cd "$HERE/.." && pwd)"

DARK_PAL="$REPO/themes/candyfactory-accent-palette-dark"
LIGHT_PAL="$REPO/themes/candyfactory-accent-palette-light"
PARLOR="$REPO/themes/candyfactory-parlor-light.ron"
CLAUDEMD="$REPO/CLAUDE.md"
INSTALL="$REPO/install.sh"

TMPHOME="$(mktemp -d)"
trap 'rm -rf "$TMPHOME"' EXIT

# install.sh resolves its config base as ${XDG_CONFIG_HOME:-$HOME/.config}.
# Overriding HOME is therefore not enough: when XDG_CONFIG_HOME is set in the
# ambient environment (as it is on CI runners), install.sh writes under that
# path while the tests assert against "$TMPHOME/.config". Pin XDG_CONFIG_HOME
# to the fake home so install.sh's target always matches what the tests check,
# regardless of the inherited value. install.sh behaviour is unchanged.
export XDG_CONFIG_HOME="$TMPHOME/.config"

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

# Extract the RGB-float triple for the Nth entry (1-indexed) of a
# palette file. Echoes "R G B" (space-separated, alpha stripped).
palette_entry_rgb() {
    local file="$1" n="$2"
    awk -v n="$n" '
        /^[[:space:]]*\(red:/ {
            count++
            if (count == n) {
                # strip leading "(", trailing "), // ..." etc.
                line = $0
                sub(/^[[:space:]]*\(/, "", line)
                sub(/\).*$/, "", line)
                # line is now: red: X, green: Y, blue: Z, alpha: W
                # extract numbers in order
                r = ""; g = ""; b = ""
                nf = split(line, parts, ",")
                for (i = 1; i <= nf; i++) {
                    p = parts[i]
                    sub(/^[[:space:]]+/, "", p)
                    if (match(p, /^red:[[:space:]]*([0-9.]+)/, m))   r = m[1]
                    if (match(p, /^green:[[:space:]]*([0-9.]+)/, m)) g = m[1]
                    if (match(p, /^blue:[[:space:]]*([0-9.]+)/, m))  b = m[1]
                }
                printf "%s %s %s\n", r, g, b
                exit
            }
        }
    ' "$file"
}

# Extract the RGB-float triple from a parlor-light.ron semantic-role
# override line such as `accent: Some((red: ..., green: ..., blue: ...))`.
# Echoes "R G B".
parlor_role_rgb() {
    local role="$1"
    awk -v role="$role" '
        $0 ~ "^[[:space:]]*"role":" {
            line = $0
            r = ""; g = ""; b = ""
            if (match(line, /red:[[:space:]]*([0-9.]+)/, m))   r = m[1]
            if (match(line, /green:[[:space:]]*([0-9.]+)/, m)) g = m[1]
            if (match(line, /blue:[[:space:]]*([0-9.]+)/, m))  b = m[1]
            printf "%s %s %s\n", r, g, b
            exit
        }
    ' "$PARLOR"
}

# Extract the RGB from parlor-light.ron palette "blue:" line (line 15).
parlor_palette_blue_rgb() {
    awk '
        /^[[:space:]]*blue:[[:space:]]*\(red:/ {
            line = $0
            r = ""; g = ""; b = ""
            if (match(line, /red:[[:space:]]*([0-9.]+)/, m))   r = m[1]
            if (match(line, /green:[[:space:]]*([0-9.]+)/, m)) g = m[1]
            if (match(line, /blue:[[:space:]]*([0-9.]+)/, m))  b = m[1]
            printf "%s %s %s\n", r, g, b
            exit
        }
    ' "$PARLOR"
}

# Extract the CLAUDE.md §6 Step 2 RON block — between the first `[`
# line and the matching `]` line, inside the fenced ```ron block that
# follows the "Step 2 — Accent palettes" heading.
extract_claudemd_step2_block() {
    awk '
        /^### Step 2 — Accent palettes/ { in_section = 1; next }
        in_section && /^```ron/         { in_fence = 1; next }
        in_fence && /^```/              { exit }
        in_fence                        { print }
    ' "$CLAUDEMD"
}

# ── tests ──────────────────────────────────────────────────────────

test_dark_palette_exists_and_parses() {
    local n="test_dark_palette_exists_and_parses"
    if [ ! -f "$DARK_PAL" ]; then
        fail "$n" "file does not exist: $DARK_PAL"
        return 1
    fi
    local first last
    first="$(head -n 1 "$DARK_PAL" | tr -d '[:space:]')"
    last="$(tail -n 1 "$DARK_PAL" | tr -d '[:space:]')"
    # Allow trailing newline: tail of an empty last line would be "".
    if [ "$last" = "" ]; then
        last="$(grep -v '^[[:space:]]*$' "$DARK_PAL" | tail -n 1 | tr -d '[:space:]')"
    fi
    if [ "$first" != "[" ]; then
        fail "$n" "first non-whitespace token is not '['; got: '$first'"
        return 1
    fi
    if [ "$last" != "]" ]; then
        fail "$n" "last non-whitespace token is not ']'; got: '$last'"
        return 1
    fi
    if [ ! -s "$DARK_PAL" ]; then
        fail "$n" "file is empty"
        return 1
    fi
    pass "$n"
}

test_dark_palette_six_entries() {
    local n="test_dark_palette_six_entries"
    local count
    count="$(grep -cE '^\s*\(red:' "$DARK_PAL" || true)"
    if [ "$count" != "6" ]; then
        fail "$n" "expected 6 entries, found $count"
        return 1
    fi
    pass "$n"
}

test_dark_palette_matches_claude_md_section_6_step_2() {
    local n="test_dark_palette_matches_claude_md_section_6_step_2"
    local expected actual
    expected="$(extract_claudemd_step2_block)"
    actual="$(cat "$DARK_PAL")"
    if [ -z "$expected" ]; then
        fail "$n" "could not extract Step 2 block from CLAUDE.md"
        return 1
    fi
    if ! diff -q <(printf '%s\n' "$expected") <(printf '%s\n' "$actual") >/dev/null 2>&1; then
        fail "$n" "dark palette content does not match CLAUDE.md §6 Step 2 block"
        diff <(printf '%s\n' "$expected") <(printf '%s\n' "$actual") | sed 's/^/      /' >&2
        return 1
    fi
    pass "$n"
}

test_light_palette_exists_and_parses() {
    local n="test_light_palette_exists_and_parses"
    if [ ! -f "$LIGHT_PAL" ]; then
        fail "$n" "file does not exist: $LIGHT_PAL"
        return 1
    fi
    local first last
    first="$(head -n 1 "$LIGHT_PAL" | tr -d '[:space:]')"
    last="$(grep -v '^[[:space:]]*$' "$LIGHT_PAL" | tail -n 1 | tr -d '[:space:]')"
    if [ "$first" != "[" ]; then
        fail "$n" "first non-whitespace token is not '['; got: '$first'"
        return 1
    fi
    if [ "$last" != "]" ]; then
        fail "$n" "last non-whitespace token is not ']'; got: '$last'"
        return 1
    fi
    pass "$n"
}

test_light_palette_six_entries() {
    local n="test_light_palette_six_entries"
    local count
    count="$(grep -cE '^\s*\(red:' "$LIGHT_PAL" || true)"
    if [ "$count" != "6" ]; then
        fail "$n" "expected 6 entries, found $count"
        return 1
    fi
    pass "$n"
}

assert_entry_matches_role() {
    local name="$1" entry_idx="$2" role="$3"
    local got expected
    got="$(palette_entry_rgb "$LIGHT_PAL" "$entry_idx")"
    expected="$(parlor_role_rgb "$role")"
    if [ -z "$expected" ]; then
        fail "$name" "could not extract parlor-light role: $role"
        return 1
    fi
    if [ "$got" != "$expected" ]; then
        fail "$name" "entry $entry_idx RGB '$got' != $role RGB '$expected'"
        return 1
    fi
    pass "$name"
}

test_light_palette_pink_matches_window_hint() {
    assert_entry_matches_role "test_light_palette_pink_matches_window_hint" 1 "window_hint"
}

test_light_palette_cherry_matches_destructive() {
    assert_entry_matches_role "test_light_palette_cherry_matches_destructive" 2 "destructive"
}

test_light_palette_mint_matches_success() {
    assert_entry_matches_role "test_light_palette_mint_matches_success" 3 "success"
}

test_light_palette_butter_matches_warning() {
    assert_entry_matches_role "test_light_palette_butter_matches_warning" 4 "warning"
}

test_light_palette_grape_matches_accent() {
    assert_entry_matches_role "test_light_palette_grape_matches_accent" 5 "accent"
}

test_light_palette_sky_matches_parlor_light_blue() {
    local n="test_light_palette_sky_matches_parlor_light_blue"
    local got expected
    got="$(palette_entry_rgb "$LIGHT_PAL" 6)"
    expected="$(parlor_palette_blue_rgb)"
    if [ -z "$expected" ]; then
        fail "$n" "could not extract parlor-light palette blue: slot"
        return 1
    fi
    if [ "$got" != "$expected" ]; then
        fail "$n" "entry 6 RGB '$got' != palette blue RGB '$expected'"
        return 1
    fi
    pass "$n"
}

test_install_sh_dry_run_shows_both_new_paths() {
    local n="test_install_sh_dry_run_shows_both_new_paths"
    local out
    out="$(HOME="$TMPHOME" bash "$INSTALL" --dry-run 2>&1)"
    if ! printf '%s' "$out" | grep -q 'accent_palette_dark'; then
        fail "$n" "--dry-run output missing 'accent_palette_dark'"
        return 1
    fi
    if ! printf '%s' "$out" | grep -q 'accent_palette_light'; then
        fail "$n" "--dry-run output missing 'accent_palette_light'"
        return 1
    fi
    pass "$n"
}

test_install_sh_uninstall_removes_palettes_when_present() {
    local n="test_install_sh_uninstall_removes_palettes_when_present"
    local settings_dir="$TMPHOME/.config/cosmic/com.system76.CosmicSettings/v1"
    mkdir -p "$settings_dir"
    : > "$settings_dir/accent_palette_dark"
    : > "$settings_dir/accent_palette_light"
    HOME="$TMPHOME" bash "$INSTALL" --uninstall >/dev/null 2>&1
    if [ -e "$settings_dir/accent_palette_dark" ]; then
        fail "$n" "accent_palette_dark still exists after --uninstall"
        return 1
    fi
    if [ -e "$settings_dir/accent_palette_light" ]; then
        fail "$n" "accent_palette_light still exists after --uninstall"
        return 1
    fi
    pass "$n"
}

test_install_sh_uninstall_is_noop_when_absent() {
    local n="test_install_sh_uninstall_is_noop_when_absent"
    local cleanhome
    cleanhome="$(mktemp -d)"
    if HOME="$cleanhome" XDG_CONFIG_HOME="$cleanhome/.config" \
        bash "$INSTALL" --uninstall >/dev/null 2>&1; then
        rm -rf "$cleanhome"
        pass "$n"
    else
        rm -rf "$cleanhome"
        fail "$n" "--uninstall exited non-zero on empty home"
        return 1
    fi
}

# ── run ────────────────────────────────────────────────────────────

test_dark_palette_exists_and_parses                       || true
test_dark_palette_six_entries                             || true
test_dark_palette_matches_claude_md_section_6_step_2      || true
test_light_palette_exists_and_parses                      || true
test_light_palette_six_entries                            || true
test_light_palette_pink_matches_window_hint               || true
test_light_palette_cherry_matches_destructive             || true
test_light_palette_mint_matches_success                   || true
test_light_palette_butter_matches_warning                 || true
test_light_palette_grape_matches_accent                   || true
test_light_palette_sky_matches_parlor_light_blue          || true
test_install_sh_dry_run_shows_both_new_paths              || true
test_install_sh_uninstall_removes_palettes_when_present   || true
test_install_sh_uninstall_is_noop_when_absent             || true

printf '\nPASSED: %d / FAILED: %d\n' "$PASS_COUNT" "$FAIL_COUNT"

if [ "$FAIL_COUNT" -gt 0 ]; then
    exit 1
fi
exit 0
