# Worked Example — Tsawwassen Beach, BC

*One dataset, followed end to end: from a filled-in data sheet to carbon-stock estimates.*

[← Back to the main guide](../README.md)

---

This folder holds the **completed** version of the workshop's worked example, so you can
see what a finished project looks like before (or while) you do your own. It follows a
single plot — **`WWF-01`** at Tsawwassen Beach, BC — with **six cores**: three in **salt
marsh** (`WWF-01-A/C/D`) and three in **eelgrass** (`WWF-01-B/E/F`).

The idea is simple: **work alongside this example, and apply the blank templates to your
own site.**

| You want… | Use this |
|---|---|
| A completed example to follow | this folder + the tables in [Part 4](../04_Data_Interpretation/) |
| A blank data sheet to fill in | [`04_Data_Interpretation/files/Eelgrass_Carbon_DigitalData_BlankSheet.xlsx`](../04_Data_Interpretation/files/Eelgrass_Carbon_DigitalData_BlankSheet.xlsx) |
| A blank sampling calculator | [`02_Project_Planning/`](../02_Project_Planning/) |
| The analysis code (reusable) | [`04_Data_Interpretation/EelgrassWorkshop/`](../04_Data_Interpretation/EelgrassWorkshop/) |

---

## What's here

- **[`Eelgrass_Carbon_DigitalData_Example.xlsx`](Eelgrass_Carbon_DigitalData_Example.xlsx)** —
  the digital data sheet, filled in: field measurements, lab results, and every calculated
  column (bulk density, carbon stock per slice, per-core totals).

The R pipeline in [`04_Data_Interpretation/EelgrassWorkshop/`](../04_Data_Interpretation/EelgrassWorkshop/)
runs on this exact dataset — its `data/` CSVs are a direct export of the sheet — so
`source("run_pipeline.R")` reproduces the analysis and report from these numbers.

## The thread, end to end

1. **Plan** ([Part 2](../02_Project_Planning/)) — how many cores, and where.
2. **Collect** ([Part 3](../03_Field_Methods/)) — the cores that fill the *Plot & Core Log*
   and *Sample Data* tabs of the sheet.
3. **Analyse** ([Part 4](../04_Data_Interpretation/)) — lab results complete the sheet, and
   the R pipeline turns them into carbon stocks.

## Headline result

| Stratum | Cores | Mean stock (kg C/m²) |
|---|---|---|
| Salt marsh | 3 | 10.3 |
| Eelgrass | 3 | 2.2 |

A ~4.6 : 1 contrast — the marsh's much higher carbon concentration outweighs its lower bulk
density. The eelgrass mean sits inside the published range for Pacific Canadian eelgrass.

> ⚠️ **This is constructed teaching data.** The coordinates and layout are realistic and the
> values are built to sit within published ranges for BC salt marsh and eelgrass, but they
> are **not field measurements** and must not be cited as such. See the provenance notes in
> [Part 4](../04_Data_Interpretation/) and cite the primary sources listed there.
