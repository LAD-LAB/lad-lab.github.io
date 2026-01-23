# Regression Analysis

Regression methods model relationships between predictors and outcomes. This page covers the regression approaches commonly used in FoodSeq analyses.

---

## Partial Least Squares Regression (PLSR)

### Purpose

Model relationships when predictors are highly collinear (correlated with each other), common in dietary composition data.

### Implementation

```r
library(pls)

# Fit PLSR model with cross-validation
model <- plsr(response ~ .,
              data = df,
              scale = TRUE,
              validation = "CV",
              segments = 10)

# View cross-validation results
summary(model)
validationplot(model, val.type = "MSEP")
```

### Selecting Components

```r
# Select optimal number of components
ncomp <- selectNcomp(model, method = "onesigma")

# Or use minimum PRESS
ncomp <- which.min(model$validation$PRESS)
```

### Variable Importance in Projection (VIP)

VIP scores identify the most influential predictors:

```r
# Calculate VIP scores
library(plsVarSel)
vip_scores <- VIP(model, opt.comp = ncomp)

# Or manual calculation
calculate_vip <- function(model, ncomp) {
  W <- model$loading.weights[, 1:ncomp, drop = FALSE]
  Q <- model$Yloadings[, 1:ncomp, drop = FALSE]
  SS <- colSums(model$scores[, 1:ncomp]^2) * c(Q)^2
  VIP <- sqrt(nrow(W) * rowSums(W^2 %*% diag(SS)) / sum(SS))
  return(VIP)
}
```

### VIP Interpretation

| VIP Score | Interpretation |
|-----------|----------------|
| > 2.0 | Very strong predictor |
| > 1.0 | Highly important |
| > 0.8 | Important predictor |
| < 0.8 | Lesser relevance |

---

## Linear Mixed-Effects Models

### Purpose

Account for repeated measures or hierarchical data structure (e.g., multiple samples per subject).

### Implementation

```r
library(lme4)
library(lmerTest)

# Random intercept model
model <- lmer(outcome ~ fixed_effect1 + fixed_effect2 + (1|subject_id),
              data = df)
summary(model)

# Random slope model
model <- lmer(outcome ~ time + treatment + (time|subject_id),
              data = df)
```

### Standard Covariates (Clinical Studies)

Include relevant confounders:

```r
model <- lmer(outcome ~ dietary_pc1 + dietary_pc2 +
              age + sex + treatment_intensity +
              sample_water_content + antibiotics +
              (1|subject_id) + (1|batch),
              data = df)
```

| Covariate Type | Examples |
|----------------|----------|
| Demographics | Age, sex, race/ethnicity |
| Clinical | Treatment intensity, disease stage |
| Sample | Water content, collection method |
| Technical | Sequencing batch, plate |
| Temporal | Week relative to event |

### Model Comparison

```r
# Compare nested models with likelihood ratio test
library(lmtest)
lrtest(model_full, model_reduced)

# Or using anova
anova(model_reduced, model_full)
```

---

## Generalized Linear Models (GLM)

### Gaussian GLM (Continuous Outcomes)

```r
# Multiple regression
model <- glm(bmi ~ pc1 + pc2 + age + sex,
             family = gaussian,
             data = df)
summary(model)

# With interaction
model <- glm(bmi ~ pc1 * country + pc2 + age + sex,
             family = gaussian,
             data = df)
```

### Binomial GLM (Binary Outcomes)

```r
# Logistic regression
model <- glm(has_disease ~ dietary_pattern + age + sex,
             family = binomial(link = "logit"),
             data = df)

# Extract odds ratios
exp(coef(model))           # Point estimates
exp(confint(model))        # 95% CI
```

### Interpreting Odds Ratios

| OR | Interpretation |
|----|----------------|
| 1.0 | No association |
| > 1.0 | Increased odds |
| < 1.0 | Decreased odds |

### Example Results

| Predictor | OR (95% CI) | p-value |
|-----------|-------------|---------|
| Corn presence → UPF consumption | 18.0 (10.8, 32.3) | <0.001 |
| Wheat + soybean → UPF consumption | 87.6 (32.9, 356.4) | <0.001 |
| Per additional species → UPF | 1.8 (1.6, 2.0) | <0.001 |

---

## Simple Linear Regression

### Implementation

```r
# Simple linear regression
model <- lm(detection_freq ~ order_freq, data = df)
summary(model)

# Extract key statistics
coef(model)              # Coefficients
confint(model)           # 95% CI
summary(model)$r.squared # R²
```

### Reporting

> Detection frequency increased with order frequency (β = 0.45 ± 0.08, R² = 0.31, p < 0.001).

---

## Model Diagnostics

### Check Assumptions

```r
# Residual plots
par(mfrow = c(2, 2))
plot(model)

# Normality of residuals
shapiro.test(residuals(model))

# Homoscedasticity
library(car)
ncvTest(model)

# Multicollinearity
vif(model)  # VIF > 5 indicates concern
```

### For Mixed Models

```r
# Check residuals
plot(model)
qqnorm(residuals(model))
qqline(residuals(model))

# Check random effects
ranef(model)
```

---

## Reporting Checklist

- [ ] State the model type (GLM, mixed effects, PLSR)
- [ ] List all covariates included
- [ ] Report effect estimates with 95% CI
- [ ] Report p-values (and correction method if multiple tests)
- [ ] For PLSR: report number of components and VIP scores
- [ ] For mixed models: specify random effects structure
- [ ] Report model fit statistics (R², AIC, etc.)
