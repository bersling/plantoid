# Plantoid Simulator

A software recreation of **Plantoid**, the programmable LED tree at Swiss Science Center
Technorama, Winterthur (exhibit 11938, OG 2 "Et Cetera"). Unofficial; the original is by
Digital Winterthur and Technorama, with block programming by smoca AG.

Live: https://bersling.github.io/plantoid/

Or open `index.html` in a browser, or serve the folder (`python3 -m http.server`) and open it.
Everything is one file. three.js and Blockly load from CDNs.

The interface is in Swiss German (no "ß") and written for kids, following the exhibit's own
"Leichte Sprache" sheet: strips are called "Äste", blocks have icons and simple wording
("färbe Ast 3 …", "immer wieder", "wenn … dann"), a 4-step "So geht's" guide opens on the
first visit, and the examples are marked leicht / mittel / knifflig. Function names in text
mode stay English (`setPixel`, `fill`, …), as in real programming languages.

## Facts from the exhibit sheet (Technorama `Plantoid_DEFIL.pdf`)

- 22 light strips, numbered 0–21.
- 476 pixels across all strips, numbered 0–475. Each pixel is a section of RGBW LEDs.
- Visitors program it with blocks on a lectern touchscreen. The categories are Light (Licht),
  Colour (Farbe), Control (Steuerung), Logic, Math and Variables. Examples can be loaded and
  changed, blocks go into a backpack (Rucksack) to save them, a broom clears the screen, and
  you can switch from blocks to text code.

## How the simulation maps to that

- Pixels run strip by strip, each strip from its base in the trunk to its tip. Strips are
  numbered left to right. The 476 pixels are shared over the strips by length, so every
  pixel is the same physical length (about 13 cm).
- The tree shape is defined in `SPEC` in `index.html`: nested bundles of strips that peel
  apart. A child bundle takes consecutive strips; lower numbers branch further left.
- Rendering: three.js. The pixel buffer (476 × RGBW bytes) is uploaded as a texture each
  frame, a shader draws each strip as a neon-flex tube with faint segment seams, bloom does the
  glow, and point lights take the tree's current colours so the pedestal and floor pick them up.
- Programs (from blocks or text) compile to async JavaScript. `wait()` resolves on the
  animation clock, every loop gets an `await __trap()` so an endless loop can't freeze the
  page, and separate block stacks run in parallel through `start()`.

## Text API

| Group  | Commands |
|--------|----------|
| Light  | `fill(c)`, `setPixel(i, c)`, `setPixels(from, to, c)`, `setStrip(s, c)`, `setStripPixel(s, k, c)`, `off()`, `fade(percent)`, `brightness(percent)`, `getPixel(i)` |
| Colour | `hsv(h, s, v)`, `rgbw(r, g, b, w)`, `rgb(r, g, b)`, `white(percent)`, `randomColour()`, `blend(c1, c2, ratio)`, `dim(c, percent)`. Colours are hex strings; an 8-digit hex carries the white channel. |
| Tree   | `PIXELS` (476), `STRIPS` (22), `stripLength(s)`, `stripStart(s)`, `stripOf(i)`, `heightOf(i)` 0–100, `posOf(i)` 0 base…100 tip, `xOf(i)` −100 left…100 right |
| Time   | `await wait(seconds)`, `await frame()`, `time()`, `start(async () => {…})` |

## Publishing as a claude.ai artifact

`./build-artifact.sh` writes `dist/plantoid.html`, which is `index.html` without the
doctype/html/head/body wrapper (the artifact host adds its own).
