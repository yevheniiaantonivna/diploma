# Install and load required packages
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

populus <- fread("datasets/Populus.csv")
populus <- unique(populus)
setDT(populus)

frequency_included <- 20
species_freq <- populus[, .N, by = scientificName]
valid_species <- species_freq[N >= frequency_included, scientificName]
populus <- populus[scientificName %in% valid_species]

coords <- vect(populus, geom = c("decimalLongitude", "decimalLatitude"), crs = "EPSG:4326")
crs(coords) <- "EPSG:4326"

param_titles <- list(
  "nitrogen_mean.tif" = "Nitrogen",
  "soc_mean.tif" = "SOC",
  "cec_mean.tif" = "CEC",
  "ukr_cfvo_mean.tif" = "CFVO",
  "ukr_pH_h2o_mean.tif" = "pH h2o",
  "HII_Ukraine.tif" = "HII"
)

if (!dir.exists("results/plots_populus")) {
  dir.create("results/plots_populus")
}

tif_files <- list.files(path = "grids", pattern = "\\.tif$", full.names = TRUE)

for (tif_path in tif_files) {
  param_raster <- rast(tif_path)
  coords_proj <- project(coords, crs(param_raster))
  extracted <- terra::extract(param_raster, coords_proj)
  populus_temp <- copy(populus)
  populus_temp[, param := extracted[, 2]]
  populus_filtered <- populus_temp[param > 0]
  
  file_name <- basename(tif_path)
  plot_title <- param_titles[[file_name]]
  if (is.null(plot_title)) plot_title <- file_name
  
  p <- populus_filtered %>%
    ggplot(aes(x = param, y = scientificName, fill = scientificName)) +
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
  
  ggsave(filename = paste0("results/plots_populus/", tools::file_path_sans_ext(file_name), "_violin.jpeg"),
         plot = p, width = 10, height = 6)
}