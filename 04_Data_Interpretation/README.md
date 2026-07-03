# 4 — Data Interpretation

*From sediment samples to carbon-stock estimates.*

[← 3 — Field Methods](../03_Field_Methods/) · [Back to main guide](../README.md)

---

## Overview

This section covers what happens after the cores come out of the field: sending
samples to a lab, understanding what the lab returns, and analysing those results with
the eelgrass carbon workflow in R.

The three stages:

1. [Submitting to a lab](#1-submitting-to-a-lab)
2. [Expected lab results](#2-expected-lab-results)
3. [The eelgrass R workflow](#3-the-eelgrass-r-workflow)

---

## 1. Submitting to a lab

Sediment samples are sent to a laboratory to measure the two quantities the carbon
calculation needs:

- **Soil organic carbon (SOC)** — organic carbon concentration (g C / kg dry sediment)
- **Dry bulk density (BD)** — mass of dry sediment per unit volume (g/cm³)

> 📝 *Placeholder — add practical guidance: sample prep, how much material per depth
> interval, drying/handling, which lab(s) and which analyses to request (e.g. loss-on-
> ignition vs. elemental analysis), and turnaround expectations.*

---

## 2. Expected lab results

> 📷 *Screenshot placeholders — example lab result sheets, with notes on how to read
> the columns and map them onto the analysis inputs (SOC → `soc_g_kg`, bulk density →
> `bulk_density_g_cm3`).*

Typical eelgrass sediments return **lower SOC than salt-marsh or mangrove soils** —
the analysis QC thresholds reflect this (SOC flagged above 200 g/kg).

---

## 3. The eelgrass R workflow

A complete, reproducible R pipeline takes the lab results through compaction
correction, depth harmonisation, carbon-stock estimation, and spatial interpolation.

**👉 See [`EelgrassWorkshop/`](EelgrassWorkshop/) — full documentation is in its
[README](EelgrassWorkshop/README.md).**

The pipeline in brief:

| Stage | Script | Does |
|-------|--------|------|
| Data prep | `01_data_prep.R` | Load, merge, and QC core data |
| Compaction correction | `01b_compaction_correction.R` | Correct percussion-core compression (uses the field measurements from Section 3) |
| Exploratory analysis | `02_exploratory_analysis.R` | Depth profiles, maps, summaries |
| Depth harmonization | `03_depth_harmonization.R` | Standardise cores to common depths |
| Estimation | `04_simple_extrapolation.R` | Mean stocks + confidence intervals |
| Spatial analysis | `05_kriging.R` | Interpolate stocks across the meadow |

A pre-rendered report — `EelgrassWorkshop/eelgrass_carbon_report.html` — walks through
the whole analysis and can be opened in any browser without running R.

**How carbon stock is calculated:**

```
Carbon stock (kg C/m²) = SOC (g/kg) × bulk density (g/cm³) × layer thickness (cm) ÷ 100
```

---

## In this section

- `EelgrassWorkshop/` — the R analysis pipeline (with its own detailed README).
- `images/` — lab result screenshots and analysis figures.

> **Iteration note:** scaffolded page. Send the lab result screenshots and any
> lab-submission details and we'll complete stages 1 and 2.
