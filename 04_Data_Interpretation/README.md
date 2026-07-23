# Part 4 — Data

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

After sampling there are three next steps we will cover:

1. **Organizing data and getting it analysed** — [Organizing data + submitting to a lab](#11-organizing-data-and-submitting-to-a-lab) · [Expected lab results](#12-expected-lab-results)
2. **Data analysis** — [The eelgrass R workflow](#2-the-eelgrass-r-workflow)
3. **[Reporting and using the results](#3-reporting-and-using-the-results)**

---

## 1.1 Organizing data and submitting to a lab

Consider the data collected from the field in the previous module: we have bagged samples in
labelled Ziploc bags, and a completed data sheet.

> 📸 **[SCREENSHOT NEEDED]** — the bagged samples alongside the completed field data sheet,
> so the reader can see what "arriving back from the field" actually looks like.

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

> ⚠️ **Measure your actual internal diameter.** Nominal pipe size is not internal diameter —
> a "3-inch" Schedule 40 PVC pipe has an internal diameter noticeably larger than 7.62 cm, and
> wall thickness varies by schedule and supplier. Because volume enters the bulk-density
> denominator directly, an unchecked diameter propagates as a **systematic bias** into every
> bulk density, and therefore into every carbon stock, in the entire dataset. Measure the ID
> of the tubing you actually used with calipers and use that value.

To make things easier, we have attached a spreadsheet where you can enter the field values
directly from the datasheet, and it will automatically populate the remaining columns.

<!-- TODO (Cathal): add the spreadsheet file to the repo and link it here, then paste a screenshot of it below. -->
**📄 Data-entry spreadsheet:** *(link to be added)*

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

> 📸 **[SCREENSHOT NEEDED]** — the example lab submission sheet from our *Practical
> Implementation Example*, filled in, so readers can see how the field datasheet transfers
> across.

The information you collected in the field transfers directly onto this submission sheet, so
the lab can perform the analysis and return results that map back onto your cores.

---

## 1.2 Expected lab results

The lab returns two quantities per sample slice, which map onto the analysis inputs:

| Lab measurement | Analysis field | Notes |
|---|---|---|
| Organic carbon | `soc_g_kg` | Often measured by loss-on-ignition (LOI₅₅₀); for best accuracy the guide recommends total carbon on an elemental analyser (p.16) |
| Dry bulk density | `bulk_density_g_cm3` | Dry mass ÷ original sample volume (p.17) |

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
| Sandy eelgrass meadow | *(add your measured values)* | <!-- TODO (Cathal): insert DBD from the NFLD/BC eelgrass cores — sandy eelgrass sediments sit well above marsh values, but I'd rather cite your own data than a generic figure. --> |

Because eelgrass meadows in Atlantic Canada are typically sandy, expect **higher** bulk
densities than the marsh values above. Note the compensating effect: low %C paired with high
bulk density can still yield a moderate carbon stock, since stock is their product. Judge the
stock, not either input alone.

> 📸 **[SCREENSHOT NEEDED]** — an example lab result sheet, with notes on how to read the
> columns and map them onto `soc_g_kg` and `bulk_density_g_cm3`.

---

## 2. The eelgrass R workflow

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

---

## 3. Reporting and using the results

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
- [`Lab-Guide-Eng-2026.pdf`](Lab-Guide-Eng-2026.pdf) — WWF-Canada laboratory procedures guide.
- `images/` — lab result screenshots and analysis figures.

> **Iteration note:** the R pipeline under `EelgrassWorkshop/` was left untouched in this
> docs pass. Language is aligned to the field-guide PDF (pp. 15–19); video callouts now use
> the direct per-video URLs.
