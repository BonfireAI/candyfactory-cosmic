# v1 Screenshots Runbook
*Capture-and-mirror procedure for the CandyFactory · Cotton Candy Parlor v1.*

## Overview

Three shots, two-repo mirror, four-draft placeholder swap. Anta's machine, Anta's eyes. The runbook is self-contained — each phase has reproducible commands plus expected output. Six phases, executed in order.

1. **Pre-capture** — install + apply themes, verify clean state.
2. **Capture** — three 1920×1080 PNGs on the live desktop.
3. **Post-process** — naming, optimization, size budget.
4. **Commit to cosmic repo** — the canonical home of the screenshots.
5. **Mirror to www repo** — *LATER*, only when the candyfactory-www lane is clear.
6. **Swap placeholders** — wire the live URLs into the three distribution drafts.

Snapshot tag `pre-v1-polish-2026-05-22` is on `main` — rollback safety if anything goes sideways.

---

## Phase 1 — Pre-capture (machine prep)

### 1.1 Check for pre-existing customizations

```bash
ls ~/.config/cosmic/com.system76.CosmicTheme.Dark/v1/ 2>/dev/null
ls ~/.config/cosmic/com.system76.CosmicTheme.Light/v1/ 2>/dev/null
ls ~/.config/cosmic/com.system76.CosmicTerm/v1/color_schemes/ 2>/dev/null
```

**Expected output:** either "No such file or directory" (clean machine) or a list of existing theme files. If any non-CandyFactory files exist that you want to preserve, back them up first:

```bash
# Optional one-liner backup
tar -czf ~/cosmic-themes-backup-$(date +%Y%m%d).tar.gz \
  ~/.config/cosmic/com.system76.CosmicTheme.Dark/v1/ \
  ~/.config/cosmic/com.system76.CosmicTheme.Light/v1/ \
  ~/.config/cosmic/com.system76.CosmicTerm/v1/color_schemes/ \
  2>/dev/null || true
```

### 1.2 Pull latest

```bash
git -C /home/ishtar/Projects/candyfactory-cosmic checkout main
git -C /home/ishtar/Projects/candyfactory-cosmic pull origin main
```

**Expected output:** `Already up to date.` or a fast-forward summary.

### 1.3 Preview the installer (dry-run)

```bash
cd /home/ishtar/Projects/candyfactory-cosmic
./install.sh --dry-run
```

**Expected output:** lists the three `.ron` themes (Bonfire dark, Parlor light, term-bonfire scheme) and the accent palette files it would write. No actual writes happen. Confirm the target paths match `~/.config/cosmic/com.system76.CosmicTheme.{Dark,Light}/v1/` and `~/.config/cosmic/com.system76.CosmicTerm/v1/color_schemes/`.

### 1.4 Install for real

```bash
./install.sh
```

**Expected output:** the installer banner, then a green "Sweets, baking" footer, then `Next steps:` instructions. Verify:

```bash
ls ~/.config/cosmic/com.system76.CosmicTheme.Dark/v1/CandyFactory-Bonfire
ls ~/.config/cosmic/com.system76.CosmicTheme.Light/v1/CandyFactory-Parlor
ls ~/.config/cosmic/com.system76.CosmicTerm/v1/color_schemes/CandyFactory-Bonfire.ron
```

All three should exist.

### 1.5 Log out / log back in

cosmic-comp picks up theme files on session restart. Log out from the COSMIC menu, then log back in.

### 1.6 Apply themes in COSMIC Settings

1. Open `cosmic-settings` → **Desktop** → **Appearance**.
2. Verify both **CandyFactory-Bonfire** (dark) and **CandyFactory-Parlor** (light) appear in the theme list.
3. Select **CandyFactory-Bonfire** as active.
4. Confirm the cream/ink palette renders correctly — accent should be pink, window-hint should be grape on the focused window.

### 1.7 Apply the cosmic-term color scheme

1. Open `cosmic-term`.
2. **View** → **Color schemes** (or right-click → Settings → Color schemes).
3. Verify **CandyFactory Bonfire** is selectable.
4. Select it. The terminal background should turn to candied-dark; `ls --color=auto` should render with the CandyFactory ANSI ramp.

If any of these steps fail, check `journalctl --user -u cosmic-comp -f` for RON parse errors before proceeding.

---

## Phase 2 — Capture (3 shots, 1920×1080)

Pick a capture tool. Check what's installed:

```bash
which flameshot gnome-screenshot cosmic-screenshot 2>/dev/null
```

