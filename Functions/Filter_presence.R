# Filter the presence data by a given study area

filter_presence_by_study_area <- function(presence_sp, study_area_shp) {
  presence_sp_transformed <- spTransform(presence_sp, CRS(proj4string(study_area_shp)))
  presence_sp_filtered <- gIntersection(presence_sp_transformed, study_area_shp)
  return(presence_sp_filtered)
}

#Arguments:
#presence_sp: A SpatialPointsDataFrame object containing the presence data (comes from 'Download_Clean' function)
#study_area_shp: A SpatialPolygonsDataFrame object containing the study area shapefile (input for the study case)
