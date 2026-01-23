# Reporting Standards

This page provides reference tables for statistical thresholds, visualization conventions, and reporting checklists for FoodSeq analyses.

---

## Statistical Significance

### P-Value Thresholds

| Notation | Threshold | Interpretation |
|----------|-----------|----------------|
| ns | p ≥ 0.05 | Not significant |
| * | p < 0.05 | Significant |
| ** | p < 0.01 | Highly significant |
| *** | p < 0.001 | Very highly significant |

!!! note "Always report exact p-values"
    While asterisks are useful for figures, report exact p-values in text (e.g., p = 0.023) except when very small (p < 0.001).

---

## Method-Specific Thresholds

### Variable Importance (PLSR)

| VIP Score | Interpretation |
|-----------|----------------|
| > 2.0 | Very strong predictor |
| > 1.0 | Highly important |
| > 0.8 | Important predictor |
| < 0.8 | Lesser relevance |

### PCA Loadings

| Loading | Use |
|---------|-----|
| \|Loading\| > 0.7 | Include in visualization/interpretation |
| \|Loading\| > 0.5 | Notable contributor |
| \|Loading\| < 0.3 | Minor contributor |

### Microbiome Community Disruption

| Threshold | Definition |
|-----------|------------|
| ≥ 30% relative abundance | Dominated community |
| ≥ 50% relative abundance | Severely disrupted |

### Quality Control

| Metric | Threshold | Action |
|--------|-----------|--------|
| Expected errors (DADA2) | > 2 | Discard read |
| Quality score (DADA2) | ≤ 2 | Truncation point |
| Primer error tolerance | 15% | Cutadapt matching |
| Outlier (z-score) | \|z\| > 3 | Consider exclusion |
| Well-detected ingredients | >90% true positive | High confidence |

---

## Clinical Definitions

| Metric | Threshold | Definition |
|--------|-----------|------------|
| Inflammation (CRP) | > 3.0 mg/L | Inflamed |
| Low albumin | < 3.5 g/dL | Below normal |
| Low caloric intake | < 700 kcal/day | Nutritionally compromised |

---

## Visualization Conventions

### Box Plots

| Element | Definition |
|---------|------------|
| Box hinges | 25th and 75th percentiles |
| Horizontal line | Median |
| Whiskers | 1.5 × IQR from hinges |
| Points beyond whiskers | Outliers |
| Jittered points | Individual observations |

```r
ggplot(df, aes(x = group, y = value)) +
  geom_boxplot(outlier.shape = NA) +
  geom_jitter(width = 0.2, alpha = 0.5) +
  theme_bw()
```

### Compact Letter Display

Groups sharing letters are **not** significantly different:

```r
library(multcomp)
library(multcompView)

# After ANOVA + Tukey
aov_result <- aov(value ~ group, data = df)
tukey <- TukeyHSD(aov_result)
cld <- multcompLetters4(aov_result, tukey)
```

### Color Palettes

```r
# Accessible color palettes
library(RColorBrewer)
display.brewer.all(colorblindFriendly = TRUE)

# Recommended palettes
brewer.pal(3, "Set2")     # Qualitative
brewer.pal(5, "Blues")    # Sequential
brewer.pal(7, "RdBu")     # Diverging
```

---

## Figure Standards

### Resolution and Format

| Use | Format | Resolution |
|-----|--------|------------|
| Journal submission | TIFF/EPS | 300-600 dpi |
| Presentations | PNG | 150 dpi |
| Web | PNG/SVG | 72-150 dpi |

```r
# Save high-resolution figure
ggsave("figure.tiff", width = 7, height = 5, dpi = 300)
ggsave("figure.pdf", width = 7, height = 5)  # Vector format
```

### Font Sizes

| Element | Minimum Size |
|---------|--------------|
| Axis labels | 10 pt |
| Tick labels | 8 pt |
| Legend text | 8 pt |
| Figure title | 12 pt |

---

## Reporting Checklists

### Statistical Analysis (General)

- [ ] Report exact software versions
- [ ] State significance threshold (typically α = 0.05)
- [ ] Specify FDR correction method if applicable
- [ ] Report sample sizes (total and per group)
- [ ] Include 95% confidence intervals for effect estimates
- [ ] State whether tests were one- or two-tailed

### PERMANOVA

- [ ] State distance metric (e.g., Euclidean on CLR data)
- [ ] Report number of permutations
- [ ] Report R² and p-value
- [ ] Test and report dispersion (PERMDISP) if applicable

### Regression Models

- [ ] List all covariates included
- [ ] Report effect estimates (β, OR, or HR)
- [ ] Include 95% CI
- [ ] Report p-values
- [ ] State model type (GLM family, mixed effects structure)

### PLSR

- [ ] Report number of components selected
- [ ] State component selection method
- [ ] Report VIP scores for key predictors
- [ ] Report cross-validation method

### Survival Analysis

- [ ] State event definition
- [ ] Report median follow-up time
- [ ] Report number of events
- [ ] Test proportional hazards assumption
- [ ] Include Kaplan-Meier curves

### CLR Transformation

- [ ] State pseudo-count handling method
- [ ] Specify if zeros were replaced

---

## Example Methods Section

> **Statistical Analysis**
>
> All analyses were performed in R v4.2.1. Dietary composition data was CLR-transformed using the microbiome package (v1.28.0) with a pseudo-count of half the minimum non-zero value. Principal component analysis was performed on CLR-transformed data using prcomp() with centering but no scaling.
>
> Compositional differences between groups were tested using PERMANOVA (vegan v2.6-4; 1000 permutations, Euclidean distance). Associations between dietary principal components and continuous outcomes were assessed using linear mixed-effects models (lme4 v1.1-35.5) with subject as a random intercept, adjusting for age, sex, and treatment intensity. Time-to-event outcomes were analyzed using Cox proportional hazards regression (survival v3.7-0).
>
> P-values were adjusted for multiple comparisons using the Benjamini-Hochberg method. Statistical significance was defined as adjusted p < 0.05.

---

## Quick Reference: R Code Templates

```r
# Standard analysis workflow
library(tidyverse)
library(phyloseq)
library(microbiome)
library(vegan)
library(lme4)
library(lmerTest)
library(survival)

# 1. Transform data
ps_clr <- transform(ps, "clr")

# 2. PERMANOVA
adonis2(otu_table(ps_clr) ~ group, data = sample_data(ps), permutations = 1000)

# 3. Mixed model
lmer(outcome ~ pc1 + pc2 + age + sex + (1|subject), data = df)

# 4. Survival
coxph(Surv(time, status) ~ pc1 + age + sex, data = df)

# 5. Adjust p-values
p.adjust(p_values, method = "BH")
```
