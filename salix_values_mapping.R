packages <- c("terra", "data.table", "sf", "ggplot2", "tidyverse", "hrbrthemes", "viridis")
installed <- packages %in% installed.packages()
if (any(!installed)) install.packages(packages[!installed])

library(terra)
library(data.table)
library(sf)
library(ggplot2)
library(tidyverse)
library(hrbrthemes)
library(viridis)

salix <- read.csv("datasets/Salix.csv")
setDT(salix)

frequency_included <- 12
salix <- na.omit(salix)
salix <- unique(salix)


species_freq <- salix[, .N, by = species]
species_to_keep <- species_freq[N >= frequency_included, species]
salix <- salix[species %in% species_to_keep]


coords <- vect(salix, geom = c("Longitude", "Latitude"), crs = "EPSG:4326")


param_titles <- list(
  "nitrogen_mean.tif" = "Nitrogen",
  "soc_mean.tif" = "SOC",
  "cec_mean.tif" = "CEC",
  "ukr_cfvo_mean.tif" = "CFVO",
  "ukr_pH_h2o_mean.tif" = "pH h2o",
  "HII_Ukraine.tif" = "HII"
)

tif_files <- list.files(path = "grids", pattern = "\\.tif$", full.names = TRUE)

if (!dir.exists("results/plots_salix")) {
  dir.create("results/plots_salix")
}

for (tif_path in tif_files) {

  param_raster <- rast(tif_path)
  coords_projected <- project(coords, crs(param_raster))
  extracted_values <- terra::extract(param_raster, coords_projected)
  salix_temp <- copy(salix)
  salix_temp[, param_value := extracted_values[,2]]

  salix_temp <- salix_temp[param_value > 0]
  file_name <- basename(tif_path)
  
  plot_title <- param_titles[[file_name]]
  if (is.null(plot_title)) plot_title <- file_name
  

  p <- salix_temp %>%
    ggplot(aes(x = param_value, y = species, fill = species)) +
    geom_violin() +
    scale_fill_viridis(discrete = TRUE, alpha = 0.6, option = "A") +
    theme_ipsum() +
    theme(
      legend.position = "none",
      plot.title = element_text(size = 11)
    ) +
    ggtitle(plot_title) +
    xlab("")
  
  print(p)
  ggsave(filename = paste0("results/plots_salix/", tools::file_path_sans_ext(file_name), "_violin.jpeg"), plot = p, width = 10, height = 6)
}