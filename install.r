#!/usr/bin/env Rscript

ruserlib = Sys.getenv("R_LIBS_USER")
dir.create(ruserlib)
install.packages(c("mice", "plyr", "foreach"), lib=ruserlib)
