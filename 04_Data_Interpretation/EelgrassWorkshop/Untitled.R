source("00_config.R")
source("01_data_prep.R")
source("01b_compaction_correction.R")   # in-situ depth correction (from scratch)
source("02_exploratory_analysis.R")
source("03_depth_harmonization.R")
source("04_simple_extrapolation.R")
source("05_kriging.R")

# NOTE: the report still reflects the previous dataset — re-render once it has been
# rebuilt against the Tsawwassen data (tracked as a follow-up).
# quarto::quarto_render("eelgrass_carbon_report.qmd")
