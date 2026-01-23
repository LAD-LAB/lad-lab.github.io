# Survival Analysis

Survival analysis methods model time-to-event outcomes such as disease progression, treatment response, or relapse. This page covers methods for clinical FoodSeq studies.

---

## Cox Proportional Hazards Regression

### Purpose

Estimate hazard ratios (HR) for predictors of time-to-event outcomes while adjusting for covariates.

### Implementation

```r
library(survival)

# Basic Cox model
model <- coxph(Surv(time, status) ~ predictor1 + predictor2,
               data = df)
summary(model)

# With dietary PCs and covariates
model <- coxph(Surv(days_to_event, event_occurred) ~
               dietary_pc1 + dietary_pc2 +
               age + sex + treatment_intensity +
               strata(batch),
               data = df)
```

### Parameters

| Parameter | Description |
|-----------|-------------|
| `time` | Follow-up time |
| `status` | Event indicator (1 = event, 0 = censored) |
| `strata()` | Stratification variable (separate baseline hazards) |

### Interpreting Hazard Ratios

| HR | Interpretation |
|----|----------------|
| 1.0 | No effect |
| > 1.0 | Increased hazard (higher risk) |
| < 1.0 | Decreased hazard (protective) |
| 0.5 | 50% reduction in hazard |
| 2.0 | 2-fold increase in hazard |

### Example Results

```r
# Extract hazard ratios with CI
exp(coef(model))           # HR
exp(confint(model))        # 95% CI
```

| Predictor | HR (95% CI) | p-value |
|-----------|-------------|---------|
| Dietary PC1 (per SD) | 0.72 (0.58, 0.89) | 0.003 |
| Dietary PC2 (per SD) | 1.15 (0.94, 1.41) | 0.18 |

---

## Checking Proportional Hazards Assumption

```r
# Schoenfeld residuals test
cox.zph(model)

# Plot residuals
plot(cox.zph(model))
```

!!! warning "Non-proportional hazards"
    If the assumption is violated (p < 0.05), consider:

    - Stratifying by the offending variable
    - Adding time-varying covariates
    - Using alternative models

---

## Competing Risks: Fine-Gray Regression

### Purpose

Handle situations where multiple event types compete (e.g., relapse vs. death from other causes).

### Implementation

```r
library(cmprsk)

# Create model matrix
covariates <- model.matrix(~ pc1 + pc2 + age + sex, data = df)[, -1]

# Fine-Gray regression
model <- crr(ftime = df$time,
             fstatus = df$status,  # 0=censored, 1=event of interest, 2=competing
             cov1 = covariates)
summary(model)
```

### Status Coding

| Value | Meaning |
|-------|---------|
| 0 | Censored |
| 1 | Event of interest |
| 2 | Competing event |

---

## Kaplan-Meier Survival Curves

### Purpose

Visualize survival probabilities over time by group.

### Implementation

```r
library(survival)
library(survminer)

# Fit Kaplan-Meier curves
fit <- survfit(Surv(time, status) ~ group, data = df)

# Summary statistics
summary(fit)
print(fit, print.rmean = TRUE)  # Restricted mean survival time

# Plot with survminer
ggsurvplot(fit,
           data = df,
           pval = TRUE,
           risk.table = TRUE,
           conf.int = TRUE,
           xlab = "Days",
           ylab = "Survival Probability")
```

### Customization

```r
ggsurvplot(fit,
           palette = c("#E7B800", "#2E9FDF"),
           risk.table = TRUE,
           risk.table.col = "strata",
           ggtheme = theme_bw(),
           surv.median.line = "hv",
           legend.labs = c("Low dietary diversity", "High dietary diversity"))
```

---

## Log-Rank Test

### Purpose

Compare survival curves between groups (without covariates).

```r
# Log-rank test
survdiff(Surv(time, status) ~ group, data = df)
```

---

## Likelihood Ratio Tests

### Purpose

Compare nested models to test variable contributions.

```r
library(lmtest)

# Full vs. reduced model
model_full <- coxph(Surv(time, status) ~ pc1 + pc2 + age + sex, data = df)
model_reduced <- coxph(Surv(time, status) ~ age + sex, data = df)

lrtest(model_full, model_reduced)

# Or using anova
anova(model_reduced, model_full)
```

---

## Time-Varying Covariates

For predictors that change over time:

```r
# Create time-varying dataset
library(survival)

# Split at event times
df_tvc <- survSplit(Surv(time, status) ~ .,
                    data = df,
                    cut = unique(df$time[df$status == 1]),
                    episode = "timegroup")

# Model with time-varying covariate
model <- coxph(Surv(tstart, time, status) ~ pc1_tv + age + sex,
               data = df_tvc)
```

---

## Sample Size and Power

```r
library(powerSurvEpi)

# Power calculation for Cox regression
powerCT(nE = 100,           # Expected number of events
        HR = 0.7,           # Hazard ratio to detect
        alpha = 0.05)       # Significance level
```

---

## Reporting Checklist

- [ ] State the event definition and censoring criteria
- [ ] Report median follow-up time
- [ ] Report number of events and total sample size
- [ ] Include hazard ratios with 95% CI
- [ ] Report p-values
- [ ] State whether proportional hazards assumption was tested
- [ ] Include Kaplan-Meier curves for key comparisons
- [ ] Report number at risk at key time points

### Example Statement

> During a median follow-up of 180 days (IQR: 120-240), 45 events occurred among 150 patients. Higher dietary PC1 scores were associated with reduced hazard of the primary outcome (HR = 0.72, 95% CI: 0.58-0.89, p = 0.003), adjusting for age, sex, and treatment intensity.
