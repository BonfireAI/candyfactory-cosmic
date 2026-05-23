# 2026-05-22 · PopSickle v1-Polish Assembly — Design Spec

**Repo:** `BonfireAI/candyfactory-cosmic`
**Product:** CandyFactory · Cotton Candy Parlor for COSMIC (workshop nickname *PopSickle*)
**Assembly:** Three independent v1-polish slices, three PRs, one session
**Linear:** existing tickets BON-1235 · BON-1236 · BON-1237 re-used (no new tickets)
**Skill posture:** Approach 1 — Bonfire-discipline parallel (Scouts → Bards/Warriors → Sages → Wizard gate per slice)

## 1. Context

`BonfireAI/candyfactory-cosmic` is public on GitHub since 2026-05-21 (MIT, topics applied, hub HTML + three RON themes + idempotent `install.sh` + spike documentation all landed). Repo work that remains is the v1-polish lane, which decomposes cleanly into three slices that share no files and have no ordering dependency.

Two parallel lanes constrain this session:

- The **`candyfactory-www` lane is busy**. No writes to that repo. The hub-deploy PR `candyfactory-www#10` (BON-1234, In Review) is hands-off.
- The **`bonfire-lexicon` lane is busy**. No touch.

Within those constraints, three v1-polish slices are unblocked:

