#Calculate nni

calculate_nni <- function(spatial_points) {
  nni(spatial_points, win = "extent")
}

