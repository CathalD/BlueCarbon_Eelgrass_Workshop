# 03_depth_harmonization.R
# Standardise cores sampled at different slice thicknesses onto common depth
# intervals, then model the profile below the base of each core.
#
# Produces `cores_harmonized` — one row per core x depth interval.
#
# ── PROVENANCE (what is a package vs. what is ours) ──────────────────────────
#   FROM A PACKAGE — mpspline2::mpspline()
#     Mass-preserving (equal-area) quadratic spline, the standard method for
#     harmonising soil/sediment profiles onto common depth supports. Chosen over
#     a hand-rolled spline so the interpolation is a citable, peer-reviewed
#     method rather than bespoke code.
#       Bishop, McBratney & Laslett (1999) Geoderma 91:27-45.
#       Malone, McBratney, Minasny & Laslett (2009) Geoderma 154:138-152.
#       O'Brien (2022) mpspline2: Mass-Preserving Spline Functions for Soil Data.
#
#   FROM BASE R — stats::nls() with the self-starting stats::SSasymp model
#     Used ONLY below the base of a core, where the spline has no data. See the
#     note on profile shape below.
#
# ── Why an ASYMPTOTIC model below core base, not exponential decay to zero ───
#   Eelgrass profiles are not a simple decay to zero. Janousek et al. and
#   Kindeberg et al. (2019, Biol. Lett. 15:20180831) describe high labile carbon
#   near the surface, a sharp decline, then a relatively CONSTANT floor of
#   recalcitrant carbon persisting at depth. Decaying to zero would understate
#   deep stock; holding the last value constant would overstate it. SSasymp
#   fits exactly the observed shape:
#       SOC(d) = Asym + (R0 - Asym) * exp(-exp(lrc) * d)
#   with Asym = the recalcitrant floor (fitted, not assumed zero).
#
#   Models are fitted PER STRATUM (pooled cores — more points, stabler fit) and
#   PER CORE where the core has enough slices and the fit converges. Core-level
#   is used when available, stratum-level is the fallback, constant is last
#   resort. Every harmonized row records which was used.
#
# Requires: cores_decompacted from 01b (preferred) OR cores_raw from 01.

library(dplyr)

source("00_config.R")

if (!exists("cores_decompacted") && !exists("cores_raw")) {
  source("01b_compaction_correction.R")
}

cores_input <- if (exists("cores_decompacted")) cores_decompacted else cores_raw
input_label <- if (exists("cores_decompacted")) "decompacted" else "raw"
cat("Harmonizing from:", input_label, "cores\n")

if (!requireNamespace("mpspline2", quietly = TRUE)) {
  stop("Package 'mpspline2' is required. Install with install.packages('mpspline2').")
}

# ── Clean input ──────────────────────────────────────────────────────────────
cores_qa <- cores_input |>
  filter(!is.na(depth_top_cm), !is.na(depth_bottom_cm),
         !is.na(soc_g_kg), !is.na(bulk_density_g_cm3),
         depth_bottom_cm > depth_top_cm) |>
  arrange(core_id, depth_top_cm)

core_meta <- cores_qa |>
  group_by(core_id) |>
  summarise(
    stratum       = first(stratum),
    latitude      = first(latitude),
    longitude     = first(longitude),
    water_depth_m = first(water_depth_m),
    core_base_cm  = max(depth_bottom_cm),
    n_slices      = n(),
    .groups = "drop"
  )

cat("Cores:", nrow(core_meta), " Slices:", nrow(cores_qa), "\n")

# ── 1. Mass-preserving spline onto the standard depth intervals ──────────────
# mpspline() expects: col1 = site ID, col2 = upper depth, col3 = lower depth,
# col4 = target variable. It interpolates WITHIN each profile's measured range
# and returns NA below it — the gap the extrapolation model fills.
run_mpspline <- function(df, var) {
  obj <- as.data.frame(df[, c("core_id", "depth_top_cm", "depth_bottom_cm", var)])
  fit <- mpspline2::mpspline(obj, var_name = var, d = DEPTH_BREAKS,
                             vlow = 0, vhigh = max(obj[[var]], na.rm = TRUE) * 2)
  # fit is a list, one element per core, each with $est_dcm over the d breaks
  out <- lapply(names(fit), function(id) {
    est <- fit[[id]]$est_dcm
    data.frame(core_id      = id,
               depth_cm_midpoint = DEPTH_MIDPOINTS,
               value        = as.numeric(est)[seq_along(DEPTH_MIDPOINTS)],
               stringsAsFactors = FALSE)
  })
  res <- bind_rows(out)
  names(res)[names(res) == "value"] <- var
  res
}

