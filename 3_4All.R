# Load required libraries
library(raster)
library(terra)
library(geodata)

# Functions
download_worldclim_data <- function(lon, lat, path, res = 0.5) {
  clim <- worldclim_tile(var = "bio", res = res, lon = lon, lat = lat, path = path)
  return(clim)
}

download_elevation_data <- function(lon, lat, path, res = 0.5) {
  alt <- worldclim_tile(var = "elev", res = res, lon = lon, lat = lat, path = path)
  return(alt)
}

# Download WorldClim data and elevation data
lon <- 31
lat <- -23
path <- "D:/IDAF/Loxodonta_africana/2_WorldClim_R/"
resolution <- 0.5

clim1km <- download_worldclim_data(lon, lat, path, resolution)
plot(clim1km)

alt <- download_elevation_data(lon, lat, path, resolution)
plot(alt)

# Explore resolution and extension of the variables
ext(clim1km)
xres(clim1km) 
yres(clim1km)

ext(alt)
xres(alt) 
yres(alt)
