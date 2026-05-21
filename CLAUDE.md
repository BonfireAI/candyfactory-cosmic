# CLAUDE.md — Build the CandyFactory COSMIC theme

You are working in a clone of the **CandyFactory · Cotton Candy Parlor** brand kit for **Pop!_OS 24.04 (COSMIC desktop)**. Your job is to take the starter files in this directory and produce a polished, working theme that installs cleanly on the user's machine.

Read this file end-to-end before touching anything. The starter pack is opinionated. Don't reinvent it — sharpen it.

---

## 1 · Mission

Ship a self-contained folder the user can `./install.sh` and immediately get:

- A **dark theme** ("Bonfire") for `cosmic-comp` / `libcosmic` apps.
- A **light theme** ("Parlor") for the same.
- A matching **cosmic-term** color scheme.
- A **README** the user can hand to their friends.

**The brand is binding.** Cream `#fff8e7`, ink `#1a1626`, sticker shadows, candy hues, mono labels in UPPERCASE with wide letter-spacing. Never invent colors. Never round corners beyond what `r-lg = 18` allows.

---

## 2 · What lives where

```
candyfactory-cosmic/
├── CLAUDE.md                              ← you are here
├── README.md                              ← user-facing, you may rewrite freely
├── install.sh                             ← bash installer; verified working
├── themes/
│   ├── candyfactory-bonfire-dark.ron      ← COSMIC dark theme
│   ├── candyfactory-parlor-light.ron      ← COSMIC light theme
│   └── candyfactory-term-bonfire.ron      ← cosmic-term scheme
└── assets/
    ├── candyfactory-logo.png
    └── parlor.css                         ← reference design tokens
```

COSMIC reads themes from `cosmic-config` directories under
`~/.config/cosmic/`:

| What                 | Path                                                                       |
|----------------------|----------------------------------------------------------------------------|
| Dark theme           | `~/.config/cosmic/com.system76.CosmicTheme.Dark/v1/<filename>`             |
| Light theme          | `~/.config/cosmic/com.system76.CosmicTheme.Light/v1/<filename>`            |
| Terminal scheme      | `~/.config/cosmic/com.system76.CosmicTerm/v1/color_schemes/<filename>.ron` |
| Accent palettes      | `~/.config/cosmic/com.system76.CosmicSettings/v1/accent_palette_{dark,light}` |

Files are **RON** (Rusty Object Notation). One typo in a `(red: …,)` and the theme silently falls back to system default — there's no error popup. Validate by `cat`-ing the installed file after copy.

---

## 3 · Canonical colors

These are the only colors you may use. Everything else must be derived.

| Token         | Hex      | RGB float (0–1)               | Role                                         |
|---------------|----------|-------------------------------|----------------------------------------------|
| `--ink`       | `#1a1626`| `0.101961, 0.086275, 0.149020`| Dark surface, all borders, body copy on cream |
| `--ink-soft`  | `#4a3f5e`| `0.290196, 0.247059, 0.368627`| Muted text, dividers                          |
| `--paper`     | `#fffaf0`| `1.000000, 0.980392, 0.941176`| Card surface                                  |
| `--bg / cream`| `#fff8e7`| `1.000000, 0.972549, 0.905882`| Light surface, default page bg                |
| `--bg-soft`   | `#f7f0d8`| `0.968627, 0.941176, 0.847059`|                                                |
| `--pink`      | `#ff5fa2`| `1.000000, 0.372549, 0.635294`| **Dark-mode accent** · headline pink         |
| `--brand-hot` | `#ff3b6b`| `1.000000, 0.231373, 0.419608`| Cherry · destructive · "burn"                |
| `--brand-pop` | `#a96bff`| `0.662745, 0.419608, 1.000000`| Grape · **Light-mode accent** · window hint  |
| `--brand-b`   | `#5fd4c4`| `0.372549, 0.831373, 0.768627`| Mint · success / "quality"                   |
| `--brand-c`   | `#5fb8ff`| `0.372549, 0.721569, 1.000000`| Sky                                            |
| `--brand-d`   | `#ffd84d`| `1.000000, 0.847059, 0.301961`| Butter · warning / "sugar"                   |

Light-mode candy hues are **deepened** for AA contrast on cream — see `themes/candyfactory-parlor-light.ron` for exact values.

---

## 4 · How a COSMIC theme RON is shaped

The file is a single tuple. Top-level keys, in order:

