<p align="center">
  <img src="01_Background/images/banner_1.svg" alt="Blue Carbon Eelgrass Workshop banner" width="100%">
</p>

# Blue Carbon Eelgrass Workshop

Materials from the **Blue Carbon Eelgrass Workshop** on measuring sediment carbon stocks in
seagrass/eelgrass meadows, from the background, through field methods, to
analysis in R and reporting

This workshop is organised in **four parts**. You can go in order, or jump to
any section you wish.

---

## Contents

| # | Section | What it covers |
|---|---------|----------------|
| 1 | [**Background**](01_Background/) | What blue carbon is and why it matters; introduce key references (the [Howard et al. Blue Carbon Manual](https://www.thebluecarboninitiative.org/manual)); the workshop [slide deck](01_Background/BlueCarbon_EelgrassPPT_FinalV1.pdf).|
| 2 | [**Project Planning**](02_Project_Planning/) | How many samples to take and where: area-based sample-size calculations, stratified allocation, and the WWF-Canada sampling-design guide + sampling design tools. |
| 3 | [**Field Methods**](03_Field_Methods/) | Collecting sediment cores: equipment, step-by-step coring methods and coring how-to videos, and accompanying datasheets. |
| 4 | [**Data Interpretation**](04_Data_Interpretation/) | Submitting samples to a lab, reading lab results, and the full carbon analysis. |


### Useful links

- **WWF-Canada Carbon Measurement library** — [wwf.ca/carbon-measurement](https://wwf.ca/carbon-measurement/)
- **Coastal Blue Carbon Field Guide** — [PDF](Coastal-Blue-Carbon-Field-Guide-FINAL.pdf) · [companion video playlist](https://www.youtube.com/playlist?list=PLLsjpJMfNDP5w78ZJNDUvMj1VoRG_qSwd)
- **Howard et al. Blue Carbon Manual** — [thebluecarboninitiative.org/manual](https://www.thebluecarboninitiative.org/manual)
- **Sampling design tools** — [interactive tool](https://blue-carbon-hub.projects.earthengine.app/) · [source code](https://github.com/WWF-Canada-SKI/Carbon-Measurement/tree/main/Blue%20Carbon/Sampling%20Design%20Tools)


---

## Objectives

The goal of the workshop is to:

1. **Learn about blue carbon in Canada** — what it is and why it matters.
2. **Learn field methods for measuring it** — how to collect and process sediment cores.
3. **Turn measurements into outputs** — convert field data into carbon analyses to inform decision making.

<!-- TODO (Cathal): add an "Eelgrass Workshop Skills Checklist" here. -->

## How to think about this workshop

As a conceptual excercise, we begin by looking at what this workshop is working toward. Simply put, we are aiming to fill in this **data sheet**. Each field
on it represents something real we measure in the ecosystem, a depth of sediment, a weight, a carbon
concentration, and once the sheet is complete, those numbers let us calculate carbon stock,
compare areas, and inform decisions.

 Through this workshop, we will focus on prioritizing 2 things:

1. **Collecting the data** following best practices, in-line with what **data sheet** asks for.
   
2. **Making the data useful** by making sure that *before* you collect anything, the samples you
   plan to take will actually answer your team's questions, and contribute to your organizational goals.

Please take some time to explore this example datasheet (Link in the filled sheet here). This data was made up to provide a user with a example they can follow along with. This workshop will cover why we collect a bit of data, understand what we are collecting, how it is measured and how it connects with our goals.

[**Section 2 — Project Planning**](02_Project_Planning/) covers side 2: designing the sampling
so the data you'll collect is worth collecting. [**Section 3 — Field Methods**](03_Field_Methods/)
covers side 1: collecting the cores that fill the sheet. Done together, they ensure your samples
are collected effectively and with best practices — so the data genuinely supports your project
and organizational goals. [**Section 4 — Data Interpretation**](04_Data_Interpretation/) then
turns the completed sheet into carbon estimates.

**👉 The data sheet we're building toward:** [digital data sheet (Google Sheets)](https://docs.google.com/spreadsheets/d/1XMA_zaFNKtxCw2tAiQa3gHaIiT_wJAecmwW7Rz4hhaQ/edit?usp=sharing)
· a fully worked copy lives in [`Worked_Example/`](Worked_Example/).

| What the sheet captures | Filled in during | Covered in |
|---|---|---|
| Plot & core log (location, depths, corer) | the field | [Section 3](03_Field_Methods/) |
| Sample slices (depths, notes) | the field | [Section 3](03_Field_Methods/) |
| Lab results (weights, %C) | after the lab | [Section 4](04_Data_Interpretation/) |
| Bulk density, carbon stock | calculated for you | [Section 4](04_Data_Interpretation/) |


**In a nutshell, once the sheet is filled, how carbon stock is calculated**

Each row of the sheet is one slice of a core. For every slice you [collect a sediment
core](https://www.youtube.com/playlist?list=PLLsjpJMfNDP5w78ZJNDUvMj1VoRG_qSwd), then measure
[how much sediment](https://www.youtube.com/watch?v=BuLRrFD78Fs&list=PLLsjpJMfNDP5w78ZJNDUvMj1VoRG_qSwd&index=11)
(bulk density) and [how much carbon](https://www.youtube.com/watch?v=_Zm9R-kGiE8) it holds, then
multiply them together:

```
Carbon stock (kg C/m²) = SOC (g/kg) × bulk density (g/cm³) × layer thickness (cm) ÷ 100
```

Higher organic carbon concentration, denser sediment (higher bulk density), and deeper sediment (larger total core thickness) all mean
more carbon stored per square metre. The sheet does this arithmetic for every slice and sums it per core.

---

## Some resources to find in this workshop

- [`BlueCarbon_EelgrassPPT_FinalV1.pptx`](01_Background/BlueCarbon_EelgrassPPT_FinalV1.pptx) — the full workshop slide deck ([PDF version](01_Background/BlueCarbon_EelgrassPPT_FinalV1.pdf)).
- [`SampleDesign_SampleAllocationCalculator_WithStrata.xlsx`](02_Project_Planning/SampleDesign_SampleAllocationCalculator_WithStrata.xlsx) — the sample-size calculator.
- [`Eelgrass_Carbon_Datasheet_v2.pdf`](Eelgrass_Carbon_Datasheet_v2.pdf) — the field datasheet.
- **Coastal Blue Carbon Field Guide** — [PDF](Coastal-Blue-Carbon-Field-Guide-FINAL.pdf) · [companion video playlist](https://www.youtube.com/playlist?list=PLLsjpJMfNDP5w78ZJNDUvMj1VoRG_qSwd).
- [`04_Data_Interpretation/EelgrassWorkshop/`](04_Data_Interpretation/EelgrassWorkshop/) — the complete R analysis pipeline and report.

---

## Extra resources

- **Ecosystem Carbon Accumulation Visualizer** — [cathald.github.io/CarbonAccumulationVisualizer](https://cathald.github.io/CarbonAccumulationVisualizer/)
- **WWF-Canada Blue Carbon Sampling Design Tools** — [github.com/WWF-Canada-SKI/Carbon-Measurement](https://github.com/WWF-Canada-SKI/Carbon-Measurement/tree/main/Blue%20Carbon/Sampling%20Design%20Tools)

