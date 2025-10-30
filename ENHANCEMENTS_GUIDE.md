# R Markdown Enhancement Guide
## Making Your Capstone Analysis Portfolio-Ready

## Step 1: Update Your YAML Header

Replace the current YAML header (lines 1-10) with this enhanced version:

```yaml
---
title: "Who Comes Back? Machine Learning for ICU Readmission Prediction"
subtitle: "Master of Science in Applied Data Science - Capstone Project"
author: "Joseph Lattanzi | Bay Path University"
date: "`r Sys.Date()`"
output:
  rmdformats::readthedown:
    code_folding: hide
    code_download: true
    highlight: kate
    toc_depth: 3
    number_sections: false
    self_contained: true
    thumbnails: false
    lightbox: true
    gallery: true
    css: custom_style.css
    includes:
      in_header: header.html
      after_body: footer.html
---
```

## Step 2: Add Custom Header (header.html)

This goes in the same directory as your Rmd file:

```html
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="Machine learning model predicting 30-day ICU readmissions with 0.683 AUC and $17.25M potential value">
<meta name="author" content="Joseph Lattanzi">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

<style>
/* Hero Banner at Top */
.hero-banner {
  background: linear-gradient(135deg, #2563eb 0%, #0ea5e9 100%);
  color: white;
  padding: 3rem 2rem;
  margin: -2rem -2rem 3rem -2rem;
  text-align: center;
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
}

.hero-banner h1 {
  color: white;
  font-size: 2.8rem;
  margin-bottom: 1rem;
  border: none;
}

.hero-banner .subtitle {
  font-size: 1.3rem;
  opacity: 0.95;
  font-weight: 400;
}

.hero-banner .key-metrics {
  display: flex;
  justify-content: center;
  gap: 3rem;
  margin-top: 2rem;
  flex-wrap: wrap;
}

.hero-banner .metric {
  text-align: center;
}

.hero-banner .metric-value {
  font-size: 2.5rem;
  font-weight: 700;
  display: block;
  margin-bottom: 0.5rem;
}

.hero-banner .metric-label {
  font-size: 0.95rem;
  opacity: 0.9;
}

/* Executive Summary Box */
.exec-summary {
  background: linear-gradient(135deg, #f8fafc 0%, #e0f2fe 100%);
  padding: 2rem;
  border-radius: 12px;
  border-left: 5px solid #2563eb;
  margin: 2rem 0;
  box-shadow: 0 4px 12px rgba(0,0,0,0.05);
}

.exec-summary h3 {
  color: #2563eb;
  margin-top: 0;
}
</style>
```

## Step 3: Add Custom Footer (footer.html)

```html
<div style="background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%); color: white; padding: 3rem 2rem; margin: 4rem -2rem -2rem -2rem; text-align: center;">
  <h3 style="color: white; margin-top: 0;">Contact & Links</h3>
  <p style="color: rgba(255,255,255,0.9); max-width: 800px; margin: 1rem auto;">
    This capstone project demonstrates end-to-end machine learning capabilities in healthcare analytics,
    featuring large-scale data engineering, model development, fairness analysis, and cost-benefit evaluation.
  </p>
  <div style="margin: 2rem 0; display: flex; justify-content: center; gap: 2rem; flex-wrap: wrap;">
    <a href="https://github.com/jlattanzi4/icu-readmission-prediction" target="_blank"
       style="color: white; text-decoration: none; padding: 0.75rem 1.5rem; background: rgba(255,255,255,0.1); border-radius: 8px; transition: all 0.3s;">
      📁 GitHub Repository
    </a>
    <a href="https://youtu.be/Le1AnfCN2xI" target="_blank"
       style="color: white; text-decoration: none; padding: 0.75rem 1.5rem; background: rgba(255,255,255,0.1); border-radius: 8px; transition: all 0.3s;">
      🎥 Video Presentation
    </a>
    <a href="https://linkedin.com/in/joseph-lattanzi" target="_blank"
       style="color: white; text-decoration: none; padding: 0.75rem 1.5rem; background: rgba(255,255,255,0.1); border-radius: 8px; transition: all 0.3s;">
      💼 LinkedIn
    </a>
    <a href="https://jlattanzi4.github.io" target="_blank"
       style="color: white; text-decoration: none; padding: 0.75rem 1.5rem; background: rgba(255,255,255,0.1); border-radius: 8px; transition: all 0.3s;">
      🌐 Portfolio
    </a>
  </div>
  <p style="color: rgba(255,255,255,0.7); font-size: 0.9rem; margin-top: 2rem;">
    Joseph Lattanzi | Bay Path University | 2025
  </p>
</div>
```

## Step 4: Enhance Your Introduction Section

Replace your introduction section with this enhanced version that includes a hero banner and executive summary:

