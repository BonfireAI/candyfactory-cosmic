# r/pop_os post — Cotton Candy Parlor for COSMIC

Conservative skeleton. The recon was blocked from `reddit.com` for the entire
session (every reddit URL and every mirror returned 403 or block),
so the items below marked UNVERIFIED need Anta's eyes on the subreddit
before the post goes live.

---

## Manual recon required (DO BEFORE POSTING)

- [ ] Open `https://www.reddit.com/r/pop_os/about/rules` and read the
      sidebar rules verbatim. Confirm no clause against theme-share posts,
      self-promotion limits, or required tags.
- [ ] Open the post-create modal on r/pop_os and enumerate the actual
      flair list. The recon confirmed only `Bug Report` and `Discussion`
      exist via search-snippet fragments; a theme-share / Showcase /
      Customization flair likely exists but is unconfirmed.
- [ ] Read 3–5 recent successful theme-share posts on r/pop_os (sort by
      Top → Year, filter to theme posts). Sanity-check the title and body
      shape below against the cadence those posts use — adjust if the
      sub's house style diverges from what's drafted here.
- [ ] Verify posting time guidance against actual r/pop_os engagement
      patterns. The recon couldn't measure subreddit-specific times; the
      best-guess below leans on general Reddit-timing studies.

---

## Suggested title (DRAFT)

> `[Theme] Cotton Candy Parlor for COSMIC — a Pop!_OS 24.04 theme kit (dark + light + cosmic-term scheme)`

Pattern follows the `[Theme] <name> — <one-line aesthetic>` shape that's
canonical across Linux-distro subs. Avoids the comparison frame, avoids
karma-bait phrasing, names the three artifacts.

## Suggested flair

`Customization` if it exists, else `Showcase`, else `Discussion`.
**UNVERIFIED** — the recon was blocked from confirming the flair list.
Confirm in the post-create modal before submitting.

## Posting time

Saturday or Sunday mid-morning Pacific (≈ Tuesday–Thursday 14:00–18:00 UTC
on weekdays as a fallback). **UNVERIFIED** for r/pop_os specifically — this
is generic Linux-subreddit guidance from indirect sources.

---

## Body

A dark + light COSMIC theme, a matching `cosmic-term` color scheme, and
an installer. Pop!_OS 24.04, MIT, no dependencies. The brand world is
"CandyFactory · Cotton Candy Parlor" — ink, cream, pink, grape, mint.

[SCREENSHOT-1: Bonfire desktop with grape window-hint visible]

§ What's in it

- `candyfactory-bonfire-dark.ron` — dark theme. Pink accent on ink, grape
  window-hint, mint for success, cherry for destructive.
- `candyfactory-parlor-light.ron` — light theme. Deepened grape accent on
  cream, deepened pink window-hint.
- `candyfactory-term-bonfire.ron` — matching cosmic-term color scheme.
- `install.sh` — idempotent, with `--dry-run` and `--uninstall` flags.

[SCREENSHOT-2: Parlor desktop with grape accent + deepened pink window-hint]

§ Install

Two paths. Pick whichever is more your shape.

GUI-import (the cosmic-native route):

```sh
git clone https://github.com/BonfireAI/candyfactory-cosmic.git
# then: cosmic-settings → Desktop → Appearance → Import → pick a .ron
# for the terminal scheme: cosmic-term → View → Color schemes → Import
```

Script-driven (one shell line, reversible):

```sh
git clone https://github.com/BonfireAI/candyfactory-cosmic.git
cd candyfactory-cosmic && ./install.sh --dry-run   # preview only
./install.sh                                        # for real
./install.sh --uninstall                            # reverts cleanly
```

[SCREENSHOT-3: cosmic-term ANSI palette over `ls -la`]

§ What's not in v1

No GTK theme — GNOME apps will inherit the accent only. No custom icon
theme, no cursor, no greeter styling. The repo is COSMIC-native; if those
matter to you they'd be a separate pass.

§ What's next + feedback

Tested on Pop!_OS 24.04 COSMIC. Curious whether the deepened light-mode
hues read cleanly against cream on different monitor profiles — that's
where I'd expect the first wrinkle. PRs and issues welcome on the repo.

Repo: `https://github.com/BonfireAI/candyfactory-cosmic` (MIT)
Also listed at: [COSMIC-THEMES-ORG-LINK]

---

## Submission notes

- [ ] Swap `[COSMIC-THEMES-ORG-LINK]` for the actual cosmic-themes.org
      listing URL once Submission 1 / 2 land (see
      `cosmic-themes-org-submissions.md`).
- [ ] Replace all three `[SCREENSHOT-N: ...]` placeholders with native
      Reddit image uploads at post-create time. Don't use markdown image
      syntax — Reddit's image carousel renders better via native upload.
- [ ] Confirm the COSMIC alpha version Anta is running on; substitute the
      specific alpha number into the body if helpful.
- [ ] If r/pop_os flair list lacks `Customization` and `Showcase`, decide
      between `Discussion` (safe fallback) and posting without flair (often
      auto-removed — avoid).
- [ ] Do not include any pricing, sponsor, Patreon, or "support the
      project" copy. If asked in comments, defer.
- [ ] Do not link to `candyfactory.ai` directly in the post body. The
      GitHub link is the only outbound; the README on the repo can
      soft-bridge.