- **Slice B — Accent palette files** (BON-1236, Low priority, mechanical)
- **Slice A — Distribution drafts** (BON-1237 partial — 4 channels, draft-parked with screenshot placeholders)
- **Slice C — Screenshot capture-and-mirror runbook** (BON-1235 enablement — capture stays Anta's job)

## 2. Slice B — Accent palette files

### Deliverables

Two source files under `themes/` (no `.ron` extension — matches install destination filenames):

| Filename | Order | Sourcing |
|---|---|---|
| `themes/candyfactory-accent-palette-dark` | pink · cherry · mint · butter · grape · sky | **Verbatim from CLAUDE.md §6 Step 2 block.** RGB float values are already canonical in the spec — copy them. |
| `themes/candyfactory-accent-palette-light` | pink · cherry · mint · butter · grape · sky | **Read `themes/candyfactory-parlor-light.ron`** and source each value from the corresponding override field (pink ← `window_hint`, cherry ← `destructive`, mint ← `success`, butter ← `warning`, grape ← `accent`). **Sky has no semantic-role override** in parlor-light.ron because COSMIC doesn't define one; B-Warrior must NOT invent a deepened sky — surface to Anta for canon clarification (most likely: use the base `#5fb8ff` from §3; possible alternative: a deepened sky added to canon at this point). |

Format = RON Srgba list per CLAUDE.md §6 Step 2 — bracketed list of `(red: f32, green: f32, blue: f32, alpha: 1.0)` tuples. Six entries each, canonical order above.

`install.sh` patched to drop the new files into `~/.config/cosmic/com.system76.CosmicSettings/v1/accent_palette_dark` and `…/accent_palette_light`. Both `--dry-run` and `--uninstall` paths cover the new files.

### Test contract (Knight)

For each palette:
- Parse as RON. Assert structural validity.
- Assert exactly six Srgba entries in the canonical order (pink · cherry · mint · butter · grape · sky).
- **Dark palette:** assert each entry exactly matches the corresponding tuple in CLAUDE.md §6 Step 2 verbatim block (tolerance zero).
- **Light palette:** assert each entry exactly matches the corresponding override in `themes/candyfactory-parlor-light.ron` (mapping above). Tolerance zero. Sky entry: assert per Anta's canon clarification.

For `install.sh`:
- `--dry-run` output contains the two new target paths.
- `--uninstall` removes the two new targets when present and is a no-op when absent.

### Anta-blocker checkpoint (before B-Warrior dispatches)

If parlor-light.ron read confirms sky has no override, **pause Slice B at Scout wave and ask Anta the single question: "for the light accent palette's sky slot, use base `#5fb8ff` or do you want to canonize a deepened sky now?"** Cheaper than a half-built palette that needs a re-pass.

### Voice review

None. Mechanical batch per the bundled-mechanical-tasks pattern.

## 3. Slice A — Distribution drafts (three channels, draft-parked)

> **Amendment 2026-05-22 (Wave 1 Scout findings):** Original spec listed four channels. Wave 1 surfaced that (a) `Department-stack/awesome-cosmic` doesn't exist — `cosmic-utils/cosmic-project-collection` IS the de-facto "awesome COSMIC" list; (b) cosmic-tweaks reads from cosmic-themes.org's API (not from cosmic-project-collection's themes.ron — the spike was wrong on this pipeline), making cosmic-themes.org the **primary** distribution surface; (c) cosmic-themes.org takes one .ron per submission, so PopSickle = 2-3 separate form fills. Channels collapsed from 4 → 3 per Anta's Option A pick. See §10 risk register row 1 for the resolved drift.

### Deliverables

Three markdown files under `docs/distribution/`:

| Filename | Channel | Target action |
|---|---|---|
| `cosmic-themes-org-submissions.md` | cosmic-themes.org | **Procedure doc** covering 2-3 separate form submissions (one per .ron file). cosmic-themes.org auto-syncs into cosmic-tweaks' "Available" tab — primary distribution surface. |
| `themes-ron-pr-body.md` | `cosmic-utils/cosmic-project-collection` | PR body adding **one entry** for the BonfireAI/candyfactory-cosmic repo to `themes.ron` (model is one entry per repo, not per theme). Low-signal channel but free reach. |
| `r-pop-os-post.md` | r/pop_os | Reddit post (title, body, flair, posting-time guidance) — **conservative skeleton + manual-eyes-on TODO list** since Scout-4 was blocked from reddit.com. |

### Placeholder convention

Every slot that requires a screenshot uses `[SCREENSHOT-N: <description>]` markers (see Slice C for the canonical N → file mapping):

- `[SCREENSHOT-1: Bonfire desktop with grape window-hint visible]`
- `[SCREENSHOT-2: Parlor desktop with grape accent + deepened pink window-hint]`
- `[SCREENSHOT-3: cosmic-term ANSI palette over `ls -la`]`

When Anta captures shots per Slice C, he swaps markers for filenames. Zero rework, slight bloat — accepted trade-off per the "draft-parked copy now" pick.

### Voice review (two-stage Sage, per blog precedent)

Each of the three drafts gets:
- **Spec-compliance Sage** — channel platform requirements: cosmic-themes.org submission form fields (Name + Author + Link + .ron file + captcha), themes.ron PR convention from `cosmic-utils`, r/pop_os flair + content rules (per Scout-5 + Scout-4 caveats).
- **Voice-quality Sage** — canon banlist clean, parlor cadence rules respected, no "AI brochure" register, single-purpose lede.

Both Sage passes can run in parallel within the slice.

## 4. Slice C — Screenshot capture-and-mirror runbook

### Deliverable

`docs/runbooks/v1-screenshots.md` with six numbered phases:

1. **Pre-capture.** Run `./install.sh --dry-run`. Run `./install.sh`. Log out, log back in (cosmic-comp picks up themes on session restart). Verify in `cosmic-settings` → Appearance that Bonfire (dark) and Parlor (light) appear; verify in cosmic-term that the `candyfactory-term-bonfire` scheme is selectable.
2. **Capture.** Three shots per BON-1235, 1920×1080:
   - Shot 1: Bonfire (dark) desktop — panel, dock, a focused libcosmic window (grape window-hint visible), an unfocused one, accent picker visible.
   - Shot 2: Parlor (light) desktop — same composition, grape accent, deepened pink window-hint.
   - Shot 3: cosmic-term in Bonfire — ANSI palette via `ls -la` or `tldr`, cream foreground on candied dark background.
3. **Post-process.** Save as PNG. Filename convention: `bonfire-desktop.png`, `parlor-desktop.png`, `cosmic-term-ansi.png`. Optional optimization with `pngcrush -reduce`. Size budget: ≤ 800 KB each.
4. **Commit to cosmic repo (canonical).** Branch `feat/v1-screenshots`. Stage into `assets/screenshots/`. Commit. Push. Open PR with body that closes BON-1235.
5. **Mirror to www repo.** Only when the `candyfactory-www` lane has cleared. Open a worktree on `candyfactory-www` main; `cp` shots into `cosmic/assets/screenshots/`; update `cosmic/index.html` to reference the local copies. PR to www main. **The runbook makes explicit: do not run this phase while another session owns the website lane.**
6. **Swap placeholders in distribution drafts.** Open the four `docs/distribution/*.md` files; replace `[SCREENSHOT-N: ...]` markers with the canonical image references; commit. The four drafts are now submission-ready.

### Voice review

Single Sage pass — clarity + spec compliance. Not brand-surface copy.

## 5. Cadre dispatch shape

### Wave 1 — parallel read-only Scouts

Maximum five in flight, single message dispatch. Estimated ~10 min wall-time. All read-only.

- **Scout-1** · cosmic-themes.org submission requirements (URL, field list, format expectations, review SLA).
- **Scout-2** · `cosmic-utils/cosmic-project-collection` — `themes.ron` format, recent merged PRs as convention reference, maintainer expectations.
- **Scout-3** · `Department-stack/awesome-cosmic` — README structure, row format, PR style, any tag/category conventions.
- **Scout-4** · r/pop_os flair rules + recent successful theme-share posts (composition + tone reference).
- **Scout-5** · canon voice prescription — re-use blog-ship voice prescription if available; layer cosmic-specific notes from `CLAUDE.md`.

### Wave 2 — parallel implementers in worktrees

Maximum four in flight (B-Warrior + A-Bard + C-Bard). Estimated ~15 min wall-time. Each in its own worktree per `feedback_worktrees_for_parallel.md`.

- **B-Warrior** in `/tmp/wt-cosmic-palettes` on branch `feat/accent-palettes` — generates the two RON files + `install.sh` patch + Knight tests per Slice B contract.
- **A-Bard** in `/tmp/wt-cosmic-distribution` on branch `feat/distribution-drafts` — generates all four channel drafts using Scout-1/2/3/4 outputs + Scout-5 voice prescription.
- **C-Bard** in `/tmp/wt-cosmic-runbook` on branch `feat/screenshot-runbook` — generates the runbook using Scout-3+4 outputs.

### Wave 3 — parallel Sage reviews

Per-slice Sage dispatch.

- **B-Sage** — runs Knight tests; verifies hex correctness against CLAUDE.md §3 line-by-line.
- **A-Sage (spec)** + **A-Sage (voice)** — two-stage per blog precedent. Both Sages parallel within Slice A.
- **C-Sage** — runbook clarity + spec compliance.

### Wave 4 — Wizard gate per slice

Per `feedback_wizard_gate_must_be_named_lane_step_2026_05_21`, each slice has a named Wave-N.5 gate step. Three independent gates. Possible verdicts per gate: SHIP · ITERATE · HOLD.

### Wave 5 — Warrior merge

Three PRs opened with `gh pr create`. Self-reviewed per the box-self-review-thorougher-than-host-cold pattern. Merged per each slice's Wizard verdict. Order is whichever gates first.

## 6. Branching, PR, and snapshot strategy

- Pre-Wave-2 snapshot: `git -C /home/ishtar/Projects/candyfactory-cosmic tag pre-v1-polish-2026-05-22 main` (no worktree snapshot needed — this is in-repo additive work, not a destructive sweep).
- Three feature branches off cosmic `main`:
  - `feat/accent-palettes` → PR → merge.
  - `feat/distribution-drafts` → PR → merge.
  - `feat/screenshot-runbook` → PR → merge.
- All three independent. Merge order is whichever gate fires first.
- Each PR body references the relevant Linear ticket but does **not** put the ticket ID in the PR title (per `feedback_no_naked_linear_ids`).

## 7. Linear ticket posture

No new tickets. Existing three re-used:

- **BON-1236 (accent palette)** — In Progress on Wave 2 dispatch · In Review on Wave 3 · Done on merge.
- **BON-1237 (distribution rollout)** — In Progress on Wave 2 dispatch · In Review on Wave 3 · **stays In Review on merge** with comment: *"3 drafts merged into `docs/distribution/`. Scope re-pivoted from 4 channels (spec amendment) — awesome-cosmic dropped (doesn't exist as separate target; collapsed into cosmic-project-collection). cosmic-themes.org submissions (2-3 form fills) + r/pop_os post gated on BON-1235 screenshots. themes.ron PR ready to submit immediately."*
- **BON-1235 (screenshots)** — stays Todo. Runbook merge does NOT close it. Comment on runbook merge: *"Runbook landed at `docs/runbooks/v1-screenshots.md`; ticket awaits capture pass on Anta's machine."*

## 8. Out of scope (explicit)

- Any write to `candyfactory-www` (website lane is busy).
- Any write to `bonfire-lexicon` (lexicon lane is busy).
- Hub-deploy PR `candyfactory-www#10` (in-review on website lane).
- Screenshot capture itself (Anta's machine, Anta's eyes).
- GTK/icon/cursor/greeter/GNOME-Shell themes (per CLAUDE.md §7 — explicit v1+ scope).
- New tickets (re-use existing three).
- Open items from the 2026-05-22 inaugural-blog handoff (snapshot cleanup, PR title hygiene, untracked plan markdowns) — those belong to whoever runs that follow-up.

## 9. Success criteria

The assembly is done when all three Wizard gates have returned a verdict (SHIP or HOLD), the SHIP slices have merged to cosmic main, Linear tickets reflect the posture in §7, and the next-session handoff documents what landed plus the still-Todo screenshot capture as the natural next step.

## 10. Risk register

| Risk | Mitigation |
|---|---|
| Scout-2 finds `themes.ron` format has changed since the 2026-05-20 spike | Scout returns format diff; A-Bard adapts the PR body accordingly; surface in design-doc amendment if change is structural. **RESOLVED 2026-05-22:** Scout-2 + Scout-3 found the spike was wrong on the cosmic-tweaks pipeline (reads cosmic-themes.org's API, not cosmic-project-collection's themes.ron), and that awesome-cosmic doesn't exist as a separate target. Spec amended (§3): 4 channels → 3. Anta picked Option A. |
| Scout-4 blocked from reddit.com (WebFetch 403 on all 13 URL patterns tried) | r/pop_os draft becomes a conservative skeleton + an explicit manual-eyes-on TODO list (flair list, sidebar rules verbatim, 3-5 reference post titles). Anta does the manual recon before posting. |
| Scout-1 / Scout-2 conflict on cosmic-themes.org term-scheme schema acceptance | Resolved empirically at submission time: A-Bard's cosmic-themes-org-submissions.md procedure tells Anta to attempt the term-scheme upload, observe validator response, fall back to repo-link only if rejected. |
| `cosmic-themes.org` submission form requires fields we don't have (e.g., a specific screenshot ratio) | Scout-1 surfaces; A-Bard composes draft + flags missing fields as TODOs Anta resolves at submission time |
| A-Sage (voice) flags multiple drafts with similar issues (e.g., over-deployment of a word per the blog precedent) | One surgical revision pass before re-gate, per the blog ship's iterate-then-ship pattern |
| Anta's CLAUDE.md §3 hex values turn out to be ambiguous in light-vs-dark for one of the six | B-Sage flags during hex correctness check; B-Warrior cannot guess — surfaces back to Anta for canon clarification |
| Three PRs cause review-overhead fatigue | Bundle-merge fallback: if any slice fails its first Wizard gate and the others are SHIP, merge the SHIPs immediately and revise the failing slice in isolation |

## 11. References

- `CLAUDE.md` §3 (canonical color table), §6 Step 2 (accent palette format), §7 (out of scope)
- `docs/spikes/2026-05-20-cosmic-theme-construction.md` (RON schema validation)
- Linear project: *CandyFactory · Cotton Candy Parlor for COSMIC* (id `3aecfd89-f250-4f6e-be7b-69a1e22839f5`)
- Linear tickets: BON-1235, BON-1236, BON-1237
- Memory: `project_candyfactory_cosmic_2026_05_20`, `feedback_wizard_gate_must_be_named_lane_step_2026_05_21`, `feedback_worktrees_for_parallel`, `feedback_subagent_git_must_use_dash_c_2026_05_22`, `feedback_bundle_mechanical_tasks_2026_05_16`
- Prior handoff precedent: `ishtar/grimoire/sessions/2026-05-22-inaugural-ishtar-blog-shipped-handoff.md`
