# Novaceris factory map

Clickable 3D map of the Novaceris sanitaryware plant for the "Perfect Production for Sanitaryware" demo. Guided mode opens with four intro slides (the company, its business challenge, how Perfect Production answers it, and the team), then walks through ten steps played by three people (Elena, VP Manufacturing; Priya, Industrialization Engineer; Kenji, Robotics Engineer); Explore mode shows the finished plant. Each step has an Experience card over the plant: the Experience, the business challenge, the brand, and what is live or on video. The 3DEXPERIENCE compass over the plant is switched off for now (`SHOW_COMPASS` in `index.html` brings it back).

The page follows the layout of the Dassault Systèmes web site: a white top bar with Novaceris and "Powered by The 3DEXPERIENCE Platform", a dark title band with Back and Next and a rail of every step (click one to jump to it), flat cards with small spaced capitals for labels, and large light headings. On a laptop or desktop the page fits the window and does not scroll: the plant takes most of it, and the side panel shows the person, their question and what is shown live or on video, with the details folded into **Presenter notes**. Labels on the plant mark what is new or has moved. The colours and the font (Inter) are neutral stand-ins; see **Brand style** below for the real ones. **Day** and **Night** under **Settings** switch between a light and a dark page; until one is picked the page follows the computer's setting, and the pick is remembered.

**Present the intro full screen** with the **Full screen** button on the intro, or **Present the intro full screen** on the right. The slides fill the screen over the slowly turning plant. Next, Back, the arrow keys and a presentation clicker (Page Up / Page Down) move through them; starting Step 1 or pressing Esc returns to the normal view.

The plant is at work: WCs ride the glazing lines, kiln cars and the packing conveyor, frames ride the frame line, the glazing robots move, the small weld-cell robots weld with sparks while the big ones pick and place the frame, forklifts drive the warehouse and the area by glazing, and people walk the aisles.

**Ambiance** (under **Settings**) puts the plant in a landscape with sunlight and shadows, kiln glow and people. Turn it off on a slower laptop: the plant then stands on a plain sky gradient without shadows, and the machines still move. The choice is remembered on that computer. If nobody has chosen and the computer draws the plant slowly, the page turns ambiance off by itself and says so. The landscape is [Rooitou Park](https://polyhaven.com/a/rooitou_park) from Poly Haven (CC0), in `env/`.

**Booth mode** (or **Full screen** on the plant) fills the screen with the finished plant and tours its cells on its own. **Back** and **Next** (or the arrow keys and a clicker) move the tour by hand, and it carries on from there; Esc or **Exit booth mode** leaves it. With reduced motion set in the operating system, the plant only moves in booth mode.

The plant changes twice. At Step 3 the raw-material racks move into the mill room in slip preparation, the experience room moves out next to the office, and the frame line (including the frame packaging machine) appears where they stood. Step 4, the flow simulation, plays in three beats on Next: glazing turns red at the target load, the robots go in (two double robot booths, two manual booths kept for quality control), and the re-run turns glazing green with the meter at 1,750. The experience room is the one in the model, which the page shows inside the plant until Step 3; the racks are simple shapes drawn by the page. The striped ground from the model is replaced with a plain surface.

## Run it on your laptop (localhost)

The demo runs entirely from this folder and needs no internet: three.js and the Inter font are included.

1. Download the folder (or **Code → Download ZIP** on GitHub and unzip it).
2. Double-click **`Start demo.bat`**. A small window opens and the browser shows the demo at http://localhost:8080. If that port is busy it takes the next free one (8081, 8082 …) and says so in the window.
3. Close the window to stop the demo.

Step links work the same way: `http://localhost:8080/#step=5` opens Step 5, so Iterop tasks can point there. Double-clicking `index.html` does not work, because browsers will not load the 3D code from a file; the page says so.

### Open it from other machines (your laptop's name)

To let others on the office network open the demo at your laptop's name, for example `http://lz15-aki61-ind:8080`:

1. Once: double-click **`Network setup (admin).bat`** and accept the administrator prompt. It allows port 8080 in Windows (a URL reservation and a firewall rule for office and private networks only, not public Wi-Fi).
2. Each time: start with **`Start demo (network).bat`** instead of `Start demo.bat`. The window lists the addresses others can use: the computer name, the full domain name and the IP address.

Your own browser still opens `http://localhost:8080`, which is the one to use inside a 3DDashboard: an https page may show `http://localhost` but blocks plain `http://` pages on any other name. If the name does not open on another machine, try the full domain name or the IP address from the window; if none works, the company network or firewall policy blocks incoming connections to laptops. Undo the setup with `netsh http delete urlacl url=http://+:8080/` and removing the firewall rule "Novaceris demo (TCP 8080)".

`Start demo.bat` runs `serve.ps1` with the PowerShell built into Windows; nothing is installed. If your laptop blocks PowerShell scripts, any local web server in this folder works, for example `python -m http.server 8080`.

If the page does not load:

- Use the exact address printed in the window. When another program (a local Tomcat, for example) already holds 8080, the demo runs on 8081 or higher and `localhost:8080` shows that other program.
- Keep the window open, and do not worry about clicking in it: the script switches off Windows' QuickEdit, which used to freeze the server when the window was clicked.
- Look at `server.log` in this folder. It records the start, the port, every missing file (`404 …`) and every error, including a company policy that runs scripts in constrained mode, which blocks the server.
- With Python as a fallback server, check that `.js` files arrive as JavaScript (F12 → Console). Some Windows setups make Python send them as `text/plain`, and the browser then refuses to run the 3D code.

- `index.html`: the page
- `factory.glb`: the plant model, compressed with meshopt and WebP textures
- `env/rooitou_park_1k.hdr`: the landscape around the plant (1.6 MB, loaded only with ambiance on)
- `vendor/three/`: three.js 0.160.0 (MIT licence, in that folder)
- `fonts/InterVariable.woff2`: the Inter font (SIL Open Font License, `fonts/Inter-LICENSE.txt`)
- `Start demo.bat`, `Start demo (network).bat`, `serve.ps1`, `Network setup (admin).bat`, `network-setup.ps1`: the local web server for Windows

## Step videos, logos and persona photos

Videos and images stay on the presenting laptop; the page only shows them, so logos and photos are never published with the public page. Open **Settings**, click **Media folder**, open the folder that holds them and click **Select folder**. The picker shows folders only, not the files inside; that is normal. The button then reads **Media: N/M videos, K images**.

Images are matched by file name (PNG, JPG, WebP or SVG); anything missing falls back to the built-in placeholder:

| File name | Where it shows |
|---|---|
| `novaceris-logo` | Optional: header and booth mode, in place of the built-in Novaceris logo |
| `3dexperience-compass` | The 3DEXPERIENCE compass, next to "Powered by The 3DEXPERIENCE Platform" at the foot of the side panel and in booth mode (`3dexperience-logo` also works) |
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
- Files named after their step (`step3.mp4`, `Step 6 - weld cell.mp4`, `step9.mp4`, steps 1 to 9) are placed automatically.
- MP4 (H.264), WebM, M4V, MOV, MKV, AVI or WMV; what plays depends on the browser, and H.264 MP4 is the safe choice.
- In Chrome or Edge the page remembers the folder; on the next visit, one click on **Reconnect media** re-grants access. Other browsers ask for the folder on each visit.

## Opening at a step

Add `#step=N` to the address (N from 0 to 10), for example `index.html#step=3`. The address follows the step as you click through, so a link in an Iterop task can bring the presenter back to that step on the map.
