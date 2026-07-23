# Part 4 — Data

*From sediment samples to carbon-stock estimates.*

[← 3 — Field Methods](../03_Field_Methods/) · [Back to main guide](../README.md)

---

## Overview

This section covers what happens after the cores come out of the field: sending samples
to a lab, understanding what the lab returns, analysing those results and interpresting them for reporting and planning. Here we follow WWF-Canada's field guide (*Part 3: Sample
Analysis* and *Part 4: Calculating Carbon Stocks*, pp. 15–19 of the
[Coastal Blue Carbon Field Guide](../Coastal-Blue-Carbon-Field-Guide-FINAL.pdf)), with a
dedicated [Lab Guide](Lab-Guide-Eng-2026.pdf) for the laboratory procedures, as well as Howard et al. 2014 guide, utlizing the "BlueCarbon" package in R.

After sampling there are 3 next steps we will cover

1. Organizing Data + [Submitting to a lab](#1-submitting-to-a-lab) + [Expected lab results](#2-expected-lab-results)
2. Data analysis [The eelgrass R workflow](#3-the-eelgrass-r-workflow)
3. Reproting and using the results

---

## 1.1 Organizing Data and Submitting to a lab

Consider the data collected from the field in the previous module, we have bagged samples, in labelled ziploc bags, and a data sheet
Show screenshot of samples + the data sheet. From this we have the Sample ID, the top and bottom depth of the core, the depth the core was inserted, and some notes.
We can therefore calculate "Depth interval of each sample", and the volume of each sample

Depth interval = Bottom depth (cm) - top depth (cm)

Volume = depth interval (cm) * by area of the circular face of the corer = pi * r^2
Since we used at corer with a 7.62 cm diameter opening, we know its area = pi * (7.62/2)^2 = 45.60 cm in area.

So for each sample we multiply the depth increment by 45.60 cm to obtain its volume in cm^3

To make things easier, we have attached a spreadsheet where you can add the field values, directly form the field to the spreadsheet and it will automatically populate the rest of the columns.

***Link in and show spreadhsheet here ***




For every core sampling location, the calculation ultimately needs three things:
**sediment depth (cm)**, **dry bulk density (g/cm³)**, and **organic carbon (%)**

**Bulk density** can be measured with a scale and drying oven

**Carbon analysis** requires more equipment, and often at this stage, the samples will be sent to a laboratory specializing in carbon analysis

Samples should be frozen at −20 °C for storage, then thawed at 5–6 °C for 2–5 days,
dried at 65 °C to a stable weight, and ground homogeneous before analysis. See the
[Lab Guide](Lab-Guide-Eng-2026.pdf) for the full procedure and packaging requirements.

> 🎥 **CHECK OUT THE VIDEO** — *"Core Sample Analysis"* · [workshop playlist](https://www.youtube.com/playlist?list=PLLsjpJMfNDP5w78ZJNDUvMj1VoRG_qSwd)
Actual link is here : https://www.youtube.com/watch?v=BuLRrFD78Fs&list=PLLsjpJMfNDP5w78ZJNDUvMj1VoRG_qSwd&index=11
Another link from IORA is here https://www.youtube.com/watch?v=_Zm9R-kGiE8&list=PL9pJDSsl2ZslDVZ5oZ5MFkykY2Kn9rDS8&index=6&pp=iAQB

*** Make this a dropdown table of labs we can fill in ***
Lab name - website - Contact - analysis - costs + date

Another section to add - What the lab needs - Submitting to the lab

Example data sheet from our "Practical implementation example"


From the data you collected in the field, you will transfer this infromation to the lab so they can perform the analysis



---

## 1.2. Expected lab results

The lab returns two quantities per sample slice, which map onto the analysis inputs:

| Lab measurement | Analysis field | Notes |
|---|---|---|
| Organic carbon | `soc_g_kg` | Often measured by loss-on-ignition (LOI₅₅₀); for best accuracy the guide recommends total carbon on an elemental analyser (p.16) |
| Dry bulk density | `bulk_density_g_cm3` | Dry mass ÷ original sample volume (p.17) |


*** Make this a dropdown menu *** How the lab measures carbon stock
Loss-on-Igntiion (LOI) takes a dried and ground portion of each sample, and burns it in a muffle furnace at 550 degrees C. Through this process, the organic materials present in the sample (composed of what used to be plant materials), are ignited and converted into gaseous carbon dioxide and water, and exit the furnace via a fume hood. Its the same process that occurs when ypu make a camp fire. The wood (organic materials) burn at their combustion temperature, converting the carbohydrates in the wood into C02 and H20. Whats left over in the morning, are a pile of ashes, these are the non-organic materials left over that do not burn (or atleast not at the same temperate). Since we know how much organic matter is composed of carbon, we can estimate this using the carbon conversion factor.

***For claude - Add in a similar description for elemental analysis, determining the total carbon in a sample, as well as H and N ***


For the most accurate results, samples should be sent to a laboratory for total carbon measurement using an elemental analyser



What to expect with eelgrass sediemnts - Typical eelgrass sediments return **lower organic carbon** when comapred to salt-marsh or mangrove
soils, however can range widely - from ***Insert stat about the range of carbon values spatially from studies as well as with depth so teh user can gauge what to expect in terms of carbon stocks from their samples. Do this as well for Bulk density. Comapre among salt marsh ecosystems, and non-vegetated (just oceanic sediemnts) ***

> 📸 **[SCREENSHOT NEEDED]** — an example lab result sheet, with notes on how to read the
> columns and map them onto `soc_g_kg` and `bulk_density_g_cm3`.

---

## 3. The eelgrass R workflow

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

## In this section

- [`EelgrassWorkshop/`](EelgrassWorkshop/) — the R analysis pipeline (with its own detailed README).
- [`Lab-Guide-Eng-2026.pdf`](Lab-Guide-Eng-2026.pdf) — WWF-Canada laboratory procedures guide.
- `images/` — lab result screenshots and analysis figures.

> **Iteration note:** the R pipeline under `EelgrassWorkshop/` was left untouched in this
> docs pass. Quotes are verified against the field-guide PDF (pp. 15–19); the video link
> points to the [playlist](https://www.youtube.com/playlist?list=PLLsjpJMfNDP5w78ZJNDUvMj1VoRG_qSwd)
> with the title to look for.
