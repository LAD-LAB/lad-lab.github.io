# Filtering Samples

After filtering taxa, the next step is to remove samples that should not be included in downstream analysis. This includes control samples (positive controls, negative controls, and blanks) as well as any samples that need to be excluded for study-specific reasons.

## Removing Controls

Your phyloseq should have a `type` column in its sample metadata with values like `"sample"`, `"positive control"`, `"negative control"`, and `"blank"`. To keep only biological samples:

``` r
ps.trnL <- subset_samples(ps.trnL, type == "sample")
ps.12S  <- subset_samples(ps.12S, type == "sample")
```

By this point in the workflow, you should have already reviewed your controls during the [quality control step](pipeline.md#quality-control) to check for contamination. Removing controls here simply excludes them from the analysis; it does not address contamination that may have spread into biological samples.

## Other Sample Exclusions

Depending on your study, you may need to exclude additional samples. Common reasons include:

* **Failed samples** — samples with very low read counts that suggest a technical failure (see [minimum read count thresholds](#minimum-read-count-thresholds) below).
* **Cohort subsetting** — keeping only samples relevant to your analysis (e.g., a specific time point, treatment group, or study site).
* **Duplicate or mislabelled samples** — samples identified during quality control as duplicates or labelling errors.

Use `subset_samples()` to filter by any column in the sample metadata:

``` r
# Example: keep only samples from a specific cohort
ps <- subset_samples(ps, cohort == "intervention")

# Example: exclude specific sample IDs
exclude <- c("1-A01", "2-B03")
ps <- subset_samples(ps, !Sample_ID %in% exclude)
```

## Minimum Read Count Thresholds

You may choose to drop samples that fall below a minimum read count. We do not have a blanket recommendation for a minimum threshold, as an appropriate value varies considerably between datasets. Note that [Filtering Taxa](taxafiltering.md) changes per-sample totals, so the same threshold may exclude different samples depending on when it is applied.

To check per-sample read counts and apply a threshold:

``` r
# View the distribution of read counts:
sort(sample_sums(ps))

# Remove samples below a threshold:
ps <- prune_samples(sample_sums(ps) >= 1000, ps)
```

!!! warning

    A low read count may reflect technical failure or genuinely low food DNA in the sample (equimolar pooling may not fully equalize read depth). Dropping low-count samples always risks discarding true dietary signal, so do this carefully and document your decision.
