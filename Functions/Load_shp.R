
# Function to load a shapefile into the R environment


load_shapefile <- function(file_path) {
  shp <- readOGR(file_path)
  return(shp)
}


# file_path: The path to the shapefile (e.g., "./PN_Limpopo/limites_limpopo/PN_Limpopo_30km.shp").