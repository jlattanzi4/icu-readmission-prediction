# Who Comes Back? Machine Learning for ICU Readmission Prediction

**Master of Science in Applied Data Science - Capstone Project**
*Joseph Lattanzi, Bay Path University, 2025*

> Capstone project. Recorded presentation linked below.

[![Watch Presentation](https://img.shields.io/badge/YouTube-Watch%20Presentation-red?logo=youtube)](https://youtu.be/Le1AnfCN2xI)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

## Overview

ICU discharge is not the end of the story. For 20% of patients, it's the beginning of a dangerous and costly cycle. This project develops a machine learning model to predict 30-day ICU readmissions using the MIMIC-IV dataset (545,316 admissions from 2008-2019).

**Key Results:**
- **0.683 AUC** on a temporally held-out test set (train 2008–2017, test 2018–2019)
- **70% sensitivity**: catches 7 of 10 readmissions
- **29.8% precision vs. 20% base rate**: flagged patients are ~49% more likely to be readmitted than a random patient
- **Top-risk third of patients holds 52.5% of readmissions**
- Fairness audit found an **11-point sensitivity gap** between Black and White patients (see limitations)

## Abstract

Despite $26 billion in annual readmission costs and penalties for hospitals, predicting which ICU patients will return remains unsolved. We developed a machine learning model using the MIMIC-IV dataset, engineering 57 clinical features from 150+ million raw data points across six interconnected tables.

Using temporal validation (training 2008-2017, testing 2018-2019), we compared logistic regression, random forest, and XGBoost models. XGBoost achieved 0.683 AUC, with top predictors being medication count, age, length of stay, and hospital mortality flags—validating multi-dimensional complexity over single-condition flags.

Risk stratification showed the highest-risk 33% of patients contained 52.5% of all readmissions. With 50% greater efficiency than random intervention, the model requires screening only 13 patients to prevent one readmission.

**Critical limitations:** Single-center data limits generalizability, missing post-discharge variables create a performance ceiling, and fairness analysis revealed an 11 percentage point sensitivity disparity between Black and White patient groups requiring group-specific calibration. Prospective validation and randomized pilot testing with ongoing equity monitoring are required before clinical deployment.

## Project Structure

```
.
├── report/
│   ├── capstone_analysis.Rmd    # Full analysis (R Markdown)
│   └── capstone_analysis.html   # Rendered report with all results
├── paper/
│   ├── scientific_paper.pdf     # Written paper
│   └── abstract.txt
├── R/                           # Scripts that produce the figures in images/
├── images/                      # Figures
└── data/                        # MIMIC-IV tables (not included, see below)
```

To reproduce: obtain credentialed MIMIC-IV access from PhysioNet, place the `.csv.gz` tables in `data/`, and knit `report/capstone_analysis.Rmd`.

## Key Findings

### Model Performance
- **Best Model**: XGBoost with temporal validation
- **AUC**: 0.683 (test set)
- **Sensitivity**: 70% (correctly identifies 7/10 readmissions)
- **Precision (PPV)**: 29.8% vs. a 20% base rate

### Top Predictive Features
1. **Medication count** - Proxy for clinical complexity
2. **Age** - Patient demographics
3. **Length of stay** - Healthcare utilization
4. **Hospital mortality flags** - Risk indicators

### Financial Impact (illustrative scenario)
This is a literature-based scenario, not a measured outcome. It assumes:
- **$26,000** cost per readmission
- **$500** per post-discharge intervention
- **25%** intervention effectiveness (sensitivity range tested: 15–48%)

Under those assumptions, a large academic hospital (30,000 annual discharges) would see roughly **$17M in annual net benefit (~280% ROI)**, and about **13 flagged patients would need intervention to prevent one readmission**. Prospective validation would be required before trusting any of these figures.

### Risk Stratification
- Highest-risk **33% of patients** contain **52.5% of readmissions**
- Enables efficient resource allocation
- Targets interventions where they matter most

## Technical Approach

### Data Source
- **MIMIC-IV Database**: Medical Information Mart for Intensive Care
- **Size**: 545,316 hospital admissions, 2008-2019
- **Institution**: Beth Israel Deaconess Medical Center
- **Access**: Requires credentialed access from PhysioNet

### Feature Engineering
- **57 clinical features** engineered from raw data
- **150+ million data points** across 6 interconnected tables
- Feature categories:
  - Comorbidity indices (Charlson, Elixhauser)
  - Healthcare utilization patterns
  - Medication risk profiles
  - Clinical complexity metrics

### Model Development
- **Temporal validation**: Train 2008-2017, test 2018-2019
- **Models**: Logistic Regression, Random Forest, XGBoost
- **Tuning**: Grid search with cross-validation
- **Evaluation**: AUC-ROC, calibration, fairness metrics

### Technologies
- **R**: Primary programming language
- **tidyverse**: Data manipulation
- **xgboost**: Gradient boosting
- **caret**: Model training framework
- **ROCR, pROC**: Model evaluation
- **ggplot2**: Visualizations

## Critical Limitations

1. **Generalizability**: Single-center data (BIDMC) may not transfer to other hospitals
2. **Missing Variables**: No post-discharge data (housing, medication adherence, caregiver support)
3. **Fairness Concerns**: 11pp sensitivity disparity between Black and White patients
4. **Temporal Drift**: Healthcare practices change; model needs regular retraining

## Before Clinical Deployment

**Required validation steps:**
- ✅ Retrospective validation complete
- ⬜ Prospective validation on new data
- ⬜ Multi-site external validation
- ⬜ Randomized controlled pilot
- ⬜ Fairness monitoring system
- ⬜ EHR integration
- ⬜ Clinician training program

## Project Materials

- **[Full Analysis (HTML)](report/capstone_analysis.html)** - Complete analysis with visualizations
- **[R Markdown Source](report/capstone_analysis.Rmd)** - Reproducible analysis code
- **[Paper](paper/scientific_paper.pdf)** - Written paper
- **[Abstract](paper/abstract.txt)** - 250-word project summary
- **[Video Presentation](https://youtu.be/Le1AnfCN2xI)** - 30-minute capstone defense

## Running the Analysis

### Prerequisites
```r
install.packages(c("tidyverse", "xgboost", "caret", "ROCR", "pROC",
                   "ggplot2", "knitr", "rmarkdown"))
```

### Data Access
1. Complete CITI training for human subjects research
2. Request access to MIMIC-IV at [PhysioNet](https://physionet.org/content/mimiciv/)
3. Download and place data files in `Data/` directory
4. Update file paths in the R Markdown file

### Execute Analysis
```r
# Open in RStudio
rmarkdown::render("Capstone_Analysis_FINAL.Rmd")
```

## Citation

If you use this work, please cite:

```
Lattanzi, J. (2025). Who Comes Back? Machine Learning for ICU Readmission Prediction.
Master of Science in Applied Data Science Capstone Project, Bay Path University.
```

## License

MIT License - See LICENSE file for details

## Acknowledgments

- **MIMIC-IV**: Johnson, A., Bulgarelli, L., Pollard, T., Horng, S., Celi, L. A., & Mark, R. (2023). MIMIC-IV (version 2.2). PhysioNet.
- **Bay Path University**: MS in Applied Data Science program faculty and advisors
- **PhysioNet**: For providing credentialed access to healthcare data

## Contact

**Joseph Lattanzi**
- Email: lattanzi.joseph@gmail.com
- LinkedIn: [joseph-lattanzi](https://linkedin.com/in/joseph-lattanzi)
- Portfolio: [jlattanzi4.github.io](https://jlattanzi4.github.io)


