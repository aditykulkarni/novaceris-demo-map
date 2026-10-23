// The demo's steps. Shared by the map (index.html) and the editor (admin.html).
// exp: the Experience the step delivers. brand: the 3DEXPERIENCE brand behind it. chal: the business challenge it answers.
// show: what runs live on the platform in the demo and what is on video.
export const STEPS = [
  { n:1, short:"Capacity gap", tab:"Can we reach 600,000?", who:"Elena", role:"VP Manufacturing", at:[37, 23, -14], view:['office', 1.0],
    exp:"Business Insight Experience", brand:"NETVIBES", show:{ live:"Data Perspective, Plant performance" },
    chal:"The board wants 41% more output and a new product, and nobody can say yet what it costs or when it pays back.",
    quote:"The board wants 600,000 units a year and a modular wall-hung WC. I need to know what it costs, what it returns and what could go wrong.",
    does:"Data Perspective, Plant performance: output 1,190 a day against a demand plan of 1,681, OEE 66.5%, utilization by area. Elena starts the NPI process in Iterop.",
    kpis:["1,190 vs 1,681 units/day","68 s vs 48 s per unit","175,000 units/yr short"], done:"gap +491/day",
    hand:"Two asks for Priya: launch the wall-hung WC, and close the capacity gap.", focus:["office"] },
  { n:2, short:"MBOM", video:true, tab:"What exactly are we building?", who:"Priya", role:"Industrialization Engineer", at:[29, 17, -7], view:['office', 1.0],
    exp:"Manufacturing Definition Experience", brand:"DELMIA", show:{ live:"EBOM and MBOM loading", video:"MBOM creation" },
    chal:"A product the plant has never built: a wall-hung WC with its own steel frame and flush tank.",
    quote:"Engineering released the wall-hung WC. I have to turn it into something this plant can build.",
    does:"EBOM to MBOM, with the frame-height option applied. The MBOM shows two operations the plant has never done.",
    kpis:["Frame welding","Frame + tank assembly","No floor space for either"], done:"2 new ops",
    hand:"Two operations with nowhere to run. Next, Priya finds them floor space.", focus:["office"] },
  { n:3, short:"Layout", video:true, tab:"Where does the frame line go?", who:"Priya", role:"Industrialization Engineer", at:[-27, 6.5, -9], view:['plant', 1.0],
    exp:"Virtual Factory Experience", brand:"DELMIA", show:{ video:"Plant layout and catalog reuse" },
    chal:"No free floor space for a new frame line, and no budget for a new building.",
    quote:"The space is already in the plant. It's full of racks that sit in the wrong place.",
    does:"Plant Layout Design: the raw-material racks move into slip preparation, next to the mills that use them, and the modular experience room moves next to the office. IP Classify and Reuse inserts the company's standard robotic arc welding cell.",
    kpis:["Racks at point of use","Experience room by the office","Standard weld cell reused"], done:"frame line placed",
    hand:"The new layout, to the flow simulation.", focus:["cut","weld","asm"] },
  { n:4, short:"Flow simulation", video:true, sim:true, tab:"Can the new plant make 1,681 a day?", who:"Priya", role:"Industrialization Engineer", at:[-25, 6, 0], view:['line', 1.0],
    exp:"Factory Simulation Experience", brand:"DELMIA", show:{ video:"Factory flow simulation: today's plant, then with robotic glazing" },
    chal:"Prove the plant reaches 1,681 good WCs a day, and find what stops it, before any money is spent.",
    quote:"Same plant, the target load. Show me where it breaks, then prove the fix before anyone buys a robot.",
    does:"Factory Flow Simulation in three beats: today's process at the 1,681 load stays at 1,190 a day; glazing is the constraint, with the manual booths at 100%; Glazing v2 (4 robots, 2 QC booths) swapped in and re-run reaches 1,750 good units a day, if QC on a robot-glazed WC takes 50 s or less (150 s on a hand-glazed one), because the robot coat is more even. Kilns are next, at about 720,000 a year.",
    kpis:["1,190 → 1,750 units/day","Manual glazers at 100%","Targets: 150 s glazing, 50 s QC"], done:"1,750/day",
    hand:"Three targets to Kenji: 150 s per WC per glazing robot, the weld cell inside the 161 s frame takt, and a coat even enough for 50 s QC.", focus:["glaze","kiln","cast","slip"],
    aisha:"Aisha and her colleagues in the manual booths spray at 100% utilization. The line runs at their pace because there is no slack." },
  { n:5, short:"Weld fixture", video:true, tab:"Will the fixture hold the frame?", who:"Kenji", role:"Robotics Engineer", at:[-5.6, 5.5, -4.6], view:['weld', 1.0],
    exp:"Equipment Design Experience", brand:"CATIA", show:{ video:"Fixture kinematics and clamp sequence" },
    chal:"A new weld fixture has to hold the frame right the first time; a wrong fixture means every weld is wrong.",
    quote:"If the frame isn't held right, every weld is wrong.",
    does:"Equipment Design: the frame holding fixture with forward kinematics, and the clamp and positioning sequence simulated collision-free. Steps 5 and 6 are one weld cell task in Iterop.",
    kpis:["Fixture kinematics","Clamp sequence collision-free","Frame positioned for welding"], done:"fixture proven",
    hand:"A fixture that holds the frame. Next, the whole weld cell in takt.", focus:["weld"] },
  { n:6, short:"Weld cell", video:true, tab:"Can the weld cell build a frame in takt?", who:"Kenji", role:"Robotics Engineer", at:[-4.4, 5.5, -6.2], view:['weld', 1.0],
    exp:"Robot Programming Experience", brand:"DELMIA", show:{ video:"Weld cell robot programming" },
    chal:"Prove the catalog weld cell builds this frame inside its takt before a single robot is bought.",
    quote:"Five robots, one frame every 161 seconds. I have to prove the cell keeps up before anyone orders it.",
    does:"DELMIA robot programming of the five-robot cell: a loading robot brings the loose frame parts together on fixture 1, two robots arc-weld the frame, one pick-and-place robot turns it onto fixture 2 and the other hands it to the assembly line. Weld paths, reach, collisions and the cell cycle against the frame takt.",
    kpis:["138 s per frame vs 161 s takt","5 robots, no collisions","Weld paths reachable"], done:"138 s per frame",
    hand:"The frame cell holds its takt. Now the glazing robots.", focus:["weld"] },
  { n:7, short:"Glazing cell", video:true, tab:"Can robots glaze a WC in 150 s?", who:"Kenji", role:"Robotics Engineer", at:[-14.5, 6, 6], view:['glaze', 1.0],
    exp:"Robot Programming Experience", brand:"DELMIA", show:{ video:"Programming one robot cell", live:"The robot cell in 3DPlay, inside the dashboard" },
    chal:"Glazing skill is scarce and manual spraying caps output; each robot must glaze a whole WC within the 150 s the simulation assumed.",
    quote:"One robot, one WC, start to finish. Program one cell, prove it on screen, and the other three run the same program.",
    does:"Robot glazing: spray trajectories on the exterior, interior and rim for one robot station, with cycle time checked; Robot Surface Simulation shows a glaze thickness map over the exterior, interior and rim, proving the coat is even enough for 50 s QC. The other three run the same program. Two booths stay manual, for quality control only. Kenji's weld and glazing work run in parallel in Iterop and meet at a check that cycle times and coat uniformity are within Step 4's targets.",
    kpis:["150 s per WC (limit 178 s)","Even coat: 50 s QC","Cycle times and coat in target"], done:"150 s per WC",
    hand:"Cycle times and coat proven. Next, the people on the new line.", focus:["glaze"],
    aisha:"Robots take the spraying. Aisha moves to quality control, where her eye for a glaze defect matters most." },
  { n:8, short:"Work instructions", video:true, tab:"Can a new operator build it on day one?", who:"Priya", role:"Industrialization Engineer", at:[15.7, 5, 3.5], view:['asm', 1.0],
    exp:"Work Instruction Experience", brand:"DELMIA", show:{ live:"Work instruction review", video:"Work instruction creation" },
    chal:"Operators have to be trained on a line that does not exist yet.",
    quote:"New operators start before the line exists. They need to be right on day one.",
    does:"3D work instructions for the frame and flush tank assembly, built from the operations Priya defined in Step 2, shown in the operator view.",
    kpis:["[number of steps]","[training time]"], done:"instructions ready",
    hand:"A line ready to staff, and every number Elena asked for.", focus:["asm"],
    aisha:"Two of Aisha's former colleagues move to the new assembly line and learn it here." },
  { n:9, short:"Business case", tab:"Is it worth it?", who:"Elena", role:"VP Manufacturing", at:[27, 23, -22], view:['plant', 1.0],
    exp:"Business Insight Experience", brand:"NETVIBES", show:{ live:"Data Perspective, Capacity investment review" },
    chal:"Approve an investment on simulated, proven numbers, and decide whether to bet on modular construction.",
    quote:"Every target I asked for now has a number. Is it worth it?",
    does:"Capacity investment review: three options side by side. Glazing v2 with the wall-hung line costs €19.8M, adds €9.2M EBITDA a year and pays back in August 2030 (IRR 37%). A new hall costs €32M and never pays back. The wall-hung edge over glazing alone holds only if the systems sell: at 60,000 a year instead of 120,000 the two are worth the same.",
    kpis:["€19.8M capex","+€9.2M EBITDA a year","Payback Aug 2030 · IRR 37%"], done:"payback Aug 2030",
    hand:"Decision: Glazing v2 with the wall-hung line, a bet on modular construction.", focus:["office"] }
];

