FROM rocker/r-ver:4.5.0

RUN apt-get update && apt-get install -y --no-install-recommends \
        libcurl4-openssl-dev libssl-dev libxml2-dev libsodium-dev libpng-dev \
    && rm -rf /var/lib/apt/lists/*

RUN R -e "install.packages(c('plumber','jsonlite','BiocManager'), repos='https://cloud.r-project.org')"
RUN R -e "BiocManager::install('phyloseq', ask=FALSE, update=FALSE)"

WORKDIR /app
COPY build_pca_data.R plumber.R ./

# HuggingFace Spaces default port is 7860; override via PORT env var on other hosts.
EXPOSE 7860
ENV PCA_MAX_BYTES=50000000

CMD ["R", "-e", "pr <- plumber::pr('plumber.R'); plumber::pr_run(pr, host='0.0.0.0', port=as.numeric(Sys.getenv('PORT', 7860)))"]