````markdown
```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE, warning = FALSE, message = FALSE,
                      fig.width = 10, fig.height = 6, fig.align = 'center')

# Load libraries
library(dplyr)
library(ggplot2)
library(plotly)  # For interactive plots
library(DT)      # For interactive tables
library(knitr)
library(kableExtra)  # For better table styling
```

<div class="hero-banner">
  <h1>Who Comes Back?</h1>
  <div class="subtitle">Machine Learning for ICU Readmission Prediction</div>
  <div class="key-metrics">
    <div class="metric">
      <span class="metric-value">0.683</span>
      <span class="metric-label">AUC Score</span>
    </div>
    <div class="metric">
      <span class="metric-value">$17.25M</span>
      <span class="metric-label">Annual Net Benefit</span>
    </div>
    <div class="metric">
      <span class="metric-value">280%</span>
      <span class="metric-label">ROI</span>
    </div>
    <div class="metric">
      <span class="metric-value">70%</span>
      <span class="metric-label">Sensitivity</span>
    </div>
  </div>
</div>

<div class="exec-summary">
  <h3>🎯 Executive Summary</h3>

**The Challenge:** Despite $26 billion in annual readmission costs, predicting which ICU patients will return within 30 days remains unsolved.

**The Solution:** Machine learning model using 545,316 hospital admissions, 150M+ data points, and 57 engineered features.

**Key Results:**
- ✅ **0.683 AUC** — Correctly identifies 7 of 10 readmissions (49% better than baseline)
- ✅ **$17.25M annual value** — Net benefit for large academic hospitals
- ✅ **Efficient targeting** — Screen only 13 patients to prevent one readmission
- ✅ **Smart stratification** — Top 33% of patients contain 52.5% of readmissions

**Impact:** Enables hospitals to target high-risk patients for early intervention, reducing costly readmissions while optimizing resource allocation.
</div>

# 1. Introduction

Hospital readmissions represent a critical challenge in healthcare, with readmission rates remaining persistently high despite targeted interventions. Approximately 20% of Medicare beneficiaries experience readmission within 30 days, with average US hospital readmission rates of 14.67% across all conditions. Hospital readmissions cost approximately **$26 billion annually** in the United States.

This analysis aims to develop a predictive model for ICU readmissions using the MIMIC-IV dataset, focusing on identifying patients at high risk for readmission within 30 days of discharge.
````

## Step 5: Make Tables Interactive

Replace regular `kable()` tables with DT datatables for interactivity:

```r
# Instead of:
kable(data_summary, caption = 'MIMIC-IV Dataset Overview')

# Use:
datatable(data_summary,
          caption = 'MIMIC-IV Dataset Overview',
          options = list(
            pageLength = 10,
            dom = 'Bfrtip',
            buttons = c('copy', 'csv', 'excel'),
            scrollX = TRUE
          ),
          class = 'cell-border stripe hover',
          rownames = FALSE) %>%
  formatStyle(columns = colnames(data_summary),
              fontSize = '14px')
```

## Step 6: Make Plots Interactive with Plotly

Convert key ggplot visualizations to interactive plotly:

```r
# Instead of:
ggplot(data, aes(x = age, fill = readmit)) + ...

# Use:
p <- ggplot(data, aes(x = age, fill = readmit)) +
  geom_histogram() +
  theme_minimal() +
  labs(title = "Age Distribution by Readmission Status")

ggplotly(p, tooltip = c("x", "y", "fill"))
```

## Step 7: Add Section Badges

Add visual badges to highlight key sections:

```markdown
# 5. Model Results {.tabset}

<span style="background: #10b981; color: white; padding: 0.25rem 0.75rem; border-radius: 12px; font-size: 0.85rem; font-weight: 600;">✓ BEST MODEL</span>

## XGBoost Performance

The XGBoost model achieved the best performance...
```

## Step 8: Improve Code Chunk Options

Use better chunk options for professional output:

```r
```{r model-training, cache=TRUE, fig.cap="XGBoost Feature Importance", fig.width=12, fig.height=8}
# Your code here
```
```

## Step 9: Re-knit Your Document

In RStudio:
1. Open `Capstone_Analysis_FINAL.Rmd`
2. Make sure `custom_style.css`, `header.html`, and `footer.html` are in the same directory
3. Click **Knit** button
4. The output will be dramatically improved!

## Key Improvements Summary

✅ **Professional color scheme** — Modern blue gradient design
✅ **Custom typography** — Google Fonts (Inter & JetBrains Mono)
✅ **Interactive elements** — Plotly charts, DT tables
✅ **Hero banner** — Eye-catching header with key metrics
✅ **Executive summary** — Quick overview for busy viewers
✅ **Enhanced tables** — Styled, sortable, searchable
✅ **Professional footer** — Contact info and links
✅ **Responsive design** — Works on all devices
✅ **Smooth animations** — Polished interactions
✅ **Better code display** — Syntax highlighting, folding

## Result

Your HTML report will look like a **professional data science portfolio piece** rather than an academic report. Perfect for impressing employers!
