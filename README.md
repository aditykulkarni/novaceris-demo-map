# Novaceris factory map

Clickable 3D map of the Novaceris sanitaryware plant for the "Perfect Production for Sanitaryware" demo. Guided mode opens with four intro slides (the company, its business challenge, how Perfect Production answers it, and the team), then walks through ten steps played by three people (Elena, VP Manufacturing; Priya, Industrialization Engineer; Kenji, Robotics Engineer); Explore mode shows the finished plant. Each step has an Experience card over the plant: the Experience, the business challenge, the brand, and what is live or on video. The 3DEXPERIENCE compass over the plant is switched off for now (`SHOW_COMPASS` in `index.html` brings it back).

The page follows the layout of the Dassault Systèmes web site: a white top bar with Novaceris and "Powered by The 3DEXPERIENCE Platform", a dark title band with Back and Next and a rail of every step (click one to jump to it), flat cards with small spaced capitals for labels, and large light headings. The colours and the font (Inter) are neutral stand-ins; see **Brand style** below for the real ones. **Day** and **Night** in the top bar switch between a light and a dark page; until one is picked the page follows the computer's setting, and the pick is remembered.

**Present the intro full screen** with the **Full screen** button on the intro, or **Present the intro full screen** on the right. The slides fill the screen over the slowly turning plant. Next, Back, the arrow keys and a presentation clicker (Page Up / Page Down) move through them; starting Step 1 or pressing Esc returns to the normal view.

The plant is at work: WCs ride the glazing lines, kiln cars and the packing conveyor, frames ride the frame line, the glazing robots move, the small weld-cell robots weld with sparks while the big ones pick and place the frame, forklifts drive the warehouse and the area by glazing, and people walk the aisles.

**Ambiance** (the switch in the header) puts the plant in a landscape with sunlight and shadows, kiln glow and people. Turn it off on a slower laptop: the plant then stands on a plain sky gradient without shadows, and the machines still move. The choice is remembered on that computer. If nobody has chosen and the computer draws the plant slowly, the page turns ambiance off by itself and says so. The landscape is [Rooitou Park](https://polyhaven.com/a/rooitou_park) from Poly Haven (CC0), in `env/`.

**Booth mode** (or **Full screen** on the plant) fills the screen with the finished plant and tours its cells on its own. **Back** and **Next** (or the arrow keys and a clicker) move the tour by hand, and it carries on from there; Esc or **Exit booth mode** leaves it. With reduced motion set in the operating system, the plant only moves in booth mode.

The plant changes twice. At Step 3 the raw-material racks move into the mill room in slip preparation, the experience room moves out next to the office, and the frame line (including the frame packaging machine) appears where they stood. At Step 7 the glazing cell becomes robotic, with two manual booths kept for quality control. The experience room is the one in the model, which the page shows inside the plant until Step 3; the racks are simple shapes drawn by the page. The striped ground from the model is replaced with a plain surface.

- `index.html`: the page (three.js from jsDelivr)
- `factory.glb`: the plant model, compressed with meshopt and WebP textures
- `env/rooitou_park_1k.hdr`: the landscape around the plant (1.6 MB, loaded only with ambiance on)

## Step videos, logos and persona photos

Videos and images stay on the presenting laptop; the page only shows them, so logos and photos are never published with the public page. Click **Media folder**, open the folder that holds them and click **Select folder**. The picker shows folders only, not the files inside; that is normal. The button then reads **Media: N/M videos, K images**.

Images are matched by file name (PNG, JPG, WebP or SVG); anything missing falls back to the built-in placeholder:

| File name | Where it shows |
|---|---|
| `novaceris-logo` | Optional: header and booth mode, in place of the built-in Novaceris logo |
| `3dexperience-logo` | Next to "Powered by The 3DEXPERIENCE Platform" |
| `brand-delmia`, `brand-catia`, `brand-netvibes` | Experience card, in place of the text badge |
| `persona-elena`, `persona-priya`, `persona-kenji` | Round photo on the step card and the team slide (square crops work best) |
| `intro-customer`, `intro-challenge`, `intro-answer` | Photo filling the lower part of intro slides 1 to 3 (landscape works best) |

Until a file is found, its place shows a placeholder: the intro slides and the team slide name the file to add, and the other placeholders name it when you point at them. After you pick the folder, the message lists the images still missing.

### Brand style

A file named `brand.css` in the media folder restyles the page on that laptop only, so brand colours and fonts are never published with the public page. It can set any of the page's variables, and `url(...)` in it loads a font file from the same folder. For example:

```css
@font-face { font-family: "Brand"; src: url(brand-regular.woff2); font-weight: 400; }
:root { --f-sans: "Brand", sans-serif; --accent: #...; --band: #...; --accent-band: #...; }
```

The main variables are `--accent` (buttons, labels), `--band` (title band, intro, card heads), `--accent-band` (accent on the dark band), `--ink`, `--bg`, `--surface` and `--f-sans`.

- Any file name works. Each step card has a **Video for this step** list with every video found (subfolders included, two levels deep); the pick is remembered.
- Files named after their step (`step3.mp4`, `Step 4 - fixture.mp4`, `step10.mp4`) are placed automatically.
- MP4 (H.264), WebM, M4V, MOV, MKV, AVI or WMV; what plays depends on the browser, and H.264 MP4 is the safe choice.
- In Chrome or Edge the page remembers the folder; on the next visit, one click on **Reconnect media** re-grants access. Other browsers ask for the folder on each visit.

## Opening at a step

Add `#step=N` to the address (N from 0 to 10), for example `index.html#step=3`. The address follows the step as you click through, so a link in an Iterop task can bring the presenter back to that step on the map.
