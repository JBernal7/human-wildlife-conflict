library(rgbif)
library(sp)
library(rgeos)
library(raster)
library(rgdal)
library(mapview)

download_presence_data <- function(species_name, country_codes, output_path) {
  presence_data <- data.frame()
  
  for (country_code in country_codes) {
    temp_data <- occ_data(scientificName = species_name,
                          hasCoordinate = TRUE, country = country_code,
                          limit = 5000)
    presence_data <- rbind(presence_data, temp_data$data[, c("datasetKey", "decimalLongitude", "decimalLatitude")])
  }
  
  presence_data <- na.omit(presence_data)
  presence_data <- presence_data[!duplicated(presence_data), ]
  presence_data$Presence <- 1
  names(presence_data)[names(presence_data) == "decimalLongitude"] <- "X"
  names(presence_data)[names(presence_data) == "decimalLatitude"] <- "Y"
  
  presence_sp <- SpatialPointsDataFrame(coords = presence_data[, c("X", "Y")], data = presence_data)
  proj4string(presence_sp) <- CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
  
  write.csv(presence_data, file.path(output_path, paste0(species_name, "_presence.csv")), row.names = FALSE)
  raster::shapefile(presence_sp, file.path(output_path, paste0(species_name, "_presence.shp")), overwrite = TRUE)
  
  return(presence_sp)
}

load_shapefile <- function(file_path) {
  shp <- readOGR(file_path)
  return(shp)
}

filter_presence_by_study_area <- function(presence_sp, study_area_shp) {
  presence_sp_transformed <- spTransform(presence_sp, CRS(proj4string(study_area_shp)))
  presence_sp_filtered <- gIntersection(presence_sp_transformed, study_area_shp)
  return(presence_sp_filtered)
}

plot_presence_data <- function(presence_sp, study_area_shp) {
  mapview(presence_sp, legend = FALSE,
          alpha.regions = 0.2, color = c("black"), lwd = 2, map.types = "Esri.WorldTopoMap") + 
    mapview(study_area_shp, legend = FALSE,
            alpha.regions = 0.2, color = c("red"), lwd = 2)
}

# Example usage:
species_name <- "Loxodonta africana"
country_codes <- c("MZ", "ZW", "ZA")
output_path <- "./Loxodonta_africana/1_presencias/1_RGBIF"
study_area_shp_file <- "./PN_Limpopo/limites_limpopo/PN_Limpopo_30km.shp"

# Make sure the output directory exists
dir.create(output_path, showWarnings = FALSE)

elephant_presence <- download_presence_data(species_name, country_codes, output_path) 
study_area_shp <- load_shapefile(study_area_shp_file)

filtered_presence <- filter_presence_by_study_area(elephant_presence, study_area_shp)
plot_presence_data(filtered_presence, study_area_shp)

