# Data Transformations

Data transformations are essential for preparing FoodSeq data for statistical analysis. This page covers the standard preprocessing steps and transformations used in dietary DNA analysis.

---

## Preprocessing

### Host/Primate Read Removal

Remove human-derived sequences from 12SV5 animal data before analysis:

```r
# Remove reads assigned to Primates order
ps_animal <- subset_taxa(ps_animal, Order != "Primates")
```

!!! note "Why remove primate reads?"
    Human DNA can contaminate fecal samples. Removing Primates-assigned reads ensures you're analyzing dietary animal content, not host DNA.

### Unassigned Read Removal

Exclude trnL reads not assignable to human food taxa:

```r
# Keep only assigned food taxa
ps_plant <- subset_taxa(ps_plant, !is.na(Genus))
```

---

## Centered Log-Ratio (CLR) Transformation

### Purpose

Sequencing data is **compositional**—the total reads per sample are constrained, so an increase in one taxon's reads necessarily decreases others' proportions. CLR transformation addresses this by:

- Converting to log-ratios relative to the geometric mean
- Allowing standard statistical methods (PCA, t-tests) to be applied
- Preserving relative differences between taxa

### Implementation

```r
library(microbiome)
ps_clr <- transform(ps, "clr")
```

### Zero Handling

Zeros are problematic for log transformations. Add a pseudo-count before CLR:

```r
# Add pseudo-count (half the lowest non-zero value)
min_nonzero <- min(otu_table(ps)[otu_table(ps) > 0])
pseudo_count <- min_nonzero / 2

# Manual CLR with pseudo-count
otu_pseudo <- otu_table(ps) + pseudo_count
clr_matrix <- t(apply(otu_pseudo, 1, function(x) {
  log(x) - mean(log(x))
}))
```

### Interpretation

| CLR Value | Meaning |
|-----------|---------|
| Positive | Above sample's geometric mean |
| Negative | Below sample's geometric mean |
| Zero | At the geometric mean |

!!! warning "CLR values are relative"
    CLR values cannot be compared across samples in absolute terms—they represent each taxon's abundance relative to that sample's geometric mean.

---

## Scaling and Centering

### Purpose

Standardize predictor variables for regression models so coefficients are comparable:

```r
# Scale and center demographic variables
demo_scaled <- scale(demo_data, center = TRUE, scale = TRUE)
```

| Parameter | Effect |
|-----------|--------|
| `center = TRUE` | Subtract mean (mean becomes 0) |
| `scale = TRUE` | Divide by SD (SD becomes 1) |

### When to Use

- **Regression models** with predictors on different scales
- **Comparing coefficient magnitudes** across variables
- **PLS regression** (typically done automatically)

---

## Log Transformations

Different log transformations serve different purposes:

| Data Type | Transformation | Code | Purpose |
|-----------|---------------|------|---------|
| SCFA proportions | Natural log | `log(x)` | Normalize for Gaussian modeling |
| Fecal water content | Log10 | `log10(x)` | Covariate normalization |
| Copy numbers | Log10 | `log10(x)` | Normalize skewed distributions |
| Read counts | Log2 | `log2(x + 1)` | Fold-change interpretation |

### Example

```r
# Natural log transformation for SCFA data
scfa_log <- log(scfa_data)

# Log10 for copy numbers (add 1 to handle zeros)
copies_log <- log10(copy_numbers + 1)
```

---

## Relative Abundance

Convert raw counts to proportions within each sample:

```r
# Transform to relative abundance
ps_rel <- transform_sample_counts(ps, function(x) x / sum(x))

# Or using microbiome package
library(microbiome)
ps_rel <- transform(ps, "compositional")
```

!!! note "When to use relative abundance vs CLR"
    - **Relative abundance:** Visualization, stacked bar plots, descriptive summaries
    - **CLR:** Statistical tests, PCA, regression models

---

## Presence/Absence

Binary transformation useful for certain analyses:

```r
# Convert to presence/absence (0/1)
otu_binary <- otu_table(ps)
otu_binary[otu_binary > 0] <- 1
```

### Applications

- **Jaccard distance** calculations
- **Detection frequency** analyses
- **Co-occurrence** networks

---

## Rarefaction

Subsample to even sequencing depth (use with caution):

```r
# Rarefy to minimum sample depth
min_depth <- min(sample_sums(ps))
ps_rarefied <- rarefy_even_depth(ps, sample.size = min_depth, rngseed = 123)
```

!!! warning "Rarefaction discards data"
    Rarefaction is controversial because it discards valid sequencing data. Consider using:

    - **CLR transformation** (handles uneven depths)
    - **Variance-stabilizing transformations** (DESeq2)
    - **Rarefaction only for diversity metrics** where depth strongly biases results

---

## Summary Table

| Transformation | Function | Use Case |
|----------------|----------|----------|
| CLR | `transform(ps, "clr")` | PCA, statistical tests |
| Relative abundance | `transform(ps, "compositional")` | Visualization, bar plots |
| Log | `log()`, `log10()` | Normalize skewed data |
| Scale/center | `scale()` | Regression predictors |
| Presence/absence | `x > 0` | Detection, co-occurrence |
| Rarefaction | `rarefy_even_depth()` | Diversity metrics (caution) |
