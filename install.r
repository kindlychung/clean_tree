#!/usr/bin/env Rscript

ruserlib = Sys.getenv("R_LIBS_USER")
suppressWarnings(dir.create(ruserlib))
packages <- c("mice", "plyr", "foreach")
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages())),
                   lib=ruserlib, repos="http://cran-mirror.cs.uu.nl/")
} else {
    message("All required R packages are already installed, cool!")
}
