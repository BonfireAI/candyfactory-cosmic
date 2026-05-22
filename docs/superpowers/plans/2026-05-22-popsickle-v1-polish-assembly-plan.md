# PopSickle v1-Polish Assembly Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Land three independent v1-polish slices into `BonfireAI/candyfactory-cosmic` main as three PRs — accent palette files (Slice B), four channel distribution drafts (Slice A), screenshot capture-and-mirror runbook (Slice C) — using Bonfire-discipline parallel cadre dispatch.

**Architecture:** Single orchestrator (Ishtar, main thread) compiles intent into structured cadre dispatches. Five parallel read-only Scouts in Wave 1 produce inputs for three parallel implementers in Wave 2 (B-Warrior, A-Bard, C-Bard — each in its own worktree). Wave 3 parallel Sage reviews (B + A-spec + A-voice + C). Wave 4 Wizard gate per slice. Wave 5 push + PR + merge per slice, then handoff. Spec doc rides on `feat/accent-palettes` (Slice B) — branch renamed from `docs/v1-polish-spec` at Wave 0.

**Tech Stack:** RON (theme files), bash (install.sh), markdown (drafts + runbook), git worktrees, GitHub PRs, Linear MCP, Claude Code Agent SDK for cadre dispatches.

**Spec:** `docs/superpowers/specs/2026-05-22-popsickle-v1-polish-assembly-design.md` — read end-to-end before executing this plan.

---

## File Structure

Files produced by this plan, organized by slice:

