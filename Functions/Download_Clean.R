
# Function to download and clean presence data for any given species and country codes:


download_presence_data <- function(species_name, country_codes, output_path) {
  presence_data <- data.frame()
  
  for (country_code in country_codes) {
    temp_data <- occ_search(scientificName = species_name,
                            hasCoordinate = TRUE, country = country_code,
                            return = "data", limit = 5000)
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


# Example usage (arguments):
species_name <- "Loxodonta africana" #The scientific name of the species
country_codes <- c("MZ", "ZW", "ZA") #A vector of two-letter ISO country codes 
output_path <- "./Loxodonta_africana/1_presencias/1_RGBIF" #The directory where the output files (CSV and shapefile) will be saved

elephant_presence <- download_presence_data(species_name, country_codes, output_path) #replace elephant by the target species