Whichever returns a path is fine. Recommended order: `flameshot` (region-select GUI), then `gnome-screenshot`, then `cosmic-screenshot` if it exists. Capture commands below assume `flameshot`; swap the binary if you're using something else.

All shots target **1920×1080**. If your monitor is higher, use the capture tool's region selector to crop to 1920×1080. If your monitor is lower, set a 1920×1080 virtual display or screenshot the full screen and accept the smaller native resolution (note it in the PR body).

### Shot 1 — Bonfire (dark) desktop · `bonfire-desktop.png`

**Composition checklist:**

- [ ] Bonfire theme active (verify accent is pink, window-hint is grape).
- [ ] COSMIC panel + dock visible.
- [ ] A **focused libcosmic window** (suggest: Files, or cosmic-settings Appearance pane) with the grape window-hint outline clearly visible.
- [ ] An **unfocused libcosmic window** in the same shot (suggest: tile-layout a second app — `Super + Y` toggles tiling; pull a second app into the layout to show gaps + the unfocused state).
- [ ] Optionally: open the accent picker in cosmic-settings → Appearance to show the full candy palette in the same frame.
- [ ] No personal info visible (close browser tabs with email, hide identifiable filenames in Files, etc.).

**Capture:**

```bash
flameshot gui --path ~/Pictures/
# In the GUI: region-select to 1920×1080, save as bonfire-desktop.png
```

Or with `gnome-screenshot`:

```bash
gnome-screenshot -i  # interactive; pick "Selection", save manually as bonfire-desktop.png
```

### Shot 2 — Parlor (light) desktop · `parlor-desktop.png`

**Switch themes first:**

1. cosmic-settings → Desktop → Appearance → select **CandyFactory-Parlor**.
2. Window manager re-renders. Wait ~2 seconds for full repaint.
3. Verify accent is deepened grape; window-hint on the focused window is deepened pink.

**Composition checklist:** same as Shot 1 (focused libcosmic window with the deepened-pink window-hint visible, an unfocused window, optional accent picker), with Parlor (light) theme active.

**Capture:** same command, save as `parlor-desktop.png`.

### Shot 3 — cosmic-term in Bonfire · `cosmic-term-ansi.png`

**Switch back to Bonfire** (cosmic-settings → Appearance → CandyFactory-Bonfire) so the desktop background is consistent with Shot 1.

**Composition checklist:**

- [ ] cosmic-term window with **CandyFactory Bonfire** color scheme active.
- [ ] One of the following commands run inside the terminal to surface the ANSI palette:
  - `ls -la --color=auto` — exercises file-type colors (directories, executables, symlinks).
  - `grep --color=always foo /etc/services` — exercises match-highlight (the bright variants).
  - `tldr ls` — if `tldr` is installed, surfaces inline-code coloring + headers.
- [ ] Cream-on-candied-dark contrast clearly visible.
- [ ] Bonfire desktop visible in the background (consistent with Shot 1).
- [ ] No secrets in scrollback (sanitize any prior shell history, or open a fresh terminal).

**Capture:** same command, save as `cosmic-term-ansi.png`.

---

## Phase 3 — Post-process

### 3.1 Verify dimensions

```bash
cd ~/Pictures/
file bonfire-desktop.png parlor-desktop.png cosmic-term-ansi.png
```

**Expected output:** each line should show `1920 x 1080` (or whatever native resolution you captured at, noted in the PR body if different).

### 3.2 Check size

```bash
du -h bonfire-desktop.png parlor-desktop.png cosmic-term-ansi.png
```

**Size budget:** ≤ 800 KB each. If any shot exceeds, re-export at slightly higher PNG compression or, as a last resort, smaller dimensions.

### 3.3 Optional optimization

```bash
# Only if pngcrush is installed
which pngcrush && {
  for f in bonfire-desktop.png parlor-desktop.png cosmic-term-ansi.png; do
    pngcrush -reduce "$f" "${f%.png}.crushed.png"
    mv "${f%.png}.crushed.png" "$f"
  done
}
```

Skip this step entirely if `pngcrush` is not installed. Re-verify size after.

---

## Phase 4 — Commit to cosmic repo (canonical)

This is the canonical home of the screenshots. The www repo (Phase 5) mirrors from here.

