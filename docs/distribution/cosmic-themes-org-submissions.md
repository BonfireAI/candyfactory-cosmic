# cosmic-themes.org Submissions

Procedure doc. Anta walks through 2–3 separate form fills at
`https://cosmic-themes.org/create/`, one `.ron` per submission. This is not a
single listing — each theme file becomes its own page on the directory.

---

## Channel context

`cosmic-themes.org` is the primary distribution surface for COSMIC desktop
color schemes. The `cosmic-tweaks` "Available" tab pulls directly from this
site's API (`https://cosmic-themes.org/api/themes/?limit=50000`, per the
public source `cosmic-utils/tweaks/src/app/pages/color_schemes/mod.rs`),
which means anything landed here also lands inside the Tweaks GUI for every
COSMIC user. Auto-publish — there is no human review queue; if the
`cosmic-theme-tools` validator parses the file and the captcha is solved,
the listing goes live immediately.

The form is intentionally minimal: four user-facing fields (Name, Author,
Link, the `.ron` file upload) plus a `3 + 3` integer captcha. No description
field, no tag picker, no license selector, no screenshot upload. All prose
— the install steps, the license, the screenshots, the brand story — lives
at the **Link** URL, which for every submission below points at the
GitHub README of `BonfireAI/candyfactory-cosmic`.

---

## Submission 1 — candyfactory-bonfire-dark

| Field   | Value                                                        |
|---------|--------------------------------------------------------------|
| Name    | `CandyFactory · Cotton Candy Parlor — Bonfire (Dark)`        |
| Author  | `CandyFactory`                                               |
| Link    | `https://github.com/BonfireAI/candyfactory-cosmic`           |
| .ron    | `themes/candyfactory-bonfire-dark.ron`                       |
| Captcha | `6`                                                          |

The accent-color preview the site auto-renders will lean on `--pink`
(`#ff5fa2`) over ink (`#1a1626`) with grape window-hint. That's the visual
that sells the listing card — confirm the colors land right by previewing
one other dark listing on the directory before submitting (e.g. listing
`/100/` Gruvbox Material Dark renders the same auto-mock with its own
palette).

---

## Submission 2 — candyfactory-parlor-light

| Field   | Value                                                        |
|---------|--------------------------------------------------------------|
| Name    | `CandyFactory · Cotton Candy Parlor — Parlor (Light)`        |
| Author  | `CandyFactory`                                               |
| Link    | `https://github.com/BonfireAI/candyfactory-cosmic`           |
| .ron    | `themes/candyfactory-parlor-light.ron`                       |
| Captcha | `6`                                                          |

Light-theme auto-previews are rarer on the directory (`Nord Light` at
`/13/` is one of the few). The deepened grape accent (`#7e38de`) over
cream will read as distinct against the dark-dominant index.

---

## Submission 3 — candyfactory-term-bonfire (CONDITIONAL — test validator first)

| Field   | Value                                                        |
|---------|--------------------------------------------------------------|
| Name    | `CandyFactory · Cotton Candy Parlor — cosmic-term scheme`    |
| Author  | `CandyFactory`                                               |
| Link    | `https://github.com/BonfireAI/candyfactory-cosmic`           |
| .ron    | `themes/candyfactory-term-bonfire.ron`                       |
| Captcha | `6`                                                          |

> **Heads up — validator may reject this file.** Per the recon,
> `cosmic-themes.org` runs every upload through Fingel's `cosmic-theme-tools`
> binary, which parses against the **desktop palette schema** (the shape
> documented in CLAUDE.md §4 — `palette: Dark(( ... ))` + `bg_color`,
> `accent`, `window_hint`, etc.). The cosmic-term scheme is a different RON
> shape (ANSI palette, not desktop palette), and there's no documented
> evidence the validator accepts it.
>
> **Procedure:** attempt the upload. If it accepts, it's listed and Tweaks
> picks it up. If it rejects, copy the exact error response into the
> "Submission notes" section below and skip this submission — the term
> scheme stays accessible via the GitHub repo's `themes/` folder and the
> install.sh path, which is the documented install route in the README
> regardless.

---

## Submission procedure

URL: `https://cosmic-themes.org/create/`

1. Open the form. Confirm the four field labels match what's documented
   above (Name, Author, Link, the file upload field, the captcha).
2. Paste the Name verbatim from the Submission section above.
3. Paste `CandyFactory` into Author.
4. Paste the GitHub URL into Link.
5. Click the file upload, navigate to the local checkout's `themes/`
   directory, pick the matching `.ron`.
6. Solve the captcha (`What is three plus three?` → `6`).
7. Submit.
8. If the form returns an error: the validator rejected the file. Copy the
   error text into "Submission notes" below; do not retry blindly.
9. If the form returns success: the listing is live immediately. Open the
   listing URL in a fresh browser tab and confirm the auto-preview colors
   look right against the site's mock-window chrome.
10. Repeat for the next submission.

No screenshots field exists on the form — confirmed against the
public source at `Fingel/cosmic-themes-org-py`. Screenshots live on the
GitHub README at the Link URL, handled separately by the runbook.

---

## Submission notes

Open TODOs Anta needs to handle at submission time:

- [ ] Confirm the exact Name field spellings before submitting — the
      `· Cotton Candy Parlor —` em-dash + middot pattern above is one
      proposal; substitute hyphens if the directory's existing listings
      shy away from non-ASCII.
- [ ] Captcha is live at submission time; the answer is `6` today but the
      site's source could swap to a different math question. Read the
      prompt before answering.
- [ ] If Submission 3 (term scheme) rejects, paste the validator error
      response below for the review record:

  > **Submission 3 validator response (if rejected):**
  > `[paste error here]`

- [ ] After each successful submission, capture the listing URL
      (`https://cosmic-themes.org/<id>/`) for the runbook's
      screenshots TODO.
- [ ] If Anta wants to rename or remove a listing later: the site has no
      edit UI. File a GitHub issue against `Fingel/cosmic-themes-org-py`.
