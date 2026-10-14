<div class="hero" markdown>

# FoodSeq Handbook

FoodSeq identifies the plants and animals in a person's diet from DNA in stool. This handbook documents the full workflow, from preparing sequencing libraries to an analysis-ready table of foods, so that any group can generate, process, and compare dietary metabarcoding data in the same way.

<p class="hero-note">The instructions assume minimal familiarity with R and the shell. This site is actively maintained, and pages are updated as methods develop.</p>

</div>

## What's here

* **Library preparation protocols** for two markers: *trnL* (plants) and 12SV5 (vertebrates). See [Wet Lab Protocols](wetlab.md).
* **A pipeline** that takes sequencing output to a phyloseq object, plus a tool that removes human reads before public deposition: [mb-pipeline](https://github.com/LAD-LAB/mb-pipeline). See [Creating a Phyloseq](pipeline.md).
* **A curated reference database of human foods** for both markers: [food-dbs](https://github.com/LAD-LAB/food-dbs), with versioned releases archived on [Zenodo](https://doi.org/10.5281/zenodo.22756737). See [Creating the References](references.md).
* **A common-name map** that turns sequences into recognizable food names. See [Assigning Common Names](commonnames.md).
* **An R package, [foodseq.tools](https://github.com/LAD-LAB/foodseq.tools)**, for quality control, taxonomy assignment, common names, harmonizing related sequences across runs, and PCA. See [Post-Phyloseq Processing and Analysis](processing.md).

## Where to start

* **Starting from samples:** [Wet Lab Protocols](wetlab.md), then [Creating a Phyloseq](pipeline.md), then [Post-Phyloseq Processing and Analysis](processing.md).
* **Starting from sequencing data:** [Creating a Phyloseq](pipeline.md), then [Post-Phyloseq Processing and Analysis](processing.md).
* **New to DNA metabarcoding, R, GitHub, or a computing cluster:** start with [Getting Started](intro.md).

!!! tip "General and Duke instructions"

    Some pages have two tabs. **General** (the default) works at any institution; **Duke** shows the setup used at Duke. Your choice carries across pages.

??? note "Keyboard shortcuts"

    * <kbd>P</kbd> or <kbd>,</kbd> moves to the previous page.
    * <kbd>N</kbd> or <kbd>.</kbd> moves to the next page.
    * <kbd>F</kbd>, <kbd>S</kbd>, or <kbd>/</kbd> opens search.

## Citing

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.20174234.svg)](https://doi.org/10.5281/zenodo.20174234)

If you use the tools or protocols described here, please cite this handbook using the DOI above. If you use the reference database, please also cite its archived release ([10.5281/zenodo.22756737](https://doi.org/10.5281/zenodo.22756737)).

## Feedback and contributions

If you have comments, questions, or suggestions, use the :material-thumb-up-outline: :material-thumb-down-outline: widget at the bottom of any page or [open an issue](https://github.com/LAD-LAB/lad-lab.github.io/issues) on the GitHub repository. To suggest foods or sequences for the reference database, open an issue on [food-dbs](https://github.com/LAD-LAB/food-dbs/issues).