soc_sp <- run_mpspline(cores_qa, "soc_g_kg")
bd_sp  <- run_mpspline(cores_qa, "bulk_density_g_cm3")

harmonized <- soc_sp |>
  left_join(bd_sp, by = c("core_id", "depth_cm_midpoint")) |>
  left_join(core_meta, by = "core_id") |>
  left_join(DEPTH_INTERVALS |>
              select(depth_cm_midpoint = depth_midpoint, thickness_cm),
            by = "depth_cm_midpoint") |>
  mutate(is_extrapolated = depth_cm_midpoint > core_base_cm)

cat("Spline complete. Rows:", nrow(harmonized), "\n")

# ── 2. Asymptotic profile models for depths below core base ──────────────────
# Fit SOC ~ SSasymp(depth) at stratum level and (where possible) core level.
fit_asymp <- function(depth, value) {
  if (length(depth) < 3 || length(unique(depth)) < 3) return(NULL)
  tryCatch(
    nls(value ~ SSasymp(depth, Asym, R0, lrc),
        data = data.frame(depth = depth, value = value)),
    error = function(e) NULL
  )
}

slice_mid <- cores_qa |>
  mutate(depth_mid = (depth_top_cm + depth_bottom_cm) / 2)

# Stratum-level fits (pooled cores within each stratum)
stratum_fits <- list()
for (s in unique(slice_mid$stratum)) {
  d <- slice_mid |> filter(stratum == s)
  stratum_fits[[s]] <- list(
    soc = fit_asymp(d$depth_mid, d$soc_g_kg),
    bd  = fit_asymp(d$depth_mid, d$bulk_density_g_cm3)
  )
  cat("Stratum", s, "asymptotic fit:",
      ifelse(is.null(stratum_fits[[s]]$soc), "FAILED (fallback used)", "ok"), "\n")
}

# Core-level fits (preferred where the core has enough slices)
core_fits <- list()
for (id in unique(slice_mid$core_id)) {
  d <- slice_mid |> filter(core_id == id)
  core_fits[[id]] <- if (nrow(d) >= EXTRAP_MIN_PTS_CORE) {
    list(soc = fit_asymp(d$depth_mid, d$soc_g_kg),
         bd  = fit_asymp(d$depth_mid, d$bulk_density_g_cm3))
  } else list(soc = NULL, bd = NULL)
}

predict_at <- function(model, depth) {
  if (is.null(model)) return(NA_real_)
  out <- tryCatch(as.numeric(predict(model, newdata = data.frame(depth = depth))),
                  error = function(e) NA_real_)
  if (is.na(out)) NA_real_ else max(0, out)
}

# Apply: fill every extrapolated cell, recording the model source used
harmonized$extrap_source <- NA_character_

for (i in which(harmonized$is_extrapolated)) {
  id  <- harmonized$core_id[i]
  s   <- harmonized$stratum[i]
  d   <- harmonized$depth_cm_midpoint[i]
  base <- harmonized$core_base_cm[i]

  # Never predict absurdly far below the core base
  if (d > base * EXTRAP_MAX_FACTOR) {
    harmonized$soc_g_kg[i]           <- NA_real_
    harmonized$bulk_density_g_cm3[i] <- NA_real_
    harmonized$extrap_source[i]      <- "beyond_limit"
    next
  }

  if (EXTRAP_MODEL == "asymptotic") {
    soc_hat <- predict_at(core_fits[[id]]$soc, d)
    bd_hat  <- predict_at(core_fits[[id]]$bd,  d)
    src     <- "core"
    if (is.na(soc_hat)) {
      soc_hat <- predict_at(stratum_fits[[s]]$soc, d)
      bd_hat  <- predict_at(stratum_fits[[s]]$bd,  d)
      src     <- "stratum"
    }
  } else {
    soc_hat <- NA_real_; bd_hat <- NA_real_; src <- "constant"
  }

  # Last resort: carry the deepest measured value forward
  if (is.na(soc_hat)) {
    deepest <- slice_mid |> filter(core_id == id) |> arrange(desc(depth_mid)) |> slice(1)
    soc_hat <- deepest$soc_g_kg
    bd_hat  <- deepest$bulk_density_g_cm3
    src     <- "constant"
  }
  if (is.na(bd_hat)) {
    deepest <- slice_mid |> filter(core_id == id) |> arrange(desc(depth_mid)) |> slice(1)
    bd_hat  <- deepest$bulk_density_g_cm3
  }

  harmonized$soc_g_kg[i]           <- soc_hat
  harmonized$bulk_density_g_cm3[i] <- bd_hat
  harmonized$extrap_source[i]      <- src
}

