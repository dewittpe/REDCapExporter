#' Build R Data Package
#'
#' Build a R Data Package from the core contents of a REDCap Project.
#'
#' To export the data from a REDCap project you will need to have an API Token.
#' Remember, the token is the equivalent of a username and password.  As such
#' you should not list the token in plain text.  Several alternative methods for
#' passing the token to this method will be provided in examples and vignettes.
#' We strongly encourage the use of the package secret
#' \url{https://cran.r-project.org/package=secret} to build vaults to store
#' tokens locally.
#'
#' The initial export will consist of four pieces of data, the user data,
#' metadata, project info, and records.
#'
#' @param x a \code{rcer_rccore} object
#' @param ... arguments passed to \code{\link{format_record}}
#'
#' @examples
#' ## Please read the vignette for examples:
#' ## vignette(topic = "export", package = "REDCapExporter")
#'
#' library(REDCapExporter)
#' # avs_raw_core <- export_core()
#' data(avs_raw_core)
#' tmppth <- tempdir()
#' build_r_data_package(avs_raw_core, tmppth, author_roles = list(dewittp = c("cre", "aut")))
#' fs::dir_tree(tmppth)
#'
#' @export
build_r_data_package <- function(x, ...) {
  UseMethod("build_r_data_package")
}

#' @param path Path where the exported project source will be
#' created/overwritten.
#' @param author_roles a list naming specific roles for each user id found in
#' the user table from an exported project.  By default all users with be
#' contributors ('ctb').  You will need to define a author/creator.
#' @param verbose provide messages to tell the user what is happening
#' @rdname build_r_data_package
#' @export
build_r_data_package.rcer_rccore <- function(x, path = NULL, author_roles = NULL, verbose = TRUE, ...) {
  access_time  <- Sys.time()

  project  <- as.data.frame(x$project_raw)
  user     <- as.data.frame(x$user_raw)
  metadata <- as.data.frame(x$metadata_raw)
  record   <- format_record(x$record_raw, x$metadata_raw, ...)

  if (is.null(path)) {
    path <- "."
  }
  path <- normalizePath(paste0(path, "/rcd", project$project_id), mustWork = FALSE)

  if (dir.exists(path)) {
    message(sprintf("Exporting to %s\nFiles will be overwritten and updated.", path))
  } else {
    message(sprintf("Creating source package at %s", path))
    dir.create(path)
  }

  # Create the DESCRIPTION FILE
  write_description_file(access_time, user, roles = author_roles, project, path)

  # LICENSE File
  cat("Proprietary\n\n
      Do not distribute to anyone or to machines which are not authorized to hold the data.\n",
      file = paste(path, "LICENSE", sep = "/"))

  # Write Raw Data
  dir.create(paste(path, "inst", "raw-data", sep = "/"), showWarnings = FALSE, recursive = TRUE)
  saveRDS(x$project_raw,  file = paste(path, "inst", "raw-data", "project.rds",  sep = "/"))
  saveRDS(x$metadata_raw, file = paste(path, "inst", "raw-data", "metadata.rds", sep = "/"))
  saveRDS(x$user_raw,     file = paste(path, "inst", "raw-data", "user.rds",     sep = "/"))
  saveRDS(x$record_raw,   file = paste(path, "inst", "raw-data", "record.rds",   sep = "/"))

  # Write Data
  dir.create(paste(path, "data", sep = "/"), showWarnings = FALSE, recursive = TRUE)
  save(project,  file = paste(path, "data", "project.rda",  sep = "/"))
  save(metadata, file = paste(path, "data", "metadata.rda", sep = "/"))
  save(user,     file = paste(path, "data", "user.rda",     sep = "/"))
  save(record,   file = paste(path, "data", "record.rda",    sep = "/"))

  # Write a dataset document file
  dir.create(paste(path, "R", sep = "/"), showWarnings = FALSE, recursive = TRUE)
  cat("#' Project",
      "#'",
      "#' Project information for REDcap Project",
      "#'",
      "#' Attributes for the project.  For any values that are boolean, they will be represented as either a 0 (no/false) or 1 (yes/true).  Also, all date/time values will be returned in Y-M-D H:M:S format.",
      "#'",
      "#' @format a data.frame with the following columns",
      "#' \\itemize{",
      paste("\n#' \\item", names(project)),
      "#' }",
      "\"project\"",
      "",
      "#' Metadata",
      "#'",
      "#' Project metadata from the project, i.e., data dictionary.",
      "#'",
      "#' @format a data.frame",
      "#'",
      "\"metadata\"",
      "",
      "",
      "#' User",
      "#'",
      "#' Attributes with regard to user privileges.  Please note that the 'forms' attribute is the only attribute that contains sub-elements (one for each data collection instrument), in which each form will have its own Form Rights value.",
      "#'",
      "#' Key:",
      "#' \\describe{",
      "#'   \\item{Data Export}{0=No Access, 2=De-Identified, 1=Full Data Set}",
      "#'   \\item{Form Rights}{0=No Access, 2=Read Only, 1=View records/responses and edit records (survey responses are read-only), 3=Edit survey responses}",
      "#'   \\item{Other attribute values}{0=No Access, 1=Access}",
      "#' }",
      "#' @format a data.frame",
      "#'",
      "\"user\"",
      "",
      "#' Record",
      "#'",
      "#' Project record for REDcap Project",
      "#'",
      "#' @format a data.frame",
      "#'",
      "\"record\"",
      sep = "\n",
      file = paste(path, "R/datasets.R", sep = "/")
  )

  devtools::document(path)

  invisible(TRUE)
}

# @param uri The URI for the REDCap API.  This is passed to
# \code{\link[RCurl]{postForm}}.
# @param token The API token for a REDCap project.

#' @inheritParams export_core
#' @rdname build_r_data_package
#' @export
build_r_data_package.default <- function(x, uri = NULL, token = NULL, format = NULL, path = NULL, author_roles = NULL, verbose = TRUE, ...) {
  core <- export_core(uri = uri, token = token, format = format, verbose = verbose, ...)
  build_r_data_package(core, path, author_roles, verbose, ...)
}
