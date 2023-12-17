# Generate a readme for a repbox example

example = function() {
  project.dir = "C:/libraries/repbox/projects_reg/aejmic_7_2_5"
  sup_url = "https://www.openicpsr.org/openicpsr/project/114322/version/V1/view"
  opts = repbox_example_options(sup_url = sup_url)
  repbox_example_readme(project.dir, opts)

}

repbox_example_readme = function(project.dir, opts, art=NULL) {
  restore.point("repbox_example_readme")
  artid = basename(project.dir)

  if (is.null(art)) {
    art = readRDS(file.path(project.dir,"art","regdb/art.Rds"))$art
  }

  if (!is.null(opts$sup_url)) {
    art$data_url = opts$sup_url
  }
  art$authors
  art$article_url

  if (is.null(opts$sup_license)) {
    sup_license_text = "**WARNING** We have not found an explicit license for the replication package. You should therefore not publicly share this example."
  } else {
    sup_license_text = paste0("The replication package is licensed under ", opts$sup_license)
  }

  if (is.null(opts$art_license)) {
    art_license_text = "We have not found an open license for the article."
  } else {
    art_license_text = paste0("The article is licensed under ", opts$art_license)
  }

  if (opts$keep_art) {
    art_text = "The `art` folder contains the original article and derived data sets."
  } else {
    art_text = "To due copyright, we removed parcels that contain original text from the article."
  }


  txt = paste0("# Repbox Example Project ", artid, "

Generated on ", Sys.time(),"

Based on the article \n\n**[", art$title, "](", art$article_url,") by ", art$authors, " (", art$year, ", ", art$journ,")**

The replication package can be found here:\n ", art$data_url, "

", sup_license_text,"

", art_license_text,"

## Content

You find the generated HTML reports in the `reports` folder. The generated data parcels in the `parcels` folder. The `parcels/rds` contains the parcels in R's Rds data type and the `csv` folder shows the first lines of all tables as csv files.

", art_text, "

We did not include the original supplement in order to save space.
")
  txt
}