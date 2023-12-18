example = function() {
  repos = jsonlite::fromJSON(readLines("C:/libraries/repbox/repos.json"))
  cat(paste0('"',repos$name,'"', collapse=", "))
  pkgs_dir = "C:/libraries/repbox/gha/gha_repbox_mono/pkgs"
  #download_repbox_pkg_zip_from_github(pkgs_dir)
  unzip_pkgs_sources(pkgs_dir)
}

repbox_packages = function() {
  c("GithubActions", "sourcemodify", "pkgFunIndex", "repboxUtils","repboxCodeText", "repboxRun",  "repboxGithub", "repboxArt", "repboxR", "repboxHtml", "repboxDB", "repboxRfun", "repboxEvaluate", "repboxReg", "repboxMap", "repboxStata", "ExtractSciTab", "repboxDeploy", "repboxverse")
}

download_repbox_pkg_zip_from_github = function(dest_dir, user="repboxr", pkgs = repbox_packages(),  branch="main") {
  restore.point("download_repbox_pkg_zip_from_github")
  urls = paste0("http://github.com/",user,"/",pkgs,"/archive/",branch,".zip")
  files = paste0(dest_dir, "/",pkgs,".zip")
  if (!dir.exists(dest_dir)) stop("Destination directory does not exist.")
  i = 1
  for (i in seq_along(urls)) {
    download.file(urls[i],files[i] )
  }
}

unzip_pkgs_sources = function(zip_dir, dest_dir=zip_dir) {
  restore.point("unzip_pkgs_sources")
  files = list.files(zip_dir, glob2rx("*.zip"),ignore.case = TRUE,full.names = TRUE)
}
