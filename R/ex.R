example = function() {
  project_dir = "C:/libraries/repbox/projects_reg/aejapp_9_4_5"
  sup_url = "https://www.openicpsr.org/openicpsr/project/114322/version/V1/view"




  project_dir = "C:/libraries/repbox/projects_reg/aejapp_9_4_5"
  sup_url = "https://www.openicpsr.org/openicpsr/project/113670/version/V1/view"
  opts = repbox_example_options(sup_url = sup_url,sup_license = "Creative Commons Attribution 4.0 and BSD", csv_max_rows = 10, report_url = "https://econ.mathematik.uni-ulm.de/repbox-example")


  ex.dir = repbox_example_project(project_dir,"C:/libraries/repbox/projects_ex", opts=opts)

  rstudioapi::filesPaneNavigate(ex.dir)

}

repbox_example_project = function(project_dir, parent.dir, opts=repbox_example_options()) {
  restore.point("repbox_example_project")
  if (!dir.exists(project_dir)) {
    stop(paste0("Project directory ", project_dir, " does not exist"))
  }
  project = basename(project_dir)
  ex.dir = file.path(parent.dir, project)
  if (!dir.exists(ex.dir)) {
    dir.create(ex.dir,recursive = TRUE)
  }

  repbox_example_copy_table_specs(project_dir, ex.dir)

  # Copy some files
  files = get_repbox_example_copy_files(project_dir, opts)
  copy_files_to_repbox_example(files, project_dir, ex.dir)

  # Create README.md
  md = repbox_example_readme(project_dir, opts=opts)
  writeUtf8(md, file.path(ex.dir, "README.md"))

  # Copy scripts
  repbox_example_copy_scripts(project_dir,ex.dir, opts)

  # Copy parcels as Rds and csv
  repbox_example_copy_parcel_rds(project_dir, ex.dir, opts)
  repbox_example_create_parcel_csv(project_dir, ex.dir, opts)

  ex.dir

}

repbox_example_copy_table_specs = function(project_dir, ex.dir) {
  source_files = repboxDB::repdb_spec_files()

  spec_dir = file.path(ex.dir, "parcels/table_spec")
  if (!dir.exists(spec_dir)) dir.create(spec_dir)
  dest_files = file.path(spec_dir, basename(source_files))
  file.copy(source_files, dest_files)
}

copy_files_to_repbox_example = function(files, project_dir, ex.dir) {
  source_files = file.path(project_dir, files)
  dest_files = file.path(ex.dir, files)
  create_dirs_of_files(dest_files)
  file.copy(source_files, dest_files)
}

repbox_example_copy_scripts = function(project_dir, ex.dir, opts=NULL) {
  sup.dir = file.path(project_dir, "org")
  files = list.files(sup.dir, "*\\.((py)|(r)|(do)|(ado)|(jl))", ignore.case = TRUE, recursive=TRUE)

  script.dir = file.path(ex.dir, "scripts")
  if (!dir.exists(script.dir)) {
    dir.create(script.dir)
  }

  source_files = file.path(sup.dir, files)
  dest_files = file.path(ex.dir,"scripts", files)
  create_dirs_of_files(dest_files)
  file.copy(source_files, dest_files)
}

create_dirs_of_files = function(files, must.have=NULL) {
  restore.point("create_dirs_of_files")
  dirs = unique(dirname(files))
  if (!all(stringi::stri_detect_fixed(files, must.have))) {
    stop(paste0("Not all directories contain the pattern ", must.have))
  }
  for (dir in dirs) {
    if (!dir.exists(dir)) {
      dir.create(dir, recursive = TRUE)
    }
  }
}

get_repbox_example_copy_files = function(project_dir, opts=repbox_example_options()) {
  restore.point("get_repbox_example_copy_files")
  files = list.files(project_dir,glob2rx("*"),full.names = FALSE, recursive = TRUE)

  files = files[startsWith(files, "reports/")]
  return(files)

  # Remove internal files that should not be part of an
  # example since internal structure might change

  ignore_prefix = c("steps","repbox/stata","repbox/r","mod","metareg","art/art_tab_raw","meta")
  keep_prefix = c("art/repdb","metareg/base/repdb","repbox/repdb","art/pdf","art/html")
  ignore = startsWithAny(files, ignore_prefix) & !startsWithAny(files, keep_prefix)
  files = files[!ignore]

  # Remove article information
  # (should be done unless there is an open license)
  if (!opts$keep_art) {
    keep_prefix = c("art/repdb")
    ignore_prefix = c("art")
    ignore = startsWithAny(files, ignore_prefix) & !startsWithAny(files, keep_prefix)
    files = files[!ignore]

    ignore_prefix = c("art/repdb/art_tab_source.rds")
    ignore = startsWithAny(files, ignore_prefix)
    files = files[!ignore]
  }

  files
}

startsWithAny = function(x, prefix) {
  res = rep(FALSE, length(x))
  for (p in prefix) {
    res = res | startsWith(x,p)
  }
  res
}

endsWithAny = function(x, prefix) {
  res = rep(FALSE, length(x))
  for (p in prefix) {
    res = res | endsWith(x,p)
  }
  res
}

repbox_example_options = function(keep_art = !is.null(art_license), art_license=NULL, sup_license=NULL, sup_url = NULL, csv_max_rows=10, report_url = NULL) {
  list(
    keep_art = keep_art,
    art_license = art_license,
    sup_license = sup_license,
    sup_url = sup_url,
    csv_max_rows = csv_max_rows,
    report_url = report_url
  )
}
