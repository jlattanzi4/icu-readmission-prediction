# Who Comes Back? Predicting 30-day hospital readmission

**Thesis (2025), reviewed 2026.** This is my MS capstone (Applied Data Science, Bay Path University), kept as submitted, with a review I wrote a year later. The analysis and its rendered report are unchanged. This page is new: every number below comes from the report's own output, and the second half lists what I got wrong and how I'd do it now.

[![Watch the defense](https://img.shields.io/badge/YouTube-Watch%20the%20defense-red?logo=youtube)](https://youtu.be/Le1AnfCN2xI)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

## What the thesis did

It predicts whether a patient discharged from hospital will be admitted again within 30 days.

- **Data:** MIMIC-IV, the de-identified records of Beth Israel Deaconess Medical Center. 545,316 hospital admissions, 20.0% followed by another admission within 30 days.
- **Features:** 57, built from diagnoses, procedures, prescriptions, lab results and prior use of the hospital (comorbidity indices, medication counts, length of stay, and so on).
- **Models:** logistic regression, random forest and XGBoost. Each model's decision threshold was chosen on a validation set by Youden's index.
- **Split:** admissions sorted by admission time, then 70% train, 15% validation, 15% test.

## Results, as the report computed them

XGBoost on the held-out test set (79,904 admissions, 21.0% readmitted):

| Measure | Value |
|---|---|
| AUC | 0.683 |
| Sensitivity | 68.8% |
| Specificity | 56.9% |
| Precision | 29.8%, against a 21.0% base rate (1.4 times) |
| Readmissions among the third of patients with the highest predicted risk | 52.5% of all readmissions (33.1% readmitted, against 9.7% in the lowest third) |

On the validation set, XGBoost's AUC was 0.695, random forest's 0.660 and logistic regression's 0.655.

**By race and ethnicity** (validation set, groups of 1,000 or more): sensitivity ranged from 58.4% for patients recorded as Hispanic or Latino to 75.5% for Black or African American patients, a spread of 17 points. For White patients it was 67.3%. The model flags Black patients more readily: higher sensitivity, lower specificity (53.1% against 59.7%).

An AUC of 0.68 is ordinary for readmission models built on data available at discharge. What happens after discharge drives much of the outcome and isn't in the data.

## What the 2026 review found

I audited this project in November 2026 the way I'd review someone else's. Six problems, most serious first.

**1. It isn't an ICU cohort.** The title says ICU readmission. The code reads the hospital `admissions` table and never joins `icustays`, so the cohort is every inpatient admission and the outcome is any readmission to the hospital. *Now:* build the cohort from ICU stays, and say which readmission is meant (to the ICU, or to the hospital after an ICU stay).

**2. The "temporal" split isn't one.** MIMIC shifts each patient's dates by a random offset to protect privacy (the admission dates in this data run from 2105 to 2214), so sorting by admission time orders patients by their offset, not by when they were treated. The test set isn't "the most recent year", and the same patient can have admissions on both sides of the split. *Now:* split by `anchor_year_group`, which MIMIC provides for exactly this, and keep each patient's admissions together.

**3. Patients who died in hospital were labeled "not readmitted".** They can't be readmitted, and the in-hospital death flag is one of the model's top features, so part of what the model learned is that the dead don't return. *Now:* exclude in-hospital deaths from the cohort, or treat death as a competing outcome.

**4. The financial case doesn't support using the model.** The scenario assumes a $500 intervention that prevents 25% of readmissions costing $26,000 each. Under those numbers, any patient with more than a 7.7% risk is worth treating, and the average patient's risk is 20%. Treating all 30,000 patients nets about $24M a year, more than the $17.25M the thesis reported for treating only the flagged ones. The comparison table for "top 20/30/40/50% by risk" also has a bug: it reports the same 932 readmissions prevented at every coverage level. *Now:* a decision-curve analysis against treat-all and treat-none, with the intervention's cost and effect varied over a plausible range.

**5. The fairness audit used the wrong set and had no uncertainty.** Group metrics were computed on the validation set, the same data the threshold was tuned on, with no confidence intervals, and several groups are small. *Now:* test set, bootstrap intervals, and error rates compared at a fixed threshold.

**6. Prose and tables disagree.** Several sentences in the report were typed by hand and contradict its own tables: net benefit ($1.3M in one place, $17.25M in another), calibration error (0.022 and 0.003), and the fairness gap (20 points and 17). The first version of this README added its own, including an "11-point gap between Black and White patients" that no table supports (the computed difference is 8 points, with the higher sensitivity for Black patients). *Now:* every number in the text is generated by the code that computes it.

Smaller corrections: the hyperparameters were set by hand with early stopping on the validation set, not by a grid search; the data is MIMIC-IV version 3, which covers 2008 to 2022, not version 2.2 (2008 to 2019); and a PDF committed as "the paper" was a published guide to writing papers, uploaded by mistake, now removed.

What holds up: the feature engineering across six tables, a test set used only for the final evaluation, thresholds chosen on validation data, a calibration check, and the decision to look at subgroup performance at all. A rebuild would keep those and fix the six items above. It's out of scope here; this repository stays as the record of the original.

## Repository

```
report/capstone_analysis.Rmd    The analysis (R Markdown)
report/capstone_analysis.html   The rendered report, with every table and figure
R/                              Scripts for the standalone figures in images/
paper/abstract.txt              The abstract as submitted (see the corrections above)
```

The analysis is unchanged from the thesis except for file paths (the original is commit [`4f82fa2`](https://github.com/jlattanzi4/icu-readmission-prediction/tree/4f82fa2)).

## Running it

MIMIC-IV needs credentialed access through [PhysioNet](https://physionet.org/content/mimiciv/) (CITI training, then a data use agreement). No patient data is in this repository.

1. Put these MIMIC-IV `hosp` tables in `data/`: `admissions`, `patients`, `diagnoses_icd`, `procedures_icd`, `prescriptions`, `labevents`, `d_labitems`, `d_icd_diagnoses`, `d_icd_procedures` (as `.csv.gz`).
2. Install the packages:
   ```r
   install.packages(c(
     "data.table", "dplyr", "tidyr", "lubridate", "ggplot2", "gridExtra",
     "knitr", "rmarkdown", "rmdformats", "kableExtra", "DT", "R.utils",
     "naniar", "VIM", "caret", "glmnet", "randomForest", "xgboost",
     "Ckmeans.1d.dp", "pROC", "ROCR"
   ))
   ```
3. Render the report. The lab events table is by far the largest (75 million usable rows), so this is slow and needs a lot of memory.
   ```r
   rmarkdown::render("report/capstone_analysis.Rmd")
   ```

## Citation

```
Lattanzi, J. (2025). Who Comes Back? Machine Learning for ICU Readmission Prediction.
MS in Applied Data Science capstone, Bay Path University.
```

Data: Johnson, A., Bulgarelli, L., Pollard, T., Gow, B., Moody, B., Horng, S., Celi, L. A., & Mark, R. (2024). MIMIC-IV (version 3). PhysioNet.

MIT License. Contact: [LinkedIn](https://linkedin.com/in/joseph-lattanzi) · [jlattanzi4.github.io](https://jlattanzi4.github.io)
