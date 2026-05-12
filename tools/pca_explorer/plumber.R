# PCA explorer Plumber API.
#
# Run locally:
#   Rscript -e "plumber::pr_run(plumber::pr('plumber.R'), port=8000)"
#
# Endpoints:
#   GET  /health    -> liveness probe
#   POST /pca       -> phyloseq Rds upload (raw body) + ?marker=trnL|12S (optional, auto-detect)
#                      returns { marker, samples, loadings, clr_matrix }
#
# Body is the raw Rds bytes (Content-Type: application/octet-stream).
# The frontend reads the picked file as ArrayBuffer and POSTs it directly,
# which avoids multipart parsing.

suppressPackageStartupMessages({
  library(plumber)
  library(jsonlite)
})

source("build_pca_data.R", local = TRUE)

# Hard cap on upload size. Defensive, not a real auth boundary.
# Reset via env var when deploying to a host with different limits.
MAX_BYTES <- as.numeric(Sys.getenv("PCA_MAX_BYTES", "50000000"))  # 50 MB

# Permissive CORS so the static frontend on lad-lab.github.io can hit
# the API hosted elsewhere. Tighten Access-Control-Allow-Origin in prod.
add_cors <- function(res) {
  res$setHeader("Access-Control-Allow-Origin", "*")
  res$setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
  res$setHeader("Access-Control-Allow-Headers", "Content-Type")
  res$setHeader("Access-Control-Max-Age", "600")
}

#* @filter cors
function(req, res) {
  add_cors(res)
  if (identical(req$REQUEST_METHOD, "OPTIONS")) {
    res$status <- 204
    return(list())
  }
  plumber::forward()
}

#* Liveness probe.
#* @get /health
function() {
  list(ok = TRUE, ts = format(Sys.time(), tz = "UTC", usetz = TRUE))
}

#* Compute PCA for an uploaded phyloseq Rds.
#* @post /pca
#* @serializer json list(auto_unbox = TRUE, na = "null")
function(req, res, marker = NULL) {
  raw <- req$bodyRaw
  if (is.null(raw) || length(raw) == 0) {
    res$status <- 400
    return(list(error = "Empty request body. POST the Rds file as raw bytes."))
  }
  if (length(raw) > MAX_BYTES) {
    res$status <- 413
    return(list(error = sprintf("Upload exceeds %.0f MB limit.", MAX_BYTES / 1e6)))
  }

  tmp <- tempfile(fileext = ".Rds")
  on.exit(unlink(tmp), add = TRUE)
  writeBin(raw, tmp)

  ps <- tryCatch(readRDS(tmp), error = function(e) e)
  if (inherits(ps, "error")) {
    res$status <- 400
    return(list(error = paste("Could not read RDS:", conditionMessage(ps))))
  }
  if (!inherits(ps, "phyloseq")) {
    res$status <- 400
    return(list(error = sprintf(
      "Uploaded RDS contains class '%s', not 'phyloseq'.", class(ps)[1]
    )))
  }

  result <- tryCatch(
    build_pca_data(ps, marker),
    error = function(e) e
  )
  if (inherits(result, "error")) {
    res$status <- 500
    return(list(error = paste("PCA build failed:", conditionMessage(result))))
  }

  result$samples  <- sanitize_for_json(result$samples)
  result$loadings <- sanitize_for_json(result$loadings)

  # Echo the marker that was actually used (matters when auto-detected).
  used_marker <- if (is.null(marker) || !nzchar(marker)) detect_marker(ps) else marker
  list(
    marker     = used_marker,
    samples    = result$samples,
    loadings   = result$loadings,
    clr_matrix = result$clr_matrix
  )
}
