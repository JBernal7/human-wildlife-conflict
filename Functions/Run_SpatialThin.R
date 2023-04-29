# Run spatial-thinning
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
