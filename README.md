# Who Comes Back? Machine Learning for ICU Readmission Prediction

**Master of Science in Applied Data Science - Capstone Project**
*Joseph Lattanzi, Bay Path University, 2025*

[![Watch Presentation](https://img.shields.io/badge/YouTube-Watch%20Presentation-red?logo=youtube)](https://youtu.be/Le1AnfCN2xI)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

## Overview

ICU discharge is not the end of the story. For 20% of patients, it's the beginning of a dangerous and costly cycle. This project develops a machine learning model to predict 30-day ICU readmissions using the MIMIC-IV dataset (545,316 admissions from 2008-2019).

**Key Results:**
- **0.683 AUC** on held-out test set (49% better than baseline)
- **$17.25M annual net benefit** for large academic hospitals
- **280% ROI** through targeted intervention
- Correctly identifies **7 of 10 readmissions**

## Abstract

Despite $26 billion in annual readmission costs and penalties for hospitals, predicting which ICU patients will return remains unsolved. We developed a machine learning model using the MIMIC-IV dataset, engineering 57 clinical features from 150+ million raw data points across six interconnected tables.

Using temporal validation (training 2008-2017, testing 2018-2019), we compared logistic regression, random forest, and XGBoost models. XGBoost achieved 0.683 AUC, with top predictors being medication count, age, length of stay, and hospital mortality flags—validating multi-dimensional complexity over single-condition flags.

Risk stratification showed the highest-risk 33% of patients contained 52.5% of all readmissions. With 50% greater efficiency than random intervention, the model requires screening only 13 patients to prevent one readmission.

**Critical limitations:** Single-center data limits generalizability, missing post-discharge variables create a performance ceiling, and fairness analysis revealed an 11 percentage point sensitivity disparity between Black and White patient groups requiring group-specific calibration. Prospective validation and randomized pilot testing with ongoing equity monitoring are required before clinical deployment.

## Project Structure

```
.
├── README.md                              # This file
├── Capstone_Analysis_FINAL.Rmd           # Complete R Markdown analysis
├── Capstone_Analysis_FINAL.html          # Full HTML report with results
├── Capstone_Abstract.txt                 # 250-word abstract
├── FINAL_PRESENTATION_COMPLETE.md        # Presentation slides
├── images/                               # Visualizations
│   ├── ROC_curves.png                   # Model performance comparison
│   ├── top_15_features_xgboost.png      # Feature importance
│   ├── confusion_matrix_heatmap_v2.png  # Model predictions
│   ├── roi_comparison_chart.png         # Financial impact
│   ├── data_completeness_chart_v2.png   # Data quality analysis
│   └── ...
└── Data/                                # MIMIC-IV data files (not included)
```

## Key Findings

### Model Performance
- **Best Model**: XGBoost with temporal validation
- **AUC**: 0.683 (test set)
- **Sensitivity**: 70% (correctly identifies 7/10 readmissions)
- **Specificity**: Optimized for high-risk patient identification

### Top Predictive Features
1. **Medication count** - Proxy for clinical complexity
2. **Age** - Patient demographics
3. **Length of stay** - Healthcare utilization
4. **Hospital mortality flags** - Risk indicators

### Financial Impact
- **Net Benefit**: $17.25M annually (large academic hospital)
- **ROI**: 280%
- **Efficiency**: Screen 13 patients to prevent 1 readmission
- **Cost per Readmission**: ~$46,000

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

- **[Full Analysis (HTML)](Capstone_Analysis_FINAL.html)** - Complete analysis with visualizations
- **[R Markdown Source](Capstone_Analysis_FINAL.Rmd)** - Reproducible analysis code
- **[Abstract](Capstone_Abstract.txt)** - 250-word project summary
- **[Presentation Slides](FINAL_PRESENTATION_COMPLETE.md)** - Complete slide deck
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

---

*This project demonstrates advanced data science capabilities in healthcare analytics, featuring large-scale data engineering, machine learning modeling, fairness analysis, and cost-benefit evaluation—all critical skills for real-world data science applications.*

