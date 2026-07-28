# Pipeline data — Tsawwassen worked example

These three CSVs are a **direct export of the digital data sheet**
([`Worked_Example/Eelgrass_Carbon_DigitalData_Example.xlsx`](../../../Worked_Example/Eelgrass_Carbon_DigitalData_Example.xlsx)).
They are what the R scripts read. To use your own site, replace them with an export of your
own filled sheet, keeping the same column names.

## Sheet → CSV mapping

| CSV | From sheet tab | Columns |
|---|---|---|
| `core_locations.csv` | Plot & Core Log | `core_id`, `longitude`, `latitude`, `stratum`, + covariates |
| `core_samples.csv` | Sample Data | `core_id`, `depth_top_cm`, `depth_bottom_cm`, `soc_g_kg` (col Q), `bulk_density_g_cm3` (col P) |
| `core_compaction.csv` | Plot & Core Log | `core_id`, `corer_diameter_cm`, `outside_depth_cm`, `inside_depth_cm`, `compaction_factor` |

- **`stratum`** — `SM` (salt marsh) / `SG` (seagrass/eelgrass), read from the sheet's
  "Study area / site" field. This drives the stratified estimator in `04`, and the
  matching stratum **areas** are set in `00_config.R` (`STRATUM_AREAS_M2`).
- **Covariate columns** — `water_depth_m`, `dist_to_shore_m`, `eelgrass_density`.
  ⚠️ **All three are constructed, nominal values.** The digital data sheet does not
  record them; they exist so the regression-kriging demonstration in `05` runs for the
  teaching example, and to make its point that *the model only knows what you provide
  it*. Replace them with real measurements — or, better, extract them from rasters
  (bathymetry, a shoreline-distance surface, a mapped density layer) with
  `terra::extract()` — for a live project.

The whole dataset is a **constructed teaching example** (Tsawwassen Beach, BC) — realistic
but not field-measured. See [`Worked_Example/`](../../../Worked_Example/).
