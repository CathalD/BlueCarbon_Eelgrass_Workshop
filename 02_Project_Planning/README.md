# 2 — Project Planning

*How many samples to take, and where to take them.*

[← 1 — Background](../01_Background/) · [Back to main guide](../README.md) · Next: [3 — Field Methods →](../03_Field_Methods/)

---

## Why planning matters

Before getting out into the field, there are two questions that need adressing, these are:
How many samples should we take? And where should we take them?
Answering these questions is the aim of a **sampling design**: do we have enough samples, allocated
across the ecosystem, to estimate carbon stock to meet our projects goals?

Here we follow both the WWF-Canada Sampling Design guide (see the sampling-design guidance in the Howard et al. blue carbon manual
(see [Section 1](../01_Background/)), implemented through two practical tools.

---

## How many samples? — Area-based sample-size calculation

The number of cores needed is estimated with **Cochran's formula** for a desired
margin of error and confidence level, given the variability (standard deviation) of
carbon in the ecosystem. This is provided as a spreadsheet calculator:

**📄 [`SampleDesign_SampleAllocationCalculator_WithStrata.xlsx`](SampleDesign_SampleAllocationCalculator_WithStrata.xlsx)**

The workbook has three sheets:

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

*(This maps directly onto the analysis in Section 4, where cores carry a `stratum`
label and water depth is used as a spatial predictor in kriging.)*

---

## Companion tools — WWF-Canada Blue Carbon Sampling Design Tools

The area-based calculator here is part of a broader set of sampling-design tools
developed previously for blue carbon work:

**👉 https://github.com/WWF-Canada-SKI/Carbon-Measurement/tree/main/Blue%20Carbon/Sampling%20Design%20Tools**

*(We'll add notes here on which tool to use when, and how they complement the
spreadsheet calculator.)*

---

## In this section

- `SampleDesign_SampleAllocationCalculator_WithStrata.xlsx` — the Cochran's-formula calculator.
- `images/` — screenshots of the calculator and planning materials.

> **Iteration note:** scaffolded page. Paste in calculator/planning screenshots and
> we'll add worked examples using the workshop site's numbers.
