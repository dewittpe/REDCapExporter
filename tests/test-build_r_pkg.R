library(REDCapExporter)
temppath <- tempdir()

msgs <- character()
withCallingHandlers(
  {
    build_r_data_package(
      x            = avs_raw_core,
      path         = temppath,
      author_roles = list(dewittp = c("cre", "aut"))
    )
  },
  message = function(m) {
    msgs <<- c(msgs, conditionMessage(m))
    invokeRestart("muffleMessage")
  }
)

pkgdir <- file.path(temppath, "rcd14465")

# check the DESCRIPTION file for the built package
d <- read.dcf(file.path(pkgdir, "DESCRIPTION"))
stopifnot(
  d[1, "Package"] == "rcd14465",
  grepl("\\d{4}\\.\\d{2}\\.\\d{2}\\.\\d{2}\\.\\d{2}", d[1, "Version"])
)

# check the file structure of the built package
x <- list.files(
  path         = pkgdir,
  all.files    = TRUE,
  recursive    = TRUE,
  include.dirs = TRUE,
  full.names   = FALSE,
  no..         = TRUE
)

# switch slashes from windows to *nix
x <- gsub("\\\\", "/", x)

expected <- sort(c(
  "DESCRIPTION",
  "LICENSE",
  "R",
  "R/datasets.R",
  "data",
  "data/metadata.rda",
  "data/project.rda",
  "data/record.rda",
  "data/user.rda",
  "inst",
  "inst/raw-data",
  "inst/raw-data/metadata.rds",
  "inst/raw-data/project.rds",
  "inst/raw-data/record.rds",
  "inst/raw-data/user.rds"
))

if (requireNamespace("devtools", quietly = TRUE)) {
  expected <- sort(c(
    expected,
    "NAMESPACE",
    "man",
    "man/metadata.Rd",
    "man/project.Rd",
    "man/record.Rd",
    "man/user.Rd"
  ))
  stopifnot(!any(grepl("Skipping devtools::document", msgs)))
} else {
  stopifnot(any(grepl("Skipping devtools::document", msgs)))
}

stopifnot(identical(x, expected))
