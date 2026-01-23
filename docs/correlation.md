# Correlation Analysis

Correlation tests measure the strength and direction of associations between variables. This page covers the standard correlation methods used in FoodSeq analyses.

---

## Spearman Rank Correlation

### Purpose

Test **monotonic** associations between variables without assuming linearity. Robust to outliers and non-normal distributions.

### Implementation

```r
# Basic Spearman correlation
cor.test(x, y, method = "spearman", alternative = "two.sided")

# Get correlation coefficient only
cor(x, y, method = "spearman")
```

### Interpretation

| ρ (rho) | Interpretation |
|---------|----------------|
| 0.0 - 0.2 | Negligible |
| 0.2 - 0.4 | Weak |
| 0.4 - 0.6 | Moderate |
| 0.6 - 0.8 | Strong |
| 0.8 - 1.0 | Very strong |

!!! note "Sign matters"
    Negative ρ indicates inverse relationship (as X increases, Y decreases).

### Example Applications

| Comparison | Typical ρ | Context |
|------------|-----------|---------|
| Wastewater vs. stool composition | 0.64 | Population surveillance validation |
| Plant richness vs. PC1 | -0.57 | Dietary pattern analysis |
| PC2 vs. HEI dietary quality | 0.39 | Diet quality assessment |
| Fish consumption vs. distance to coast | -0.65 | Geographic dietary patterns |

---

## Pearson Correlation

### Purpose

Test **linear** associations when both variables are normally distributed.

### Implementation

```r
# Basic Pearson correlation
cor.test(x, y, method = "pearson")

# Check assumptions first
shapiro.test(x)  # Test normality
shapiro.test(y)
```

### When to Use Pearson vs. Spearman

| Condition | Use |
|-----------|-----|
| Both variables normally distributed | Pearson |
| One or both variables non-normal | Spearman |
| Ordinal data | Spearman |
| Outliers present | Spearman |
| Linear relationship expected | Pearson |
| Monotonic (but not linear) relationship | Spearman |

---

## Correlation Matrices

### Pairwise Correlations

```r
# Correlation matrix for multiple variables
cor_matrix <- cor(data_matrix, method = "spearman", use = "pairwise.complete.obs")

# With p-values using Hmisc
library(Hmisc)
cor_results <- rcorr(as.matrix(data_matrix), type = "spearman")
cor_results$r   # Correlation coefficients
cor_results$P   # P-values
```

### Visualization

```r
library(corrplot)

# Basic correlation plot
corrplot(cor_matrix, method = "circle", type = "upper")

# With significance masking
corrplot(cor_matrix, method = "circle", type = "upper",
         p.mat = cor_results$P, sig.level = 0.05, insig = "blank")
```

---

## Partial Correlation

### Purpose

Measure association between two variables while controlling for confounders.

```r
library(ppcor)

# Partial correlation controlling for z
pcor.test(x, y, z, method = "spearman")

# Multiple control variables
pcor.test(x, y, list(z1, z2, z3), method = "spearman")
```

### Example

```r
# Correlation between dietary diversity and health outcome
# controlling for age and sex
pcor.test(diversity, outcome, list(age, sex), method = "spearman")
```

---

## Reporting Correlations

### Standard Format

> There was a moderate positive correlation between X and Y (ρ = 0.45, p < 0.001).

### Checklist

- [ ] Report correlation coefficient (r or ρ)
- [ ] Specify method (Pearson or Spearman)
- [ ] Report p-value
- [ ] Report sample size (n)
- [ ] Note if FDR-corrected (for multiple comparisons)

### Example Table

| Variable 1 | Variable 2 | ρ | p-value | n |
|------------|------------|---|---------|---|
| Plant richness | Shannon diversity | 0.82 | <0.001 | 150 |
| PC1 | BMI | 0.31 | 0.003 | 150 |
| Animal DNA % | Protein intake | 0.45 | <0.001 | 150 |

---

## Common Pitfalls

!!! warning "Correlation ≠ Causation"
    A significant correlation does not imply that X causes Y (or vice versa). Consider:

    - Reverse causation
    - Confounding variables
    - Bidirectional relationships

!!! warning "Multiple Testing"
    When testing many correlations, correct for multiple comparisons:

    ```r
    p_adjusted <- p.adjust(p_values, method = "BH")
    ```

!!! warning "Compositional Data"
    Correlations between compositional variables (like relative abundances) can be spurious due to the constant-sum constraint. Use:

    - CLR-transformed data
    - SparCC (for sparse compositional data)
    - SPIEC-EASI
