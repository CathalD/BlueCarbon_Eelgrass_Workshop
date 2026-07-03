# Blue Carbon Eelgrass Workshop

A hands-on guide to measuring sediment carbon stocks in eelgrass (*Zostera marina*)
meadows — from the science of blue carbon, through planning a sampling campaign and
collecting cores in the field, to analysing the results in R.

This repository is organised as a **four-part guide**. Work through it in order,
or jump to the section you need.

---

## Contents

| # | Section | What it covers |
|---|---------|----------------|
| 1 | [**Background**](01_Background/) | What blue carbon is, why eelgrass matters, key references (incl. the Howard et al. blue carbon manual), and an interactive carbon-accumulation visualiser. |
| 2 | [**Project Planning**](02_Project_Planning/) | How many samples to take and where — area-based sample-size calculation (Cochran's formula) and stratified allocation tools. |
| 3 | [**Field Methods**](03_Field_Methods/) | Core collection basics, equipment list, field data sheets, and coring how-to videos. |
| 4 | [**Data Interpretation**](04_Data_Interpretation/) | Submitting samples to a lab, understanding lab results, and the full eelgrass carbon analysis workflow in R. |

---

## The big picture

The goal of the workshop is to answer one question end-to-end:

> **How much carbon is stored in the sediment beneath an eelgrass meadow, and how confident are we in that number?**

Getting there means making good decisions at every stage — enough samples in the
right places (Section 2), collected correctly (Section 3), measured by a lab, and
analysed with methods that account for compaction, differing sample depths, and
spatial variation (Section 4). Section 1 sets out why any of this matters.

**How carbon stock is calculated:**

```
Carbon stock (kg C/m²) = SOC (g/kg) × bulk density (g/cm³) × layer thickness (cm) ÷ 100
```

Higher organic carbon concentration, denser sediment, and thicker layers all mean
more carbon stored per square metre.

---

## Also in this repository

- `BlueCarbon_EelgrassPPT_FinalV1.pptx` — the full workshop slide deck.
- `02_Project_Planning/SampleDesign_SampleAllocationCalculator_WithStrata.xlsx` — the sample-size calculator.
- `04_Data_Interpretation/EelgrassWorkshop/` — the complete R analysis pipeline (with its own README).

---

## Related resources

- **Ecosystem Carbon Accumulation Visualizer** — https://cathald.github.io/CarbonAccumulationVisualizer/
- **WWF-Canada Blue Carbon Sampling Design Tools** — https://github.com/WWF-Canada-SKI/Carbon-Measurement/tree/main/Blue%20Carbon/Sampling%20Design%20Tools

---

*Workshop materials — Bay of Islands, West Coast Newfoundland.*
