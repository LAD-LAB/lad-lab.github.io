# PCA Explorer

Interactive PCA visualizer for phyloseq objects, served from the David Lab handbook site.

This directory holds three artifacts and the deploy recipe for one Plumber API + one static HTML page.

## Files

| File | Role |
| --- | --- |
| `build_pca_data.R` | Pure R helper. Takes a phyloseq object + marker (`trnL` / `12S`, auto-detected from `tax_table` if omitted), returns `{samples, loadings, clr_matrix}`. Source from CLI, Plumber, or Shiny without duplication. |
| `plumber.R` | Plumber API. `GET /health`, `POST /pca` (raw Rds bytes in body, optional `?marker=` query). Permissive CORS so the static frontend can hit it from a different origin. |
| `../../docs/pca-explorer-app.html` | Static frontend (lives in `docs/` so mkdocs serves it). Drag-and-drop Rds upload, POSTs to the API, renders Plotly + a client-side power-iteration PCA for live recompute. Reads the API URL from `window.PCA_API_CONFIG.url` (set before the page's `<script>` tag), defaulting to `http://localhost:8000/pca`. |
| `../../docs/pca-explorer.md` | Markdown wrapper that iframes the explorer into the mkdocs nav. |
| `Dockerfile` | Container for the Plumber backend. Based on `rocker/r-ver:4.5.0`; installs `plumber`, `jsonlite`, and `phyloseq` (Bioconductor). Listens on port 7860 (HuggingFace Spaces default). |

## Local dev

```bash
# Backend
cd tools/pca_explorer
Rscript -e "plumber::pr_run(plumber::pr('plumber.R'), port=8000)"

# Frontend (different shell — serve the repo root so docs/ paths resolve)
cd ../..
python3 -m http.server 8001
# Open http://localhost:8001/docs/pca-explorer-app.html
```

Default frontend points at `http://localhost:8000/pca`, so the two play together with no config.

## Deploy (HuggingFace Spaces)

1. Create a new Space at `huggingface.co/new-space`, pick **Docker** as the SDK and **CPU basic** hardware (free).
2. In the Space repo root, drop in `build_pca_data.R`, `plumber.R`, `Dockerfile`, and a `README.md` with this frontmatter:

   ```yaml
   ---
   title: David Lab PCA Explorer API
   emoji: 🌿
   colorFrom: green
   colorTo: blue
   sdk: docker
   app_port: 7860
   ---
   ```

3. Push. HF builds the image (~15-25 min on first build because `phyloseq` pulls a lot of Bioconductor deps).
4. The Space exposes `https://<user>-<space>.hf.space`. Update `visualizer.html` (or override via `window.PCA_API_CONFIG.url` from the mkdocs page) to point at `https://<user>-<space>.hf.space/pca`.

## Production hardening (not in this spike)

- Tighten CORS in `plumber.R` from `*` to `https://lad-lab.github.io` once the deploy URL is settled.
- Add rate limiting and per-IP request counts at the host layer (HF has built-in basic limits; tune if abused).
- Persist no uploads (current behavior — uses a tempfile cleaned on `on.exit`).
- Consider a small in-memory result cache keyed by content hash so repeat uploads of the same Rds skip the compute.

## CLI parity

The original `launch_pca_explorer.R` (Ashish's standalone launcher) is unchanged in scope but should be updated to `source("build_pca_data.R")` rather than redefining the function inline. That refactor is left for the launcher's owner; nothing here breaks the existing CLI.
