# Workshop TODO — gaps to fill

A running checklist of everything the workshop still needs from you. Grouped by page.
Items are things only you can supply (photos, real data, lab quotes, video IDs) or
decisions to make. Tick them off as you go.

Legend: 📸 image/screenshot needed · 🔗 link needed · ✍️ writing needed · 📊 data needed · ❓ decision needed

---

## Landing page (`README.md`)

- [ ] ✍️ Add the **"Eelgrass Workshop Skills Checklist"** (placeholder comment near the Objectives list).
- [ ] ❓ Confirm the flipped ordering reads right: the two jobs are now listed **Making the data useful → Collecting the data** (plan-then-collect), to match the Section 2 → 3 order.

## Part 1 — Background (`01_Background/README.md`)

- [ ] ❓ The three carbon-curve GIFs are now wired to `images/download (Null).gif`, `download (pulse).gif`, and `download.gif`. Confirm each caption matches the correct animation (baseline equilibrium / single disturbance+recovery / pulse+press collapse).
- [ ] 🗑️ `images/download (1).gif` is unused — delete it or wire it in if it belongs somewhere.

## Part 2 — Project Planning (`02_Project_Planning/README.md`)

- [ ] 🔗 Step 1: Google Earth Engine boundary-drawing tool — replace *(link to be added)*.
- [ ] 🔗 Step 2: remote-sensing / auto-stratification method — replace *(links to be added)*.
- [ ] 🔗 Step 5 video callout: swap the playlist link for the **direct** *"Site Selection and Required Materials"* video URL.
- [ ] ❓ **Two sheets or three?** The intro says the calculator has *three sheets* but only Sheet 1 and Sheet 2 are documented. Either add a "Sheet 3" description or change the count to "two sheets."
- [ ] 📸 A small screenshot/GIF of the calculator's **"check precision after survey"** cells (SE / t-value / relative precision rows) to sit under the post-survey RME section.
- [ ] 📸 **Margin-of-error comparison** (new "See it for yourself" block in Step 4): calculator at ±20% vs ±10% side by side, *n* readout circled (~17 vs ~68).
- [ ] 📸 **Variability comparison** (same block): a smooth vs patchy meadow at the same target precision, showing *n* roughly quadruple as CV goes 0.5 → 1.0.
- [ ] ❓ Worked example precision target: currently standardised to **±10% → ~68 cores → ~98 padded** throughout. Confirm this is the intended target (an earlier draft had ±20% / ~38, which isn't internally consistent — see the inline comment).

## Part 3 — Field Methods (`03_Field_Methods/README.md`)

- [ ] 📸 **NFLD corer photos** for the underwater / stop-cap section.
- [ ] 📸 A real field photo in **each of the 5 coring steps** (left-hand cells currently say *[Paste field photo]*).
- [ ] 📸 A workshop photo of the team coring / extruding, to anchor the "Extrude and section" step.
- [ ] 🔗 **Core Depths** video (step 1): needs its own direct URL — the old link pointed at the same clip as "Site Selection." Currently linked to the playlist with the position flagged.
- [ ] 🔗 **DIY extrusion-device blueprint PDF** — replace *(link to be added)*.

## Part 4 — Data Interpretation (`04_Data_Interpretation/README.md`)

- [ ] 📸 Bagged samples next to the completed field data sheet ("arriving back from the field").
- [ ] 📸 The digital data sheet with example rows filled in, showing typed vs. auto-calculated columns.
- [ ] 📸 The example lab **submission** sheet, filled in.
- [ ] 📸 An example lab **result** sheet, with notes on mapping columns onto `soc_g_kg` / `bulk_density_g_cm3`.
- [ ] 📸 A rendered plot from the R pipeline (SOC depth profile or kriging map) + a screenshot of `eelgrass_carbon_report.html`.
- [ ] 📸 An example summary figure / one-page results summary.
- [ ] 📊 **Lab directory table** — add real labs: website, contact, analyses, cost per sample, "quoted on" date.
- [ ] 📊 **Sandy eelgrass DBD row** in the bulk-density table — add your real NFLD/BC measured values.
- [ ] ✍️ **§3 "Reporting and using the results"** — "Interpreting the numbers" and "Communicating with partners" are both *(to be written)*. This is the workshop's closing beat.
- [ ] ✍️ Tidy the **References** into your preferred citation style; confirm the Boundary Bay reference.

## R pipeline (`04_Data_Interpretation/EelgrassWorkshop/`)

- [ ] ⚠️ **Re-render the report.** `eelgrass_carbon_report.qmd`/`.html` still reflects the previous dataset and the old compaction schema. Re-render against the Tsawwassen data + new compaction model.
- [ ] ❓ `Untitled.R` is referenced as the "run the whole pipeline" script — consider renaming it something descriptive (e.g. `run_pipeline.R`, which the Worked_Example README already calls it).
- [ ] ❓ Data dictionary examples still use old IDs (`EG01`, stratum `SG` only) — align with the Tsawwassen `WWF-01-x` / `SM`+`SG` dataset.

---

## Enhancements — implemented

- [x] **Sample Size Visualizer to *show* the math** (Part 2): added a "What drives sample size?"
  table with rough approximations (E, CV, confidence, area) and a "See it for yourself" block.
  Remaining: supply the two comparison screenshots listed under Part 2 above.
- [x] **Reorganized Part 2** (A + B + C): roadmap table moved up front; sampling theory trimmed to
  a short primer; all how-many-samples math consolidated into Step 4; steps rebuilt as uniform
  side-by-side cards each opening with the question they answer.
