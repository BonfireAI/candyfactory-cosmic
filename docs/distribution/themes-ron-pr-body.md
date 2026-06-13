# cosmic-utils/cosmic-project-collection — themes.ron PR body

PR body draft for adding one entry to `themes.ron` in
`cosmic-utils/cosmic-project-collection`. Per Scout-3, the registry model is
one entry per **repo**, not per individual theme — so this is a single tuple
block adding `BonfireAI/candyfactory-cosmic`, not three.

PR title (suggested, plain factual — match the dominant
`Add <name> <type>` pattern observed across the last 30 merged PRs):

> `Add CandyFactory · Cotton Candy Parlor themes for COSMIC`

(No bracket-tag, no Conventional Commits prefix needed; no Linear ID in
the title.)

---

## Summary

- Adds `BonfireAI/candyfactory-cosmic` as a third entry in `themes.ron` — a
  dark + light COSMIC theme set with a matching `cosmic-term` color scheme.
- First community theme submission to the `Themes` section since June 2024
  (`catppuccin/cosmic-desktop` and `Fingel/cosmic-themes-org-py` are the
  existing entries).

## What changed

Single addition to `themes.ron`, appended as the third item in the `list:` —
adds a trailing comma after the existing `cosmic-themes` entry's closing `)`
and inserts the block below.

```ron
(
  name: "candyfactory-cosmic",
  description: "Dark + light COSMIC themes with matching cosmic-term scheme",
  repo: "https://github.com/BonfireAI/candyfactory-cosmic",
  image: "[SCREENSHOT-1-RAW-URL-HERE]"
)
```

The `image:` value is a `raw.githubusercontent.com` URL pointing at a
screenshot in `BonfireAI/candyfactory-cosmic`'s `main` branch (per the
established convention — Scout-3 cites PR #17 specifically fixing several
applets to use raw URLs instead of github.com web URLs). The placeholder
`[SCREENSHOT-1-RAW-URL-HERE]` will be swapped for the actual URL once
the screenshot capture lands; the file lives at
`raw.githubusercontent.com/BonfireAI/candyfactory-cosmic/main/<path>` once
the asset is committed to `main`.

**Alternate path if the PR ships before screenshots land:** omit the
`image:` field entirely (the `#![enable(implicit_some)]` directive at the
top of `themes.ron` makes it `Option<String>` and tolerant of omission).
Add a comment in the PR body noting the image will be added in a follow-up
PR once the screenshot is hosted.

## Why include

The two existing `themes.ron` entries cover broad-aesthetic territory
(catppuccin pastel; cosmic-themes.org as a meta-link). `candyfactory-cosmic`
fills a different visual niche — pink + grape + cream over ink — that the
current top-20 of `cosmic-themes.org` does not occupy (Scout-4's read of
the top-20 downloads found no "sweet" or "playful" aesthetic in the list).
Adding it gives the `Themes` section a third distinct visual direction.

## License

MIT (the listing repo; the project-collection registry itself is GPL-3.0
and accepts mixed licenses per its existing catppuccin/MIT entry).

---

## Local validation before opening the PR

Per Scout-3, the post-merge CI runs `cargo run` to regenerate `README.md`
from the `.ron` source files via `src/readme.rs` — and there is no PR-side
CI gate. Malformed RON would panic at `ron::from_str(...).unwrap()` in the
post-merge build, so validate locally first:

```bash
git clone https://github.com/cosmic-utils/cosmic-project-collection.git
cd cosmic-project-collection
# apply the themes.ron edit, then:
cargo run
# README.md regenerates cleanly = the entry parses
```

Confirm the regenerated README's `## Themes` section shows the new row
with the correct repo URL and (if `image:` is set) the screenshot.

## Submission notes

- Do not edit `README.md` directly in the PR — it's auto-generated. The
  Rust binary regenerates it on push to `main`. Scout-3 cites PR #60's
  rejection for this exact mistake.
- The repo has no `CONTRIBUTING.md`, no PR template, no `.github/ISSUE_TEMPLATE/`.
- The README's "How to add your project?" copy only names `applications.ron`
  and `applets.ron` — `themes.ron` is accepted but the docs lag. Worth
  stating explicitly in the PR body that this is a `themes.ron` addition
  so the reviewer doesn't need to deduce intent.
- Maintainer of record: `edfloreshz` (Eduardo Flores). Merge cadence is
  hours-to-days; review bar is low for additive `.ron` edits.
