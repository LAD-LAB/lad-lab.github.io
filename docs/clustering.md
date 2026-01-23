# Clustering Methods

Clustering methods group samples or taxa by similarity. This page covers hierarchical clustering and time-series clustering for FoodSeq data.

---

## Hierarchical Clustering

### Purpose

Group samples or taxa into nested clusters based on similarity, creating a dendrogram that shows relationships at multiple levels.

### Implementation

```r
# Calculate distance matrix on CLR-transformed data
dist_matrix <- dist(t(clr_matrix), method = "euclidean")

# Perform hierarchical clustering
hc <- hclust(dist_matrix, method = "complete")

# Plot dendrogram
plot(hc, labels = sample_names, main = "Sample Clustering")
```

### Distance Methods

| Method | Use Case |
|--------|----------|
| `euclidean` | CLR-transformed data |
| `manhattan` | Robust to outliers |
| `binary` (Jaccard) | Presence/absence data |

```r
# Different distances
dist_euc <- dist(t(clr_matrix), method = "euclidean")
dist_man <- dist(t(clr_matrix), method = "manhattan")

# For binary data (Jaccard)
library(vegan)
dist_jac <- vegdist(t(binary_matrix), method = "jaccard")
```

### Linkage Methods

| Method | Description |
|--------|-------------|
| `complete` | Maximum distance between clusters (default) |
| `single` | Minimum distance (can produce chains) |
| `average` | Mean distance (UPGMA) |
| `ward.D2` | Minimizes within-cluster variance |

```r
# Ward's method (often better for distinct clusters)
hc_ward <- hclust(dist_matrix, method = "ward.D2")
```

### Cutting the Dendrogram

```r
# Cut into k clusters
clusters <- cutree(hc, k = 3)

# Or cut at specific height
clusters <- cutree(hc, h = 0.5)

# Add cluster assignments to metadata
metadata$cluster <- as.factor(clusters)
```

---

## Determining Optimal Cluster Number

### Silhouette Method

```r
library(cluster)

# Calculate silhouette width for different k
sil_width <- sapply(2:10, function(k) {
  clusters <- cutree(hc, k = k)
  sil <- silhouette(clusters, dist_matrix)
  mean(sil[, 3])
})

# Plot
plot(2:10, sil_width, type = "b",
     xlab = "Number of clusters", ylab = "Silhouette width")
```

### Gap Statistic

```r
library(cluster)

gap_stat <- clusGap(t(clr_matrix), FUN = hcut, K.max = 10, B = 50)
fviz_gap_stat(gap_stat)
```

---

## Visualization

### Basic Dendrogram

```r
# Color by clusters
library(dendextend)

dend <- as.dendrogram(hc)
dend <- color_branches(dend, k = 3)
plot(dend)
```

### Heatmap with Clustering

```r
library(pheatmap)

pheatmap(clr_matrix,
         clustering_distance_cols = "euclidean",
         clustering_method = "complete",
         cutree_cols = 3,
         show_colnames = FALSE)
```

### With Annotations

```r
# Create annotation data frame
annotation_col <- data.frame(
  Group = metadata$group,
  row.names = colnames(clr_matrix)
)

pheatmap(clr_matrix,
         annotation_col = annotation_col,
         clustering_distance_cols = "euclidean",
         clustering_method = "complete")
```

---

## Time-Series Clustering

### Purpose

Identify trajectory patterns over time (e.g., dietary changes during treatment, albumin trajectories).

### Dynamic Time Warping (DTW)

DTW aligns time series that may be shifted or stretched relative to each other:

```r
library(dtwclust)

# Prepare time series list (one series per subject)
ts_list <- split(df$value, df$subject_id)
ts_list <- lapply(ts_list, function(x) as.numeric(x))

# Hierarchical clustering with DTW distance
clusters <- tsclust(ts_list,
                    type = "hierarchical",
                    distance = "dtw",
                    k = 3)

# Plot
plot(clusters)
```

### Partitional Clustering

```r
# K-means style clustering with DTW
clusters <- tsclust(ts_list,
                    type = "partitional",
                    distance = "dtw",
                    k = 3,
                    centroid = "dba")  # DTW Barycenter Averaging

# View centroids (prototypes)
plot(clusters, type = "centroids")
```

### Trajectory Visualization

```r
# Add cluster assignments
trajectory_data <- df %>%
  group_by(subject_id) %>%
  mutate(cluster = clusters@cluster[cur_group_id()])

# Plot trajectories colored by cluster
ggplot(trajectory_data, aes(x = time, y = value,
                            group = subject_id, color = factor(cluster))) +
  geom_line(alpha = 0.5) +
  stat_summary(aes(group = cluster), fun = mean, geom = "line", size = 2) +
  facet_wrap(~cluster) +
  labs(color = "Cluster")
```

---

## Cluster Validation

### Internal Validation

```r
library(cluster)

# Silhouette scores
sil <- silhouette(clusters@cluster, clusters@distmat)
summary(sil)
plot(sil)

# Cluster quality index
clusters@clusinfo
```

### External Validation

Compare clusters to known groups:

```r
library(mclust)

# Adjusted Rand Index
adjustedRandIndex(clusters@cluster, metadata$known_group)
```

---

## Reporting Clustering Results

### Checklist

- [ ] State distance metric used
- [ ] State linkage method (for hierarchical)
- [ ] Report method for choosing cluster number
- [ ] Report cluster sizes
- [ ] Include dendrogram or cluster visualization
- [ ] Describe cluster characteristics

### Example Statement

> Hierarchical clustering (Ward's method, Euclidean distance on CLR-transformed data) identified three dietary pattern clusters (n = 45, 62, 43). Cluster 1 was characterized by high processed food taxa, Cluster 2 by diverse produce, and Cluster 3 by high animal-derived taxa (see heatmap).