```bash
git -C /home/ishtar/Projects/candyfactory-cosmic fetch origin
git -C /home/ishtar/Projects/candyfactory-cosmic checkout main
git -C /home/ishtar/Projects/candyfactory-cosmic pull origin main
git -C /home/ishtar/Projects/candyfactory-cosmic checkout -b feat/v1-screenshots

mkdir -p /home/ishtar/Projects/candyfactory-cosmic/assets/screenshots

cp ~/Pictures/bonfire-desktop.png /home/ishtar/Projects/candyfactory-cosmic/assets/screenshots/
cp ~/Pictures/parlor-desktop.png /home/ishtar/Projects/candyfactory-cosmic/assets/screenshots/
cp ~/Pictures/cosmic-term-ansi.png /home/ishtar/Projects/candyfactory-cosmic/assets/screenshots/

git -C /home/ishtar/Projects/candyfactory-cosmic add assets/screenshots/
git -C /home/ishtar/Projects/candyfactory-cosmic status
```

**Expected status:** three new files staged under `assets/screenshots/`, nothing else.

```bash
git -C /home/ishtar/Projects/candyfactory-cosmic commit -m "feat(assets): v1 screenshots (Bonfire desktop, Parlor desktop, cosmic-term)

Closes BON-1235."

git -C /home/ishtar/Projects/candyfactory-cosmic push -u origin feat/v1-screenshots

gh pr create --repo BonfireAI/candyfactory-cosmic --base main --head feat/v1-screenshots \
  --title "feat(assets): v1 screenshots" \
  --body "Adds the three v1 screenshots to assets/screenshots/. Closes BON-1235."
```

The title intentionally omits the Linear ID (per `feedback_no_naked_linear_ids`); the body uses the `Closes BON-1235` footer so Linear auto-closes the ticket on merge.

### 4.1 Self-review the PR

```bash
gh pr view --repo BonfireAI/candyfactory-cosmic --json files,additions,deletions,title
```

**Expected:** 3 files (the PNGs), 0 deletions, additions in the hundreds-of-KB range. Nothing outside `assets/screenshots/`.

### 4.2 Merge

```bash
gh pr merge <PR#> --repo BonfireAI/candyfactory-cosmic --merge --delete-branch
```

After merge, the canonical raw URLs become:

- `https://raw.githubusercontent.com/BonfireAI/candyfactory-cosmic/main/assets/screenshots/bonfire-desktop.png`
- `https://raw.githubusercontent.com/BonfireAI/candyfactory-cosmic/main/assets/screenshots/parlor-desktop.png`
- `https://raw.githubusercontent.com/BonfireAI/candyfactory-cosmic/main/assets/screenshots/cosmic-term-ansi.png`

These URLs are used by Phase 6 (placeholder swap in the distribution drafts).

---

## Phase 5 — Mirror to www repo (LATER, when website lane clears)

> **HALT IF:** another session owns `candyfactory-www`. Before starting this phase:
>
> 1. Run `git -C /home/ishtar/Projects/candyfactory-www status` — must be clean.
> 2. Check Linear for in-flight tickets touching `candyfactory-www` — must be none.
> 3. If anything is in flight, coordinate with the other session or wait. Do **not** open a competing branch.
>
> If the lane is yours and the working tree is clean, proceed.

### 5.1 Confirm the lane is clean

```bash
git -C /home/ishtar/Projects/candyfactory-www status   # must be clean
git -C /home/ishtar/Projects/candyfactory-www fetch origin
git -C /home/ishtar/Projects/candyfactory-www checkout main
git -C /home/ishtar/Projects/candyfactory-www pull origin main
```

### 5.2 Branch and mirror the PNGs

```bash
git -C /home/ishtar/Projects/candyfactory-www checkout -b feat/cosmic-screenshots-v1

mkdir -p /home/ishtar/Projects/candyfactory-www/cosmic/assets/screenshots

cp /home/ishtar/Projects/candyfactory-cosmic/assets/screenshots/*.png \
   /home/ishtar/Projects/candyfactory-www/cosmic/assets/screenshots/
```

### 5.3 Update `cosmic/index.html` to point at local copies

