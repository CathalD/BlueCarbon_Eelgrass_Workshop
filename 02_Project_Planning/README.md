<p align="center">
  <img src="images/banner_planning.svg" alt="Project Planning — Blue Carbon Eelgrass Workshop banner" width="100%">
</p>

# 2 — Project Planning

*How many samples to take, and where to take them.*

[← 1 — Background](../01_Background/) · [Back to main guide](../README.md) · Next: [3 — Field Methods →](../03_Field_Methods/)

---

**Quick links:** [Sampling Design Guide](Sampling-Design-Eng-2026.pdf) · [Sample Allocation Calculator](SampleDesign_SampleAllocationCalculator_WithStrata.xlsx) · [Coastal Blue Carbon Field Guide](../Coastal-Blue-Carbon-Field-Guide-FINAL.pdf) · [Howard et al. (2014) Blue Carbon Manual](https://www.thebluecarboninitiative.org/manual)

---

## Why planning matters

Before heading into the field, two questions need answering: **how many samples should
we take, and where should we take them?** Answering these is the aim of a **sampling
design** — in other words, having enough samples, allocated across the ecosystem, to
estimate carbon stock and meet the project's goals.

> "A sampling design is a framework for choosing what and where to sample to estimate
> the carbon stored in a larger ecosystem area. Sampling designs allow for the strategic
> measurement of smaller sections (i.e., sites and plots) within the larger study area.
> Combining measurements from multiple plots allows us to estimate the value for the
> study area."
>
> — WWF-Canada, *[Carbon Measurement: Sampling Design](Sampling-Design-Eng-2026.pdf)* (2026), p.4

We follow this WWF-Canada [Sampling Design guide](Sampling-Design-Eng-2026.pdf), as well
as the sampling-design guidance in the [Howard et al. Blue Carbon Manual](https://www.thebluecarboninitiative.org/manual)
(see [Section 1](../01_Background/)).

### The five steps to a sampling design

The guide breaks *applying* a sampling design into five steps. A full-scale project
works through all five; this page focuses on the two most relevant at workshop scale —
**how many** samples (Step 3) and **where** they go (Steps 2 and 4).

1. Identify the boundary of the study area
2. Stratify the study area *(see "Where to sample?" below)*
3. Determine the sample allocation *(see "How many samples?" below)*
4. Determine the sample distribution *(see "Where to sample?" below)*
5. Select a plot design *(for eelgrass sediment cores, see [Section 3 — Field Methods](../03_Field_Methods/))*

*Source: WWF-Canada, [Carbon Measurement: Sampling Design](Sampling-Design-Eng-2026.pdf) (2026), p.13, "5 steps to applying a sampling design."*

---

## How many samples? — Sample allocation

The number of cores needed can be estimated using an area-based approach with
**Cochran's formula** for a desired margin of error and confidence level, given the
variability (standard deviation) of carbon in the ecosystem. This is provided as a
spreadsheet calculator:

**📄 [`SampleDesign_SampleAllocationCalculator_WithStrata.xlsx`](SampleDesign_SampleAllocationCalculator_WithStrata.xlsx)**

This is the **"Sample Design Sample Allocation Calculator"** named directly in the
Sampling Design guide's Step 3:

> "This framework uses the central limit theorem to estimate the minimum number of
> plots needed to meet a desired level of accuracy and precision for estimating the
> carbon stock of a large area."
>
> — WWF-Canada, *[Carbon Measurement: Sampling Design](Sampling-Design-Eng-2026.pdf)* (2026), p.16

> "For example, if the study area is 10,000 km² and the allowable error is 10%, 43 plots
> will need to be set up."
>
> — WWF-Canada, *[Carbon Measurement: Sampling Design](Sampling-Design-Eng-2026.pdf)* (2026), p.16

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
number of plots to allocate — the same proportional-allocation principle the guide
describes for stratified-random sampling:

> "Allocate (Step 3 'Sample allocation') plots proportionally based on the size of each
> study site (e.g., a 50ha area will have twice as many plots as a 25ha area)."
>
> — WWF-Canada, *[Carbon Measurement: Sampling Design](Sampling-Design-Eng-2026.pdf)* (2026), p.17

### Sheet 3 — Sample Allocation Visualization
Shows how the required *n* scales with study-area size at different confidence levels
(80 / 85 / 90 / 95%), to help you see the trade-off between effort and precision.

<table>
<tr>
<td width="45%">

<img width="100%" alt="Sample Allocation Calculator — filled-in example">

</td>
<td width="55%">

*Add a brief description of this screenshot here.*

*(Suggested: the calculator open in Excel with a filled-in worked example — study area,
margin of error, confidence level → resulting* n *.)*

</td>
</tr>
</table>

<table>
<tr>
<td width="45%">

<img width="100%" alt="Sample Allocation Visualization chart">

</td>
<td width="55%">

*Add a brief description of this screenshot here.*

*(Suggested: the Sheet 3 visualization chart, showing how* n *scales with study-area
size across confidence levels.)*

</td>
</tr>
</table>

---

## Where to sample? — Stratification & sample distribution

Rather than scattering cores at random, the meadow is divided into **strata** and
samples are allocated across them (Sheet 2 above). Stratifying by features that drive
carbon variability — meadow density, water depth, sediment type — gives a more precise
estimate for the same number of cores and ensures no part of the site is missed.

The guide names four sampling strategies for deciding *where* plots go; which one fits
depends on how much you already know about the site:

| Strategy | When to use it |
|---|---|
| **Random** | Plots placed randomly across the study area — the default when the area is uniform or there's no prior data. |
| **Systematic** | Plots at regular intervals — guarantees even coverage, but only when variation across the site is already known. |
| **Stratified-random** | Study area divided into strata first, then plots randomly assigned within each — most accurate and cost-effective when variability is known. **This is the strategy used here.** |
| **Convenience/practical** | Plots placed wherever is accessible — not statistically rigorous, but useful for a low-cost initial assessment. |

*Source: WWF-Canada, [Carbon Measurement: Sampling Design](Sampling-Design-Eng-2026.pdf) (2026), pp.5–6, "Sampling strategy types."*

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

<table>
<tr>
<td width="45%">

<img width="100%" alt="Site and plot selection — slide" src="https://github.com/user-attachments/assets/19e30448-624d-460d-98da-93acce8724c5">

</td>
<td width="55%">

*Add a brief description of this slide here.*

</td>
</tr>
</table>

<table>
<tr>
<td width="45%">

<img width="100%" alt="Site and plot selection — slide" src="https://github.com/user-attachments/assets/a2d13fda-6c63-417d-aad6-b506be50a59d">

</td>
<td width="55%">

*Add a brief description of this slide here.*

</td>
</tr>
</table>

<table>
<tr>
<td width="45%">

<img width="100%" alt="Site and plot selection — slide" src="https://github.com/user-attachments/assets/d5d1f4f8-7040-434c-8a72-41f3a88cec09">

</td>
<td width="55%">

*Add a brief description of this slide here.*

</td>
</tr>
</table>

<table>
<tr>
<td width="45%">

<img width="100%" alt="Site and plot selection — slide" src="https://github.com/user-attachments/assets/080e16d2-3be6-4da8-a0d1-bb4154c82e96">

</td>
<td width="55%">

*Add a brief description of this slide here.*

</td>
</tr>
</table>

<table>
<tr>
<td width="45%">

<img width="100%" alt="Site and plot selection — slide" src="https://github.com/user-attachments/assets/1cf7295f-9143-4637-84dc-b6daab789f85">

</td>
<td width="55%">

*Add a brief description of this slide here.*

</td>
</tr>
</table>

---

## Companion tools — WWF-Canada Blue Carbon Sampling Design Tools

The area-based calculator here is part of a broader set of sampling-design tools
developed previously for blue carbon work:

- **Interactive tool:** [Blue Carbon Hub sampling-design app](https://blue-carbon-hub.projects.earthengine.app/)
- **Source code:** [WWF-Canada-SKI/Carbon-Measurement — Sampling Design Tools](https://github.com/WWF-Canada-SKI/Carbon-Measurement/tree/main/Blue%20Carbon/Sampling%20Design%20Tools)

<table>
<tr>
<td width="45%">

<img width="100%" alt="Blue Carbon Hub sampling-design tool">

</td>
<td width="55%">

*Add a brief description of this screenshot here.*

*(Suggested: the [Blue Carbon Hub sampling-design tool](https://blue-carbon-hub.projects.earthengine.app/)
with a study area outlined and strata drawn.)*

</td>
</tr>
</table>

---

## In this section

- [`SampleDesign_SampleAllocationCalculator_WithStrata.xlsx`](SampleDesign_SampleAllocationCalculator_WithStrata.xlsx) — the Cochran's-formula calculator.
- [`Sampling-Design-Eng-2026.pdf`](Sampling-Design-Eng-2026.pdf) — the WWF-Canada sampling-design guide.
- `images/` — screenshots of the calculator and planning materials.

<details>
<summary><b>📋 Slide/screenshot layout template — copy/paste this to add an image</b></summary>

Each image is a two-column block: the image on the left and a description on the right.
To add one, copy the block below and:

1. In GitHub's editor, click inside the left cell (between the blank lines) and **paste
   or drag your image** — or paste the image URL into `src="…"`.
2. Type your description in the right cell (plain text, **markdown**, links, and lists
   all work).

Keep the blank lines inside the cells — they're what let GitHub render the pasted
image and formatted text.

```html
<table>
<tr>
<td width="45%">

<img width="100%" alt="Image description" src="PASTE_IMAGE_URL_HERE">

</td>
<td width="55%">

Paste your description here.

</td>
</tr>
</table>
```

</details>
