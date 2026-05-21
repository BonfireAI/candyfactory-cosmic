# Spike — How to properly build a Pop!_OS 24.04 COSMIC theme

**Date:** 2026-05-20
**Repo:** `candyfactory-cosmic/`
**Author:** Ishtar (research dispatched to two Explore scouts + local system probe)
**Status:** Closed — findings applied; no RON edits required

---

## TL;DR

- Our RON theme files match current upstream `cosmic-theme` + `cosmic-term` schema. **Zero RON fixes required.**
- One stale comment fixed: `install.sh` claimed "COSMIC alpha/beta" — it's `cosmic-comp 1.0.0` (shipped with Pop!_OS 24.04 LTS).
- Distribution map locked: **GitHub + cosmic-themes.org + cosmic-tweaks registry + r/pop_os**. No .deb for v1; community convention is RON-only. Pling/GNOME-Look skipped for brand-positioning reasons.
- Anta's machine inventory captured. All install-target directories already exist.
- High-leverage finding: `cosmic-utils/cosmic-project-collection/themes.ron` is a registry that `cosmic-tweaks` reads to populate its "Available" tab. A PR there auto-lists us in every cosmic-tweaks user's UI, including Anta's.

---

## 1. Live system inventory (Anta's machine, 2026-05-20)

| Component | Value |
|---|---|
| OS | `Pop!_OS 24.04 LTS` (noble) |
| Kernel | `6.18.7-76061807-generic` |
| Compositor | `cosmic-comp 1.0.0` (released, not alpha/beta) |
| COSMIC apps via apt | cosmic-comp, cosmic-session, cosmic-settings, cosmic-term, cosmic-files, cosmic-edit, cosmic-launcher, cosmic-greeter, cosmic-osd, cosmic-panel, cosmic-bg, cosmic-app-library, cosmic-icons, cosmic-store, cosmic-workspaces, cosmic-randr, cosmic-screenshot, cosmic-notifications, cosmic-player, cosmic-idle, cosmic-settings-daemon, xdg-desktop-portal-cosmic, cosmic-initial-setup |
| cosmic-tweaks | Flatpak `dev.edfloreshz.CosmicTweaks 0.2.3` (stable channel, user scope) |
| `~/.config/cosmic/` | Full app tree present, including `com.system76.CosmicTheme.{Dark,Light}/v1/` and `.Builder/v1/`, `com.system76.CosmicTerm/v1/`, `dev.edfloreshz.CosmicTweaks/v1` + `…CosmicTweaks.ColorScheme/v1` |
| `/usr/share/cosmic/` | System defaults present: `CosmicTheme.{Dark,Light}/v1` + `.Builder/v1` |

**Install impact:** All target directories already exist. Our `install.sh` mkdir steps will no-op cleanly. The themes will install under the user-config path; `/usr/share/cosmic/` is system-defaults territory and we don't touch it.

---

## 2. RON schema validation vs upstream

Source-of-truth checked: `github.com/pop-os/cosmic-theme` (master, last push 2026-05-20), `github.com/pop-os/cosmic-term`, `github.com/pop-os/cosmic-comp`. Citations from `src/model/theme.rs`, `src/model/cosmic_palette.rs`, `src/model/dark.ron`, `src/model/light.ron`, `cosmic-term/src/config.rs`, `cosmic-term/src/terminal_theme.rs`, `cosmic-term/color-schemes/COSMIC Dark.ron`.

### Top-level theme shape (15 fields, all confirmed)
`palette`, `spacing`, `corner_radii`, `bg_color`, `text_tint`, `accent`, `success`, `warning`, `destructive`, `window_hint`, `neutral_tint`, `primary_container_bg`, `secondary_container_bg`, `is_frosted`, `gaps`, `active_hint`. No deprecations, renames, or recent additions.

### Palette interior (36 fields, all confirmed)
- 4 standard hues: `blue`, `red`, `green`, `yellow`
- 3 grays: `gray_1..3`
- 11 neutrals: `neutral_0..neutral_10`
- 3 bright variants: `bright_green`, `bright_red`, `bright_orange`
- 7 extended hues: `ext_warm_grey`, `ext_orange`, `ext_yellow`, `ext_blue`, `ext_purple`, `ext_pink`, `ext_indigo`
- 9 accent picks: `accent_blue`, `accent_red`, `accent_green`, `accent_warm_grey`, `accent_orange`, `accent_yellow`, `accent_purple`, `accent_pink`, `accent_indigo`

### Color tuple shapes
- **4-tuple `(red, green, blue, alpha)`:** palette colors, `bg_color`, `primary_container_bg`, `secondary_container_bg`
- **3-tuple `(red, green, blue)`:** `text_tint`, `accent`, `success`, `warning`, `destructive`, `window_hint`, `neutral_tint`
- Values are `f32` in `[0.0, 1.0]` (NOT `[0, 255]`)
- `None` is valid for nullable overrides — COSMIC derives from palette

### cosmic-term format
Confirmed via `cosmic-term/src/config.rs` and `terminal_theme.rs`. Hex strings only (`"#fff8e7"`), never RGB tuples. Fields: `name`, `foreground`, `background`, `cursor`, `bright_foreground`, `dim_foreground`, `selection_foreground`, `selection_background`, `normal: (black/red/green/yellow/blue/magenta/cyan/white)`, `bright: (...)`, `dim: Some((...))`. Our file already includes `selection_foreground` + `selection_background`.

