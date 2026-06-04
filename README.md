# 🍭 CandyFactory · Cotton Candy Parlor for COSMIC

A Pop!_OS 24.04 / COSMIC desktop theme set
based on the **CandyFactory** brand world.

> *Sweets, baking. Stay close.*

---

## § What's in the box

| File                                              | Purpose                                    |
|---------------------------------------------------|--------------------------------------------|
| `themes/candyfactory-bonfire-dark.ron`            | COSMIC dark theme — ink + pink + grape    |
| `themes/candyfactory-parlor-light.ron`            | COSMIC light theme — cream + grape + mint |
| `themes/candyfactory-term-bonfire.ron`            | cosmic-term color scheme — "candied dark" |
| `install.sh`                                      | One-shot installer (safe to re-run)        |
| `CLAUDE.md`                                       | Spec sheet for regenerating with Claude Code |

---

## § Install

There are two ways in. Use the script — manual Import is the fallback, not a
second step. You don't need both.

### The script — recommended

```bash
chmod +x install.sh
./install.sh --dry-run        # see what will happen
./install.sh                  # do it
```

The script copies the themes straight into COSMIC's config, so they show up
**already in the picker** — no Import needed. After it runs, in COSMIC:

1. `Settings → Desktop → Appearance` → pick **CandyFactory-Bonfire** (dark) or
   **CandyFactory-Parlor** (light) from the list.
2. `cosmic-term → View → Color schemes` → pick **CandyFactory Bonfire**.

### Manual Import — the alternative

If you'd rather not run the script, import the `.ron` files by hand:

1. `Settings → Desktop → Appearance` → **Import** → pick one of the `.ron` files
   in `themes/`.
2. `cosmic-term → View → Color schemes → Import` → pick
   `themes/candyfactory-term-bonfire.ron`.

To revert the script's install:

```bash
./install.sh --uninstall
```

---

## § Regenerating the theme

If you change the brand colors, type, or roundness, hand the directory to
**Claude Code**: `claude` in this directory, then ask it to *"re-build the COSMIC
theme per CLAUDE.md."* The spec sheet drives the whole rebuild — token table,
RON schema, installer rules, validation steps.

---

## § Credits

- Brand world: [candyfactory.ai](https://candyfactory.ai) · Cotton Candy Parlor.
- Theme schema: System76 COSMIC desktop ([github.com/pop-os/cosmic-epoch](https://github.com/pop-os/cosmic-epoch)).

§ Stay close.
