# Plot the presence data along with the study area

plot_presence_data <- function(presence_sp, study_area_shp) {
  mapview(presence_sp, legend = FALSE,
          alpha.regions = 0.2, color = c("black"), lwd = 2, map.types = "Esri.WorldTopoMap") + 
    mapview(study_area_shp, legend = FALSE,
            alpha.regions = 0.2, color = c("red"), lwd = 2)
}

#customize the appearance of the plot (e.g., colors, line widths, background map)


# Arguments:
#presence_sp: A SpatialPointsDataFrame object containing the presence data (comes from 'Download_Clean' function).
#study_area_shp: A SpatialPolygonsDataFrame object containing the study area shapefile (input for the study case).