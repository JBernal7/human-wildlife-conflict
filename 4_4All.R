

library(raster)
library(rgdal)
library(spatstat)
library(spatialEco)
library(usdm)
library(ggplot2)
library(maptools)
library(corrplot)

### Define Functions

select_uncorrelated_variables <- function(data_frame, method = "spearman", threshold = 0.8) {
  cor_matrix <- cor(data_frame, method = method)
  cor_matrix[diag(cor_matrix)] <- 0
  high_cor <- which(abs(cor_matrix) > threshold, arr.ind = TRUE)
  to_remove <- unique(high_cor[high_cor[, 1] != high_cor[, 2], 2])
  selected_vars <- names(data_frame)[-to_remove]
  return(selected_vars)
}

update_raster_stack <- function(raster_stack, selected_variables) {
  new_stack <- brick(raster_stack[[selected_variables]])
  return(new_stack)
}

### Load Data

path2layers <- "./Loxodonta_africana/2_WorldClim_R/wc2.1_tiles"
VAR_PN <- stack(list.files(path = path2layers, pattern = "", full.names = TRUE))

### Crop and Mask Raster Stack with AOI

PN_shp <- readOGR("./PN_Limpopo/limites_limpopo/PN_Limpopo_30km.shp")
PN_shp <- spTransform(PN_shp, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))
VAR_PN <- crop(VAR_PN, extent(PN_shp))
VAR_PN <- mask(VAR_PN, PN_shp)

### Remove bio_3, bio_14, bio_15

names(VAR_PN)
VAR_PN_DEF <- dropLayer(VAR_PN, c(3, 14, 15))

### Calculate Correlations and Select Uncorrelated Variables

var.df <- as.data.frame(VAR_PN_DEF)
var.df <- na.omit(var.df)
uncorrelated_vars <- select_uncorrelated_variables(var.df, method = "spearman", threshold = 0.8)

### Update Raster Stack with Selected Variables

var.def <- update_raster_stack(VAR_PN_DEF, uncorrelated_vars)

### Correlation Matrix, VIF, and Plots for Selected Variables

var.df2 <- var.df[, uncorrelated_vars]
var.cor <- cor(var.df2, method = "spearman")

corrplot_number <- corrplot(var.cor, type = "upper", method = "number")
corrplot_circle <- corrplot(var.cor, type = "upper", method = "circle")

result.vif <- vif(var.df2)

p <- ggplot(data = result.vif, aes(x = Variables, y = VIF)) +
  ggtitle("VIF") +
  geom_bar(stat = "identity") +
  coord_flip() +
  theme(
    plot.title = element_text(size = 18, face = "bold"),
    axis.title = element_text(size = 18, face = "bold"),
    legend.title = element_text(size = 14, face = "bold"),
    legend.text = element_text(size = 12),
    axis.text = element_text(size = 14, colour = "black"))

p

### Save Selected Variables to Calibrate ENMs

path2work2 <- "./Loxodonta_africana/3_test_multicolinealidad/resultados/variables_seleccionadas/"
writeRaster(x = var.def, path2work2, names(var.def), bylayer = TRUE, format = "ascii", overwrite = TRUE)

### Clean up and Free Memory

rm(var.cor, var.df, var.df2, result.vif, var.cluster, var.dist, var.selected)
gc()

