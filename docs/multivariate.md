# Multivariate Tests

Multivariate tests assess differences in overall composition across groups. This page covers PERMANOVA and ANOVA, the primary methods for testing group differences in FoodSeq data.

---

## PERMANOVA

### Purpose

**Permutational Multivariate Analysis of Variance** tests whether the centroids and dispersion of groups differ in multivariate space. It's the go-to method for testing compositional differences across groups.

### Implementation

```r
library(vegan)

# Basic PERMANOVA
result <- adonis2(clr_matrix ~ group,
                  data = metadata,
                  permutations = 1000,
                  method = "euclidean")
result
```

### Parameters

| Parameter | Value | Notes |
|-----------|-------|-------|
| `permutations` | 1000 | Standard; increase for publication |
| `method` | "euclidean" | Use with CLR-transformed data |
| `method` | "bray" | Use with relative abundance data |

### Multiple Factors

```r
# Multiple factors
result <- adonis2(clr_matrix ~ group + time + group:time,
                  data = metadata,
                  permutations = 1000,
                  method = "euclidean")

# Controlling for covariates
result <- adonis2(clr_matrix ~ age + sex + group,
                  data = metadata,
                  permutations = 1000,
                  method = "euclidean")
```

!!! note "Order matters"
    In sequential PERMANOVA, the order of terms affects results. Variables listed first have priority. Use `by = "margin"` for marginal effects:

    ```r
    adonis2(clr_matrix ~ group + time, by = "margin", ...)
    ```

### Interpretation

| Output | Meaning |
|--------|---------|
| R² | Proportion of variance explained by factor |
| F | Pseudo-F statistic |
| Pr(>F) | P-value from permutation test |

### Example Results

| Factor | R² | p-value | Interpretation |
|--------|-----|---------|----------------|
| County | 0.090 | 0.001 | Geographic location explains 9% of dietary variation |
| Time | 0.019 | 0.001 | Temporal changes explain 2% |
| Country | 0.134 | <0.001 | Country explains 13% of variation |

---

## Testing Assumptions: PERMDISP

PERMANOVA can be sensitive to differences in group dispersion (spread). Test this assumption with PERMDISP:

```r
# Calculate distances
dist_matrix <- dist(clr_matrix, method = "euclidean")

# Test dispersion
disp <- betadisper(dist_matrix, metadata$group)
permutest(disp, permutations = 1000)

# Visualize
plot(disp)
boxplot(disp)
```

!!! warning "Significant PERMDISP"
    If PERMDISP is significant, PERMANOVA results may reflect dispersion differences rather than location (centroid) differences. Report both tests.

---

## Pairwise Comparisons

For >2 groups, follow up with pairwise PERMANOVA:

```r
library(pairwiseAdonis)

# Pairwise comparisons with FDR correction
pairwise.adonis2(clr_matrix ~ group,
                 data = metadata,
                 p.adjust.m = "BH")
```

Or manually:

```r
# Manual pairwise for groups A, B, C
groups <- unique(metadata$group)
pairs <- combn(groups, 2, simplify = FALSE)

pairwise_results <- lapply(pairs, function(pair) {
  subset_idx <- metadata$group %in% pair
  adonis2(clr_matrix[subset_idx, ] ~ group,
          data = metadata[subset_idx, ],
          permutations = 1000)
})
```

---

## ANOVA

### Purpose

Test differences in a **single continuous variable** across groups.

### One-Way ANOVA

```r
# Basic ANOVA
aov_result <- aov(diversity ~ group, data = df)
summary(aov_result)

# Or using lm
lm_result <- lm(diversity ~ group, data = df)
anova(lm_result)
```

### Post-hoc Tests

```r
# Tukey's HSD
TukeyHSD(aov_result)

# Or with emmeans
library(emmeans)
emmeans(aov_result, pairwise ~ group, adjust = "tukey")
```

### Non-parametric Alternative: Kruskal-Wallis

When ANOVA assumptions aren't met:

```r
# Kruskal-Wallis test
kruskal.test(diversity ~ group, data = df)

# Post-hoc Dunn test
library(dunn.test)
dunn.test(df$diversity, df$group, method = "bh")
```

---

## Assumptions Checklist

### PERMANOVA

- [x] Observations are independent
- [x] Groups have similar dispersions (check with PERMDISP)
- [x] Appropriate distance metric chosen

### ANOVA

- [ ] Normality of residuals (`shapiro.test(residuals(model))`)
- [ ] Homogeneity of variance (`leveneTest(y ~ group)`)
- [ ] Independence of observations

---

## Reporting

### PERMANOVA

> Dietary composition differed significantly by country (PERMANOVA: R² = 0.134, F = 12.3, p < 0.001, 1000 permutations).

### ANOVA

> Shannon diversity differed across dietary patterns (F(2,147) = 8.45, p < 0.001). Post-hoc Tukey tests revealed that the Salad Bowl pattern had higher diversity than Starchy (p = 0.002) and Mixed (p = 0.01) patterns.

---

## Distance Metrics

| Metric | Data Type | Notes |
|--------|-----------|-------|
| Euclidean | CLR-transformed | Standard for CLR data |
| Bray-Curtis | Relative abundance | Accounts for abundance |
| Jaccard | Presence/absence | Binary data |
| Aitchison | Raw counts | CLR + Euclidean combined |
| UniFrac | Phylogenetic data | Incorporates phylogeny |

```r
# Calculate different distance matrices
library(vegan)

dist_euc <- dist(clr_matrix, method = "euclidean")
dist_bray <- vegdist(rel_abundance, method = "bray")
dist_jaccard <- vegdist(binary_matrix, method = "jaccard")
```