```ron
(
    palette: Dark((  // or Light((...))
        name: "<string>",
        // 4 standard hues — used by syntax highlighting & status:
        blue / red / green / yellow,
        // 3 grays (background ramp from darkest to lightest):
        gray_1 / gray_2 / gray_3,
        // 11 neutrals — full surface ramp:
        neutral_0 … neutral_10,
        // 3 bright variants (used for emphasis):
        bright_green / bright_red / bright_orange,
        // 7 extended hues (syntax highlight grade):
        ext_warm_grey / ext_orange / ext_yellow / ext_blue /
        ext_purple / ext_pink / ext_indigo,
        // 9 accent options — these populate Settings → Accent picker:
        accent_blue / accent_red / accent_green / accent_warm_grey /
        accent_orange / accent_yellow / accent_purple / accent_pink / accent_indigo,
    )),

    spacing: ( space_none / xxxs / xxs / xs / s / m / l / xl / xxl / xxxl ),

    corner_radii: ( radius_0 / xs / s / m / l / xl ),
    // each is a 4-float tuple (tl, tr, br, bl), all equal for uniform corners

    bg_color:   Some(( red:, green:, blue:, alpha: )),
    text_tint:  Some(( red:, green:, blue: )),           // no alpha
    accent:     Some((...)),  // ★ the default pick from the palette above
    success:    Some((...)),
    warning:    Some((...)),
    destructive:Some((...)),
    window_hint:Some((...)),                              // outline color on focused window
    neutral_tint:           Some((...)),                  // dark theme: subtle warm cast on neutrals
    primary_container_bg:   Some((..., alpha: )),         // header bars, cards
    secondary_container_bg: Some((..., alpha: )),         // nested surfaces

    is_frosted:  false,    // true = backdrop-blur. We do NOT use this.
    gaps:        (4, 8),   // (outer, inner) tiling gap in px
    active_hint: 3,        // active-window outline thickness in px
)
```

Colors are `f32` floats in 0.0–1.0 — **not** 0–255. Wrong scale silently looks black/blown out.

Fields wrapped in `Some(...)` are nullable; `None` means "derive from palette." For light themes we set `neutral_tint`, `primary_container_bg`, `secondary_container_bg` = `None` and let COSMIC compute them.

---

## 5 · Token mapping (CandyFactory → COSMIC)

Use this table verbatim. Don't improvise — these decisions were made for contrast and brand consistency.

### Bonfire (dark)
| COSMIC field              | CandyFactory token        | Why                                  |
|---------------------------|---------------------------|--------------------------------------|
| `bg_color`                | `--ink`                   | The "candied dark" surface           |
| `text_tint`               | `--bg` (cream)            | High-contrast body on dark           |
| `accent`                  | `--pink` `#ff5fa2`        | Friendly headline pink — pops on ink |
| `destructive`             | `--brand-hot` `#ff3b6b`   | Cherry — semantic "burn"             |
| `success`                 | `--brand-b` mint          | Quality indicator                    |
| `warning`                 | `--brand-d` butter        | Sugar / heat                         |
| `window_hint`             | `--brand-pop` grape       | Distinctive on dark surfaces         |
| `neutral_tint`            | `--ink-soft`              | Warm cast on grays                   |
| `primary_container_bg`    | `#221c30`                 | One step up from ink                 |
| `secondary_container_bg`  | `#2c243d`                 | Two steps up                         |

### Parlor (light)
| COSMIC field              | CandyFactory token        | Why                                                 |
|---------------------------|---------------------------|-----------------------------------------------------|
| `bg_color`                | `--bg` cream              | Parlor floor                                        |
| `text_tint`               | `--ink`                   | Plum-black                                          |
| `accent`                  | `--brand-pop` deepened grape `#7e38de` | Best AA contrast on cream         |
| `destructive`             | deepened cherry `#e22e59` | Cherry, AA on cream                                 |
| `success`                 | deepened mint  `#3da394`  | Mint, AA on cream                                   |
| `warning`                 | deepened butter `#c79900` | Butter, AA on cream                                 |
| `window_hint`             | deepened pink  `#e2438e`  | Pink hint vs grape accent                           |
| `neutral_tint` & containers | `None`                  | Let COSMIC derive cream-tinted neutrals             |

`gaps: (4, 8)` and `active_hint: 3` everywhere — gives windows a sticker-like rim consistent with the brand's hard-offset shadow language.
`is_frosted: false` — **never enable**. CandyFactory does not use glassmorphism.
`corner_radii.radius_l = 18` matches `--r-lg`; other radii scale proportionally.

---

## 6 · Build steps

Do these in order. Don't skip the validation step — silently-broken RON is the #1 way this goes wrong.

### Step 1 — Validate the starter RONs
Open `themes/candyfactory-bonfire-dark.ron` and `themes/candyfactory-parlor-light.ron`. Confirm:

- Every color tuple has the right key count: palette colors have `(red, green, blue, alpha)`, overrides like `text_tint` are `(red, green, blue)` with no alpha.
- All RGB values are in `[0.0, 1.0]`. If you see `0.9 / 0.0 / 0.0` it's correct; if you see `255 / 0 / 0` it's broken.
- Trailing commas on every field. RON tolerates them and missing ones break parses.
- `Light((...))` for the light theme, `Dark((...))` for the dark theme. Mismatch will load but render wrong.

