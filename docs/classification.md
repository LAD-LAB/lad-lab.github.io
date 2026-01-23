# Classification & ROC Analysis

Classification methods predict categorical outcomes and evaluate prediction performance. This page covers ROC analysis and related diagnostic methods.

---

## ROC Analysis

### Purpose

Evaluate the ability of a continuous predictor to classify samples into binary categories (e.g., high vs. low intake, disease vs. healthy).

### Implementation

```r
library(pROC)

# Create ROC curve
roc_obj <- roc(response = df$status,     # Binary outcome (0/1)
               predictor = df$score,      # Continuous predictor
               levels = c(0, 1),          # Specify control and case levels
               direction = "<")           # Lower scores = class 0

# View results
roc_obj
auc(roc_obj)
ci.auc(roc_obj)  # 95% CI for AUC
```

### Plot ROC Curve

```r
# Basic plot
plot(roc_obj, print.auc = TRUE)

# With ggplot2
ggroc(roc_obj) +
  geom_abline(intercept = 1, slope = 1, linetype = "dashed", color = "gray") +
  annotate("text", x = 0.25, y = 0.25,
           label = paste("AUC =", round(auc(roc_obj), 3))) +
  theme_bw()
```

---

## Interpreting AUC

| AUC | Performance |
|-----|-------------|
| 0.5 | No discrimination (chance) |
| 0.5-0.6 | Failed |
| 0.6-0.7 | Poor |
| 0.7-0.8 | Acceptable |
| 0.8-0.9 | Good |
| 0.9-1.0 | Excellent |

### FoodSeq Validation Results

| Application | AUC | Interpretation |
|-------------|-----|----------------|
| Plant ingredient detection | 0.806 | Good |
| Animal ingredient detection | 0.844 | Good |

---

## Optimal Thresholds

### Youden's J Statistic

Maximizes sensitivity + specificity - 1:

```r
# Find optimal threshold
coords(roc_obj, "best", ret = c("threshold", "sensitivity", "specificity"))

# Or manually
youden_coords <- coords(roc_obj, "best", best.method = "youden")
```

### Other Criteria

```r
# Closest to top-left corner
coords(roc_obj, "best", best.method = "closest.topleft")

# At specific sensitivity
coords(roc_obj, x = 0.9, input = "sensitivity", ret = c("threshold", "specificity"))

# At specific specificity
coords(roc_obj, x = 0.9, input = "specificity", ret = c("threshold", "sensitivity"))
```

---

## Comparing ROC Curves

```r
# Two predictors for same outcome
roc1 <- roc(df$status, df$predictor1)
roc2 <- roc(df$status, df$predictor2)

# DeLong test for comparing AUCs
roc.test(roc1, roc2, method = "delong")

# Plot both curves
plot(roc1, col = "blue")
plot(roc2, col = "red", add = TRUE)
legend("bottomright", legend = c("Predictor 1", "Predictor 2"),
       col = c("blue", "red"), lwd = 2)
```

---

## Confusion Matrix

After choosing a threshold, evaluate classification performance:

```r
library(caret)

# Classify based on threshold
threshold <- coords(roc_obj, "best")$threshold
predicted <- ifelse(df$score > threshold, 1, 0)

# Confusion matrix
confusionMatrix(factor(predicted), factor(df$status), positive = "1")
```

### Metrics

| Metric | Formula | Meaning |
|--------|---------|---------|
| Sensitivity | TP / (TP + FN) | True positive rate |
| Specificity | TN / (TN + FP) | True negative rate |
| PPV | TP / (TP + FP) | Positive predictive value |
| NPV | TN / (TN + FN) | Negative predictive value |
| Accuracy | (TP + TN) / Total | Overall correctness |

---

## Cross-Validation

Avoid overfitting by evaluating on held-out data:

```r
library(caret)

# 10-fold cross-validation
ctrl <- trainControl(method = "cv",
                     number = 10,
                     classProbs = TRUE,
                     summaryFunction = twoClassSummary)

# Train model
model <- train(status ~ predictor1 + predictor2,
               data = df,
               method = "glm",
               family = "binomial",
               trControl = ctrl,
               metric = "ROC")

# View cross-validated AUC
model$results
```

---

## Multi-Class ROC

For outcomes with >2 categories:

```r
library(pROC)

# Multi-class ROC
multiclass.roc(df$category, df$score)

# Or one-vs-all approach
roc_list <- lapply(levels(df$category), function(class) {
  binary <- ifelse(df$category == class, 1, 0)
  roc(binary, df$score)
})
```

---

## Calibration

Check if predicted probabilities match observed frequencies:

```r
library(rms)

# Fit logistic model
model <- lrm(status ~ predictor, data = df, x = TRUE, y = TRUE)

# Calibration plot
cal <- calibrate(model, B = 100)
plot(cal)
```

---

## Reporting Checklist

- [ ] Report AUC with 95% CI
- [ ] Include ROC curve figure
- [ ] State threshold selection method
- [ ] Report sensitivity and specificity at chosen threshold
- [ ] If comparing models, report comparison test results
- [ ] Report sample sizes for each class

### Example Statement

> The dietary PC1 score discriminated between low and high vegetable consumers with good accuracy (AUC = 0.81, 95% CI: 0.74-0.88). At the optimal threshold (Youden's J), sensitivity was 0.78 and specificity was 0.72.

---

## Common Pitfalls

!!! warning "Imbalanced Classes"
    When one class is much more common:

    - AUC can be misleading
    - Consider precision-recall curves
    - Use stratified cross-validation

!!! warning "Overfitting"
    Evaluating on training data overestimates performance:

    - Always use cross-validation or held-out test set
    - Report cross-validated metrics

!!! warning "Threshold Selection"
    Optimal threshold depends on the cost of false positives vs. false negatives:

    - Medical screening: favor sensitivity
    - Confirmatory diagnosis: favor specificity
    - Report multiple thresholds if context varies
