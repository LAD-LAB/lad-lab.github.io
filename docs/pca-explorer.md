# PCA Explorer

Interactive PCA visualizer for `phyloseq` objects. Drag in a `.Rds` file, the lab's compute service runs CLR + PCA, and the result is rendered in-browser with Plotly. Marker (trnL / 12Sv5) is auto-detected from the tax_table.

This is a companion to the [PCA Plot tutorial](pca.md) — that page covers how to compute and interpret a PCA in R, this page lets you drop an existing phyloseq object and inspect it without leaving the browser.

!!! note "Heads up"
    Your file is sent to an external compute server for the R computation. It is not stored. See the "Privacy" copy below the upload zone.

<iframe
  src="pca-explorer-app.html"
  title="PCA Explorer"
  style="width:100%;height:92vh;border:1px solid #e2e8f0;border-radius:8px;margin-top:0.5rem;"
  loading="lazy">
</iframe>

If the embedded view feels cramped, [open the explorer full-screen](pca-explorer-app.html).
