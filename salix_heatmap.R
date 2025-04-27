if (!require("pheatmap")) install.packages("pheatmap")
library(pheatmap)

data <- read.csv("heatmap/salix_heatmap.csv", 
                 sep = ";", 
                 fileEncoding = "windows-1251", 
                 row.names = 1)
View(data)

data[is.na(data)] <- 0

if (!dir.exists("results/plots_heatmap")) {
  dir.create("results/plots_heatmap")
}

pheatmap(data,
         filename = "results/plots_heatmap/salix_heatmap.jpeg",  
         width = 10,   
         height = 8,
         color = colorRampPalette(c("white", "#ffffcc", "#800026", "#49006a"))(100),
         border_color = "grey80",
         cluster_rows = FALSE,
         cluster_cols = FALSE,
         fontsize = 12,
         main = "Фіторемедіаційна активність видів")