# run_pipeline.R
# Runs the whole eelgrass carbon analysis, start to finish.
#
# Usage — from inside the EelgrassWorkshop/ folder:
#     source("run_pipeline.R")
#
# Which estimation methods run is controlled by ESTIMATION_METHODS in
# 00_config.R ("stratified" always; "ok" and "rk" optional).

source("00_config.R")                    # settings — edit this first
source("01_data_prep.R")                 # load, merge, QC
source("01b_compaction_correction.R")    # in-situ depth correction
source("02_exploratory_analysis.R")      # profiles, maps, summaries
source("03_depth_harmonization.R")       # mass-preserving spline (mpspline2)
source("04_stratified_estimation.R")     # design-based estimation (survey)
source("05_kriging.R")                   # ordinary + regression kriging (gstat)

# Render the Quarto report (requires Quarto and the quarto R package):
# quarto::quarto_render("eelgrass_carbon_report.qmd")
