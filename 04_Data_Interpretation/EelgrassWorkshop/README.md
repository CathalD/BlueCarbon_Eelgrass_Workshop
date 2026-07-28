# Eelgrass Carbon Stock Analysis

A reproducible R pipeline for estimating sediment carbon stocks in an eelgrass
(*Zostera marina*) meadow, from raw sediment-core measurements through to
spatially interpolated carbon-stock maps.

**Site:** Tsawwassen Beach, BC — *worked teaching example* (constructed data; see
[`Worked_Example/`](../../Worked_Example/))
**Data:** 6 sediment cores (WWF-01-A…F) — 3 salt marsh + 3 eelgrass — 32 sediment samples,
exported from the digital data sheet

---

## Contents

```
EelgrassWorkshop/
├── 00_config.R                  # Site settings, strata, methods — edit this first
├── 01_data_prep.R               # Load, merge, and QC core data
├── 01b_compaction_correction.R  # Correct for percussion-core compaction
├── 02_exploratory_analysis.R    # Depth profiles, maps, summary stats
├── 03_depth_harmonization.R     # Mass-preserving spline (mpspline2) + profile model
├── 04_stratified_estimation.R   # Design-based stratified estimation (survey)
├── 05_kriging.R                 # Ordinary + regression kriging (gstat)
├── run_pipeline.R               # Runs the whole pipeline
├── eelgrass_carbon_report.qmd   # Quarto report tying it all together
├── eelgrass_carbon_report.html  # Pre-rendered report (open in a browser)
└── data/
    ├── core_locations.csv       # One row per core — position, stratum, covariates
    ├── core_samples.csv         # One row per sediment slice — SOC and BD
    └── core_compaction.csv      # Field measurements for compaction correction
```

## Methods and their sources

This pipeline **defers to established packages** wherever a peer-reviewed
implementation exists, so the methods can be cited rather than audited
line-by-line. What is ours is limited to data plumbing and the choice of model.

| Step | Method | Package | Citation |
|---|---|---|---|
| Depth harmonization | Mass-preserving (equal-area) quadratic spline | **mpspline2** | Bishop et al. (1999); Malone et al. (2009) |
| Below-core profile model | Asymptotic (recalcitrant-floor) model, `SSasymp` | base **stats** | shape after Kindeberg et al. (2019) |
| Stratified estimation | Design-based (Horvitz–Thompson) stratified mean, SE, CI | **survey** | Lumley (2004, 2010); Cochran (1977) |
| Ordinary & regression kriging | Variogram fitting and kriging | **gstat** | Pebesma (2004); Hengl et al. (2007) |
| Spatial handling | Projection, coordinates | **sf**, **sp** | Pebesma & Bivand (2023) |
| Compaction correction | Ratio arithmetic (identical to the digital data sheet) | *from scratch* | — |

---

## Requirements

- **R** (≥ 4.1 recommended, for the native `|>` pipe)
- **Quarto** (only needed to render the report) — https://quarto.org/

### R packages

```r
install.packages(c(
  "dplyr", "readr", "tidyr", "ggplot2", "knitr",  # data wrangling + plots
  "mpspline2",                                    # depth harmonization
  "survey",                                       # stratified estimation
  "sf", "gstat", "sp"                             # spatial analysis / kriging
))
# Optional — only for the compaction cross-check in 01b (USE_BLUECARBON = TRUE):
# install.packages("BlueCarbon")
# Optional — for reading real raster covariates in 05 (bathymetry, density):
# install.packages("terra")
```

| Package | Used for |
|---------|----------|
| `dplyr`, `readr`, `tidyr` | Data loading and manipulation |
| `ggplot2` | All plots |
| `knitr` | Report tables |
| `mpspline2` | Mass-preserving spline for depth harmonization |
| `survey` | Design-based stratified estimation (means, SE, CI) |
| `sf`, `sp`, `gstat` | Spatial data handling and kriging |
| `terra` | **Optional** — reading raster covariates for regression kriging |
| `BlueCarbon` | **Optional** — compaction cross-check only (`decompact()`); not required to run |

---

## How to run

### Option 1 — Run the whole pipeline

```r
# From within the EelgrassWorkshop/ directory:
source("run_pipeline.R")   # runs 00 → 05
```

### Option 2 — Run stages individually

Each script `source()`s the ones it depends on, so you can start anywhere:

```r
source("00_config.R")
source("01_data_prep.R")
source("02_exploratory_analysis.R")
# ...and so on
```

### Option 3 — Just read the report

Open `eelgrass_carbon_report.html` in any web browser. It's fully self-contained
(embedded plots and tables) — no R required.

> ⚠️ **Being rebuilt.** The `.qmd`/`.html` report still reflects the previous dataset and
> recomputes compaction with the old field-measurement schema. It needs re-rendering against
> the Tsawwassen data and the new compaction model — tracked as a follow-up. The scripts
> (`00`–`05`) are the current source of truth.

