# 2 — Project Planning

*How many samples to take, and where to take them.*

[← 1 — Background](../01_Background/) · [Back to main guide](../README.md) · Next: [3 — Field Methods →](../03_Field_Methods/)

---

## Why planning matters

Before getting out into the field, there are two questions that need adressing, these are:
How many samples should we take? And where should we take them?
Answering these questions is the aim of a **sampling design**: In other words, do we have enough samples, allocated
across the ecosystem, to estimate carbon stock to meet our projects goals?

Here we follow both the WWF-Canada [Sampling Design guide](Sampling-Design-Eng-2026.pdf), as well as the sampling-design guidance present in the [Howard et al. blue carbon manual](https://www.thebluecarboninitiative.org/manual)
(see [Section 1](../01_Background/)).

> "A sampling design is a framework for choosing what and where to sample to estimate
> the carbon stored in a larger ecosystem area. Sampling designs allow for the strategic
> measurement of smaller sections (i.e., sites and plots) within the larger study area."
>
> — WWF-Canada, *[Measuring Carbon in Coastal Sediments](../Coastal-Blue-Carbon-Field-Guide-FINAL.pdf)* (2026), p.5

---

## How many samples? — Area-based sample-size calculation

The number of cores needed can be estimated using an area-based appraoch with **Cochran's formula** for a desired
margin of error and confidence level, given the variability (standard deviation) of
carbon in the ecosystem. This is provided as a spreadsheet calculator:

**📄 [`SampleDesign_SampleAllocationCalculator_WithStrata.xlsx`](SampleDesign_SampleAllocationCalculator_WithStrata.xlsx)**

The spreadsheet has three sheets: 

### Sheet 1 — Sample Allocation Calculator
Estimates the total number of plots/cores (*n*) for the whole study area.

| Input | Meaning |
|-------|---------|
| Size of total study area (m²) | The area you want to characterise |
| Margin of error | Acceptable relative error (e.g. `0.2` = ±20%) |
| Confidence level (alpha) | Precision level (e.g. `0.1` → 90% confidence) |
| Carbon mean & standard deviation | Expected carbon and its variability — defaults come from the WWF-Canada carbon map and can be overwritten with local values |

**Output:** number of plots *n* needed to hit the target precision.

### Sheet 2 — Sample Allocation per Strata
Splits the total *n* across **strata** (sub-areas — e.g. dense vs. sparse meadow,
depth zones) in proportion to each stratum's area, with a **minimum of 5 plots per
stratum**. Enter each stratum's size and the sheet returns the proportion and the
number of plots to allocate.

### Sheet 3 — Sample Allocation Visualization
Shows how the required *n* scales with study-area size at different confidence levels
(80 / 85 / 90 / 95%), to help you see the trade-off between effort and precision.

> 📷 *Screenshot placeholders — the calculator with example inputs, and the
> visualization chart. Drop images into `images/`.*

---

## Where to sample? — Stratification

Rather than scattering cores at random, the meadow is divided into **strata** and
samples are allocated across them (Sheet 2 above). Stratifying by features that drive
carbon variability — meadow density, water depth, sediment type — gives a more precise
estimate for the same number of cores and ensures no part of the site is missed.

> "stratification (optional) is used to divide the study area into smaller distinct
> sites. This process can reduce the cost of sampling by increasing the statistical
> power of your field data."
>
> — WWF-Canada, *[Measuring Carbon in Coastal Sediments](../Coastal-Blue-Carbon-Field-Guide-FINAL.pdf)* (2026), p.6

For eelgrass specifically, the field guide recommends a shoreline-aligned transect layout:

> "seagrass meadows should be sampled along transects that run parallel to the shoreline
> and align with the depth of the sediment. Within each site, a random or probability-based
> grid sampling strategy is recommended, with at least two replicates per site."
>
> — WWF-Canada, *[Measuring Carbon in Coastal Sediments](../Coastal-Blue-Carbon-Field-Guide-FINAL.pdf)* (2026), p.7

*(This maps directly onto the analysis in [Section 4](../04_Data_Interpretation/), where
cores carry a `stratum` label and water depth is used as a spatial predictor in kriging.)*

> 🎥 **CHECK OUT THE VIDEO** — *"Site Selection and Required Materials"* · [workshop playlist](https://www.youtube.com/playlist?list=PLLsjpJMfNDP5w78ZJNDUvMj1VoRG_qSwd) *(swap in the direct video link)*

<img width="2400" height="1350" alt="image" src="https://github.com/user-attachments/assets/19e30448-624d-460d-98da-93acce8724c5" />


<img width="2400" height="1350" alt="image" src="https://github.com/user-attachments/assets/a2d13fda-6c63-417d-aad6-b506be50a59d" />


<img width="2400" height="1350" alt="image" src="https://github.com/user-attachments/assets/d5d1f4f8-7040-434c-8a72-41f3a88cec09" />



<img width="2400" height="1350" alt="image" src="https://github.com/user-attachments/assets/080e16d2-3be6-4da8-a0d1-bb4154c82e96" />


<img width="2400" height="1350" alt="image" src="https://github.com/user-attachments/assets/1cf7295f-9143-4637-84dc-b6daab789f85" />


---

## Companion tools — WWF-Canada Blue Carbon Sampling Design Tools

The area-based calculator here is part of a broader set of sampling-design tools
developed previously for blue carbon work:

- **Interactive tool:** [Blue Carbon Hub sampling-design app](https://blue-carbon-hub.projects.earthengine.app/)
- **Source code:** [WWF-Canada-SKI/Carbon-Measurement — Sampling Design Tools](https://github.com/WWF-Canada-SKI/Carbon-Measurement/tree/main/Blue%20Carbon/Sampling%20Design%20Tools)

> 📸 **[SCREENSHOT NEEDED]** — the [Blue Carbon Hub sampling-design tool](https://blue-carbon-hub.projects.earthengine.app/)
> with a study area outlined and strata drawn.



---

## In this section

- [`SampleDesign_SampleAllocationCalculator_WithStrata.xlsx`](SampleDesign_SampleAllocationCalculator_WithStrata.xlsx) — the Cochran's-formula calculator.
- [`Sampling-Design-Eng-2026.pdf`](Sampling-Design-Eng-2026.pdf) — the WWF-Canada sampling-design guide.
- `images/` — screenshots of the calculator and planning materials.


