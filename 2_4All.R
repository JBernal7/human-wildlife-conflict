# Load required libraries
library(raster)
library(rgdal)
library(spatstat)
library(spatialEco)
library(spThin)

# Functions
calculate_nni <- function(spatial_points) {
  nni(spatial_points, win = "extent")
}

run_spatial_thinning <- function(data, lat_col, long_col, species_col, thin_par, reps, output_dir) {
  thin.sp <- thin(loc.data = data,
                  lat.col = lat_col, long.col = long_col,
                  spec.col = species_col,
                  thin.par = thin_par, reps = reps,
                  locs.thinned.list.return = TRUE,
                  write.files = TRUE,
                  max.files = 3,
                  out.dir = output_dir,
                  write.log.file = TRUE,
                  log.file = paste0(output_dir, "loxodonta_thinned_log_file.txt"))
  return(thin.sp)
}

# Paths
path2sp <- "./Loxodonta_africana/1_presencias/1_RGBIF/La_1_AE.csv"
path2sp_shp <- "./Loxodonta_africana/1_presencias/1_rgbif/La_1_AE.shp"
path2area_shp <- "./PN_Limpopo/limites_limpopo/PN_Limpopo_30km.shp"
path2work <- "./Loxodonta_africana/1_presencias/2_filtering_records/"

# Load data
sp.df <- read.csv(path2sp, header = TRUE, sep = ',', fill = TRUE, check.names = TRUE, stringsAsFactors = FALSE)
sp.shp <- readOGR(path2sp_shp)
area.shp <- readOGR(path2area_shp)

# Transform objects
sp.sp <- as(sp.shp, "SpatialPoints")
area_poly <- as(area.shp, "SpatialPolygons")

# Plot points and study area
plot(area_poly, col = "gray80")
points(sp.sp, add = TRUE, col = "darkred")

# Calculate NNI
nni_result <- calculate_nni(sp.sp)
print(nni_result)

# Convert sp.shp to decimal degree format
sp.df <- spTransform(sp.shp, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))
sp.df <- as.data.frame(sp.df)
names(sp.df)[names(sp.df) == "coords.x1"] <- "X"
names(sp.df)[names(sp.df) == "coords.x2"] <- "Y"

# Run spatial thinning
thinned_data <- run_spatial_thinning(sp.df, "Y", "X", "La", 3, 10, path2work)

# Summary and plot
summaryThin(thinned_data, show = TRUE)
plotThin(thinned_data)

