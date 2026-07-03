# Blue Carbon Eelgrass Workshop

Materials from the **Blue Carbon Eelgrass Workshop**


This repository contains everything covered in the workshop: the presentation
slides, the sample field data, and a complete, reproducible R analysis pipeline
that takes raw core measurements all the way through to spatial carbon-stock maps.

---

## What's in here

| Item | Description |
|------|-------------|
| `BlueCarbon_EelgrassPPT_FinalV1.pptx` | Workshop slide deck — background on blue carbon, eelgrass ecology, field methods, and an overview of the analysis. |
| `EelgrassWorkshop/` | The full R analysis project: numbered scripts, sample data, and a rendered Quarto report. See [`EelgrassWorkshop/README.md`](EelgrassWorkshop/README.md) for details. |

Sampling design tool library
https://github.com/WWF-Canada-SKI/Carbon-Measurement/tree/main/Blue%20Carbon/Sampling%20Design%20Tools


---

## Quick start

The analysis runs in **R** (with [Quarto](https://quarto.org/) for the report).

```r
# From inside the EelgrassWorkshop/ folder, in R or RStudio:
source("00_config.R")               # site settings
source("01_data_prep.R")            # load + QC core data
source("01b_compaction_correction.R")  # correct for core compaction
source("02_exploratory_analysis.R") # depth profiles, maps, summaries
source("03_depth_harmonization.R")  # standardise cores to common depths
source("04_simple_extrapolation.R") # mean stocks + confidence intervals
source("05_kriging.R")              # spatial interpolation

# Or render the full report:
quarto::quarto_render("eelgrass_carbon_report.qmd")
```

A pre-rendered copy of the report is included at
`EelgrassWorkshop/eelgrass_carbon_report.html` — open it in any browser to see
the full analysis without running any code.

See the [analysis README](EelgrassWorkshop/README.md) for required packages,
data formats, and a walk-through of each stage.

---

## The workflow at a glance

The pipeline answers one question: **how much carbon is stored in the sediment
beneath an eelgrass meadow, and how is it distributed across the site?**

1. **Raw data** — Load field measurements of soil organic carbon (SOC) and bulk
   density from sediment cores; compute raw carbon stocks.
2. **Compaction correction** — Percussion coring compresses sediment. Field
   measurements let us "stretch" cores back to their true depths using the
   [`BlueCarbon`](https://cran.r-project.org/package=BlueCarbon) R package.
3. **Depth harmonization** — Cores are sampled at different intervals; spline
   interpolation estimates SOC and bulk density at a common set of standard
   depths so cores can be compared directly.
4. **Estimation & spatial analysis** — Summarise mean stocks with confidence
   intervals, then use kriging to interpolate carbon stocks across the meadow.

**How carbon stock is calculated:**

```
Carbon stock (kg C/m²) = SOC (g/kg) × bulk density (g/cm³) × layer thickness (cm) ÷ 100
```

Higher organic carbon concentration, denser sediment, and thicker layers all mean
more carbon stored per square metre.

---

## A note on scope

The sample dataset contains only **6 cores**. This is enough to demonstrate the
full workflow, but too few for reliable spatial interpolation — the kriging maps
in the report are **illustrative**, meant to show the method rather than provide
definitive carbon estimates. Treat spatial patterns as hypotheses to test with
additional sampling.

---

## Contact

Workshop materials assembled by the workshop organisers. Questions about the data
or analysis can be directed to the workshop contact.
