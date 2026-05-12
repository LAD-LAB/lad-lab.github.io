# PCA explorer compute helper.
#
# Sourced by both the CLI launcher (launch_pca_explorer.R) and the
# Plumber API (plumber.R). Pure: takes a phyloseq object + marker label,
# returns the JSON-ready payload {samples, loadings, clr_matrix}.

suppressPackageStartupMessages({
  library(phyloseq)
})

# Marker auto-detect: peek at tax_table column names.
#   - "superkingdom" present  -> trnL (plant marker, GTDB-style tax)
#   - otherwise               -> 12S  (animal marker, NCBI-style tax)
# This mirrors the convention in launch_pca_explorer.R and matches the
# two megaphyloseq Rds files Ashish ships.
detect_marker <- function(ps) {
  cols <- colnames(tax_table(ps))
  if ("superkingdom" %in% cols) "trnL" else "12S"
}

build_pca_data <- function(ps, marker = NULL) {
  if (is.null(marker) || !nzchar(marker)) marker <- detect_marker(ps)
  if (!marker %in% c("trnL", "12S")) {
    stop(sprintf("marker must be 'trnL' or '12S', got: %s", marker))
  }
  message("Processing ", marker, "...")

  sd <- data.frame(sample_data(ps), stringsAsFactors = FALSE)
  sd$sample_name <- rownames(data.frame(sample_data(ps)))
  sd$run_id <- gsub(".*-", "", sd$sample_name)
  sd$run_date <- as.Date(sd$run_id, format = "%y%m%d")
  sd$run_year <- as.numeric(format(sd$run_date, "%Y"))

  if ("project_name" %in% colnames(sd)) {
    sd$project <- sd$project_name
  } else if (!"project" %in% colnames(sd)) {
    sd$project <- sd$run_id
  }
  sd$project[is.na(sd$project) | sd$project == ""] <- "Unknown"

  tt <- as.data.frame(tax_table(ps))
  if (marker == "trnL" && "superkingdom" %in% colnames(tt)) {
    na_mask <- is.na(tt$superkingdom)
  } else if ("kingdom" %in% colnames(tt)) {
    na_mask <- is.na(tt$kingdom)
  } else {
    na_mask <- rep(FALSE, nrow(tt))
  }
  ps <- prune_taxa(!na_mask, ps)

  tt2 <- as.data.frame(tax_table(ps))
  species_col <- if ("species" %in% colnames(tt2)) tt2$species else rep(NA, nrow(tt2))

  if (marker == "trnL") {
    control_species <- c("Ilex paraguariensis", "Trifolium pratense", "synthetic trnL ASV")
  } else {
    control_species <- c("Homo sapiens", "Dromaius novaehollandiae", "Correlophus ciliatus",
                         "Rhacodactylus leachianus", "synthetic 12S ASV")
  }
  remove_mask <- !is.na(species_col) & species_col %in% control_species
  if (marker == "12S" && "common_name" %in% colnames(tt2)) {
    remove_mask <- remove_mask | (!is.na(tt2$common_name) & grepl("^human$", tt2$common_name, ignore.case = TRUE))
  }
  message("  Removing ", sum(remove_mask), " control/human taxa")
  ps <- prune_taxa(!remove_mask, ps)

  ps <- prune_samples(sample_sums(ps) > 0, ps)
  ps <- prune_taxa(taxa_sums(ps) > 0, ps)

  otu_filt_raw <- as(otu_table(ps), "matrix")
  if (taxa_are_rows(ps)) otu_filt_raw <- t(otu_filt_raw)
  sd$total_reads <- rowSums(otu_filt_raw[match(sd$sample_name, rownames(otu_filt_raw)), , drop = FALSE])
  sd$total_reads[is.na(sd$total_reads)] <- 0

  tt3 <- as.data.frame(tax_table(ps))
  glom_rank <- if (marker == "trnL") "common_name" else "species"
  if (!glom_rank %in% colnames(tt3)) {
    for (fallback in c("species", "genus", "family")) {
      if (fallback %in% colnames(tt3)) { glom_rank <- fallback; break }
    }
    if (!glom_rank %in% colnames(tt3)) glom_rank <- colnames(tt3)[1]
    message("  Using ", glom_rank, " for glomming")
  }
  glom_col <- tt3[[glom_rank]]
  glom_col[is.na(glom_col) | glom_col == ""] <- NA
  valid <- !is.na(glom_col)
  unique_taxa <- unique(glom_col[valid])

  otu_filt <- as(otu_table(ps), "matrix")
  if (taxa_are_rows(ps)) otu_filt <- t(otu_filt)

  glom_mat <- matrix(0, nrow = ncol(otu_filt), ncol = length(unique_taxa))
  rownames(glom_mat) <- colnames(otu_filt)
  colnames(glom_mat) <- unique_taxa
  for (i in seq_along(unique_taxa)) {
    idx <- which(glom_col == unique_taxa[i] & valid)
    glom_mat[idx, i] <- 1
  }
  otu_glommed <- otu_filt %*% glom_mat

  richness <- rowSums(otu_glommed > 0)
  dominance <- apply(otu_glommed, 1, function(x) {
    s <- sum(x); if (s == 0) return(NA); max(x) / s
  })
  top_taxon <- apply(otu_glommed, 1, function(x) {
    if (sum(x) == 0) return(NA); colnames(otu_glommed)[which.max(x)]
  })

  otu_comp <- sweep(otu_glommed, 1, rowSums(otu_glommed), "/")
  otu_comp[!is.finite(otu_comp)] <- 0
  gm <- exp(rowMeans(log(otu_comp + 1e-6)))
  otu_clr_glom <- log(otu_comp + 1e-6) - log(gm)

  sd_match <- sd[match(rownames(otu_clr_glom), sd$sample_name), ]
  sd_match$project[is.na(sd_match$project) | sd_match$project == "" | sd_match$project == "Unknown"] <- "No metadata"

  otu_sub <- otu_clr_glom
  sd_pca <- sd_match
  col_var <- apply(otu_sub, 2, var)
  otu_sub <- otu_sub[, col_var > 0]

  pca_res <- prcomp(otu_sub, center = TRUE, scale. = FALSE)
  var_exp <- summary(pca_res)$importance[2, 1:5] * 100
  message("  Variance: PC1=", round(var_exp[1], 1), "% PC2=", round(var_exp[2], 1), "%")
  message("  Samples: ", nrow(otu_sub), " Taxa: ", ncol(otu_sub))

  snames <- sd_pca$sample_name

  result <- data.frame(
    PC1 = pca_res$x[, 1], PC2 = pca_res$x[, 2], PC3 = pca_res$x[, 3],
    project = sd_pca$project,
    run_year = sd_pca$run_year,
    total_reads = sd_pca$total_reads,
    richness = richness[match(snames, names(richness))],
    dominance = dominance[match(snames, names(dominance))],
    top_taxon = top_taxon[match(snames, names(top_taxon))],
    marker = marker,
    var_pc1 = var_exp[1], var_pc2 = var_exp[2], var_pc3 = var_exp[3],
    stringsAsFactors = FALSE
  )

  sd_orig <- data.frame(sample_data(ps), stringsAsFactors = FALSE, check.names = FALSE)
  sd_orig$.sample_name_orig <- rownames(data.frame(sample_data(ps)))

  skip_cols <- c(".sample_name_orig", "sample_name", "Sample_ID", "megaphyloseq_id",
                 "run_id", "project_name", "Project", "project")
  demo_cols <- setdiff(colnames(sd_orig), c(skip_cols, colnames(result)))
  demo_cols <- demo_cols[demo_cols != ""]

  if (length(demo_cols) > 0) {
    message("  Demographic columns: ", paste(demo_cols, collapse = ", "))
    match_idx <- match(snames, sd_orig$.sample_name_orig)
    for (col in demo_cols) {
      vals <- sd_orig[[col]][match_idx]
      if (is.factor(vals)) vals <- as.character(vals)
      result[[col]] <- vals
    }
  }

  rownames(result) <- NULL

  clr_matrix <- list(
    samples = rownames(otu_sub),
    taxa    = colnames(otu_sub),
    data    = round(as.vector(t(otu_sub)), 2)
  )

  rot <- pca_res$rotation[, 1:3, drop = FALSE]
  loading_mag <- sqrt(rot[, 1]^2 + rot[, 2]^2)
  top_n <- min(15, length(loading_mag))
  top_idx <- order(loading_mag, decreasing = TRUE)[seq_len(top_n)]
  loadings <- data.frame(
    taxon = colnames(otu_sub)[top_idx],
    PC1   = rot[top_idx, 1],
    PC2   = rot[top_idx, 2],
    PC3   = rot[top_idx, 3],
    mag   = loading_mag[top_idx],
    stringsAsFactors = FALSE
  )
  rownames(loadings) <- NULL

  list(samples = result, loadings = loadings, clr_matrix = clr_matrix)
}

# Helper used by both CLI and Plumber: replace NAs in character columns with "".
# toJSON otherwise drops sparse columns in dataframe=rows mode.
sanitize_for_json <- function(df) {
  for (col in colnames(df)) {
    if (is.character(df[[col]]) || is.factor(df[[col]])) {
      df[[col]][is.na(df[[col]])] <- ""
    }
  }
  df
}
