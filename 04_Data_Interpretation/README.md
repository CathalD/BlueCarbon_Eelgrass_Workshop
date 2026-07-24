# Part 4 — Data Interpretation

*From sediment samples to carbon-stock estimates.*

[← 3 — Field Methods](../03_Field_Methods/) · [Back to main guide](../README.md)

---

## Overview

This section covers what happens after the cores come out of the field: organizing your
field data, sending samples to a lab, understanding what the lab returns, analysing those
results, and interpreting them for reporting and planning. Here we follow WWF-Canada's field
guide (*Part 3: Sample Analysis* and *Part 4: Calculating Carbon Stocks*, pp. 15–19 of the
[Coastal Blue Carbon Field Guide](../Coastal-Blue-Carbon-Field-Guide-FINAL.pdf)), with a
dedicated [Lab Guide](Lab-Guide-Eng-2026.pdf) for the laboratory procedures, alongside
Howard et al. (2014), and using the `BlueCarbon` package in R.

After sampling, three steps take you from bagged samples to a reportable carbon estimate:

| # | Step | Answers | Covered in |
|---|------|---------|------------|
| 1 | **Organize data and get it analysed** | *How do I get my samples measured?* | [§1.1](#11-organizing-data-and-submitting-to-a-lab) · [§1.2](#12-expected-lab-results) |
| 2 | **Analyse the data** | *How do I turn lab numbers into carbon stocks?* | [§2 — the R workflow](#2-the-eelgrass-r-workflow) |
| 3 | **Report and use the results** | *How do I communicate and act on it?* | [§3](#3-reporting-and-using-the-results) |

> 🧭 **The worked example.** Throughout this section we follow a single dataset — six cores
> from a small inlet at **Tsawwassen Beach, BC** (plot `WWF-01`), three in **salt marsh** and
> three in **eelgrass**. Every table below is taken directly from that dataset, so you can
> follow one core all the way from a bagged sample to a carbon stock.

---

## 1.1 Organizing data and submitting to a lab

*What do I send, and to whom?*

Consider the data collected from the field in the previous module: we have bagged samples in
labelled Ziploc bags, and a completed data sheet.

> 📸 **[SCREENSHOT NEEDED]** — the bagged samples alongside the completed field data sheet,
> so the reader can see what "arriving back from the field" actually looks like.

### What comes back from the field

The paper datasheet records information at two levels, and the spreadsheet keeps them on two
separate tabs for exactly that reason: some things are true of the **whole core**, and some
are true of a **single slice**.

**Recorded once per core** — this is the *Plot & Core Log* tab:

| Field | What it is | Example (`WWF-01-A`) |
|---|---|---|
| Plot ID | The plot the core was taken in | `WWF-01` |
| Core ID | Unique identifier: site, plot, sampling location | `WWF-01-A` |
| Date / Time | When the core was taken | 2025-06-25, 11:32 |
| Study area / site | Location and stratum | Tsawwassen Beach — salt marsh |
| Latitude / Longitude | Coordinates of the core | 49.003354, −123.131287 |
| Photo series ID | Links the core to its photo record | `WWF-01-A-P` |
| Weather / tidal conditions | Context for the sampling day | Slightly overcast, 17 °C; low tide 18:02 (1.429 m) |
| Corer internal diameter (cm) | Sets the cross-sectional area — **measure it, don't assume it** | 7.62 |
| Outside depth (cm) | How far the corer was driven in (penetration) | 65.0 |
| Inside depth (cm) | Length of core actually recovered | 58.0 |

**Recorded once per slice** — this is the *Sample Data* tab:

| Field | What it is | Example (`WWF-01-A`, slice 1) |
|---|---|---|
| Core ID | Must match the Core Log exactly | `WWF-01-A` |
| Sample ID | Slice number, counting down from the surface | 1 |
| Top depth (cm) | Top of the slice, measured down the core | 0 |
| Bottom depth (cm) | Bottom of the slice | 5 |
| Notes | Texture, colour, roots, shell, rocks | Dense live root mat, dark brown silty clay |

Laid out as it appears in the spreadsheet, the six slices of core `WWF-01-A` look like this:

| Core ID | Sample ID | Top depth (cm) | Bottom depth (cm) | Notes |
|---|---|---|---|---|
| WWF-01-A | 1 | 0 | 5 | Dense live root mat, dark brown silty clay |
| WWF-01-A | 2 | 5 | 10 | Root mat thinning, dark brown silty clay |
| WWF-01-A | 3 | 10 | 15 | Fine roots, dark grey-brown silt |
| WWF-01-A | 4 | 15 | 25 | Occasional root fragments, grey silty clay |
| WWF-01-A | 5 | 25 | 40 | Grey silt, faint organic banding, few roots |
| WWF-01-A | 6 | 40 | 58 | Firm grey silt grading to fine sand at base |

Note two things about that table. The slices get **thicker with depth** — 5 cm near the
surface where carbon changes fastest, coarser further down — which is a deliberate sampling
choice, not an inconsistency. And the bottom depth of the last slice (58 cm) equals the
**inside depth** on the Core Log, which is a useful check that no slice went unrecorded.

### Calculating depth interval and volume

From these we have the **Sample ID**, the **top and bottom depth** of each slice, the **depth
the corer was inserted**, and any **notes**. From that we can calculate the **depth interval**
of each sample and the **volume** of each sample.

**Depth interval (cm)** = bottom depth (cm) − top depth (cm)

**Volume (cm³)** = depth interval (cm) × area of the circular face of the corer, where
area = π r²

Using a corer with a 7.62 cm (3″) internal diameter:

```
area = π × (7.62 / 2)²  =  π × 3.81²  =  45.60 cm²
```

So for each sample we multiply the depth interval by 45.60 cm² to obtain its volume in cm³.
A standard 2 cm slice therefore has a volume of 2 × 45.60 = **91.2 cm³**, matching the worked
example in the field guide (p.17).

Applied to core `WWF-01-A`, where the slices are of different thicknesses:

| Sample ID | Top (cm) | Bottom (cm) | Depth interval (cm)<br>*= bottom − top* | Volume (cm³)<br>*= 45.60 × interval* |
|---|---|---|---|---|
| 1 | 0 | 5 | 5 | 228.02 |
| 2 | 5 | 10 | 5 | 228.02 |
| 3 | 10 | 15 | 5 | 228.02 |
| 4 | 15 | 25 | 10 | 456.04 |
| 5 | 25 | 40 | 15 | 684.06 |
| 6 | 40 | 58 | 18 | 820.87 |

Both columns are calculated for you in the spreadsheet — you only ever type the top and
bottom depths.

> ⚠️ **Measure your actual internal diameter.** Nominal pipe size is not internal diameter —
> a "3-inch" Schedule 40 PVC pipe has an internal diameter noticeably larger than 7.62 cm, and
> wall thickness varies by schedule and supplier. Because volume enters the bulk-density
> denominator directly, an unchecked diameter propagates as a **systematic bias** into every
> bulk density, and therefore into every carbon stock, in the entire dataset. Measure the ID
> of the tubing you actually used with calipers and use that value.

### The digital data sheet

To make things easier, we have attached a spreadsheet where you can enter the field values
directly from the datasheet, and it will automatically populate the remaining columns.

**📊 [Open the digital data sheet in Google Sheets](https://docs.google.com/spreadsheets/d/1XMA_zaFNKtxCw2tAiQa3gHaIiT_wJAecmwW7Rz4hhaQ/edit?usp=sharing)**
· blank copy: [`files/Eelgrass_Carbon_DigitalData_BlankSheet.xlsx`](files/Eelgrass_Carbon_DigitalData_BlankSheet.xlsx)

The workbook has four tabs, following the same order as the workflow:

| Tab | What it holds | Do you type in it? |
|---|---|---|
| **1. Instructions** | Legend, colour key, units, and the field names the R pipeline expects | No |
| **2. Plot & Core Log** | One row per core — plot/core notes, corer diameter, insertion depths | Yes |
| **3. Sample Data** | One row per slice, in four bands: field · calculated · lab · calculated | Yes |
| **4. Core Summary** | Per-core totals, calculated automatically | No |

Only the **yellow cells** are for typing. Everything grey is a formula — the depth interval,
the volume, the compaction factor, and after the lab results arrive, the bulk density and
carbon stock. The compaction factor and corer diameter are looked up from the Core Log by
Core ID, so **the Core ID on the Sample Data tab must match the Core Log exactly**; if it
doesn't, those cells stay blank rather than silently using another core's geometry.

> 📸 **[SCREENSHOT NEEDED]** — the spreadsheet with the example rows filled in, showing which
> columns are typed by hand and which auto-calculate.

For every core sampling location, the calculation ultimately needs three things:
**sediment depth (cm)**, **dry bulk density (g/cm³)**, and **organic carbon (%)**.

- **Bulk density** can be measured with a scale and a drying oven.
- **Carbon analysis** requires more equipment, and at this stage samples are usually sent to a
  laboratory specializing in carbon analysis.

Samples should be frozen at −20 °C for storage, then thawed at 5–6 °C for 2–5 days, dried at
65 °C to a stable weight, and ground homogeneous before analysis. See the
[Lab Guide](Lab-Guide-Eng-2026.pdf) for the full procedure and packaging requirements.

> 🎥 **Watch:** [*"Core Sample Analysis"*](https://www.youtube.com/watch?v=BuLRrFD78Fs&list=PLLsjpJMfNDP5w78ZJNDUvMj1VoRG_qSwd&index=11) — workshop playlist
>
> 🎥 **Also:** [IORA Blue Carbon Hub — sample analysis](https://www.youtube.com/watch?v=_Zm9R-kGiE8&list=PL9pJDSsl2ZslDVZ5oZ5MFkykY2Kn9rDS8&index=6)

### Finding a lab

<details>
<summary><b>📋 Laboratories offering sediment carbon analysis</b> (click to expand)</summary>

<br>

<!-- TODO (Cathal): fill in as you confirm labs, quotes and turnaround. Keep the "quoted on" date so costs can be re-checked — prices go stale fast. -->

| Lab | Website | Contact | Analyses offered | Cost (per sample) | Quoted on |
|---|---|---|---|---|---|
| *(add lab)* | | | | | |
| *(add lab)* | | | | | |
| *(add lab)* | | | | | |
| *(add lab)* | | | | | |

**Notes when comparing quotes**
- Confirm whether the price is per sample or per batch, and whether it includes drying/grinding.
- Ask whether **inorganic carbon** is removed (acidification) or reported separately — this
  changes what "total carbon" means on your results sheet.
- Ask for the **method detection limit**; eelgrass sediments are often low-carbon and can sit
  near the limit of some methods.
- Ask whether **replicates and reference standards** are run, and whether you are charged for them.
- Confirm minimum sample mass and packaging, and whether they accept frozen or dried samples.

</details>

### What the lab needs — submitting samples

<!-- TODO (Cathal): confirm the specifics below against whichever lab you go with, and against the Lab Guide. -->

Before shipping, confirm the lab's own requirements — they vary. In general you will need to
provide:

- **The samples themselves**, labelled with the Core ID convention from
  [Section 3](../03_Field_Methods/) (site, plot, sampling location, depth interval).
- **A sample manifest** — one row per sample, matching the bag labels exactly. This is the
  same table you built in the spreadsheet above.
- **The analyses you want** — dry bulk density, organic carbon, and whether you also want
  inorganic carbon, total carbon, N, or isotopes.
- **Packaging and shipping arrangements** — frozen vs. dried, courier, and arrival timing so
  samples are not sitting at a loading dock over a weekend.

The manifest is simply the field columns plus the volume you calculated, which the lab needs
if they are also determining bulk density:

| Core ID | Sample ID | Top (cm) | Bottom (cm) | Volume (cm³) | Analyses requested |
|---|---|---|---|---|---|
| WWF-01-A | 1 | 0 | 5 | 228.02 | DBD, %C<sub>org</sub> |
| WWF-01-A | 2 | 5 | 10 | 228.02 | DBD, %C<sub>org</sub> |
| WWF-01-A | 3 | 10 | 15 | 228.02 | DBD, %C<sub>org</sub> |
| … | … | … | … | … | … |

> 📸 **[SCREENSHOT NEEDED]** — the example lab submission sheet from our *Practical
> Implementation Example*, filled in, so readers can see how the field datasheet transfers
> across.

The information you collected in the field transfers directly onto this submission sheet, so
the lab can perform the analysis and return results that map back onto your cores.

---

## 1.2 Expected lab results

*What comes back from the lab, and what does it mean?*

The lab returns two quantities per sample slice, which map onto the analysis inputs:

| Lab measurement | Analysis field | Notes |
|---|---|---|
| Organic carbon | `soc_g_kg` | Often measured by loss-on-ignition (LOI₅₅₀); for best accuracy the guide recommends total carbon on an elemental analyser (p.16) |
| Dry bulk density | `bulk_density_g_cm3` | Dry mass ÷ original sample volume (p.17) |

Coming back to core `WWF-01-A`, the lab returns the wet and dry weights and the carbon
concentration (the three yellow columns), and the spreadsheet calculates the rest:

| Sample | Volume (cm³) | Wet wt (g) | Dry wt (g) | %C | → Bulk density (g/cm³)<br>*= dry ÷ volume* | → Carbon density (g C/cm³)<br>*= BD × %C/100* | → Stock (g C/cm²)<br>*= C density × interval* |
|---|---|---|---|---|---|---|---|
| 1 | 228.02 | 299.28 | 95.77 | 6.20 | 0.420 | 0.0260 | 0.1302 |
| 2 | 228.02 | 304.03 | 109.45 | 5.40 | 0.480 | 0.0259 | 0.1296 |
| 3 | 228.02 | 298.60 | 125.41 | 4.30 | 0.550 | 0.0237 | 0.1182 |
| 4 | 456.04 | 598.54 | 287.30 | 3.20 | 0.630 | 0.0202 | 0.2016 |
| 5 | 684.06 | 912.07 | 492.52 | 2.30 | 0.720 | 0.0166 | 0.2484 |
| 6 | 820.87 | 1126.95 | 664.90 | 1.60 | 0.810 | 0.0130 | 0.2333 |
| | | | | | | **Core total** | **1.0613 g C/cm² = 10.61 kg C/m²** |

This is the field guide's equations 3–6 running down the table: carbon density per slice
(Eq 3), stock per slice (Eq 4), summed over the core (Eq 5), then ×10 into kg C/m² (Eq 6).
Notice the inverse pattern in the two lab columns — bulk density **rises** with depth as
carbon **falls**, which is the relationship described further down this page.

<details>
<summary><b>🔬 How the lab measures carbon</b> — LOI and elemental analysis (click to expand)</summary>

<br>

**Loss-on-ignition (LOI)**

LOI takes a dried and ground portion of each sample and burns it in a muffle furnace at
550 °C. Through this process the organic materials present in the sample (composed of what
used to be plant material) are ignited and converted into gaseous carbon dioxide and water,
which exit the furnace via a fume hood.

It is the same process that occurs when you make a campfire. The wood (organic material) burns
at its combustion temperature, converting the carbohydrates in the wood into CO₂ and H₂O.
What is left over in the morning is a pile of ashes — the non-organic material that does not
burn, or at least not at the same temperature.

By weighing the sample before and after, we know the mass of organic matter lost. Since we
know roughly how much of that organic matter is carbon, we can estimate organic carbon using a
**carbon conversion factor**.

> ⚠️ **The conversion factor is the weak link.** LOI measures *organic matter*, not carbon, so
> a factor is applied to convert one to the other. A commonly used value for seagrass sediments
> is ~0.43 (Fourqurean et al. 2012, for sediments with >0.2% OM), but the true ratio varies
> with organic-matter source and mineralogy. Clay-rich samples can also lose structural water
> at 550 °C, inflating apparent organic matter. If carbon numbers need to withstand scrutiny —
> for example for a credited project — validate LOI against elemental analysis on a subset of
> samples and report the relationship you used.

**Elemental analysis (CHN / CHNS)**

An elemental analyser measures carbon directly rather than inferring it from mass loss. A
small, precisely weighed aliquot of dried, ground sample (typically a few milligrams, sealed
in a tin capsule) is dropped into a combustion column at roughly 950–1150 °C in an
oxygen-enriched atmosphere. Everything combusts completely; the resulting gas stream is passed
through reduction and separation stages, and the CO₂, H₂O and N₂ produced are quantified —
usually by thermal conductivity detection — against standards of known composition.

Because each element is measured as its own gas, the instrument reports **total carbon**,
**hydrogen** and **nitrogen** as a percentage of sample dry mass in a single run. That gives
you more than just a carbon number:

- **Carbon (C)** — total carbon. If the sediment contains shell fragments or other carbonates,
  this includes inorganic carbon, so samples are usually **acidified** first (or inorganic
  carbon is measured separately and subtracted) to isolate organic carbon.
- **Nitrogen (N)** — lets you calculate the **C:N ratio**, which is a source indicator. Low
  C:N generally points to marine/algal or planktonic material; higher C:N points to vascular
  plant or terrestrial input. Paired with δ¹³C, this is how you distinguish carbon the meadow
  produced itself (autochthonous) from carbon it trapped from elsewhere (allochthonous) — a
  distinction that matters for crediting.
- **Hydrogen (H)** — largely a diagnostic of organic-matter type and combustion completeness;
  it is reported routinely but is used less often in blue carbon accounting.

The trade-off is cost and access: elemental analysis is more expensive per sample and requires
a specialized lab, whereas LOI is cheap and uses the same equipment already needed for bulk
density. A common compromise is to run **LOI on all samples and elemental analysis on a
representative subset**, then use the calibration to correct the LOI series.

</details>

For the most accurate results, samples should be sent to a laboratory for total carbon
measurement using an elemental analyser.

### What to expect from eelgrass sediments

Eelgrass sediments typically return **lower organic carbon** than salt-marsh or mangrove
soils, but the range is wide — spanning more than an order of magnitude between meadows, and
sometimes between cores in the same meadow. The values below are for gauging whether your
results are plausible, **not** for substituting for your own measurements.

**Organic carbon content, by ecosystem**

| Ecosystem | Typical %C<sub>org</sub> (dry mass) | Source |
|---|---|---|
| Salt marsh | mean 5.0%, median ~3.0% | EURO-CARBON database (Europe, all depths) |
| Seagrass / eelgrass | mean ~2.4%; temperate *Z. marina* average 1.4 ± 0.4% | EURO-CARBON; Röhr et al. 2018 |
| Bare / unvegetated marine sediment | mean 1.9%, median ~1.2% | EURO-CARBON database |

The ordering — **salt marsh > seagrass > bare sediment** — is consistent, but the
distributions overlap heavily. Across all habitats and depths the EURO-CARBON compilation
spans <0.1% to 41.6%, so a single value is close to meaningless without context.

**Spatial variation within eelgrass alone**

| Region | %C<sub>org</sub> | Stock context |
|---|---|---|
| Pacific coast of Canada (Clayoquot Sound, BC) | did not exceed 1.30% | stocks averaged 1,343 ± 482 g C m⁻² |
| Baltic Sea | 0.25 ± 0.21% | 635 ± 321 g C m⁻² |
| Kattegat–Skagerrak | 3.25 ± 2.78% | 3,457 ± 3,382 g C m⁻² |
| Four European regions (Portugal → Black Sea) | 2.79 ± 0.50% down to 0.17 ± 0.02% | Dahl et al. 2016 |
| Global temperate *Z. marina* (54 meadows) | 1.4 ± 0.4% | stocks 318–26,523 g C m⁻² (0–25 cm), mean 2,721 |

**The Canadian numbers are the relevant benchmark for this workshop:** BC eelgrass sediments
did not exceed 1.30% C<sub>org</sub>, with stocks well below global averages, attributed to
shallow rooting, patchy meadows, sandy sediment and shallow sedimentation. If your Atlantic
Canadian cores return values in the same broad range, that is expected — low numbers are a
real result, not a failed analysis.

**Variation with depth**

Do not assume carbon declines smoothly downcore. In a 141-core, 47-site global eelgrass
dataset, depth profiles fell into **three patterns** — organic carbon *increased*, *decreased*,
or showed *no distinct pattern* with depth. Profiles dominated by eelgrass-derived material
tended to be the high-carbon ones, while low-carbon profiles were dominated by planktonic and
macroalgal material.

Our worked example shows both behaviours: the marsh cores decline steadily with depth, while
eelgrass core `WWF-01-E` carries a **buried organic layer at 10–20 cm** where bulk density dips
and carbon rises again. A core like that is not an error to be smoothed away — it is a
depositional signal, and averaging it out of your profile discards real information.

The practical consequence: **extrapolating a whole-core stock from a shallow core is
unreliable**, which is exactly why the field guide insists on coring to the depth of refusal
([Section 3](../03_Field_Methods/)). Plot your own depth profiles before assuming any trend —
[`02_exploratory_analysis.R`](EelgrassWorkshop/02_exploratory_analysis.R) does this.

**Dry bulk density**

Bulk density is inversely related to organic carbon — organic-rich sediments are lighter and
more porous, mineral/sandy sediments are denser. Reported relationships between DBD and %C are
consistently negative (often exponential).

| Ecosystem | Typical DBD (g/cm³) | Source |
|---|---|---|
| Salt marsh, high marsh (BC) | 0.53 ± 0.14 | Boundary Bay, BC |
| Salt marsh, low marsh (BC) | 0.69 ± 0.16 | Boundary Bay, BC |
| Salt marsh (Mediterranean, by species) | 0.50–0.75 | Venice Lagoon |
| Sandy eelgrass meadow | *(add your measured values)* | — |

<!-- TODO (Cathal): the eelgrass DBD row still needs your real NFLD/BC measurements. I have deliberately NOT put the Tsawwassen worked-example numbers here — this is a literature comparison table and the example dataset is illustrative, not measured. -->

Because eelgrass meadows in Atlantic Canada are typically sandy, expect **higher** bulk
densities than the marsh values above. Note the compensating effect: low %C paired with high
bulk density can still yield a moderate carbon stock, since stock is their product. Judge the
stock, not either input alone.

> 📸 **[SCREENSHOT NEEDED]** — an example lab result sheet, with notes on how to read the
> columns and map them onto `soc_g_kg` and `bulk_density_g_cm3`.

### The worked example, end to end

Running all six Tsawwassen cores through the spreadsheet gives:

| Core | Stratum | Slices | Core depth (cm) | Mean DBD (g/cm³) | Mean %C | Stock (kg C/m²) |
|---|---|---|---|---|---|---|
| WWF-01-A | Salt marsh | 6 | 65 | 0.602 | 3.83 | 10.61 |
| WWF-01-C | Salt marsh | 6 | 72 | 0.572 | 4.25 | 11.98 |
| WWF-01-D | Salt marsh | 6 | 58 | 0.703 | 2.83 | 8.41 |
| WWF-01-B | Eelgrass | 5 | 30 | 1.216 | 0.78 | 2.16 |
| WWF-01-E | Eelgrass | 5 | 35 | 1.140 | 0.99 | 3.21 |
| WWF-01-F | Eelgrass | 4 | 26 | 1.300 | 0.51 | 1.33 |

Salt marsh averages **10.3 kg C/m²** and eelgrass **2.2 kg C/m²** — roughly a **4.6 : 1**
contrast, driven by the marsh's much higher carbon concentration more than offsetting its
lower bulk density. The eelgrass mean (2,232 g C m⁻²) sits comfortably inside the published
range for Pacific Canadian eelgrass quoted above.

Note that core depth differs by a factor of nearly three across the six cores, so these totals
are **not directly comparable to each other** until they are standardised to a common depth —
which is what [`03_depth_harmonization.R`](EelgrassWorkshop/03_depth_harmonization.R) is for.

> ⚠️ **Provenance.** The Tsawwassen dataset is a **teaching example**. The coordinates and
> layout are realistic and the values are constructed to sit within published ranges for BC
> salt marsh and eelgrass, but they are **not field measurements** and must not be cited as
> such. Cite the primary sources listed at the end of this page instead.

---

## 2. The eelgrass R workflow

*How do I turn lab numbers into carbon stocks?*

A complete, reproducible R pipeline takes the lab results through compaction correction,
depth harmonisation, carbon-stock estimation, and spatial interpolation.

**👉 See [`EelgrassWorkshop/`](EelgrassWorkshop/) — full documentation is in its
[README](EelgrassWorkshop/README.md).**

The pipeline in brief:

| Stage | Script | Does |
|-------|--------|------|
| Data prep | [`01_data_prep.R`](EelgrassWorkshop/01_data_prep.R) | Load, merge, and QC core data |
| Compaction correction | [`01b_compaction_correction.R`](EelgrassWorkshop/01b_compaction_correction.R) | Correct percussion-core compression (uses the field measurements from [Section 3](../03_Field_Methods/)) |
| Exploratory analysis | [`02_exploratory_analysis.R`](EelgrassWorkshop/02_exploratory_analysis.R) | Depth profiles, maps, summaries |
| Depth harmonization | [`03_depth_harmonization.R`](EelgrassWorkshop/03_depth_harmonization.R) | Standardise cores to common depths |
| Estimation | [`04_simple_extrapolation.R`](EelgrassWorkshop/04_simple_extrapolation.R) | Mean stocks + confidence intervals |
| Spatial analysis | [`05_kriging.R`](EelgrassWorkshop/05_kriging.R) | Interpolate stocks across the meadow |

The two columns the pipeline reads from the spreadsheet are `bulk_density_g_cm3` and
`soc_g_kg`, which are named exactly that way on the *Sample Data* tab so the sheet can be
exported and loaded without renaming anything.

A pre-rendered report — [`EelgrassWorkshop/eelgrass_carbon_report.html`](EelgrassWorkshop/eelgrass_carbon_report.html)
— walks through the whole analysis and can be opened in any browser without running R.

> 📸 **[SCREENSHOT NEEDED]** — a rendered plot from the pipeline (e.g. the SOC depth
> profile from [`02_exploratory_analysis.R`](EelgrassWorkshop/02_exploratory_analysis.R)
> or a kriging map from [`05_kriging.R`](EelgrassWorkshop/05_kriging.R)), plus a screenshot
> of the rendered `eelgrass_carbon_report.html`.

### How the carbon-stock formula relates to the guide

The single line the pipeline uses is the field guide's equations 3–6 (pp. 17–18) combined:

```
Carbon stock (kg C/m²) = SOC (g/kg) × bulk density (g/cm³) × layer thickness (cm) ÷ 100
```

Per slice, the guide computes sediment carbon density = bulk density × (%C ⁄ 100),
multiplies by the depth interval to get g C/cm², sums the slices, and ×10 to reach
kg C/m². Because organic carbon in g/kg is ten times %C, that whole chain reduces to the
one formula above — then summing slices per core, averaging across cores, and scaling by
area gives the site total (guide equations 7–10).

> 🧮 **Compaction corrects depths, not stocks.** The carbon stock of a slice uses the
> **measured** depth interval, not the decompacted one. The dry mass in the tube already came
> from a taller in-situ column, so applying the compaction factor a second time would
> double-count it. The corrected depths exist to tell you *which in-situ depth each slice
> represents*, which is what depth harmonisation needs. A useful check: the deepest corrected
> depth should equal the outside (penetration) depth on the Core Log — for `WWF-01-A`,
> 58 cm recovered × 1.121 = 65 cm penetrated.

---

## 3. Reporting and using the results

*How do I communicate and act on the numbers?*

<!-- TODO (Cathal): this section is a skeleton — the headings below are my read of what belongs here based on the workshop's arc. Add, cut or reorder. -->

Once stocks are estimated, the final step is turning them into something a partner, funder or
regulator can act on.

**What to report**

- Carbon stock with an explicit **uncertainty estimate**, not a bare point value.
- The **depth interval** the stock refers to (e.g. 0–30 cm vs. to depth of refusal) — stocks
  are not comparable without it.
- **Sample sizes**: number of cores, number of slices, and how many sites they represent.
- **Methods**: LOI or elemental analysis, and any conversion factor applied.

**Interpreting the numbers**

*(to be written)*

**Communicating with partners**

*(to be written)*

> 📸 **[SCREENSHOT NEEDED]** — an example summary figure or one-page results summary from the
> Practical Implementation Example.

---

## References for the expected-values section

- Dahl, M. et al. (2016). Sediment properties as important predictors of carbon storage in *Zostera marina* meadows: a comparison of four European areas. *PLoS ONE*.
- EURO-CARBON: a marine and salt marsh sediment organic carbon database for European regional seas (2025). *Data in Brief*.
- Kindeberg, T. et al. (2019). Variation of carbon contents in eelgrass (*Zostera marina*) sediments implied from depth profiles. *Biology Letters* 15: 20180831. DOI: 10.1098/rsbl.2018.0831
- Postlethwaite, V.R. et al. (2018). Low blue carbon storage in eelgrass (*Zostera marina*) meadows on the Pacific Coast of Canada. *PLoS ONE*. DOI: 10.1371/journal.pone.0198348
- Röhr, M.E. et al. (2018). Blue carbon storage capacity of temperate eelgrass (*Zostera marina*) meadows. *Global Biogeochemical Cycles* 32: 1457–1475. DOI: 10.1029/2018GB005941
- Gailis, M. et al. / Boundary Bay salt marsh blue carbon studies (BC) — for marsh dry bulk density comparisons.
- Howard, J. et al. (2014). *Coastal Blue Carbon: Methods for assessing carbon stocks and emissions factors.*

<!-- TODO (Cathal): tidy these into your preferred citation style and confirm the Boundary Bay reference you want to use. -->

---

## In this section

- [`EelgrassWorkshop/`](EelgrassWorkshop/) — the R analysis pipeline (with its own detailed README).
- [`files/Eelgrass_Carbon_DigitalData_BlankSheet.xlsx`](files/Eelgrass_Carbon_DigitalData_BlankSheet.xlsx) — blank digital data sheet.
- [`Lab-Guide-Eng-2026.pdf`](Lab-Guide-Eng-2026.pdf) — WWF-Canada laboratory procedures guide.
- `images/` — lab result screenshots and analysis figures.

> **Iteration note:** the R pipeline under `EelgrassWorkshop/` was left untouched in this
> docs pass. Language is aligned to the field-guide PDF (pp. 15–19); video callouts use the
> direct per-video URLs. Tables in Section 1 are generated from the Tsawwassen worked example
> so they stay consistent with the spreadsheet.