# ── 3. Carbon stock per harmonized interval ──────────────────────────────────
cores_harmonized <- harmonized |>
  rename(soc_harmonized = soc_g_kg, bd_harmonized = bulk_density_g_cm3) |>
  filter(!is.na(soc_harmonized), !is.na(bd_harmonized)) |>
  mutate(
    soc_harmonized     = pmax(0, soc_harmonized),
    bd_harmonized      = pmax(0, bd_harmonized),
    carbon_stock_kg_m2 = (soc_harmonized * bd_harmonized * thickness_cm) / 100,
    # Depth intervals at or above PRIMARY_DEPTH_CM are fully measurement-backed
    is_primary         = depth_cm_midpoint <= PRIMARY_DEPTH_CM
  )

# ── 4. Profile-shape flag (flag only — never filters) ────────────────────────
# Kindeberg et al. (2019) find eelgrass profiles that increase, decrease, or
# show no pattern with depth. A non-monotonic profile is a depositional signal
# (e.g. a buried organic layer), NOT a data error — so this is recorded for
# interpretation and never used to drop a core.
shape_flag <- cores_harmonized |>
  group_by(core_id) |>
  summarise(
    profile_shape = {
      r <- suppressWarnings(cor(depth_cm_midpoint, soc_harmonized,
                                use = "complete.obs", method = "spearman"))
      if (is.na(r)) "undetermined"
      else if (r < -0.3) "declining"
      else if (r >  0.3) "increasing"
      else "no clear trend"
    },
    .groups = "drop"
  )

cores_harmonized <- cores_harmonized |> left_join(shape_flag, by = "core_id")

cat("\nHarmonization complete.\n")
cat("  Cores:", n_distinct(cores_harmonized$core_id), " Rows:", nrow(cores_harmonized), "\n")
cat("  Extrapolated cells:", sum(cores_harmonized$is_extrapolated), "of", nrow(cores_harmonized), "\n")

cat("\n── Profile shapes (flag only, nothing filtered) ──\n")
print(as.data.frame(shape_flag))

cat("\n── Extrapolated fraction of stock, by stratum ──\n")
extrap_share <- cores_harmonized |>
  group_by(stratum) |>
  summarise(
    stock_total      = sum(carbon_stock_kg_m2),
    stock_measured   = sum(carbon_stock_kg_m2[!is_extrapolated]),
    pct_extrapolated = 100 * (1 - stock_measured / stock_total),
    .groups = "drop"
  )
print(as.data.frame(extrap_share))

# ── Visual check ─────────────────────────────────────────────────────────────
library(ggplot2)

p_harmonized <- ggplot(cores_harmonized,
  aes(x = carbon_stock_kg_m2, y = depth_cm_midpoint,
      group = core_id, colour = stratum)) +
  geom_path(linewidth = 0.6) +
  geom_point(aes(shape = is_extrapolated), size = 2) +
  scale_y_reverse(name = "Depth midpoint (cm)") +
  scale_colour_manual(values = STRATUM_COLORS, labels = STRATUM_LABELS) +
  scale_shape_manual(values = c("FALSE" = 16, "TRUE" = 1),
                     labels = c("Measured", "Modelled")) +
  theme_bw(base_size = 12) +
  labs(title    = "Harmonized carbon stocks by depth",
       subtitle = paste0("Mass-preserving spline (mpspline2); open points modelled below core base"),
       x = expression("Carbon stock (kg C m"^{-2}*")"),
       colour = "Stratum", shape = "Source")

print(p_harmonized)
