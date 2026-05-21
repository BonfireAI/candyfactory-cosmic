#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════
# candyfactory-cosmic · installer
#
# Installs the CandyFactory Cotton Candy Parlor theme into the
# current user's COSMIC config.  Safe to re-run.
#
#   ./install.sh                  install everything
#   ./install.sh --uninstall      remove everything we wrote
#   ./install.sh --dry-run        print what would happen
#
# Tested against Pop!_OS 24.04 (COSMIC alpha/beta).
# ═══════════════════════════════════════════════════════════════════

set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CFG="${XDG_CONFIG_HOME:-$HOME/.config}/cosmic"

DRY=0
UNINSTALL=0
for arg in "$@"; do
    case "$arg" in
        --dry-run)   DRY=1 ;;
        --uninstall) UNINSTALL=1 ;;
        -h|--help)
            sed -n '2,15p' "$0"; exit 0 ;;
        *) echo "unknown arg: $arg" >&2; exit 2 ;;
    esac
done

say()  { printf '  \033[1;35m▸\033[0m  %s\n' "$*"; }
note() { printf '  \033[2m·  %s\033[0m\n' "$*"; }
run()  { if [ "$DRY" = "1" ]; then note "would: $*"; else "$@"; fi; }

banner() {
cat <<'EOF'
  ╭──────────────────────────────────────────────╮
  │  🍭  CandyFactory  ·  Cotton Candy Parlor    │
  │      for POP!_OS 24.04 · COSMIC              │
  ╰──────────────────────────────────────────────╯
EOF
}

banner

# ── targets ────────────────────────────────────────────────────────
THEME_DARK_DIR="$CFG/com.system76.CosmicTheme.Dark/v1"
THEME_LIGHT_DIR="$CFG/com.system76.CosmicTheme.Light/v1"
TERM_DIR="$CFG/com.system76.CosmicTerm/v1/color_schemes"
SETTINGS_DIR="$CFG/com.system76.CosmicSettings/v1"

DARK_TARGET="$THEME_DARK_DIR/CandyFactory-Bonfire"
LIGHT_TARGET="$THEME_LIGHT_DIR/CandyFactory-Parlor"
TERM_TARGET="$TERM_DIR/CandyFactory-Bonfire.ron"

# ── uninstall ──────────────────────────────────────────────────────
if [ "$UNINSTALL" = "1" ]; then
    say "Uninstalling CandyFactory theme…"
    run rm -f "$DARK_TARGET" "$LIGHT_TARGET" "$TERM_TARGET"
    say "Done. Run 'cosmic-settings' to pick a different appearance."
    exit 0
fi

# ── precheck ───────────────────────────────────────────────────────
if ! command -v cosmic-settings >/dev/null 2>&1; then
    note "Warning: 'cosmic-settings' not found on PATH."
    note "         Is this Pop!_OS 24.04 with COSMIC installed?"
fi

# ── install themes ─────────────────────────────────────────────────
say "Installing Bonfire (dark) theme → $DARK_TARGET"
run mkdir -p "$THEME_DARK_DIR"
run cp -f "$HERE/themes/candyfactory-bonfire-dark.ron" "$DARK_TARGET"

say "Installing Parlor (light) theme → $LIGHT_TARGET"
run mkdir -p "$THEME_LIGHT_DIR"
run cp -f "$HERE/themes/candyfactory-parlor-light.ron" "$LIGHT_TARGET"

say "Installing cosmic-term color scheme → $TERM_TARGET"
run mkdir -p "$TERM_DIR"
run cp -f "$HERE/themes/candyfactory-term-bonfire.ron" "$TERM_TARGET"

# ── done ───────────────────────────────────────────────────────────
cat <<'EOF'

  ╭──────────────────────────────────────────────╮
  │  ✓  Sweets, baking. Stay close.              │
  ╰──────────────────────────────────────────────╯

  Next steps:
    1) Open  Settings → Desktop → Appearance
    2) Pick  CandyFactory-Bonfire  (dark)  or
             CandyFactory-Parlor    (light)
    3) Open  cosmic-term → View → Color schemes
       and pick "CandyFactory Bonfire".

  To revert:  ./install.sh --uninstall
EOF
