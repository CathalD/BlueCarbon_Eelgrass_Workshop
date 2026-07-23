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

# ── Standard depth intervals ─────────────────────────────────────────────────
# Depth bins for harmonization. Modify if your cores are shallower/deeper.
# Sized for the worked example: eelgrass cores reach ~24-35 cm (in situ),
# salt-marsh cores ~58-72 cm — so the deepest bin is extrapolated for eelgrass.
DEPTH_INTERVALS <- data.frame(
  depth_top      = c( 0, 10, 20, 40),
  depth_bottom   = c(10, 20, 40, 70),
  depth_midpoint = c( 5, 15, 30, 55),
  thickness_cm   = c(10, 10, 20, 30)
)
DEPTH_MIDPOINTS <- DEPTH_INTERVALS$depth_midpoint

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

# ── Stratum colours (for plots) ─────────────────────────────────────────────
STRATUM_COLORS <- c("SM" = "#8B5A2B",   # salt marsh — brown
                    "SG" = "#2E8B57")   # seagrass/eelgrass — sea green