### Accent palette files (`accent_palette_{dark,light}`)
Format is not documented in the public `cosmic-theme` crate — it's read by `cosmic-settings` UI directly to populate the picker. The shape our spec speculates is the right shape (a Srgba list):

```ron
[
    (red: 1.0, green: 0.372549, blue: 0.635294, alpha: 1.0),
    // ...
]
```

These don't affect theme load; they only expose colors in the accent picker.

### Verdict

**No RON edits required.** Our files in `themes/` parse against current upstream.

---

## 3. cosmic-tweaks integration

`dev.edfloreshz.CosmicTweaks` (community Tauri/iced app, maintained by the `cosmic-utils` org) is the highest-leverage discovery surface in the COSMIC ecosystem.

**How it discovers themes:** the "Available" tab pulls from a registry file at `github.com/cosmic-utils/cosmic-project-collection/blob/main/themes.ron`. Each entry links a name → GitHub repo URL. A PR adding our theme means **every cosmic-tweaks user (including Anta) sees CandyFactory · Cotton Candy Parlor in their Available list with no further action**.

**No special integration code needed.** cosmic-tweaks reads `~/.config/cosmic/` the same way `cosmic-settings` does. Our installer's output lands where both apps expect.

---

## 4. Distribution strategy

Priority order — what to do first wins most attention per unit effort.

| # | Channel | Why |
|---|---|---|
| 1 | **GitHub public** (`BonfireAI/candyfactory-cosmic`) | Canonical install source. `git clone && ./install.sh`. Stars = SEO. |
| 2 | **cosmic-themes.org** listing | Community-adjacent theme showcase. Users discover by browsing. Reviewed (anti-spam). |
| 3 | **cosmic-utils/cosmic-project-collection** themes.ron PR | Auto-listing in cosmic-tweaks "Available" tab. Highest passive-discovery leverage. |
| 4 | **Department-stack/awesome-cosmic** PR | Curated community list. Developer/power-user surface. |
| 5 | **r/pop_os** showcase post | Where COSMIC users actually live. One good screenshot = velocity. Catppuccin COSMIC's path. |
| 6 | **candy-factory.ai/cosmic** | Our own brand surface. Hub HTML deployed via `candyfactory-www`. |
| 7 | **Mastodon @system76 ping** | Possible boost from System76. |

**Skipped intentionally:**
- `.deb` packaging — rare in community-COSMIC-themes-land; cosmic-tweaks handles discovery cleaner. Revisit if we ever want system-wide install + Pop!_Shop submission (System76-gated, separate negotiation).
- pling.com / gnome-look.org / opendesktop.org — brand-positioning. Our product is `for COSMIC`; we don't list on GNOME-flavored surfaces. (See feedback memory `cosmic-distribution-not-gnome-flavored-2026-05-20`.)

---

## 5. Fixes applied during this spike

| File | Change |
|---|---|
| `install.sh` line 12 | Comment updated: "Pop!_OS 24.04 (COSMIC alpha/beta)" → "Pop!_OS 24.04 LTS (COSMIC 1.0)" |
| `themes/*.ron` | **No changes.** All three files validated against upstream. |

---

## 6. Open follow-ups

Filed as Linear tickets under the *CandyFactory · Cotton Candy Parlor for COSMIC* project.

1. **MIT LICENSE** — added in this commit
2. **GitHub public push** — `BonfireAI/candyfactory-cosmic`
3. **Deploy hub at `candy-factory.ai/cosmic`** — via `candyfactory-www`
4. **Capture v1 screenshots** (3 minimum: Bonfire desktop, Parlor desktop, cosmic-term in Bonfire) — gated behind Anta running `./install.sh` on his live machine
5. **Generate `accent_palette_{dark,light}` files** (CLAUDE.md §6 Step 2) — optional polish, exposes our candy palette in COSMIC's accent picker
6. **Distribution rollout** (cosmic-themes.org submission + cosmic-utils themes.ron PR + awesome-cosmic PR + r/pop_os post) — gated on screenshots + GitHub URL

---

## 7. Sources

**Schema validation (Scout 1):**
- https://github.com/pop-os/cosmic-theme/blob/master/src/model/theme.rs
- https://github.com/pop-os/cosmic-theme/blob/master/src/model/cosmic_palette.rs
- https://github.com/pop-os/cosmic-theme/blob/master/src/model/dark.ron
- https://github.com/pop-os/cosmic-theme/blob/master/src/model/light.ron
- https://github.com/pop-os/cosmic-term/blob/master/src/config.rs
- https://github.com/pop-os/cosmic-term/blob/master/src/terminal_theme.rs
- https://github.com/pop-os/cosmic-term/blob/master/color-schemes/COSMIC%20Dark.ron
- https://github.com/pop-os/cosmic-comp (master @ 2026-05-20)

**Distribution (Scout 2):**
- https://cosmic-themes.org/
- https://github.com/pop-os/cosmic-epoch
- https://github.com/pop-os/cosmic-icons
- https://github.com/cosmic-utils/tweaks
- https://github.com/cosmic-utils/cosmic-project-collection
- https://github.com/Department-stack/awesome-cosmic
- https://github.com/catppuccin/cosmic-desktop (community precedent)

**Local system probe:** captured 2026-05-20 via `dpkg -l`, `find ~/.config/cosmic`, `command -v`, `flatpak list`.
