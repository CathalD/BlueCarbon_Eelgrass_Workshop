# 00_config.R
# Site-specific settings for eelgrass carbon stock analysis.
# Edit this file for your site — all other scripts read from here.

# ── Project metadata ─────────────────────────────────────────────────────────
PROJECT_NAME <- "Eelgrass_Workshop_Worked_Example_2026"
SITE_NAME    <- "Tsawwassen Beach, BC (worked example)"

# ── File paths ───────────────────────────────────────────────────────────────
DATA_DIR    <- "data"
OUTPUT_DIR  <- "outputs"

LOCATIONS_FILE   <- file.path(DATA_DIR, "core_locations.csv")
SAMPLES_FILE     <- file.path(DATA_DIR, "core_samples.csv")
COMPACTION_FILE  <- file.path(DATA_DIR, "core_compaction.csv")

# Area of Interest boundary (shapefile, GeoJSON, or GPKG).
# Set to NULL if not available — extrapolation will report densities only.
AOI_FILE          <- NULL
AOI_STRATUM_FIELD <- NULL

# ── Strata ───────────────────────────────────────────────────────────────────
# Strata come from Step 2 of the sampling design (see 02_Project_Planning/).
# They can be delineated automatically (land-cover classification or cluster
# analysis in the Blue Carbon Hub tool) or manually.
#
# STRATUM_AREAS_M2 drives the design-based estimator in 04: each stratum's mean
# is weighted by its AREA, not by how many cores happened to land in it. Replace
# these with the areas your Step 1/Step 2 boundary actually reports.
STRATUM_LABELS <- c("SM" = "Salt marsh",
                    "SG" = "Seagrass / eelgrass")

STRATUM_AREAS_M2 <- c("SM" = 18000,   # 1.8 ha
                      "SG" = 32000)   # 3.2 ha   → 5 ha inlet total

# Plot area (m²) — the area each core is taken to represent.
#
# A core is a few centimetres across, but it is not a measurement of a few
# centimetres of meadow: it stands in for the plot it was taken from. We use a
# 10 x 10 m plot, so each core represents 100 m². This is what converts a
# stratum's area into its finite population size N_h (= how many such plots
# would fit in the stratum), which in turn sets the sampling fraction.
#
# Change this if your design uses a different plot size — it affects N_h, the
# finite population correction, and therefore the sample size the planning
# calculator asks for.
PLOT_AREA_M2 <- 100   # 10 m x 10 m

# ── Analysis methods to run ──────────────────────────────────────────────────
# "stratified" — design-based stratified estimation (DEFAULT; always runs)
# "ok"         — ordinary kriging (spatial autocorrelation only)
# "rk"         — regression kriging (kriging with environmental covariates)
ESTIMATION_METHODS <- c("stratified", "ok", "rk")

# Covariates offered to regression kriging (05_kriging.R).
# The teaching point: the model only knows what you provide it. Adding an
# informative covariate changes the map; adding a meaningless one does not.
RK_COVARIATES <- c("water_depth_m", "dist_to_shore_m", "eelgrass_density")

# ── Standard depth intervals ─────────────────────────────────────────────────
# Depth bins for harmonization (cm).
#
# PRIMARY_DEPTH_CM defines the depth to which EVERY core was physically
# sampled — stocks to this depth are fully measurement-backed and are directly
# comparable with the published seagrass literature (Röhr et al. 2018 and
# Fourqurean et al. 2012 both report 0–25 cm). Anything deeper is MODELLED and
# is reported separately, with the extrapolated fraction stated.
PRIMARY_DEPTH_CM <- 25

DEPTH_INTERVALS <- data.frame(
  depth_top    = c(0,  5, 15, 25,  50),
  depth_bottom = c(5, 15, 25, 50, 100)
)
DEPTH_INTERVALS$depth_midpoint <- with(DEPTH_INTERVALS,
                                       (depth_top + depth_bottom) / 2)
DEPTH_INTERVALS$thickness_cm   <- with(DEPTH_INTERVALS,
                                       depth_bottom - depth_top)
DEPTH_MIDPOINTS <- DEPTH_INTERVALS$depth_midpoint

# Depth breaks passed to mpspline2 (needs a single ascending vector).
DEPTH_BREAKS <- c(DEPTH_INTERVALS$depth_top[1], DEPTH_INTERVALS$depth_bottom)

# ── Down-core extrapolation model ────────────────────────────────────────────
# Below the base of a core, SOC is modelled rather than measured.
#
# Eelgrass profiles are NOT simple exponential decay to zero. Janousek et al.
# and Kindeberg et al. (2019) describe high labile carbon near the surface, a
# sharp decline, then a relatively constant floor of recalcitrant carbon that
# persists at depth. An ASYMPTOTIC model captures that shape:
#
#     SOC(d) = Asym + (R0 - Asym) * exp(-exp(lrc) * d)
#
# where Asym is the recalcitrant floor (NOT zero), R0 the surface value. This is
# base R's self-starting stats::SSasymp, so no hand-rolled optimiser is needed.
#
# Models are fitted PER STRATUM (pooling that stratum's cores, which stabilises
# the fit) and PER CORE where a core has enough points and converges. Core-level
# is preferred when available; stratum-level is the fallback; a constant
# (deepest measured value) is the last resort.
EXTRAP_MODEL          <- "asymptotic"  # "asymptotic" | "constant"
EXTRAP_MIN_PTS_CORE   <- 4    # min slices before a core gets its own fit
EXTRAP_MAX_FACTOR     <- 2.0  # never predict deeper than this x the core base

# ── Bulk density defaults (g/cm³) ────────────────────────────────────────────
# Applied where bulk_density_g_cm3 is missing. Keyed by stratum.
# SM = salt marsh (organic-rich, lower BD); SG = seagrass/eelgrass (sandy, higher BD).
BD_DEFAULTS <- list(
  "SM" = 0.60,
  "SG" = 1.20
)

# ── QC thresholds ────────────────────────────────────────────────────────────
QC_SOC_MIN <- 0      # g/kg
QC_SOC_MAX <- 200    # g/kg — eelgrass sediments are typically lower than salt marsh
QC_BD_MIN  <- 0.1    # g/cm³
QC_BD_MAX  <- 2.0    # g/cm³

# ── Inference settings ───────────────────────────────────────────────────────
CONF_LEVEL <- 0.90   # reported confidence level for all interval estimates

# ── Spatial reference ────────────────────────────────────────────────────────
# EPSG code for the projected CRS used in kriging. Must be a metre-based
# projection appropriate to YOUR site:
#   32610 = UTM 10N  (southwestern BC — Tsawwassen, the worked example)
#   32621 = UTM 21N  (eastern Newfoundland)
UTM_EPSG <- 32610

# ── Stratum colours (for plots) ─────────────────────────────────────────────
STRATUM_COLORS <- c("SM" = "#8B5A2B",   # salt marsh — brown
                    "SG" = "#2E8B57")   # seagrass/eelgrass — sea green
