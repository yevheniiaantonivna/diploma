# 📚 Diploma Project Description

## Title
**Spatial and Environmental Analysis of *Salix* and *Populus* Species Based on Soil and Anthropogenic Indicators**

---

## 🧠 Project Purpose

This project analyzes the distribution of *Salix*  and *Populus* species in relation to environmental soil characteristics and anthropogenic impact indicators.

The study uses geospatial data (species occurrence points) and raster datasets (soil parameters) to:
- **Extract environmental values** at species observation points
- **Visualize** the distribution of environmental variables for different species (violin plots)
- **Assess** phytoremediation potential using heatmaps
- **Identify** ecological patterns of *Salix* and *Populus* adaptation to different environments

---

## 📂 Project Structure

| Folder | Description |
|:-------|:------------|
| `datasets/` | CSV files with coordinates and names of species occurrences (*Salix.csv*, *Populus.csv*) |
| `grids/` | Environmental raster files (soil chemical properties, anthropogenic index) |
| `heatmap/` | Prepared matrix for phytoremediation heatmap |
| `results/plots_salix/` | Violin plots for *Salix* species |
| `results/plots_populus/` | Violin plots for *Populus* species |
| `results/plots_heatmap/` | Heatmap of phytoremediation activity |
| `*.R` scripts | Code for data processing and visualization |

---

## 🛠️ How the Project Works

1. **Extract environmental values**:
   - Each species occurrence point is projected onto environmental raster grids.
   - The corresponding soil or anthropogenic values are extracted for each species.

2. **Violin plot creation**:
   - Species' distributions across variables like SOC, Nitrogen, CEC, CFVO, and pH are plotted.
   - Separate plots are created for *Salix* and *Populus* species.

3. **Heatmap creation**:
   - Based on predefined phytoremediation potential indicators, a heatmap is created for *Salix* species.
   - This visualizes the comparative activity of species across several parameters.
---

## 🚀 How to Run the Project

### 1. Prepare Environment

- Install R (4.0 or later) and RStudio (recommended).
- Open `Salix.Rproj` in RStudio.
- Install required packages (only once):
  ```r
  install.packages(c("terra", "data.table", "sf", "ggplot2", "tidyverse", "hrbrthemes", "viridis", "pheatmap"))
  ```

### 2. Generate Graphs

- Run `salix_values_mapping.R` to create violin plots for *Salix*.
- Run `populus_values_mapping.R` to create violin plots for *Populus*.
- Run `salix_heatmap.R` to create a heatmap for *Salix* phytoremediation activity.

### 3. View Results

- Generated JPEG plots will appear in `results/plots_salix/`, `results/plots_populus/`, and `results/plots_heatmap/`.

---

## 🧩 Key Technologies Used

- **Spatial data extraction**: `terra` package (for rasters and vectors)
- **Data manipulation**: `data.table`
- **Visualization**: `ggplot2`, `viridis`, `pheatmap`
- **Project organization**: RStudio `.Rproj`
