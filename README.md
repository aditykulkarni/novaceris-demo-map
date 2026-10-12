# Novaceris factory map

Clickable 3D map of the Novaceris sanitaryware plant for the "Perfect Production for Sanitaryware" demo. Guided mode walks through eight persona steps; Explore mode shows the finished plant.

- `index.html`: the page (three.js from jsDelivr)
- `factory.glb`: the plant model, compressed with meshopt and WebP textures

## Step videos

Videos stay on the presenting laptop; the page only plays them. Click **Videos folder**, open the folder that holds them and click **Select folder**. The picker shows folders only, not the files inside; that is normal. The button then reads **Videos: N of M placed**.

- Any file name works. Each step card has a **Video for this step** list with every video found (subfolders included, two levels deep); the pick is remembered.
- Files named after their step (`step3.mp4`, `Step 5 - fixture.mp4`) are placed automatically.
- MP4 (H.264), WebM, M4V, MOV, MKV, AVI or WMV; what plays depends on the browser, and H.264 MP4 is the safe choice.
- In Chrome or Edge the page remembers the folder; on the next visit, one click on **Reconnect videos** re-grants access. Other browsers ask for the folder on each visit.

## Opening at a step

Add `#step=N` to the address (N from 0 to 8), for example `index.html#step=3`. The address follows the step as you click through, so a link in an Iterop task can bring the presenter back to that step on the map.
