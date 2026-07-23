# 01b_compaction_correction.R
# Correct core DEPTHS for percussion-core compaction, matching the digital data sheet.
# Produces `cores_decompacted` — cores with in-situ (stretched) depths.
# Requires: cores_raw from 01_data_prep.R
#
# ── PROVENANCE (what is built from scratch vs. from a package) ────────────────
#   FROM SCRATCH (base R + dplyr): the compaction factor and the in-situ depths.
#     This is plain arithmetic and is identical to what the digital data sheet
#     computes on its "Sample Data" tab, so the two agree cell-for-cell.
#   FROM A PACKAGE (BlueCarbon): used ONLY as an optional cross-check, guarded by
#     USE_BLUECARBON below (default FALSE). The pipeline does not depend on it.
#
# ── Compaction model (same as the digital data sheet) ────────────────────────
#   compaction_factor = outside_depth / inside_depth        (>= 1)
#       outside_depth = how far the corer was driven in (penetration)
#       inside_depth  = length of core actually recovered
#   in-situ depth     = measured depth x compaction_factor
#
#   ⚠️ Bulk density and carbon stock are deliberately LEFT ON THE MEASURED
#   interval. The dry mass in the tube already came from the taller in-situ
#   column, so applying the factor again would double-count it. The corrected
#   depths exist only to tell us which in-situ depth each slice represents,
#   which is what depth harmonisation (03) needs.

library(dplyr)
library(readr)

source("00_config.R")

if (!exists("cores_raw")) source("01_data_prep.R")

USE_BLUECARBON <- FALSE   # set TRUE to also run the BlueCarbon cross-check (optional)

# ── Load compaction field measurements ───────────────────────────────────────
#   core_id, corer_diameter_cm, outside_depth_cm, inside_depth_cm, compaction_factor
comp_meas <- read_csv(COMPACTION_FILE, show_col_types = FALSE)

# Recompute the factor defensively (in case it wasn't carried in the CSV)
comp_meas <- comp_meas |>
  mutate(
    compaction_factor = if_else(
      is.na(compaction_factor) & !is.na(outside_depth_cm) & inside_depth_cm > 0,
      outside_depth_cm / inside_depth_cm,
      compaction_factor
    ),
    compaction_cm = outside_depth_cm - inside_depth_cm
  )

cat("Compaction measurements for", nrow(comp_meas), "cores\n")
cat("\n── Compaction factors ──\n")
print(comp_meas |> select(core_id, outside_depth_cm, inside_depth_cm, compaction_factor))

# ── Apply the correction: stretch measured depths to in-situ depths ──────────
cores_decompacted <- cores_raw |>
  left_join(select(comp_meas, core_id, compaction_factor), by = "core_id") |>
  mutate(
    compaction_factor = coalesce(compaction_factor, 1),
    # in-situ (pre-compaction) depth coordinates
    depth_top_cm    = depth_top_cm    * compaction_factor,
    depth_bottom_cm = depth_bottom_cm * compaction_factor,
    depth_cm        = (depth_top_cm + depth_bottom_cm) / 2
    # NOTE: layer_thickness_cm and carbon_stock_kg_m2 are carried unchanged from
    # cores_raw (i.e. on the MEASURED interval) — see the provenance note above.
  )

cat("\nDecompaction complete (depths only).\n")
cat("Cores:", n_distinct(cores_decompacted$core_id), "\n")
cat("Rows:", nrow(cores_decompacted), "\n")

# ── Optional cross-check against the BlueCarbon package ───────────────────────
# BlueCarbon::decompact() parameterises compaction as (1 - inside/outside).
# This block is illustrative only and never feeds the pipeline.
if (USE_BLUECARBON && requireNamespace("BlueCarbon", quietly = TRUE)) {
  cat("\n── Optional BlueCarbon cross-check ──\n")
  bc_in <- read_csv(SAMPLES_FILE, show_col_types = FALSE) |>
    left_join(select(comp_meas, core_id, compaction_factor), by = "core_id") |>
    mutate(compaction = coalesce(1 - 1 / compaction_factor, 0))
  names(bc_in)[names(bc_in) == "depth_top_cm"]       <- "mind"
  names(bc_in)[names(bc_in) == "depth_bottom_cm"]    <- "maxd"
  names(bc_in)[names(bc_in) == "bulk_density_g_cm3"] <- "dbd"
  bc <- BlueCarbon::decompact(bc_in, core = "core_id", compaction = "compaction",
                              mind = "mind", maxd = "maxd", dbd = "dbd")
  cat("BlueCarbon in-situ max depth per core (compare to measured x factor):\n")
  print(bc |> group_by(core_id) |> summarise(bc_maxd = max(maxd_corrected), .groups = "drop"))
} else if (USE_BLUECARBON) {
  message("BlueCarbon not installed — skipping optional cross-check.")
}

# ── Visualizations ───────────────────────────────────────────────────────────
library(ggplot2)

p_compaction <- ggplot(comp_meas,
    aes(x = reorder(core_id, compaction_factor), y = compaction_factor)) +
  geom_col(fill = "#e76f51", alpha = 0.85) +
  geom_text(aes(label = round(compaction_factor, 3)), vjust = -0.5, size = 3.5) +
  geom_hline(yintercept = 1, linetype = "dashed", colour = "grey50") +
  labs(title = "Compaction factor per core",
       subtitle = "Factor = outside / inside depth. Values > 1 indicate compression.",
       x = NULL, y = "Compaction factor") +
  theme_bw(base_size = 12)
print(p_compaction)

# Depth shift: measured midpoint -> in-situ midpoint
depth_shift <- cores_raw |>
  select(core_id, depth_mid_measured = depth_cm) |>
  bind_cols(cores_decompacted |> select(depth_mid_insitu = depth_cm))

p_depth_shift <- ggplot(depth_shift) +
  geom_segment(aes(x = depth_mid_measured, xend = depth_mid_insitu,
                   y = core_id, yend = core_id), colour = "grey60", linewidth = 0.5) +
  geom_point(aes(x = depth_mid_measured, y = core_id), colour = "#6baed6", size = 2.5) +
  geom_point(aes(x = depth_mid_insitu,   y = core_id), colour = "#e76f51", size = 2.5, shape = 17) +
  labs(title = "Depth correction: measured vs in-situ",
       subtitle = "Blue circles = measured depths, orange triangles = in-situ (stretched) depths",
       x = "Depth midpoint (cm)", y = NULL) +
  theme_bw(base_size = 12)
print(p_depth_shift)
