# PCA Projection

## Why Project Instead of Refitting?

A PCA is fit on a specific set of samples and ASVs — its axes (principal components) are a coordinate system derived from that exact dataset. If a new batch of samples arrives later and you simply re-run [`pca_plot()`](pca.md) on the combined data, you get a *different* PCA: the axes shift, and a sample's position (and what "PC1" even means) is no longer directly comparable to the version you already interpreted and reported on.

Projection avoids this by keeping the reference PCA fixed and placing new samples into it, using the same technique as `stats::predict.prcomp()`: center the new data by the reference's own column means, then multiply by the reference's own rotation matrix. The axes never move. This matters whenever you want to compare a new batch against an already-established reference population — an ongoing/longitudinal study enrolling participants over time, a validation cohort you want to place alongside a published reference, or any case where re-deriving and re-interpreting new axes every time you get new data would be more disruptive than useful.

Because a PCA's feature set is just as fixed as its axes, the new data also has to be expressed in the *exact* same ASV space the reference PCA was fit on — not just "the same trnL marker," but literally the same set of ASV sequences as columns. That's what `plan_projection()` and `apply_projection()` do: they take a new, unharmonized phyloseq and map its ASVs onto a reference's ASV space, so the result can be fed straight into `project_pca()`.

## Prerequisites