### Step 2 — Accent palettes (optional, recommended)
Generate `~/.config/cosmic/com.system76.CosmicSettings/v1/accent_palette_dark` and `accent_palette_light` to expose the candy hues in the Settings accent picker. The format is a list of `Srgba`:

```ron
[
    (red: 1.0, green: 0.372549, blue: 0.635294, alpha: 1.0), // pink
    (red: 1.0, green: 0.231373, blue: 0.419608, alpha: 1.0), // cherry
    (red: 0.372549, green: 0.831373, blue: 0.768627, alpha: 1.0), // mint
    (red: 1.0, green: 0.847059, blue: 0.301961, alpha: 1.0), // butter
    (red: 0.662745, green: 0.419608, blue: 1.0, alpha: 1.0), // grape
    (red: 0.372549, green: 0.721569, blue: 1.0, alpha: 1.0), // sky
]
```

For the light palette, swap to the deepened variants from the light theme RON.

### Step 3 — Run the installer
```bash
chmod +x install.sh
./install.sh --dry-run        # preview
./install.sh                  # for real
```

It copies the three RONs and three PNGs to the right places. Idempotent. `--uninstall` undoes it.

### Step 4 — Apply in COSMIC Settings
1. `Settings → Desktop → Appearance` → click `Import`, browse to `themes/candyfactory-bonfire-dark.ron` (or `-parlor-light.ron`). The theme appears in the list — select it.
2. `cosmic-term → View → Color schemes → Import` → pick `themes/candyfactory-term-bonfire.ron`.

### Step 5 — Sanity-check the live desktop
- Open a libcosmic app (Files, Settings, Terminal). Cards should sit on the right surface tone, buttons should use the accent color.
- Right-click an inactive window. The outline on the focused window should be the `window_hint` color (grape on Bonfire, pink on Parlor).
- Toggle a tile layout (`Super + Y`). Gaps should be visible (`gaps: (4, 8)`).
- Open `Settings → Desktop → Appearance → Accent color`. The full candy palette should appear if you wrote the accent palette in Step 2.

If anything renders wrong: `journalctl --user -u cosmic-comp -f` shows config parse errors at theme load.

---

## 7 · What's optional (and what's out of scope for v1)

| Item                        | Status   | Notes                                                                  |
|-----------------------------|----------|------------------------------------------------------------------------|
| GTK theme for legacy apps   | Optional | COSMIC bridges to GTK; for now, GNOME apps will inherit accent only.   |
| Custom icon theme           | Skip     | Big lift. Stub a `candy-icons/` folder if asked; do not invent icons.  |
| Cursor theme                | Optional | Recommend `Bibata-Modern-Classic` or fork w/ pink. Don't ship one.    |
| Greeter / login screen      | Skip     | `cosmic-greeter` styling is not yet themable.                         |
| GNOME Shell themes          | Skip     | We are COSMIC-native. Don't try to be both.                           |

If the user asks for any of the above, point them back to this file and let them decide before you do speculative work.

---

## 8 · Rules of engagement

- **Never invent colors.** If you need a shade not in §3, mix in CSS `color-mix(in oklab, ...)` style on paper first, get the user's sign-off, *then* add it to §3 with a hex code.
- **Never round corners past `radius_l = 18px`.** The brand is hard-offset shadows, not rounded glass.
- **Never set `is_frosted: true`.** No glassmorphism. Ever.
- **Never substitute system fonts.** If the user mentions fonts at all, point them at `Fredoka 700 / Lato / IBM Plex Mono` from Google Fonts and explain that COSMIC reads its default UI font from `~/.config/cosmic/com.system76.CosmicTk/v1/`. We don't change it without a separate ask.
- **Show your work.** When you finish, print the diff of files written and which COSMIC config paths now have CandyFactory content. The user should be able to verify with `tree ~/.config/cosmic`.

---

## 9 · Voice

If you write any user-facing copy (README, install messages, error messages), match the parlor voice:

- Stoic, plain, slightly tactile.
- Mono labels uppercase with wide letter-spacing.
- Section headers prefixed with `§ `.
- Sample diction: *"Sweets, baking. Stay close."* · *"Conveyors warm."* · *"Stay close, the doors open soon."*
- Avoid hype words. No "stunning," "delightful," "amazing." We're a confectioner who happens to ship code.
- Emoji are content not chrome — allowed inline: 🍬 (sugar) 🍭 (batch) 🔥 (burn) 💚 (quality).

---

That's the spec. Begin with §6 Step 1. Print what you intend to do before changing anything. If something in §5 looks wrong, ask before you fix it — these mappings have already been argued over.
