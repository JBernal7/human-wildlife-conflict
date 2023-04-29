# To download elevation data (from WorldClim)

download_elevation_data <- function(lon, lat, path, res = 0.5) {
  alt <- worldclim_tile(var = "elev", res = res, lon = lon, lat = lat, path = path)
  return(alt)
}