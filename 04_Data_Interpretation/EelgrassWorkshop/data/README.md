# Pipeline data — Tsawwassen worked example

These three CSVs are a **direct export of the digital data sheet**
([`Worked_Example/Eelgrass_Carbon_DigitalData_Example.xlsx`](../../../Worked_Example/Eelgrass_Carbon_DigitalData_Example.xlsx)).
They are what the R scripts read. To use your own site, replace them with an export of your
own filled sheet, keeping the same column names.

## Sheet → CSV mapping

| CSV | From sheet tab | Columns |
|---|---|---|
| `core_locations.csv` | Plot & Core Log | `core_id`, `longitude`, `latitude`, `stratum`, `water_depth_m` |
| `core_samples.csv` | Sample Data | `core_id`, `depth_top_cm`, `depth_bottom_cm`, `soc_g_kg` (col Q), `bulk_density_g_cm3` (col P) |
| `core_compaction.csv` | Plot & Core Log | `core_id`, `corer_diameter_cm`, `outside_depth_cm`, `inside_depth_cm`, `compaction_factor` |

- **`stratum`** — `SM` (salt marsh) / `SG` (seagrass/eelgrass), read from the sheet's
  "Study area / site" field.
- **`water_depth_m`** — ⚠️ **constructed, nominal values.** The digital data sheet does not
  record water depth; these placeholders exist only so the exploratory map and universal
  kriging (which use water depth) run for the teaching example. Replace with real
  measurements for a live project. *(A better external-drift variable for this two-stratum
  example is `stratum` itself — a planned refinement.)*

The whole dataset is a **constructed teaching example** (Tsawwassen Beach, BC) — realistic
but not field-measured. See [`Worked_Example/`](../../../Worked_Example/).