// Fields the editor can change. show.video and show.live are edited as "video" and "live".
export const FIELDS = [
  ['short', 'Tab name'], ['tab', 'Question'], ['who', 'Persona'], ['role', 'Persona role'],
  ['exp', 'Experience'], ['brand', 'Brand'], ['chal', 'Business challenge'], ['quote', 'Persona quote'],
  ['live', 'Live on the platform'], ['video', 'On video'], ['does', 'On the platform (presenter notes)'],
  ['kpis', 'On screen, one per line'], ['done', 'Done label on the step rail'], ['hand', 'Hands off'], ['aisha', 'Aisha, glazing operator'],
];
export const EDITS_FILE = 'demo-config.json';         // edits saved with the demo, next to index.html
export const PREVIEW_KEY = 'novaceris-admin-preview';  // edits previewed in this browser only
export const LINKS_KEY = 'novaceris-tab-links';        // per-step tab links, kept in this browser only (never in the public repo)

export function getField(s, k) { return k === 'video' || k === 'live' ? (s.show || {})[k] : s[k]; }
export function setField(s, k, v) {
  if (k === 'video' || k === 'live') { s.show = { ...(s.show || {}) }; if (v) s.show[k] = v; else delete s.show[k]; }
  else if (v === undefined || v === '') delete s[k]; else s[k] = v;
}
// edits: { steps: { "4": { quote: "...", kpis: [...] } } }. Only known fields of existing steps are applied.
export function applyEdits(steps, edits) {
  const keys = new Set(FIELDS.map(f => f[0]));
  for (const [n, e] of Object.entries((edits && edits.steps) || {})) {
    const s = steps.find(x => x.n === +n); if (!s || !e || typeof e !== 'object') continue;
    for (const [k, v] of Object.entries(e)) {
      if (!keys.has(k)) continue;
      if (k === 'kpis') { if (Array.isArray(v)) s.kpis = v.map(String).filter(Boolean); }
      else if (typeof v === 'string') setField(s, k, v);
    }
  }
}
export async function loadEdits() {
  let file = null, preview = null;
  try { const r = await fetch(EDITS_FILE, { cache: 'no-store' }); if (r.ok) file = await r.json(); } catch (e) {}
  try { preview = JSON.parse(localStorage.getItem(PREVIEW_KEY)); } catch (e) {}
  return { file, preview };
}
export function loadLinks() { try { return JSON.parse(localStorage.getItem(LINKS_KEY)) || {}; } catch (e) { return {}; } }
export function saveLinks(l) { try { localStorage.setItem(LINKS_KEY, JSON.stringify(l)); } catch (e) {} }
