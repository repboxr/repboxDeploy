example = function() {
  project_dir = "C:/libraries/repbox/projects_reg/aejmic_7_2_5"
  sup_url = "https://www.openicpsr.org/openicpsr/project/114322/version/V1/view"
  opts = repbox_example_options(sup_url = sup_url)

  repbox_example_project(project_dir,"C:/libraries/repbox/projects_ex", opts=opts)

}



repbox_example_copy_parcel_rds = function(project_dir, ex.dir, opts) {
  restore.point("repbox_example_create_parcel_csv")
  parcel_df = repboxDB::repdb_list_parcels(project_dir)


  source_files = parcel_df$path
  dest.dir = file.path(ex.dir, "parcels/rds")
  dest_files = file.path(dest.dir, basename(source_files))
  if (!dir.exists(dest.dir)) dir.create(dest.dir, recursive = TRUE)
  file.copy(source_files, dest_files)
}


repbox_example_create_parcel_csv = function(project_dir, ex.dir, opts) {
  restore.point("repbox_example_create_parcel_csv")
  parcel_df = repboxDB::repdb_list_parcels(project_dir)

  csv.dir = file.path(ex.dir, "parcels/csv")
  if (!dir.exists(csv.dir)) dir.create(csv.dir)
  i = 1
  for (i in seq_len(NROW(parcel_df))) {
    parcel_file = parcel_df$path[i]
    parcel = readRDS(parcel_file)
    parcel_name = parcel_df$parcel[i]
    for (tab in names(parcel)) {
      csv_file = paste0(csv.dir,"/", parcel_name, ".", tab, ".csv")
      df = parcel[[tab]] %>% as.data.frame()
      if (!is.null(opts$csv_max_rows)) {
        df = slice(df, 1:opts$csv_max_rows)
      }
      data.table::fwrite(df, csv_file)
    }
  }
}