**Slice B (branch `feat/accent-palettes` — formerly `docs/v1-polish-spec`):**
- Create: `themes/candyfactory-accent-palette-dark`
- Create: `themes/candyfactory-accent-palette-light`
- Modify: `install.sh` (add the two new install targets + their --dry-run + --uninstall paths)
- Create: `tests/test_accent_palettes.sh` (Knight test contract per spec §2 — bash since this repo has no Python infrastructure)
- Already-present (from this plan's spec commit): `docs/superpowers/specs/2026-05-22-popsickle-v1-polish-assembly-design.md`

**Slice A (branch `feat/distribution-drafts`):**
- Create: `docs/distribution/cosmic-themes-org-listing.md`
- Create: `docs/distribution/themes-ron-pr-body.md`
- Create: `docs/distribution/awesome-cosmic-pr-body.md`
- Create: `docs/distribution/r-pop-os-post.md`

**Slice C (branch `feat/screenshot-runbook`):**
- Create: `docs/runbooks/v1-screenshots.md`

**Already-present (this plan itself):**
- Create: `docs/superpowers/plans/2026-05-22-popsickle-v1-polish-assembly-plan.md` (commits at Wave 0 task 1)

---

## Wave 0 — Pre-flight (main thread)

### Task 1: Commit this plan, snapshot tag, rename spec branch, Linear status sync

**Files:**
- Commit: `docs/superpowers/plans/2026-05-22-popsickle-v1-polish-assembly-plan.md` (this file)
- Branch rename: `docs/v1-polish-spec` → `feat/accent-palettes`
- Linear: BON-1236 + BON-1237 → In Progress; BON-1235 stays Todo

- [ ] **Step 1: Stage and commit this plan onto current `docs/v1-polish-spec` branch**

```bash
git -C /home/ishtar/Projects/candyfactory-cosmic add docs/superpowers/plans/2026-05-22-popsickle-v1-polish-assembly-plan.md
git -C /home/ishtar/Projects/candyfactory-cosmic commit -m "docs(plan): PopSickle v1-polish assembly — 19-task implementation plan

Cadre-dispatch plan executing the design doc at
docs/superpowers/specs/2026-05-22-popsickle-v1-polish-assembly-design.md.
Six waves: pre-flight, parallel Scouts, parallel implementers in worktrees,
parallel Sages, Wizard gate per slice, merge + handoff."
```
Expected: commit succeeds; HEAD advances on `docs/v1-polish-spec`.

- [ ] **Step 2: Snapshot tag main before any feature-branch ships**

```bash
git -C /home/ishtar/Projects/candyfactory-cosmic tag pre-v1-polish-2026-05-22 main
git -C /home/ishtar/Projects/candyfactory-cosmic show-ref --tags | grep pre-v1-polish
```
Expected: tag pointing to current `main` (`1bed554`).

- [ ] **Step 3: Rename `docs/v1-polish-spec` → `feat/accent-palettes`**

```bash
git -C /home/ishtar/Projects/candyfactory-cosmic branch -m docs/v1-polish-spec feat/accent-palettes
git -C /home/ishtar/Projects/candyfactory-cosmic branch --show-current
```
Expected: output is `feat/accent-palettes`. Spec commit + plan commit both ride on this branch.

- [ ] **Step 4: Update BON-1236 to In Progress via Linear MCP**

Dispatch:
```
mcp__claude_ai_Linear__save_issue with:
  id: "BON-1236"
  status: "In Progress"
```
Expected: ticket status reflects In Progress.

- [ ] **Step 5: Update BON-1237 to In Progress via Linear MCP**

Dispatch:
```
mcp__claude_ai_Linear__save_issue with:
  id: "BON-1237"
  status: "In Progress"
```
Expected: ticket status reflects In Progress. BON-1235 stays Todo.

- [ ] **Step 6: Sanity check — git state + Linear state**

```bash
git -C /home/ishtar/Projects/candyfactory-cosmic log --oneline -3 --all --decorate
```
Expected: two commits on `feat/accent-palettes` (spec + plan), main at 1bed554 with tag `pre-v1-polish-2026-05-22`.

---

## Wave 1 — Parallel read-only Scouts (single message, ≤5 in flight)

### Task 2: Dispatch all five Scouts in one message

**Files:** none modified. All Scouts return findings to /tmp/v1-polish-brief/.

- [ ] **Step 1: Pre-create the brief directory**

```bash
mkdir -p /tmp/v1-polish-brief
ls -la /tmp/v1-polish-brief
```
Expected: empty directory exists.

- [ ] **Step 2: Dispatch all five Scouts as parallel Agent calls in a single message**

Use `Agent` tool five times in one assistant message (parallel execution). Each Scout = `subagent_type: "Explore"` (read-only, no Edit/Write). All must save findings to a named file under `/tmp/v1-polish-brief/`.

**Scout-1 prompt (cosmic-themes.org submission requirements):**
```
You are Scout-1 for the PopSickle v1-polish assembly. Read-only mission.

Mission: Discover cosmic-themes.org's theme submission requirements. We are
preparing to submit "CandyFactory · Cotton Candy Parlor for COSMIC" — a free
Pop!_OS 24.04 COSMIC theme kit (BonfireAI/candyfactory-cosmic, MIT, public).

Tasks (use WebFetch and WebSearch):
1. Find the cosmic-themes.org submission entry point (URL).
2. List the required fields for a theme submission (title, description,
   screenshots, license, repo URL, tags, etc.).
3. Note any screenshot format requirements (resolution, aspect, count, file
   format).
4. Note any review/moderation SLA mentioned on the site.
5. Note any do/don't rules for submissions (banned content, formatting rules,
   text length limits).
6. Find 2-3 recently-listed themes (read their listing pages) as voice/format
   reference.

Output: write findings to `/tmp/v1-polish-brief/scout-1-cosmic-themes-org.md`.
Structure: ## Submission URL · ## Required Fields · ## Screenshot Requirements
· ## Review SLA · ## Do/Don't Rules · ## Reference Listings.

DO NOT write any file outside /tmp/v1-polish-brief/. DO NOT modify any
candyfactory-cosmic file.
```

**Scout-2 prompt (cosmic-utils/cosmic-project-collection themes.ron):**
```
You are Scout-2 for the PopSickle v1-polish assembly. Read-only mission.

Mission: Understand the `themes.ron` format and PR conventions for the
`cosmic-utils/cosmic-project-collection` GitHub repo. We will be submitting
a PR adding three themes (candyfactory-bonfire-dark, candyfactory-parlor-light,
candyfactory-term-bonfire).

Tasks (use Bash with gh, WebFetch on github.com URLs as needed):
1. Browse https://github.com/cosmic-utils/cosmic-project-collection — find
   the themes.ron file or equivalent. Capture its exact current format.
2. Find 3-5 most recently merged PRs that added themes. Capture the PR body
   patterns the maintainer accepts.
3. Note any CONTRIBUTING.md or PR template requirements.
4. Capture the maintainer's accepted/rejected ratio if visible from the PR list.
5. Note the license expectations (MIT is ours — is it acceptable?).
6. Confirm the registry IS what cosmic-tweaks reads (per our spike
   2026-05-20).

Output: write findings to `/tmp/v1-polish-brief/scout-2-themes-ron.md`.
Structure: ## Repo URL · ## themes.ron Current Format (with verbatim
snippet) · ## Recent PR Patterns · ## CONTRIBUTING Requirements · ## License
Acceptance · ## cosmic-tweaks Registry Confirmation.

DO NOT modify any candyfactory-cosmic file.
```

**Scout-3 prompt (Department-stack/awesome-cosmic):**
```
You are Scout-3 for the PopSickle v1-polish assembly. Read-only mission.

Mission: Understand the `Department-stack/awesome-cosmic` README structure and
PR conventions. We will be submitting a PR adding our theme to the appropriate
section.

Tasks (use Bash with gh, WebFetch on github.com URLs as needed):
1. Browse https://github.com/Department-stack/awesome-cosmic — find the README
   sections (themes, applications, etc.).
2. Find the section themes go in. Capture the exact row format (Markdown
   table row format, link format, description length).
3. Find 3-5 most recent merged PRs adding themes. Capture the PR body
   patterns.
4. Note CONTRIBUTING.md or PR template requirements.
5. Find the alphabetization/ordering convention if any.

Output: write findings to `/tmp/v1-polish-brief/scout-3-awesome-cosmic.md`.
Structure: ## Repo URL · ## README Section for Themes · ## Row Format · ##
Recent PR Patterns · ## CONTRIBUTING Requirements · ## Ordering Convention.

DO NOT modify any candyfactory-cosmic file.
```

**Scout-4 prompt (r/pop_os theme-share conventions):**
```
You are Scout-4 for the PopSickle v1-polish assembly. Read-only mission.

Mission: Understand r/pop_os subreddit conventions for theme-share posts. We
will be posting "Cotton Candy Parlor for COSMIC" with screenshots + GitHub
link + install one-liner.

Tasks (use WebFetch on reddit.com URLs):
1. Browse https://reddit.com/r/pop_os — find the subreddit rules.
2. Find the available flairs and which is right for a theme-share post.
3. Find 5-10 recent successful theme/customization posts (high upvote, lots
   of comments). Capture:
   - Title patterns (length, format, do they use brackets/prefixes?)
   - Body patterns (lede, screenshot placement, install instructions, links,
     question-prompting close)
   - Posting time clues (any obvious "best time" patterns)
4. Note any banned post patterns from rules or recent removals if visible.

Output: write findings to `/tmp/v1-polish-brief/scout-4-r-pop-os.md`.
Structure: ## Subreddit Rules · ## Flairs · ## Title Patterns · ## Body
Patterns · ## Posting Time Guidance · ## Banned Patterns · ## Reference Posts
(URLs + 1-line each).

DO NOT modify any candyfactory-cosmic file.
```

**Scout-5 prompt (canon voice prescription for cosmic surface):**
```
You are Scout-5 for the PopSickle v1-polish assembly. Read-only mission.

Mission: Produce a voice prescription for the four distribution drafts (Slice
A). The drafts are: cosmic-themes.org listing, themes.ron PR body, awesome-
cosmic PR body, r/pop_os post.

Tasks:
1. Read the candyfactory-cosmic CLAUDE.md sections that touch voice/brand
   (the "Brand is binding" line, §3 colors, README rewrites guidance). Path:
   `/home/ishtar/Projects/candyfactory-cosmic/CLAUDE.md`.
2. Read the existing `/home/ishtar/Projects/candyfactory-cosmic/README.md` —
   what's its register? Capture concrete cadence patterns.
3. Read the candyfactory-cosmic hub HTML (`Cotton Candy Parlor for COSMIC.html`)
   for the surface voice already shipped.
4. Read `/home/ishtar/Projects/candyfactory-canon/04-voice/` files for the
   canon banlist + MUST-USE/MUST-NOT-USE lists. If that path doesn't exist,
   look under `/home/ishtar/Projects/candyfactory-canon/` for the voice rules.
5. Read the most recent blog-ship voice prescription if it exists:
   `/tmp/bard-brief/voice-prescription.md`. If gone, skip.
6. Synthesize a SINGLE PAGE voice prescription specifically for the four
   distribution drafts:
   - MUST-USE register notes
   - MUST-NOT-USE banlist (concrete words/phrases)
   - Cadence rules (sentence length, em-dash density, paragraph length)
   - Channel-specific overrides: r/pop_os is more casual than the
     awesome-cosmic PR; cosmic-themes.org listing is more "product
     description" voice; themes.ron PR body is dry/factual

Output: write the voice prescription to
`/tmp/v1-polish-brief/scout-5-voice-prescription.md`.
Structure: ## Register · ## MUST-USE · ## MUST-NOT-USE (banlist) · ## Cadence
Rules · ## Per-Channel Overrides (4 channels).

DO NOT modify any candyfactory-cosmic file. DO NOT modify any canon file.
```

- [ ] **Step 3: Wait for all five Scouts to complete; verify outputs exist**

```bash
ls -la /tmp/v1-polish-brief/
```
Expected: five files present.
- scout-1-cosmic-themes-org.md
- scout-2-themes-ron.md
- scout-3-awesome-cosmic.md
- scout-4-r-pop-os.md
- scout-5-voice-prescription.md

If any Scout returned an error or empty output, re-dispatch only that Scout (do not re-dispatch the four that succeeded) before proceeding to Wave 2.

- [ ] **Step 4: Quick review pass — read each Scout's headline findings**

For each of the five files, read the first 30 lines using the Read tool. Confirm:
- Scout-1: submission URL is named.
- Scout-2: themes.ron format snippet is captured.
- Scout-3: awesome-cosmic row format is captured.
- Scout-4: at least 3 reference posts are listed.
- Scout-5: register + banlist + per-channel overrides all present.

If any are thin or missing, dispatch a single targeted clarification Scout for the missing piece before Wave 2.

---

## Wave 2 — Parallel implementers in worktrees (single message, 3 in flight)

### Task 3: Create three worktrees off `feat/accent-palettes`

**Files:** none modified. Worktrees created at:
- `/tmp/wt-cosmic-palettes` (on `feat/accent-palettes` — carries spec + plan + about to carry Slice B work)
- `/tmp/wt-cosmic-distribution` (on new branch `feat/distribution-drafts` from main)
- `/tmp/wt-cosmic-runbook` (on new branch `feat/screenshot-runbook` from main)

- [ ] **Step 1: Create palettes worktree**

```bash
git -C /home/ishtar/Projects/candyfactory-cosmic worktree add /tmp/wt-cosmic-palettes feat/accent-palettes
ls /tmp/wt-cosmic-palettes/docs/superpowers/specs/
```
Expected: worktree created, spec file visible.

- [ ] **Step 2: Create distribution worktree**

```bash
git -C /home/ishtar/Projects/candyfactory-cosmic worktree add -b feat/distribution-drafts /tmp/wt-cosmic-distribution main
ls /tmp/wt-cosmic-distribution
```
Expected: worktree created, branch is `feat/distribution-drafts` based on main.

- [ ] **Step 3: Create runbook worktree**

```bash
git -C /home/ishtar/Projects/candyfactory-cosmic worktree add -b feat/screenshot-runbook /tmp/wt-cosmic-runbook main
ls /tmp/wt-cosmic-runbook
```
Expected: worktree created, branch is `feat/screenshot-runbook` based on main.

- [ ] **Step 4: Verify worktree list**

```bash
git -C /home/ishtar/Projects/candyfactory-cosmic worktree list
```
Expected: four entries — main checkout + three /tmp worktrees.

### Task 4: Dispatch B-Warrior, A-Bard, C-Bard in a single message

**Files:** each implementer modifies/creates files in its own worktree.

- [ ] **Step 1: Read parlor-light.ron to confirm sky has no override (Anta-blocker pre-check)**

```bash
grep -in "sky\|brand-c\|brand_c\|5fb8ff" /tmp/wt-cosmic-palettes/themes/candyfactory-parlor-light.ron
```
Expected: zero or no semantic-role hits for sky (sky may appear only in the palette as `accent_blue` or similar, not as a top-level override).

If sky DOES have an override (unexpected), proceed to Step 2 without the Anta-blocker. If sky does NOT have an override, surface to Anta BEFORE Step 2 — single question: *"For the light accent palette's sky slot, use base `#5fb8ff` (sticks with §3) or canonize a deepened sky at this point?"* Then proceed.

- [ ] **Step 2: Dispatch all three implementers as parallel Agent calls in a single message**

Use `Agent` tool three times in one assistant message. Each implementer = `subagent_type: "general-purpose"` with Write + Edit + Bash access scoped to its worktree.

**B-Warrior prompt (mechanical palette generation + Knight tests + install.sh patch):**
```
You are B-Warrior for the PopSickle v1-polish assembly Slice B. Mechanical
generation task — no voice, no opinion, just exact data per spec.

Working directory: /tmp/wt-cosmic-palettes
Branch: feat/accent-palettes

Inputs to read FIRST:
- /tmp/wt-cosmic-palettes/docs/superpowers/specs/2026-05-22-popsickle-v1-polish-assembly-design.md
  → §2 Slice B (deliverables, sourcing rules, test contract)
- /tmp/wt-cosmic-palettes/CLAUDE.md
  → §3 canonical color table, §6 Step 2 verbatim block
- /tmp/wt-cosmic-palettes/themes/candyfactory-parlor-light.ron
  → light palette deepened values
- /tmp/wt-cosmic-palettes/install.sh
  → existing install pattern; you patch it

ANTA-BLOCKER (already resolved by orchestrator before your dispatch): the
"sky" slot for the light palette uses value: <ORCHESTRATOR FILLS IN: either
`(red: 0.372549, green: 0.721569, blue: 1.0, alpha: 1.0)` from §3 base, OR
a new deepened sky Anta canonized>. Use that value verbatim.

Deliverables (in /tmp/wt-cosmic-palettes):

1. CREATE `themes/candyfactory-accent-palette-dark` — RON Srgba list per
   CLAUDE.md §6 Step 2 verbatim block, six entries in order
   (pink, cherry, mint, butter, grape, sky), 4-tuple (red, green, blue,
   alpha: 1.0), trailing comma on every line, opening `[` and closing `]`.

2. CREATE `themes/candyfactory-accent-palette-light` — same shape, six
   entries in same order, values sourced as:
   - pink ← `window_hint` value from parlor-light.ron
   - cherry ← `destructive` value from parlor-light.ron
   - mint ← `success` value from parlor-light.ron
   - butter ← `warning` value from parlor-light.ron
   - grape ← `accent` value from parlor-light.ron
   - sky ← <value from Anta-blocker resolution above>

3. MODIFY `install.sh` — add the two new files to the install list. Follow
   the existing pattern (study the three .ron entries already there). Cover:
   - `--dry-run` shows the two new destination paths
   - default install copies the two new files
   - `--uninstall` removes them

4. CREATE `tests/test_accent_palettes.sh` — bash Knight tests per spec §2
   "Test contract (Knight)". Repo has no Python infrastructure; bash is
   native.

   Required test functions (each a shell function returning 0 on pass,
   non-zero on fail; main body calls each and tallies; exits non-zero on
   any failure):
   - test_dark_palette_parses_as_ron (matches the bracket-list shape +
     six `(red:` lines)
   - test_dark_palette_exactly_six_entries_in_canonical_order (six entries,
     in order pink/cherry/mint/butter/grape/sky — verify by comment markers
     OR by exact-match against expected RGB tuples)
   - test_dark_palette_matches_claude_md_section_6_step_2_verbatim
     (use `diff` against a heredoc'd reference snippet inside the test)
   - test_light_palette_parses_as_ron
   - test_light_palette_exactly_six_entries_in_canonical_order
   - test_light_palette_pink_matches_parlor_light_window_hint
     (grep `window_hint` line from parlor-light.ron, extract tuple, compare
     with palette entry 1)
   - test_light_palette_cherry_matches_parlor_light_destructive
   - test_light_palette_mint_matches_parlor_light_success
   - test_light_palette_butter_matches_parlor_light_warning
   - test_light_palette_grape_matches_parlor_light_accent
   - test_light_palette_sky_matches_resolved_value (compare entry 6 against
     the value the orchestrator filled into the prompt above)
   - test_install_sh_dry_run_shows_both_new_paths (run
     `bash install.sh --dry-run` in a temp HOME, grep for both new
     destination paths)
   - test_install_sh_uninstall_removes_both_new_paths_when_present
     (touch both files in temp HOME, run `bash install.sh --uninstall`,
     assert both gone)
   - test_install_sh_uninstall_is_noop_when_absent (run
     `bash install.sh --uninstall` against empty temp HOME, assert exit 0)

   Use `set -euo pipefail` + a `fail()` helper + a counter. Use
   `mktemp -d` for the temp HOME. RESTORE `$HOME` cleanly on exit (trap).

   File header `#!/usr/bin/env bash` + `chmod +x` it.

5. Run the tests: `bash /tmp/wt-cosmic-palettes/tests/test_accent_palettes.sh`
   All 14 MUST pass. If any fail, fix until they pass. The script must
   print one line per test: `PASS test_name` or `FAIL test_name (reason)`,
   and a final summary line.

6. Commit your work to the `feat/accent-palettes` branch:
   ```
   git -C /tmp/wt-cosmic-palettes add themes/candyfactory-accent-palette-dark themes/candyfactory-accent-palette-light install.sh tests/test_accent_palettes.sh
   git -C /tmp/wt-cosmic-palettes commit -m "feat(palettes): add accent_palette_{dark,light} per CLAUDE.md §6 Step 2

   Six-entry Srgba lists in canonical order (pink, cherry, mint, butter,
   grape, sky). Dark sources values verbatim from CLAUDE.md §6 Step 2 block;
   light sources from parlor-light.ron overrides. Sky-light resolved to
   <value> per Anta call.

   install.sh patched to cover both new files in default install, --dry-run,
   and --uninstall paths. Knight tests in tests/test_accent_palettes.py
   assert exact-match against canonical sources.

   Closes BON-1236."
   ```

7. Report back: which tests passed, which files you created, commit SHA,
   any deviations from spec.

DO NOT push. DO NOT open a PR. DO NOT touch any file outside
/tmp/wt-cosmic-palettes. DO NOT modify the spec or plan files.

Use `git -C /tmp/wt-cosmic-palettes <command>` for ALL git operations — NEVER
`cd && git`. (Permission-class hit otherwise — see
feedback_subagent_git_must_use_dash_c_2026_05_22.)
```

**A-Bard prompt (four distribution drafts with placeholders):**
```
You are A-Bard for the PopSickle v1-polish assembly Slice A. Voice-gated
drafting task. Four parallel deliverables, one branch.

Working directory: /tmp/wt-cosmic-distribution
Branch: feat/distribution-drafts

Inputs to read FIRST:
- /home/ishtar/Projects/candyfactory-cosmic/docs/superpowers/specs/2026-05-22-popsickle-v1-polish-assembly-design.md
  → §3 Slice A (deliverables, placeholder convention)
  → §10 risk register (re: format changes since spike)
- /tmp/v1-polish-brief/scout-1-cosmic-themes-org.md
  → cosmic-themes.org submission format
- /tmp/v1-polish-brief/scout-2-themes-ron.md
  → themes.ron format + PR conventions
- /tmp/v1-polish-brief/scout-3-awesome-cosmic.md
  → awesome-cosmic row format
- /tmp/v1-polish-brief/scout-4-r-pop-os.md
  → r/pop_os post conventions
- /tmp/v1-polish-brief/scout-5-voice-prescription.md
  → REGISTER + BANLIST + per-channel overrides — BINDING
- /home/ishtar/Projects/candyfactory-cosmic/CLAUDE.md
  → §1 (mission), §3 (colors), §7 (out of scope)
- /home/ishtar/Projects/candyfactory-cosmic/README.md
  → existing voice reference

Placeholder convention (BINDING — use these EXACTLY):
- [SCREENSHOT-1: Bonfire desktop with grape window-hint visible]
- [SCREENSHOT-2: Parlor desktop with grape accent + deepened pink window-hint]
- [SCREENSHOT-3: cosmic-term ANSI palette over `ls -la`]

Deliverables (in /tmp/wt-cosmic-distribution):

1. CREATE `docs/distribution/cosmic-themes-org-listing.md` — full submission
   copy following Scout-1's format requirements. Include all required fields
   from Scout-1. Drop the three SCREENSHOT placeholders inline where shots
   belong. Lede: ≤2 sentences hooking the candy aesthetic. Description:
   3-5 short paragraphs. Install: one-liner per CLAUDE.md §6 Step 3 (clone
   + ./install.sh). License: MIT. Repo URL:
   https://github.com/BonfireAI/candyfactory-cosmic.
   END of file: a `### Submission notes` section listing fields Anta needs
   to manually resolve at submission time (any TODOs surfaced by Scout-1
   that you can't pre-fill from this repo's metadata).

2. CREATE `docs/distribution/themes-ron-pr-body.md` — PR body for
   cosmic-utils/cosmic-project-collection adding our three themes. Follow
   Scout-2's PR convention exactly. Include:
   - `## Summary` (3-bullet what this adds)
   - `## What changed` (the verbatim ron-snippet diff to themes.ron — three
     entries, exact format Scout-2 captured)
   - `## Why now` (1 paragraph — connects to the cosmic-tweaks registry
     mechanism per our spike)
   - `## License` (MIT, link to repo LICENSE)
   - `## Test plan` (checkbox list: cosmic-tweaks "Available" tab shows our
     theme after registry update; install via cosmic-tweaks works; theme
     loads correctly)
   - `## Linear` (BON-1237 link)
   NO screenshots in this draft — themes.ron PRs don't typically include
   screenshots. NO placeholders needed.

3. CREATE `docs/distribution/awesome-cosmic-pr-body.md` — PR body for
   Department-stack/awesome-cosmic. Follow Scout-3's convention. Include:
   - `## Summary` (1 sentence)
   - `## Changes` (verbatim Markdown row in the format Scout-3 captured)
   - `## Why include` (1 paragraph — what's distinctive about this theme)
   - `## License` (MIT)
   - `## Linear` (BON-1237 link)
   NO screenshots. NO placeholders needed.

4. CREATE `docs/distribution/r-pop-os-post.md` — full reddit post in the
   format Scout-4 captured. Include:
   - `## Suggested title` (single line — follow title patterns from Scout-4)
   - `## Suggested flair` (per Scout-4)
   - `## Posting time` (per Scout-4)
   - `## Body` (the actual post body):
     - Lede paragraph (≤3 sentences, hook the candy aesthetic)
     - [SCREENSHOT-1: Bonfire desktop with grape window-hint visible]
     - 1-paragraph what-it-is
     - [SCREENSHOT-2: Parlor desktop with grape accent + deepened pink window-hint]
     - 1-paragraph install instructions (link to repo + ./install.sh one-liner)
     - [SCREENSHOT-3: cosmic-term ANSI palette over `ls -la`]
     - 1-paragraph what's-next + invitation to feedback
     - End: GitHub link + MIT note
   - `## Submission notes` (any TODOs Anta needs at posting time per
     Scout-4's findings)

Voice constraints (BINDING — Scout-5's prescription wins on any conflict
with these examples):
- Use the parlor cadence — short paragraphs, occasional em-dash, no
  marketing-shape claims like "industry-leading" or "revolutionary"
- NO ban-listed phrases per Scout-5
- NO "AI brochure" register
- NO money/pricing/monetization language (per feedback_money_is_not_claude_codes_business)
- Cosmic-themes.org listing = product-description register
- themes.ron PR body = dry/factual register
- awesome-cosmic PR body = same
- r/pop_os post = more casual but still on-brand

5. Commit your work to the `feat/distribution-drafts` branch:
   ```
   git -C /tmp/wt-cosmic-distribution add docs/distribution/
   git -C /tmp/wt-cosmic-distribution commit -m "feat(distribution): draft-parked submissions for four COSMIC channels

   Four draft files under docs/distribution/ ready for Anta to submit:
   - cosmic-themes.org listing (with screenshot placeholders)
   - cosmic-utils/cosmic-project-collection themes.ron PR body
   - Department-stack/awesome-cosmic PR body
   - r/pop_os post (with screenshot placeholders)

   Two channels (cosmic-themes.org, r/pop_os) use [SCREENSHOT-N: ...]
   placeholders per spec §3 — they ship once BON-1235 screenshots land. Two
   channels (themes.ron PR, awesome-cosmic PR) are submission-ready now.

   Per Scout-1/2/3/4 platform research + Scout-5 voice prescription. Tracks
   BON-1237 (stays In Review on merge — gated on screenshot capture)."
   ```

6. Report back: which files you created, commit SHA, any places where
   Scout outputs were thin and you had to make a judgment call.

DO NOT push. DO NOT open a PR. DO NOT modify the spec/plan. DO NOT modify
files outside /tmp/wt-cosmic-distribution.

Use `git -C /tmp/wt-cosmic-distribution <command>` for ALL git ops.
```

**C-Bard prompt (screenshot capture-and-mirror runbook):**
```
You are C-Bard for the PopSickle v1-polish assembly Slice C. Documentation
task — clarity + spec compliance over voice flair.

Working directory: /tmp/wt-cosmic-runbook
Branch: feat/screenshot-runbook

Inputs to read FIRST:
- /home/ishtar/Projects/candyfactory-cosmic/docs/superpowers/specs/2026-05-22-popsickle-v1-polish-assembly-design.md
  → §4 Slice C (six-phase structure required)
  → §8 out-of-scope (especially: do NOT run mirror phase while website lane busy)
- /tmp/v1-polish-brief/scout-3-awesome-cosmic.md (background context)
- /tmp/v1-polish-brief/scout-4-r-pop-os.md (background context)
- /home/ishtar/Projects/candyfactory-cosmic/CLAUDE.md
  → §6 Step 3-5 (install + apply + sanity-check procedure)
- /home/ishtar/Projects/candyfactory-cosmic/install.sh
  → confirm --dry-run + --uninstall flags work as documented in spec

Deliverable (in /tmp/wt-cosmic-runbook):

CREATE `docs/runbooks/v1-screenshots.md` — runbook for Anta to execute on
his Pop!_OS 24.04 COSMIC desktop. Six numbered phases per spec §4:

# v1 Screenshots Runbook
*Capture-and-mirror procedure for the CandyFactory · Cotton Candy Parlor v1.*

## Phase 1 — Pre-capture (machine prep)
[Step-by-step. Each command shown. Expected output noted. Reference CLAUDE.md
§6 Step 3-4 for install + apply, but inline the commands here so the runbook
is self-contained.]

Include:
- Verify clean state: `ls ~/.config/cosmic/com.system76.CosmicTheme.{Dark,Light}/v1/` (note pre-existing customizations Anta wants to back up).
- `git -C /home/ishtar/Projects/candyfactory-cosmic pull origin main`
- `./install.sh --dry-run` (preview)
- `./install.sh` (install)
- Log out / log back in (cosmic-comp picks up themes on session restart)
- `cosmic-settings` → Appearance → verify Bonfire (dark) and Parlor (light)
  both appear
- cosmic-term → verify candyfactory-term-bonfire scheme is selectable

## Phase 2 — Capture (3 shots, 1920×1080)
[Each shot: composition checklist + capture command.]

Include all three shots per BON-1235:
- Shot 1: Bonfire (dark) desktop — panel + dock + focused libcosmic window
  (grape window-hint visible) + unfocused window + accent picker visible.
  Suggested capture tool (whichever Anta has — flameshot, gnome-screenshot,
  cosmic-screenshot if it exists). Filename: bonfire-desktop.png
- Shot 2: Parlor (light) desktop — same composition, grape accent +
  deepened pink window-hint. Filename: parlor-desktop.png
- Shot 3: cosmic-term in Bonfire — `ls -la` or `tldr ls` to show ANSI
  palette. Filename: cosmic-term-ansi.png

## Phase 3 — Post-process
[Naming + optimization + size budget.]

Include:
- Filename convention (above)
- Optional: `pngcrush -reduce <in.png> <out.png>` for size reduction
- Size budget: ≤ 800 KB each (state how to check: `du -h *.png`)

## Phase 4 — Commit to cosmic repo (canonical)
[Exact git commands.]

Include:
- `git -C /home/ishtar/Projects/candyfactory-cosmic checkout -b feat/v1-screenshots main`
- `mkdir -p /home/ishtar/Projects/candyfactory-cosmic/assets/screenshots`
- `cp <shot files> /home/ishtar/Projects/candyfactory-cosmic/assets/screenshots/`
- `git -C /home/ishtar/Projects/candyfactory-cosmic add assets/screenshots/`
- Commit message template (referencing BON-1235)
- `git -C /home/ishtar/Projects/candyfactory-cosmic push -u origin feat/v1-screenshots`
- `gh pr create` with body template (title without ticket ID per
  feedback_no_naked_linear_ids; body references BON-1235 and uses "Closes
  BON-1235" footer)

## Phase 5 — Mirror to www repo (LATER, when website lane clears)
[Make EXPLICIT that this phase does NOT run while another session owns
candyfactory-www.]

Open with a callout:
> **HALT IF**: someone else is actively working in `candyfactory-www`.
> Coordinate first. If the lane is yours, proceed.

Include:
- `git -C /home/ishtar/Projects/candyfactory-www status` (must be clean)
- `git -C /home/ishtar/Projects/candyfactory-www checkout -b feat/cosmic-screenshots-v1 main`
- `mkdir -p /home/ishtar/Projects/candyfactory-www/cosmic/assets/screenshots`
- `cp` shots from cosmic repo's assets/screenshots into the www mirror path
- Update `candyfactory-www/cosmic/index.html` to point image refs at the
  local copies (search/replace pattern: any external screenshot URLs become
  `./assets/screenshots/<filename>.png`)
- Commit + push + PR with body referencing the cosmic-repo PR from Phase 4

## Phase 6 — Swap placeholders in distribution drafts
[After both PRs merge, drafts become submission-ready.]

Include:
- `cd /home/ishtar/Projects/candyfactory-cosmic`
- For each of the four `docs/distribution/*.md` files: open, find any
  `[SCREENSHOT-N: ...]` markers, replace with the canonical reference
  (either a relative path `./assets/screenshots/bonfire-desktop.png` or a
  GitHub raw URL — pick the one each platform actually accepts; reference
  Scout-1 and Scout-4 outputs for guidance)
- Commit on a new branch `chore/distribution-placeholder-swap` and PR

## Notes
- This runbook is generated procedure, not brand surface. Voice is
  neutral/practical.
- If any phase fails, do NOT improvise — document the failure and surface
  to Ishtar for a re-plan pass.

(End of runbook.)

Commit your work to the `feat/screenshot-runbook` branch:
```
git -C /tmp/wt-cosmic-runbook add docs/runbooks/
git -C /tmp/wt-cosmic-runbook commit -m "feat(runbook): v1 screenshot capture-and-mirror procedure

Six-phase runbook in docs/runbooks/v1-screenshots.md covering pre-capture
machine prep, three-shot capture, post-process, canonical commit to
candyfactory-cosmic, dual-repo mirror to candyfactory-www (with explicit
lane-collision halt), and placeholder swap in the four distribution drafts.

Enables BON-1235 (capture stays Anta's job); ticket stays Todo until shoot."
```

Report back: file created, commit SHA, any phases where the spec was
ambiguous and you made a judgment call.

DO NOT push. DO NOT open a PR. DO NOT touch any file outside
/tmp/wt-cosmic-runbook. DO NOT modify the spec/plan.

Use `git -C /tmp/wt-cosmic-runbook <command>` for ALL git ops.
```

- [ ] **Step 3: Wait for all three implementers to complete; verify worktrees**

```bash
git -C /tmp/wt-cosmic-palettes log --oneline -3
git -C /tmp/wt-cosmic-distribution log --oneline -3
git -C /tmp/wt-cosmic-runbook log --oneline -3
```
Expected: each worktree has its implementer's commit on top of main.

- [ ] **Step 4: Read each implementer's report-back**

For each implementer: confirm reported commit SHA matches git log, confirm reported files exist, note any judgment-call deviations for Sage review.

If any implementer FAILED (tests didn't pass, commit didn't land), re-dispatch only that implementer with the failure context. Do NOT proceed to Wave 3 until all three have green commits.

---

## Wave 3 — Parallel Sage reviews (single message, up to 4 in flight)

### Task 5: Dispatch four Sages in parallel

**Files:** none modified. Sages write verdicts to `/tmp/v1-polish-brief/sage-*-verdict.md`.

- [ ] **Step 1: Dispatch B-Sage + A-Sage(spec) + A-Sage(voice) + C-Sage as parallel Agent calls in a single message**

Use `Agent` tool four times in one assistant message.

**B-Sage prompt (palette correctness + Knight tests):**
```
You are B-Sage for PopSickle v1-polish Slice B. Spec-compliance review only
(no voice — Slice B is mechanical).

Working directory: /tmp/wt-cosmic-palettes (read + run tests)
Branch: feat/accent-palettes

Inputs:
- Spec: /tmp/wt-cosmic-palettes/docs/superpowers/specs/2026-05-22-popsickle-v1-polish-assembly-design.md §2
- CLAUDE.md §3 + §6 Step 2: /tmp/wt-cosmic-palettes/CLAUDE.md
- parlor-light.ron: /tmp/wt-cosmic-palettes/themes/candyfactory-parlor-light.ron
- Anta's sky resolution: <ORCHESTRATOR FILLS IN>

Review checklist (each = PASS/FAIL with evidence):

1. `themes/candyfactory-accent-palette-dark` exists; six entries; values
   exactly match CLAUDE.md §6 Step 2 verbatim block (line-by-line).
2. `themes/candyfactory-accent-palette-light` exists; six entries; values
   match: pink=window_hint, cherry=destructive, mint=success, butter=warning,
   grape=accent from parlor-light.ron; sky = <Anta resolution>.
3. `install.sh` patched: --dry-run shows both new targets; default install
   would copy them (read the script — do NOT actually run install);
   --uninstall covers them.
4. `tests/test_accent_palettes.sh` exists with all 14 required test
   functions per spec §2.
5. Run the tests: `bash /tmp/wt-cosmic-palettes/tests/test_accent_palettes.sh`
   ALL must PASS. Capture the output.
6. Commit message follows the convention (closes BON-1236; mechanical-batch
   shape; no ticket ID in title).

Verdict: APPROVE | APPROVE-WITH-NOTES | ITERATE | HOLD

If ITERATE: list each fix needed with exact file:line and the change.

Write verdict to `/tmp/v1-polish-brief/sage-b-verdict.md`. Structure:
## Verdict · ## Checklist Results · ## Test Output · ## Iterate List (if any).

DO NOT modify any file. DO NOT push. DO NOT open a PR. Read-only + pytest run.
```

**A-Sage(spec) prompt (4-channel spec compliance):**
```
You are A-Sage(spec) for PopSickle v1-polish Slice A. Spec-compliance review
only — voice is a separate Sage.

Working directory: /tmp/wt-cosmic-distribution (read-only)
Branch: feat/distribution-drafts

Inputs:
- Spec: /home/ishtar/Projects/candyfactory-cosmic/docs/superpowers/specs/2026-05-22-popsickle-v1-polish-assembly-design.md §3
- Scout outputs (the bar A-Bard had to clear):
  - /tmp/v1-polish-brief/scout-1-cosmic-themes-org.md
  - /tmp/v1-polish-brief/scout-2-themes-ron.md
  - /tmp/v1-polish-brief/scout-3-awesome-cosmic.md
  - /tmp/v1-polish-brief/scout-4-r-pop-os.md

Review each of the four draft files against the matching Scout's platform
requirements. Per-channel checklist:

For each draft (cosmic-themes-org-listing.md, themes-ron-pr-body.md,
awesome-cosmic-pr-body.md, r-pop-os-post.md):
1. All required fields present per Scout's findings?
2. Format conforms (Markdown tables, code blocks, link format)?
3. Screenshot placeholders use canonical convention
   `[SCREENSHOT-N: <description>]` and only where shots actually belong?
4. License + repo URL + Linear reference present?
5. Any obvious mismatch (e.g., r/pop_os post using awesome-cosmic format)?
6. `Submission notes` section present for the two channels that need it
   (cosmic-themes-org-listing.md, r-pop-os-post.md)?

Verdict: APPROVE | APPROVE-WITH-NOTES | ITERATE | HOLD (per draft)

Overall verdict: worst of the four.

If ITERATE: list each fix per draft with exact file:line and the change.

Write verdict to `/tmp/v1-polish-brief/sage-a-spec-verdict.md`. Structure:
## Overall Verdict · ## Per-Draft Results (4 sections) · ## Iterate List.

DO NOT modify any file. DO NOT push.
```

**A-Sage(voice) prompt (4-channel voice quality):**
```
You are A-Sage(voice) for PopSickle v1-polish Slice A. Voice review only —
spec compliance is a separate Sage.

Working directory: /tmp/wt-cosmic-distribution (read-only)
Branch: feat/distribution-drafts

Inputs:
- Voice prescription (BINDING):
  /tmp/v1-polish-brief/scout-5-voice-prescription.md
- Canon banlist: re-read from
  /home/ishtar/Projects/candyfactory-canon/04-voice/ if that exists
- Spec voice cues:
  /home/ishtar/Projects/candyfactory-cosmic/docs/superpowers/specs/2026-05-22-popsickle-v1-polish-assembly-design.md §3 (Voice review)
- Memory rule: no money/pricing/monetization language
  (feedback_money_is_not_claude_codes_business)
- Repo voice context: /home/ishtar/Projects/candyfactory-cosmic/README.md +
  /home/ishtar/Projects/candyfactory-cosmic/Cotton\ Candy\ Parlor\ for\ COSMIC.html

Review each draft against:
1. MUST-USE register notes from Scout-5 — does each draft hit them?
2. MUST-NOT-USE banlist from Scout-5 + canon — any words/phrases trigger?
   (Word-frequency check: is any single word overdeployed? Blog ship found
   "discipline" used 4× when the prescription said "once, deliberately" —
   look for similar.)
3. Cadence rules (sentence length, em-dash density, paragraph length) —
   does each draft fit?
4. Per-channel register override compliance:
   - cosmic-themes.org = product-description register
   - themes.ron PR = dry/factual
   - awesome-cosmic PR = dry/factual
   - r/pop_os post = more casual but on-brand
5. Money/pricing language — ZERO tolerance per memory rule.
6. AI brochure register markers (e.g., "revolutionary", "industry-leading",
   "best-in-class") — ZERO tolerance.

Verdict: APPROVE | APPROVE-WITH-NOTES | ITERATE | HOLD (per draft)

If ITERATE: list each voice issue with exact file:line + the fix (the actual
substitute phrasing, not "rewrite this paragraph").

Write verdict to `/tmp/v1-polish-brief/sage-a-voice-verdict.md`. Structure:
## Overall Verdict · ## Per-Draft Voice Notes (4 sections) · ## Word-
Frequency Anomalies · ## Iterate List (with exact substitutions).

DO NOT modify any file. DO NOT push.
```

**C-Sage prompt (runbook clarity + spec):**
```
You are C-Sage for PopSickle v1-polish Slice C. Combined spec + clarity
review (this is procedure, not brand surface — single Sage pass).

Working directory: /tmp/wt-cosmic-runbook (read-only)
Branch: feat/screenshot-runbook

Inputs:
- Spec: /home/ishtar/Projects/candyfactory-cosmic/docs/superpowers/specs/2026-05-22-popsickle-v1-polish-assembly-design.md §4
- CLAUDE.md §6 Step 3-5 for procedure-correctness checking:
  /home/ishtar/Projects/candyfactory-cosmic/CLAUDE.md

Review `docs/runbooks/v1-screenshots.md` against:

1. All six phases present in order (Pre-capture, Capture, Post-process,
   Commit to cosmic, Mirror to www, Swap placeholders)?
2. Phase 5 has an EXPLICIT halt-if-website-lane-busy callout per spec §4?
3. Each Phase 1-2 step is reproducible: exact command shown, exact expected
   output noted?
4. Phase 2 covers all three shots with full composition checklists per
   spec §4 phase 2?
5. Phase 4 git commands use `git -C <abs-path>` form (not `cd && git`) per
   feedback_subagent_git_must_use_dash_c_2026_05_22?
6. Phase 4 PR body template avoids putting "BON-1235" in the PR title per
   feedback_no_naked_linear_ids?
7. Phase 6 placeholder swap procedure is clear — what exactly to find +
   replace?
8. Voice is neutral/practical (not brand surface, no marketing register)?
9. No assumption that a separate session is running anything else for the
   user — runbook self-contained?

Verdict: APPROVE | APPROVE-WITH-NOTES | ITERATE | HOLD

If ITERATE: list each fix with exact file:line.

Write verdict to `/tmp/v1-polish-brief/sage-c-verdict.md`. Structure:
## Verdict · ## Checklist Results · ## Iterate List.

DO NOT modify any file. DO NOT push.
```

- [ ] **Step 2: Wait for all four Sages to complete; collect verdicts**

```bash
ls -la /tmp/v1-polish-brief/sage-*-verdict.md
```
Expected: four verdict files present.

- [ ] **Step 3: Read each verdict and surface the overall picture**

For each verdict file, read the `## Verdict` and `## Iterate List` (if present). Tabulate:
| Slice | Sage | Verdict | Iterate items |
|---|---|---|---|
| B | spec/test | ... | ... |
| A | spec | ... | ... |
| A | voice | ... | ... |
| C | clarity/spec | ... | ... |

This table feeds the Wizard gates in Wave 4.

---

## Wave 4 — Wizard gate per slice (main thread)

### Task 6: B Wizard gate

**Files:** none modified.

- [ ] **Step 1: Read B-Sage's verdict**

`/tmp/v1-polish-brief/sage-b-verdict.md`.

- [ ] **Step 2: Apply gate decision criteria**

Criteria:
- APPROVE → SHIP
- APPROVE-WITH-NOTES with no functional issue → SHIP, note carries forward
- APPROVE-WITH-NOTES with a functional issue → ITERATE
- ITERATE → ITERATE
- HOLD → HOLD (re-plan)

- [ ] **Step 3: Execute decision**

- If SHIP: proceed to Wave 5 Task 9.
- If ITERATE: dispatch B-Warrior again with the iterate list, then re-run Wave 3 B-Sage, then re-gate. Cap at 2 iteration rounds; third iteration = HOLD.
- If HOLD: stop the assembly, write a partial handoff documenting what gated and what didn't, surface to Anta.

### Task 7: A Wizard gate

**Files:** none modified.

- [ ] **Step 1: Read both A-Sage verdicts**

`/tmp/v1-polish-brief/sage-a-spec-verdict.md` and `/tmp/v1-polish-brief/sage-a-voice-verdict.md`.

- [ ] **Step 2: Apply gate decision criteria**

Combined verdict = WORST of the two. (e.g., if spec=APPROVE and voice=ITERATE, verdict=ITERATE.)

Same SHIP/ITERATE/HOLD logic as Task 6.

- [ ] **Step 3: Execute decision**

- If SHIP: proceed to Wave 5 Task 10.
- If ITERATE: dispatch A-Bard again with the combined iterate list (both Sages' notes), then re-run Wave 3 A-Sages, then re-gate. Cap at 2 iteration rounds.
- If HOLD: stop, partial handoff, surface to Anta.

### Task 8: C Wizard gate

**Files:** none modified.

- [ ] **Step 1: Read C-Sage verdict**

`/tmp/v1-polish-brief/sage-c-verdict.md`.

- [ ] **Step 2: Apply gate decision criteria**

Same SHIP/ITERATE/HOLD logic as Task 6.

- [ ] **Step 3: Execute decision**

- If SHIP: proceed to Wave 5 Task 11.
- If ITERATE: dispatch C-Bard again, re-run C-Sage, re-gate. Cap 2 rounds.
- If HOLD: stop, partial handoff, surface to Anta.

---

## Wave 5 — Merge + handoff (main thread)

### Task 9: Slice B — push + PR + merge

**Files:**
- Push: `feat/accent-palettes` to `origin`
- Modify (via merge): cosmic main on GitHub

- [ ] **Step 1: Push branch**

```bash
git -C /tmp/wt-cosmic-palettes push -u origin feat/accent-palettes
```
Expected: branch published.

- [ ] **Step 2: Open PR**

```bash
gh pr create --repo BonfireAI/candyfactory-cosmic --base main --head feat/accent-palettes \
  --title "feat(palettes): add accent_palette_{dark,light}" \
  --body "$(cat <<'EOF'
## Summary

Adds the optional accent-palette files per CLAUDE.md §6 Step 2, so the candy
hues populate cosmic-settings' accent picker after `./install.sh`.

## What changed

- `themes/candyfactory-accent-palette-dark` — six-entry Srgba list,
  CLAUDE.md §6 Step 2 verbatim values (pink, cherry, mint, butter, grape, sky)
- `themes/candyfactory-accent-palette-light` — six entries sourced from
  parlor-light.ron overrides (window_hint, destructive, success, warning,
  accent) plus a sky value resolved by Anta call
- `install.sh` — patched for both new files in default install, --dry-run,
  and --uninstall paths
- `tests/test_accent_palettes.py` — 13 Knight tests, all green

## Rides along

This branch carries the v1-polish assembly design + plan docs from earlier
in the session. Reviewing those is optional; they document the larger
context the three v1-polish slices came from.

- `docs/superpowers/specs/2026-05-22-popsickle-v1-polish-assembly-design.md`
- `docs/superpowers/plans/2026-05-22-popsickle-v1-polish-assembly-plan.md`

## Linear

Closes BON-1236 (accent palettes). Spec doc supports BON-1235/1236/1237.

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```
Expected: PR URL returned.

- [ ] **Step 3: Self-review + merge**

```bash
gh pr view <PR#> --repo BonfireAI/candyfactory-cosmic
```
Read the PR diff; confirm: file count matches Wave 2 Task 4 Step 2 deliverables; commit messages match expected; no unrelated files.

```bash
gh pr merge <PR#> --repo BonfireAI/candyfactory-cosmic --merge --delete-branch
```
Expected: PR merged, branch deleted on remote.

- [ ] **Step 4: Verify on main**

```bash
git -C /home/ishtar/Projects/candyfactory-cosmic fetch origin main
git -C /home/ishtar/Projects/candyfactory-cosmic log --oneline origin/main -5
```
Expected: merge commit visible; spec + plan + palette commits on main.

### Task 10: Slice A — push + PR + merge

**Files:**
- Push: `feat/distribution-drafts` to `origin`
- Modify (via merge): cosmic main on GitHub

- [ ] **Step 1: Push branch**

```bash
git -C /tmp/wt-cosmic-distribution push -u origin feat/distribution-drafts
```

- [ ] **Step 2: Open PR**

```bash
gh pr create --repo BonfireAI/candyfactory-cosmic --base main --head feat/distribution-drafts \
  --title "feat(distribution): paste-ready submissions for four COSMIC channels" \
  --body "$(cat <<'EOF'
## Summary

Four draft files under `docs/distribution/` — paste-ready submissions for
the COSMIC-native distribution channels identified in our 2026-05-20 spike.

## What changed

- `docs/distribution/cosmic-themes-org-listing.md` — full submission copy
  with `[SCREENSHOT-N: ...]` placeholders for the three shots
- `docs/distribution/themes-ron-pr-body.md` — full PR body for
  cosmic-utils/cosmic-project-collection adding our three themes
- `docs/distribution/awesome-cosmic-pr-body.md` — full PR body for
  Department-stack/awesome-cosmic
- `docs/distribution/r-pop-os-post.md` — full reddit post with title +
  flair + posting-time guidance + screenshot placeholders

## Ship readiness

Two channels are submission-ready now:
- cosmic-utils/cosmic-project-collection themes.ron PR
- Department-stack/awesome-cosmic PR

Two channels need BON-1235 screenshots before submission:
- cosmic-themes.org listing
- r/pop_os post

## Linear

Tracks BON-1237. Ticket stays In Review on merge (gated on BON-1235
screenshot capture for two of four channels).

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

- [ ] **Step 3: Self-review + merge**

Same shape as Task 9 Step 3.

- [ ] **Step 4: Verify on main**

```bash
git -C /home/ishtar/Projects/candyfactory-cosmic fetch origin main
git -C /home/ishtar/Projects/candyfactory-cosmic log --oneline origin/main -5
```

### Task 11: Slice C — push + PR + merge

**Files:**
- Push: `feat/screenshot-runbook` to `origin`
- Modify (via merge): cosmic main on GitHub

- [ ] **Step 1: Push branch**

```bash
git -C /tmp/wt-cosmic-runbook push -u origin feat/screenshot-runbook
```

- [ ] **Step 2: Open PR**

```bash
gh pr create --repo BonfireAI/candyfactory-cosmic --base main --head feat/screenshot-runbook \
  --title "feat(runbook): v1 screenshot capture-and-mirror procedure" \
  --body "$(cat <<'EOF'
## Summary

Six-phase runbook in `docs/runbooks/v1-screenshots.md` for capturing the
three v1 screenshots and mirroring them across the cosmic + www repos.

## What changed

- `docs/runbooks/v1-screenshots.md` — pre-capture machine prep,
  three-shot capture, post-process, canonical commit to candyfactory-cosmic,
  dual-repo mirror to candyfactory-www (with explicit lane-collision halt),
  and placeholder swap in the four distribution drafts.

## Why now

Anta is the only one who can execute the capture (his machine, his
COSMIC session). Landing the procedure ahead of the shoot lets him run
the runbook offline without dispatch overhead.

## Linear

Enables BON-1235. Ticket stays Todo until the capture phase runs.

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

- [ ] **Step 3: Self-review + merge**

Same shape as Task 9 Step 3.

- [ ] **Step 4: Verify on main**

```bash
git -C /home/ishtar/Projects/candyfactory-cosmic fetch origin main
git -C /home/ishtar/Projects/candyfactory-cosmic log --oneline origin/main -5
```

### Task 12: Linear ticket updates per spec §7

**Files:** none. Linear MCP calls.

- [ ] **Step 1: Update BON-1236 to Done**

```
mcp__claude_ai_Linear__save_issue with:
  id: "BON-1236"
  status: "Done"
```

- [ ] **Step 2: Add comment to BON-1237 + leave In Review**

```
mcp__claude_ai_Linear__save_comment with:
  issueId: "BON-1237"
  body: "4 drafts merged into `docs/distribution/`; cosmic-themes.org + r/pop_os submission gated on BON-1235 screenshots; themes.ron PR + awesome-cosmic PR ready to submit immediately."
```

Verify status stays In Review (not Done — that's intentional).

- [ ] **Step 3: Add comment to BON-1235 + leave Todo**

```
mcp__claude_ai_Linear__save_comment with:
  issueId: "BON-1235"
  body: "Runbook landed at `docs/runbooks/v1-screenshots.md` (PR <slice C PR URL>); ticket awaits capture pass on Anta's machine."
```

### Task 13: Cleanup — worktrees + snapshot tag

**Files:**
- Remove: `/tmp/wt-cosmic-palettes`, `/tmp/wt-cosmic-distribution`, `/tmp/wt-cosmic-runbook`
- Keep (for Anta's rollback judgement): tag `pre-v1-polish-2026-05-22`

- [ ] **Step 1: Remove worktrees (only after merges all confirmed)**

```bash
git -C /home/ishtar/Projects/candyfactory-cosmic worktree remove /tmp/wt-cosmic-palettes
git -C /home/ishtar/Projects/candyfactory-cosmic worktree remove /tmp/wt-cosmic-distribution
git -C /home/ishtar/Projects/candyfactory-cosmic worktree remove /tmp/wt-cosmic-runbook
git -C /home/ishtar/Projects/candyfactory-cosmic worktree list
```
Expected: only main checkout remains.

- [ ] **Step 2: Leave snapshot tag in place; surface to Anta in handoff**

Tag `pre-v1-polish-2026-05-22` stays. Document in handoff: "Snapshot tag stays for your rollback judgement; remove when satisfied."

### Task 14: Write session handoff

**Files:**
- Create: `/home/ishtar/Projects/ishtar/grimoire/sessions/2026-05-22-popsickle-v1-polish-shipped-handoff.md`

- [ ] **Step 1: Write handoff per the precedent of `2026-05-22-inaugural-ishtar-blog-shipped-handoff.md`**

Sections: Status · Lane (chronological wave-by-wave) · What landed · Lessons surfaced · Open items · Receipts (PR URLs, Linear tickets, snapshot tag) · What's next.

- [ ] **Step 2: Commit the handoff to ishtar repo on a branch**

```bash
git -C /home/ishtar/Projects/ishtar checkout -b docs/handoff-popsickle-v1-polish-2026-05-22 main
git -C /home/ishtar/Projects/ishtar add grimoire/sessions/2026-05-22-popsickle-v1-polish-shipped-handoff.md
git -C /home/ishtar/Projects/ishtar commit -m "docs(handoff): PopSickle v1-polish assembly shipped (B+A+C)"
```

Leave for Anta to PR/merge per his ishtar-repo discipline.

---

## Self-Review (skip if executing fresh — just for the orchestrator)

**Spec coverage check (run before dispatching Wave 1):**

| Spec section | Plan task(s) covering it |
|---|---|
| §1 Context | Task 1 (sets up branch + tag) |
| §2 Slice B deliverables | Task 4 (B-Warrior), Task 5 (B-Sage), Task 6 (B Wizard) |
| §2 Anta-blocker checkpoint | Task 4 Step 1 (pre-check), Task 4 Step 2 (orchestrator fills before dispatch) |
| §3 Slice A deliverables | Task 4 (A-Bard), Task 5 (A-Sages spec + voice), Task 7 (A Wizard) |
| §3 Placeholder convention | Task 4 A-Bard prompt (binding convention named) |
| §4 Slice C deliverables | Task 4 (C-Bard), Task 5 (C-Sage), Task 8 (C Wizard) |
| §5 Cadre dispatch shape | Tasks 2 (Wave 1), 3-4 (Wave 2), 5 (Wave 3), 6-8 (Wave 4), 9-11 (Wave 5) |
| §6 Branching strategy | Task 1 (rename + tag), Tasks 3-4 (worktrees on branches), Tasks 9-11 (PRs) |
| §7 Linear posture | Task 1 Step 4-5 (start), Task 12 (close per spec) |
| §8 Out of scope | C-Bard prompt has explicit Phase 5 halt-if-website-busy; A-Bard prompt has no www writes; orchestrator never dispatches to www/lexicon |
| §9 Success criteria | Task 14 handoff documents what landed + Todo |
| §10 Risk register | Wave 2 Step 4 catches implementer failures; Wave 4 ITERATE caps; HOLD path defined |

All sections covered.

**Placeholder scan:** no "TBD" / "TODO" / "fill in later" except the explicit `<ORCHESTRATOR FILLS IN>` token in B-Warrior + B-Sage prompts, which is intentional (resolved at Wave 2 Task 4 Step 1 from Anta's sky call).

**Type consistency:** verdict format (APPROVE/APPROVE-WITH-NOTES/ITERATE/HOLD) is consistent across all four Sage prompts and all three Wizard gates. Filename conventions consistent across Scout/Sage prompts.

---

## Execution Handoff

Plan complete and saved to `docs/superpowers/plans/2026-05-22-popsickle-v1-polish-assembly-plan.md` (on branch `feat/accent-palettes`, alongside the spec).

Two execution options:

1. **Subagent-Driven (recommended)** — I dispatch a fresh subagent per task (or per wave of parallel tasks), review between tasks, fast iteration. Fits the cadre model — each dispatch in this plan IS already a subagent task.

2. **Inline Execution** — Execute tasks in this session using executing-plans, batch execution with checkpoints. Same waves, same dispatches, but all from this conversation context.

Which approach?
