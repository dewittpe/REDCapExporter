library(REDCapExporter)
temppath <- tempdir()
build_r_data_package(
  x            = avs_raw_core,
  path         = temppath,
  author_roles = list(dewittp = c("cre", "aut")),
)

x <- fs::dir_tree(temppath)
x <- unname(sapply(strsplit(x, "rcd14465"), `[`, 2))
x[is.na(x)] <- ""
x <- sort(paste0("rcd14465", x))

print(x)

stopifnot(
  identical(
    x,
    sort(
      c("rcd14465", "rcd14465/DESCRIPTION", "rcd14465/LICENSE", "rcd14465/NAMESPACE",
      "rcd14465/R", "rcd14465/R/datasets.R", "rcd14465/data", "rcd14465/data/metadata.rda",
      "rcd14465/data/project.rda", "rcd14465/data/record.rda", "rcd14465/data/user.rda",
      "rcd14465/inst", "rcd14465/inst/raw-data", "rcd14465/inst/raw-data/metadata.rds",
      "rcd14465/inst/raw-data/project.rds", "rcd14465/inst/raw-data/record.rds",
      "rcd14465/inst/raw-data/user.rds", "rcd14465/man", "rcd14465/man/metadata.Rd",
      "rcd14465/man/project.Rd", "rcd14465/man/record.Rd", "rcd14465/man/user.Rd")
    )
  )
)

stopifnot(
    packageDescription(pkg = "rcd14465", lib.loc = temppath)$Package == "rcd14465",
    grepl("\\d{4}\\.\\d{2}\\.\\d{2}\\.\\d{2}\\.\\d{2}", packageDescription(pkg = "rcd14465", lib.loc = temppath)$Version)
    )