> **Working directory:** scripts use relative paths (`data/…`), so run them from
> inside the `EelgrassWorkshop/` folder (or open the folder as an RStudio project).

---

## The pipeline, stage by stage

### `00_config.R` — Configuration
The one file you edit for a new site. Sets project/site names, file paths,
**strata and their areas**, **which estimation methods to run**, the standard
depth intervals, the below-core profile model, default bulk densities, QC
thresholds, the projected CRS, and plot colours. Every other script reads its
settings from here.

Two settings matter more than the rest:

- **`STRATUM_AREAS_M2`** — the area of each stratum, from Steps 1–2 of the
  sampling design. These are the weights in the stratified estimator, so the
  answer depends on them. Replace the worked-example values with your own.
- **`PRIMARY_DEPTH_CM`** (default 25) — the depth every core physically reached.
  Stocks to this depth are fully measurement-backed and directly comparable with
  published seagrass values (Röhr et al. 2018; Fourqurean et al. 2012). Deeper
  intervals are modelled and reported separately.

### `01_data_prep.R` — Data preparation
Loads and merges `core_locations.csv` and `core_samples.csv`, fills any missing
bulk-density values from the per-stratum defaults, computes raw carbon stock per
sample layer, and flags samples that fall outside QC thresholds. Produces
`cores_raw`.

### `01b_compaction_correction.R` — Compaction correction
Percussion coring compresses sediment, so the recovered core is shorter than the
sediment column it came from. Using the field measurements in `core_compaction.csv`,
this computes a **compaction factor** per core and stretches the sample **depths**
back to their in-situ positions — the same arithmetic the digital data sheet uses,
so the two agree. Produces `cores_decompacted`.

- `compaction_factor = outside_depth / inside_depth` (≥ 1; > 1 means compression)
- `in-situ depth = measured depth × compaction_factor`

Bulk density and carbon stock stay on the **measured** interval on purpose (the dry
mass already came from the taller in-situ column — applying the factor again would
double-count it). The `BlueCarbon` package is used only as an **optional cross-check**
(`USE_BLUECARBON <- FALSE` by default), so the pipeline has no hard dependency on it.

### `02_exploratory_analysis.R` — Exploratory analysis
SOC and bulk-density depth profiles, a map of core locations coloured by water
depth, total raw stock per core, and a summary statistics table.

### `03_depth_harmonization.R` — Depth harmonization
Cores are sampled at different slice thicknesses, so they can't be compared or
averaged directly. Harmonization puts every core on the same depth support.

**Within the measured range** this uses `mpspline2::mpspline()` — the
mass-preserving (equal-area) quadratic spline of Bishop et al. (1999) and
Malone et al. (2009), the standard method for soil and sediment profiles. It
conserves mass, which a plain interpolating spline does not.

