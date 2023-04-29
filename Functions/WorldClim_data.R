# To download WorldClim data

download_worldclim_data <- function(lon, lat, path, res = 0.5) {
  clim <- worldclim_tile(var = "bio", res = res, lon = lon, lat = lat, path = path)
  return(clim)
}