Open `/home/ishtar/Projects/candyfactory-www/cosmic/index.html`. Search for any external screenshot URLs (likely placeholder markers or links pointing back to the cosmic repo's raw URLs) and replace them with local references of the form `./assets/screenshots/<filename>.png`.

Either edit by hand, or use `sed`:

```bash
# Example — adapt to whatever placeholder shape the file actually contains
sed -i 's|<EXTERNAL-SCREENSHOT-URL>|./assets/screenshots/bonfire-desktop.png|g' \
    /home/ishtar/Projects/candyfactory-www/cosmic/index.html
```

Diff-check before commit:

```bash
git -C /home/ishtar/Projects/candyfactory-www diff cosmic/index.html
```

### 5.4 Commit + push + PR

```bash
git -C /home/ishtar/Projects/candyfactory-www add \
    cosmic/assets/screenshots/ cosmic/index.html
git -C /home/ishtar/Projects/candyfactory-www commit -m "feat(cosmic): mirror v1 screenshots from candyfactory-cosmic

Refs BonfireAI/candyfactory-cosmic#<PR-from-Phase-4>."

git -C /home/ishtar/Projects/candyfactory-www push -u origin feat/cosmic-screenshots-v1

gh pr create --repo BonfireAI/candyfactory-www --base main --head feat/cosmic-screenshots-v1 \
  --title "feat(cosmic): mirror v1 screenshots from candyfactory-cosmic" \
  --body "Mirrors the v1 screenshots into the cosmic/ subpath. Pairs with BonfireAI/candyfactory-cosmic PR <N>."
```

Self-review (as in Phase 4.1), then merge:

```bash
gh pr merge <PR#> --repo BonfireAI/candyfactory-www --merge --delete-branch
```

### 5.5 Deploy to Vercel

`candyfactory-www` does **not** auto-deploy on push to main (per `reference_vercel_candyfactory_www_no_auto_deploy_2026_05_22`). Trigger manually:

```bash
vercel --cwd /home/ishtar/Projects/candyfactory-www --prod --yes
```

Verify the deploy with `vercel ls` and then visit `https://candyfactory.ai/cosmic/` to confirm the screenshots render against the mirrored paths.

---

## Phase 6 — Swap placeholders in distribution drafts

After Phase 4 and Phase 5 have merged, the three distribution drafts become submission-ready by swapping the `[SCREENSHOT-N: …]` markers for real references.

### 6.1 Pull latest

```bash
cd /home/ishtar/Projects/candyfactory-cosmic
git checkout main
git pull origin main
```

### 6.2 Identify what to swap

Three drafts under `docs/distribution/` carry placeholders:

| File | Placeholder shape | Target |
|------|-------------------|--------|
| `docs/distribution/r-pop-os-post.md` | `[SCREENSHOT-1: …]` etc. — Reddit markdown image syntax | `![Bonfire desktop](https://raw.githubusercontent.com/BonfireAI/candyfactory-cosmic/main/assets/screenshots/bonfire-desktop.png)` |
| `docs/distribution/themes-ron-pr-body.md` | `[SCREENSHOT-1-RAW-URL-HERE]` — the `image:` field value | `https://raw.githubusercontent.com/BonfireAI/candyfactory-cosmic/main/assets/screenshots/bonfire-desktop.png` |
| `docs/distribution/<third-draft>.md` | (per its own placeholder convention) | (per its own target convention) |

### 6.3 Swap, commit, PR

```bash
git checkout -b chore/distribution-placeholder-swap

# Edit each draft with your preferred editor, or use sed for mechanical swaps.
# Example for the Reddit draft:
sed -i 's|\[SCREENSHOT-1: [^]]*\]|![Bonfire desktop](https://raw.githubusercontent.com/BonfireAI/candyfactory-cosmic/main/assets/screenshots/bonfire-desktop.png)|g' \
    docs/distribution/r-pop-os-post.md

# (Repeat for SCREENSHOT-2 / -3 with parlor-desktop.png and cosmic-term-ansi.png.)

git add docs/distribution/
git status
```

**Expected status:** only the three distribution-draft files modified, nothing else.

```bash
git commit -m "chore(distribution): swap screenshot placeholders for actual refs

Pairs with PRs <cosmic PR#>, <www PR#>."

git push -u origin chore/distribution-placeholder-swap

gh pr create --repo BonfireAI/candyfactory-cosmic --base main \
  --head chore/distribution-placeholder-swap \
  --title "chore(distribution): swap screenshot placeholders for actual refs" \
  --body "Swaps the [SCREENSHOT-N: ...] markers in the three distribution drafts for live raw.githubusercontent.com URLs (PR <cosmic PR#>) and (where applicable) the candyfactory.ai mirror (PR <www PR#>). Drafts are now submission-ready."
```

Self-review, merge as before.

After this PR merges, all three drafts are submission-ready. BON-1237 can move to **Done**.

---

## Notes

- This runbook is generated procedure, not brand surface. Voice is neutral and practical, not parlor-toned.
- If any phase fails or is ambiguous, do NOT improvise — document the failure and surface to Ishtar for a re-plan pass.
- Snapshot tag `pre-v1-polish-2026-05-22` is on `main` — rollback safety if anything goes sideways:
  ```bash
  git -C /home/ishtar/Projects/candyfactory-cosmic checkout pre-v1-polish-2026-05-22
  ```
- The capture step (Phase 2) stays Anta's job — his machine, his eyes, his final composition call. Everything else is mechanical and can be re-run.

*(End of runbook.)*