**Below the base of a core** the profile is *modelled*, not measured. Eelgrass
profiles are not a simple decay to zero: Kindeberg et al. (2019) and Janousek
et al. describe high labile carbon at the surface, a sharp decline, then a
relatively constant floor of recalcitrant carbon. So the extrapolation uses an
**asymptotic model** (base R's self-starting `SSasymp`), which fits that floor
rather than assuming it is zero:

```
SOC(d) = Asym + (R0 − Asym) · exp(−exp(lrc) · d)
```

Models are fitted **per stratum** (pooled cores, stabler fit) and **per core**
where a core has enough slices and converges; core-level is preferred,
stratum-level is the fallback, and carrying the deepest measured value forward
is the last resort. Every row records which was used (`extrap_source`) and
whether it was measured or modelled (`is_extrapolated`). The script prints the
**extrapolated share of stock per stratum** so that fraction is never hidden.

Profile shape is **flagged, never filtered** — a core whose SOC rises with depth
is a depositional signal, not an error, so `profile_shape` records
declining / increasing / no clear trend and nothing is dropped.

Produces `cores_harmonized` (one row per core × depth interval).

### `04_stratified_estimation.R` — Design-based estimation
The default estimator, and it mirrors the design taught in Part 2: each
stratum's mean is weighted by its **area**, not by how many cores landed in it.

Built on the **`survey`** package (Lumley 2004, 2010), so the stratified mean,
standard error, finite-population correction and degrees of freedom all come
from a peer-reviewed implementation rather than hand-rolled arithmetic:

```r
svydesign(ids = ~1, strata = ~stratum, fpc = ~N_h, data = core_totals)
```

Two points of statistical hygiene are deliberate here:

- **The core is the sampling unit, not the slice.** Slices within a core are not
  independent, so all inference runs on per-core totals.
- **Two numbers are reported, not one** — stock to `PRIMARY_DEPTH_CM`
  (fully measured, literature-comparable) and stock over the full modelled
  profile, each with its interval, plus the modelled share per core.

It also reports achieved relative margin of error, so you can check the campaign
against the precision target set during planning.

### `05_kriging.R` — Spatial interpolation
Interpolates total carbon stock across the study area two ways, selected via
`ESTIMATION_METHODS`:

- **Ordinary kriging** — knows only *where* each core is.
- **Regression kriging** — also knows *what the place is like*, via covariates
  (water depth, distance to shore, eelgrass density), following Hengl et al.
  (2007). Fitting is `gstat`.

The script prints a **covariate screening table** (variance in stock explained
by each covariate alone) and an **OK-vs-RK comparison** of mean prediction error.
That contrast is the teaching point: *the model only knows what you provide it* —
an informative covariate sharpens the map, an uninformative one cannot, however
good the method.

Grid covariates in the worked example are interpolated from the core points so
the example runs end to end. **In a real project these come from rasters**
(bathymetry, a shoreline-distance surface, a mapped density layer) read with
`terra::rast()` and sampled with `terra::extract()`.

> ⚠️ **With only 6 cores, a variogram is not identifiable** — there are too few
> point-pairs to estimate range, sill and nugget, and the script falls back to a
> pure-nugget model when fitting fails. These maps are a **teaching
> demonstration**, not carbon maps. Treat every pattern as a hypothesis to test
> with more sampling.

---

## Data dictionary

### `core_locations.csv` — one row per core
| Column | Type | Description |
|--------|------|-------------|
| `core_id` | text | Unique core identifier (e.g. `WWF-01-A`) |
| `longitude` | number | Decimal degrees (WGS84) |
| `latitude` | number | Decimal degrees (WGS84) |
| `stratum` | text | Design stratum — `SM` = salt marsh, `SG` = seagrass/eelgrass |
| `water_depth_m` | number | Water depth at the core location (m) — *covariate* |
| `dist_to_shore_m` | number | Distance to shoreline (m) — *covariate* |
| `eelgrass_density` | number | Eelgrass shoot density (shoots/m²) — *covariate* |

The last three columns are **optional covariates** offered to regression kriging
via `RK_COVARIATES` in `00_config.R`. Add or remove columns freely — the
covariate screening table in `05` will show which ones actually carry
information about carbon.

> ⚠️ In the worked example the three covariate columns are **constructed
> placeholder values**, present so the regression-kriging demonstration runs.
> Replace them with real measurements (or raster extractions) for a live project.

### `core_samples.csv` — one row per sediment slice
| Column | Type | Description |
|--------|------|-------------|
| `core_id` | text | Links to `core_locations.csv` |
| `depth_top_cm` | number | Top of the sample slice (cm below sediment surface) |
| `depth_bottom_cm` | number | Bottom of the sample slice (cm) |
| `soc_g_kg` | number | Soil organic carbon (g C / kg dry sediment) |
| `bulk_density_g_cm3` | number | Dry bulk density (g/cm³); blank = use default |

### `core_compaction.csv` — one row per core
| Column | Type | Description |
|--------|------|-------------|
| `core_id` | text | Links to `core_locations.csv` |
| `corer_diameter_cm` | number | Measured internal diameter of the corer (cm) |
| `outside_depth_cm` | number | How far the corer was driven in — penetration (cm) |
| `inside_depth_cm` | number | Length of core actually recovered (cm) |
| `compaction_factor` | number | `outside_depth / inside_depth` (≥ 1); recomputed if blank |

> These are the same field measurements the digital data sheet's *Plot & Core Log*
> records, so `core_compaction.csv` is a direct export of that tab.

---

## Adapting this to your own site

1. Replace the three CSVs in `data/` with your own, keeping the same column names.
2. Edit `00_config.R`:
   - `PROJECT_NAME`, `SITE_NAME`
   - **`STRATUM_AREAS_M2`** — your strata and their areas, from Steps 1–2 of the
     sampling design. These are the weights in the estimator, so get them right.
   - **`PRIMARY_DEPTH_CM`** — the depth every one of your cores reached.
   - **`UTM_EPSG`** — a metre-based CRS for your region (32610 = UTM 10N for
     southwestern BC; 32621 = UTM 21N for eastern Newfoundland).
   - `DEPTH_INTERVALS` if your cores are shallower/deeper
   - `ESTIMATION_METHODS` — which of `stratified` / `ok` / `rk` to run
   - `RK_COVARIATES` — the covariate columns to offer regression kriging
   - `BD_DEFAULTS` per stratum
   - QC thresholds (`QC_SOC_*`, `QC_BD_*`)
   - `STRATUM_COLORS` for plots
   - `AOI_FILE` — point to a shapefile/GeoJSON/GPKG boundary to get a total
     site-wide carbon estimate (leave `NULL` for densities only).
3. Re-run the pipeline or re-render the report.

---

## Key output

Carbon stock for each sample layer is:

```
Carbon stock (kg C/m²) = SOC (g/kg) × bulk density (g/cm³) × layer thickness (cm) ÷ 100
```

Summed over depth, this gives total stock per core (kg C/m² or Mg C/ha); averaged
across cores it gives a site-level density; and interpolated spatially it gives a
carbon-stock map.
