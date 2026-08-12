# Filtering Samples

!!! to-do

    Add instructions on removing control samples and other sample-level exclusions.

## Minimum read count thresholds

You may choose to drop samples that fall below a minimum read count. We do not have a blanket recommendation for a minimum threshold, as an appropriate value varies considerably between datasets. Note that [Filtering Taxa](taxafiltering.md) changes per-sample totals, so the same threshold may exclude different samples depending on when it is applied.

!!! warning

    A low read count may reflect technical failure or genuinely low food DNA in the sample (equimolar pooling may not fully equalize read depth). Dropping low-count samples always risks discarding true dietary signal, so do this carefully and document your decision.
