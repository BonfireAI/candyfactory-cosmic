#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════
# tests/test_install.sh
#
# Integration test for the installer's real (no-flag) install path.
# The installer IS the product, yet the other suites only exercise
# `install.sh --dry-run` (which just prints) and `install.sh
# --uninstall` (which only removes). Nothing runs `bash install.sh`
# with no flags and confirms the five files actually land.
#
# That gap matters: CLAUDE.md §2 warns COSMIC gives no error popup on
# a missing or broken theme — it silently falls back to the system
# default. So a regression in any of the five `cp` targets, a dropped
# `mkdir -p`, or a renamed source file would ship green. This suite
# closes that gap by running the real installer into a throwaway home
# and asserting each target file both exists and is byte-identical to
# its repo source, then re-running to prove idempotency.
#
# Dependency-free: bash + coreutils (mktemp, cmp), matching the CI
# ubuntu-latest setup that installs only a shell linter.
# ═══════════════════════════════════════════════════════════════════
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO="$(cd "$HERE/.." && pwd)"

INSTALL="$REPO/install.sh"

# Repo source files (the truth each installed copy must match).
SRC_DARK="$REPO/themes/candyfactory-bonfire-dark.ron"
SRC_LIGHT="$REPO/themes/candyfactory-parlor-light.ron"
SRC_TERM="$REPO/themes/candyfactory-term-bonfire.ron"
SRC_ACCENT_DARK="$REPO/themes/candyfactory-accent-palette-dark"
SRC_ACCENT_LIGHT="$REPO/themes/candyfactory-accent-palette-light"

# A throwaway home for the install. install.sh resolves its config base
# as ${XDG_CONFIG_HOME:-$HOME/.config}, so overriding HOME alone is not
# enough: when XDG_CONFIG_HOME is set in the ambient environment (as it
# is on CI runners) install.sh writes under that path while the tests
# assert under "$TMPHOME/.config". Pin BOTH so install.sh's targets
# always match what the tests check, regardless of the inherited value.
# install.sh behaviour is unchanged. (Same pinning as
# test_accent_palettes.sh lines 26-32.)
TMPHOME="$(mktemp -d)"
trap 'rm -rf "$TMPHOME"' EXIT
export HOME="$TMPHOME"
export XDG_CONFIG_HOME="$TMPHOME/.config"

# Installed target paths (CLAUDE.md §2 table + install.sh §targets).
CFG="$XDG_CONFIG_HOME/cosmic"
DST_DARK="$CFG/com.system76.CosmicTheme.Dark/v1/CandyFactory-Bonfire"
DST_LIGHT="$CFG/com.system76.CosmicTheme.Light/v1/CandyFactory-Parlor"
DST_TERM="$CFG/com.system76.CosmicTerm/v1/color_schemes/CandyFactory-Bonfire.ron"
DST_ACCENT_DARK="$CFG/com.system76.CosmicSettings/v1/accent_palette_dark"
DST_ACCENT_LIGHT="$CFG/com.system76.CosmicSettings/v1/accent_palette_light"

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

# Run the real installer with no flags. Echoes nothing; returns the
# installer's exit code.
run_installer() {
    bash "$INSTALL" >/dev/null 2>&1
}

# Assert a target file exists and is byte-identical to its source.
assert_target_matches() {
    local n="$1" dst="$2" src="$3"
    if [ ! -f "$dst" ]; then
        fail "$n" "target does not exist: $dst"
        return 1
    fi
    if ! cmp -s "$dst" "$src"; then
        fail "$n" "target differs from source: $dst != $src"
        return 1
    fi
    pass "$n"
}

# ── tests ──────────────────────────────────────────────────────────

test_install_exits_zero() {
    local n="test_install_exits_zero"
    if run_installer; then
        pass "$n"
    else
        fail "$n" "bash install.sh (no flags) exited non-zero"
        return 1
    fi
}

test_dark_theme_lands_and_matches() {
    assert_target_matches \
        "test_dark_theme_lands_and_matches" "$DST_DARK" "$SRC_DARK"
}

test_light_theme_lands_and_matches() {
    assert_target_matches \
        "test_light_theme_lands_and_matches" "$DST_LIGHT" "$SRC_LIGHT"
}

test_term_scheme_lands_and_matches() {
    assert_target_matches \
        "test_term_scheme_lands_and_matches" "$DST_TERM" "$SRC_TERM"
}

test_accent_dark_lands_and_matches() {
    assert_target_matches \
        "test_accent_dark_lands_and_matches" "$DST_ACCENT_DARK" "$SRC_ACCENT_DARK"
}

test_accent_light_lands_and_matches() {
    assert_target_matches \
        "test_accent_light_lands_and_matches" "$DST_ACCENT_LIGHT" "$SRC_ACCENT_LIGHT"
}

test_rerun_is_idempotent() {
    local n="test_rerun_is_idempotent"
    # Second run on an already-installed home must still exit 0 and
    # leave every target byte-identical to its source.
    if ! run_installer; then
        fail "$n" "second install.sh run exited non-zero"
        return 1
    fi
    local dst src
    for pair in \
        "$DST_DARK|$SRC_DARK" \
        "$DST_LIGHT|$SRC_LIGHT" \
        "$DST_TERM|$SRC_TERM" \
        "$DST_ACCENT_DARK|$SRC_ACCENT_DARK" \
        "$DST_ACCENT_LIGHT|$SRC_ACCENT_LIGHT"; do
        dst="${pair%%|*}"
        src="${pair##*|}"
        if [ ! -f "$dst" ]; then
            fail "$n" "target missing after re-run: $dst"
            return 1
        fi
        if ! cmp -s "$dst" "$src"; then
            fail "$n" "target drifted after re-run: $dst != $src"
            return 1
        fi
    done
    pass "$n"
}

# ── run ────────────────────────────────────────────────────────────
# Order matters: install first, then assert the landed files, then
# prove the re-run is idempotent.

test_install_exits_zero            || true
test_dark_theme_lands_and_matches  || true
test_light_theme_lands_and_matches || true
test_term_scheme_lands_and_matches || true
test_accent_dark_lands_and_matches || true
test_accent_light_lands_and_matches || true
test_rerun_is_idempotent           || true

printf '\nPASSED: %d / FAILED: %d\n' "$PASS_COUNT" "$FAIL_COUNT"

if [ "$FAIL_COUNT" -gt 0 ]; then
    exit 1
fi
exit 0