* A **harmonized reference** — the cumulative ASV ledger [`apply_harmonization()`](glomming.md#apply_harmonization) produces (its `$asv_outcomes`), with zero `"unresolved"` ASVs. If you're harmonizing incrementally across rounds, this should be the ledger you've been carrying forward via `apply_harmonization()`'s own `prior_outcomes` argument.
* If the reference needs taxonomy-based filtering (removing unassigned ASVs, controls, host reads, etc.), do that filtering **before** running `plan_harmonization()`/`apply_harmonization()` on it — never after, and never by filtering the query or `$ps_projected` independently later. Harmonization physically merges some ASVs away, so filtering the reference only after harmonizing filters a different ASV universe than the one the ledger was actually built from.
* A **fitted reference PCA** — [`pca_plot()`](pca.md) run on the reference (CLR-transformed, filtered the same way as above).
* A **query phyloseq** — the new batch of samples you want to project, not yet harmonized against the reference. Any taxonomy or sample-based filtering and taxa pruning should occur before harmonization to reference.

## Workflow

```
plan_projection()  -->  apply_projection()  -->  project_pca()
   (detect + review        (build the                (project into
    correspondences)        projected phyloseq)        the fixed PCA)
```

<div class="download-buttons" markdown>
[Download plan_projection.R](files/plan_projection.R){ .md-button }
[Download apply_projection.R](files/apply_projection.R){ .md-button }
[Download project_pca.R](files/project_pca.R){ .md-button }
</div>

## `plan_projection()`

After reading the function into your analysis file, run:

``` r
plan <- plan_projection(ref_harmonized, ps_query)
```

at minimum to detect correspondences and review anything ambiguous. The inputs of the function are:

* `ps_ref_outcomes` (required) — the reference's cumulative ASV ledger: `apply_harmonization()`'s full return value, its `$asv_outcomes` data frame directly, or a file path to one saved as a CSV. Must have at least one `"representative"`/`"unchanged"` row and zero `"unresolved"` ones. Passing the full `apply_harmonization()` result (rather than a bare data frame) also enables the sample-name uniqueness check below.
* `ps_query` (required) — the new phyloseq to project onto the reference's ASV space
* `prior_decisions` (optional) — decisions from an earlier `plan_projection()` round on this (or a closely related) reference/query pair; by default `NULL`, meaning every pair is planned fresh
* `source_names` (optional) — a length-2 vector naming the reference and query, passed through to the underlying `compare_asvs()`; by default `c("x", "y")`
* `min_overlap` (optional) — the species-set overlap threshold, passed through to `compare_asvs()`; by default `0.01`
* `tax_rank_cols` (optional) — character vector of formal taxonomic rank column names present in `ps_ref_outcomes`; inferred when `NULL`
* `save_path` (optional) — a file path to write `$decisions` to as a CSV; by default `NULL`
* `verbose` (optional) — whether to report progress and a summary; by default `TRUE`

Internally, `plan_projection()` relies on several small helper functions: `.ledger_to_reference()` reconstructs the reference's current final ASV set directly from the ledger (so a live reference phyloseq is never actually needed); `.check_sample_name_uniqueness()` and `.project_query_checkpoint()` handle the two safety checks described below; `.swap_ij()` and `.relabel_sources()` normalize flagged pairs so the reference side is always `asv_i`; and `.resolve_projection_pairs()` and `.build_projection_decisions_out()` assemble the final decisions table from the automatic, prior, and reviewed resolutions.

`plan_projection()` works in a few stages. First, two things are checked before anything else runs: every ASV in `ps_ref_outcomes` must already be resolved —

``` r
pending <- ledger_df$asv[!is.na(ledger_df$asv_status) & ledger_df$asv_status == "unresolved"]
if (length(pending) > 0) {
  stop("plan_projection: ps_ref_outcomes has ", length(pending), " ASV(s) still unresolved...")
}
```

— and the reference and query must never share a sample name (a hard `stop()` when a live reference object is available; only a `message()` when just a bare ledger was supplied, since there's no live object to check names against).

Next, any query ASV whose sequence is *identical* to a known historical discard from the reference's own harmonization is redirected immediately to its final representative — a "ghost redirect" — without going through detection at all, since its fate is already known. Everything else runs through `compare_asvs()` against the reference's reconstructed ASV set, exactly the same substring/species-set comparison `plan_harmonization()` uses. The flagged pairs are then narrowed down to genuine reference↔query relationships (dropping any redundancy purely within one side or the other) and oriented so the reference's ASV is always `asv_i`.

Confident matches (scenario S1 — substring pair, identical species set) are auto-resolved, but with one deliberate departure from `apply_harmonization()`'s usual rule: the **reference's** ASV is always kept, regardless of which sequence is shorter, since the goal here is a fixed coordinate system, not the more parsimonious representative. Anything not auto-resolved is checked against `prior_decisions` if supplied, and finally, the same interactive review gadget `plan_harmonization()` uses is launched automatically for whatever's still blank.

### Understanding the Output

`plan_projection()` returns a `projection_plan` object meant to be passed as-is to `apply_projection()` (and safe to `saveRDS()` for later reuse). `$decisions` holds the pairs needing review — `asv_i` is always the reference-side candidate, `asv_j` is always the query ASV — already filled in for anything resolved automatically, by `prior_decisions`, or by the review that just ran, and `NULL` if nothing ever needed review. `$compare_result` (the full `compare_asvs()` output) is always included, along with internal state `apply_projection()` needs (the resolved reference ASV set, exact/ghost/auto-merge maps, and checkpoint fingerprints) — this is why `apply_projection()` needs the whole `plan` object, not just `$decisions` on its own.

## `apply_projection()`

Once every pair in `plan$decisions` is resolved (via the gadget, hand-editing, or both), build the projected phyloseq:

``` r
result <- apply_projection(plan, ps_query)
```

The inputs of the function are:

* `plan` (required) — the list returned by `plan_projection()` (or a previous `apply_projection()` call whose status was `"needs_review"`) — must carry the internal state those functions attach, not just a bare decisions table
* `ps_query` (required) — the same phyloseq object `plan_projection()` was given, re-supplied here since its real read counts are what's actually being projected
* `verbose` (optional) — whether to report progress and a summary; by default `TRUE`

Internally, `apply_projection()` relies on one helper function: `.apply_projection_checkpoint()`, which checks `ps_query`'s current taxa and samples against the fingerprint `plan_projection()` embedded on `plan` — always a `warning()`, never a block.

It's all-or-nothing: if anything in `plan$decisions` is still blank or ambiguous, `apply_projection()` stops there and returns without building anything —

``` r
if (!all_resolved) {
  return(structure(
    utils::modifyList(plan, list(status = "needs_review", decisions = decisions_out)),
    class = "projection_result"
  ))
}
```

— so you can hand-edit `$decisions` and call it again. Once everything is resolved, it builds the full `query ASV -> reference ASV` map (exact matches, ghost redirects, auto-merges, and reviewed merges together) and builds the projected OTU matrix: query samples × reference ASVs, summing reads from every query ASV that mapped into each reference ASV:

``` r
for (q_asv in matched_q) {
  ref_asv <- map[[q_asv]]
  out_mat[, ref_asv] <- out_mat[, ref_asv] + otu_q[, q_asv]
}
```

Any query sample left with zero total reads after projection — none of its ASVs correspond to anything in the reference at all — is dropped from the result outright, with a `warning()` naming which. This is the one sample-level decision this function makes automatically rather than leaving to you: such a sample has no valid composition to keep, and left in would silently produce `NaN`/`Inf` under a CLR transform and distort a downstream PCA for every other sample too. Finally, it builds `$match_report`, recording each original query ASV's fate.

### Understanding the Output

`apply_projection()` returns a `projection_result` object. If anything still needs review, `$status` is `"needs_review"` and `$decisions` holds it (same shape as `plan_projection()`'s own — feed it straight back into `apply_projection()` after editing). Once everything is resolved, `$status` is `"complete"` and the result also includes `$ps_projected` (the query's data expressed in the reference's exact ASV/tax-table space, zero-filled for reference ASVs absent from the query, with any all-zero sample dropped as described above) and `$match_report` (one row per original query ASV: `asv`, `fate` — `exact_match`, `ghost_redirected`, `auto_merged`, `reviewed_merged`, `reviewed_distinct`, or `no_correspondence_found` — `matched_ps_ref_asv`, and `reads_total`). `$compare_result` is always included.

## `project_pca()`

With `$ps_projected` in hand, CLR-transform it the same way the reference was, then project it into the reference's PCA:

``` r
query_clr <- microbiome::transform(result$ps_projected, "clr")
proj <- project_pca(ref_clr, query_clr, colorVar = "study")
proj$pca.biplot
```

The inputs of the function are:

* `ps_ref` (required) — the reference's CLR-transformed, filtered phyloseq — the same one you'd pass as `pca_plot()`'s own `ps`. Used to label loading arrows by taxon, and (when `pca_ref` isn't supplied) to fit the PCA itself.
* `ps_query` (required) — the new, CLR-transformed and filtered phyloseq to project — must have exactly the reference PCA's fitted ASV set. Typically `apply_projection()`'s `$ps_projected`, filtered identically to how the reference was.
* `pca_ref` (optional) — an already-fit PCA to project onto, skipping re-fitting; accepts `pca_plot()`'s full return value, or just `list(pca.output = <the prcomp object>)` for a much smaller object worth persisting long-term. By default `NULL`, meaning the PCA is fit fresh from `ps_ref` (equivalent to, and just as expensive as, `pca_plot(ps_ref)`) — worth avoiding by supplying `pca_ref` when projecting many query batches onto the same reference repeatedly.
* `together` (optional) — if `FALSE` (default), the biplot shows only the query's projected points; if `TRUE`, the reference's own points are shown alongside, and `$pca.df` combines both objects' sample data
* `nTaxa` (optional) — number of loading arrows to display; by default `10`
* `colorVar` / `colorName` (optional) — same meaning as `pca_plot()`'s own; by default `NULL`
* `customColors` (optional) — one color per `colorVar` level, as in `pca_plot()`; or, when `colorVar` isn't set and `together = TRUE`, a named length-2 vector `c(query = ..., reference = ...)` overriding the two built-in dataset colors
* `customGradient` / `mid` (optional) — same meaning as `pca_plot()`'s own, for a continuous `colorVar`; by default `NULL` / `"mean"`
* `xPC` / `yPC` (optional) — principal components for the x-/y-axes; by default `1` / `2`
* `ellipse` (optional) — whether to add centroid ellipses; by default `FALSE`
* `bplab` (optional) — tax-table column (on `ps_ref`) to prioritize for biplot arrow labels; same meaning as `pca_plot()`'s own

`project_pca()` doesn't define any helper functions of its own beyond reusing [`.pca_biplot_layer()`](pca.md#pca_plot-function) — the same drawing routine `pca_plot()` uses for its loading arrows and labels.

It works as follows. First, it fits the reference PCA if `pca_ref` wasn't supplied (identical to calling `pca_plot(ps_ref)`), then checks a hard precondition: `ps_query`'s ASVs must be *exactly* the reference PCA's fitted feature set — stricter than `stats::predict.prcomp()`'s own check, which only requires the fitted ASVs to be present and silently ignores anything extra:

``` r
missing_taxa <- setdiff(ref_taxa, query_taxa)
extra_taxa   <- setdiff(query_taxa, ref_taxa)
if (length(missing_taxa) > 0 || length(extra_taxa) > 0) {
  stop("project_pca: ps_query's ASVs do not exactly match the reference PCA's fitted feature space...")
}
```

There's no override — a mismatch means `ps_query` was never actually run through `apply_projection()` against this reference, or was filtered differently, either of which would otherwise produce a technically-computable but meaningless projection.

With that confirmed, it does the actual projection: centers `ps_query` by the reference's own column means and multiplies by the reference's own rotation matrix, via `stats::predict()` — the standard technique for placing new samples into an existing PCA's fixed space:

``` r
query_scores <- stats::predict(pca_obj, newdata = otu_mat)
```

It then assembles `pca.df` — the query's own scores and sample data, or (when `together = TRUE`) both objects' scores and sample data combined, with any shared-but-incompatibly-typed column kept separate instead of merged (suffixed `.ref`/`.query`, with a `message()` naming which) — builds the base scatter plot, and finally calls `.pca_biplot_layer()` with the **reference's own** rotation, eigenvalues, and taxon labels, so the loading arrows are always the reference's, unchanged.

### Understanding the Output

`project_pca()` returns a named list: `pca.df` (PC scores plus `name`, `dataset`, and sample metadata), `pca.biplot` (the finished biplot), and `loadings` (the reference's own loading matrix, passed through unchanged). It does **not** return `pca.output`/`scree.table`/`scree.plot` — nothing new is fit here, so those would just duplicate `pca_ref`'s own; use `pca_ref` directly for those.

## Example: End to End

``` r
# ref_harmonized <- apply_harmonization(ps.trnL, plan)   # from Agglomerating Taxa
# ref_clr filtered/CLR-transformed the same way ref_harmonized's inputs were

plan   <- plan_projection(ref_harmonized, ps_query)
# ... resolve any pairs plan$decisions flags, if needed ...
result <- apply_projection(plan, ps_query)               # $status == "complete"

query_clr <- microbiome::transform(result$ps_projected, "clr")

proj <- project_pca(ref_clr, query_clr, colorVar = "study")
proj$pca.biplot

# Reference and query together, colored by the built-in dataset label:
proj2 <- project_pca(ref_clr, query_clr, together = TRUE)
proj2$pca.biplot
```
