#' Export REDCap Project
#'
#' Using the REDCap API, export parts of the project
#'
#' To export the data from a REDCap project you will need to have an API Token.
#' Remember, the token is the equivalent of a username and password.  As such
#' you should not list the token in plan text.  Several alternative methods for
#' passing the token to this method will be provided in examples and vignettes.
#' We strongly encourage the use of the pacakge secret
#' \url{https://cran.r-project.org/package=secret} to build vaults to store
#' tokens locally.
#'
#' The initial export will consist of four pieces of data, the user data,
#' metadata, proejct info, and records.
#'
#' @param uri The URI for the REDCap API.  This is passed to
#' \code{\link[RCurl]{postForm}}.
#' @param token The API token for a REDCap project.
#' @param path Path where the exported project source will be
#' created/overwritten.
#' @param author_roles a list naming specific roles for each user id found in
#' the user table from an exported project.  By default all users with be
#' contributers ('ctb').  You will need to define a author/creater.
#' @param verbose provide messages to tell the user what is happening
#'
#' @examples
#' ## Please read the vignette for examples:
#' ## vignette(topic = "export", package = "REDCapExporteR")
#' @export
export_redcap_project <- function(uri, token, path = NULL, author_roles = NULL, verbose = TRUE) {
  if (verbose) message("Getting Project Info")
  project_raw <- export_content(uri = uri, token = token, content = "project")

  if (verbose) message("Getting project metadata")
  metadata_raw     <- export_content(uri = uri, token = token, content = "metadata")

  if (verbose) message("Getting user data")
  user_raw         <- export_content(uri = uri, token = token, content = "user")

  if (verbose) message("Getting project record")
  record_raw      <- export_content(uri = uri, token = token, content = "record")

  access_time  <- Sys.time()

  project  <- as.data.frame(project_raw)
  user     <- as.data.frame(user_raw)
  metadata <- as.data.frame(metadata_raw)
  record   <- format_record(record_raw, metadata_raw)

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
  saveRDS(project_raw,  file = paste(path, "inst", "raw-data", "project.rds",  sep = "/"))
  saveRDS(metadata_raw, file = paste(path, "inst", "raw-data", "metadata.rds", sep = "/"))
  saveRDS(user_raw,     file = paste(path, "inst", "raw-data", "user.rds",     sep = "/"))
  saveRDS(record_raw,   file = paste(path, "inst", "raw-data", "record.rds",   sep = "/"))

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
      "#' Attributes for the project.  For any values that are boolean, they will be represtned as either a 0 (no/false) or 1 (yes/true).  Also, all date/time values will be returned in Y-M-D H:M:S format.",
      "#'",
      "#' @format a data.frame with the following collumns",
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

#' Export Content
#'
#' Export specific data elemetns from REDCap
#'
#' The \code{content} and \code{format} arguements are used to control the
#' specific items to be exported, and in what format.  **Review the API
#' documentation**
#'
#' The \code{uri}, \code{token}, and \code{format} arguments are set to
#' \code{NULL} by default and will look to the
#' \code{Sys.getenv("REDCap_API_URI")},
#' \code{Sys.getenv("REDCap_API_TOKEN")}, and
#' \code{Sys.getenv("REDCap_API_format")}, respectively, to define the values if
#' not explictly done so by the end user.
#'
#' @param content The element to export, see Details.
#' @param uri The URI for the REDCap API.  If \code{NULL} (default) the value
#' \code{Sys.getenv("REDCap_API_URI")} is used.
#' @param token The API token for the projedct you want to export from. If
#' \code{NULL} (default) the value \code{Sys.getenv("REDCap_API_TOKEN")} is
#' used.
#' @param format The format to return. If \code{NULL} (default) the value
#' \code{Sys.getenv("REDCap_API_format")} is used.
#' @param ... additional arguments passed to \code{\link[RCurl]{postForm}}.
#'
#' @return The raw return from the REDCap API with the class
#' \code{rcer_raw_<content>}.
#'
#' @examples
#'
#' # A reproducible example would require a REDCap project, accessable via an
#' # API token.  An example of the return from these calls are provided as data
#' # with this package.
#'
#' # avs_raw_metadata <- export_content(content = "metadata")
#' data(avs_raw_metadata)
#' str(avs_raw_metadata)
#'
#' @export
export_content <- function(content, uri = NULL, token = NULL, format = NULL, ...) {

  if (is.null(uri)) {
    uri <- Sys.getenv("REDCap_API_URI")
  }

  if (is.null(token)) {
    token <- Sys.getenv("REDCap_API_TOKEN")
  }

  if (is.null(format)) {
    format <- Sys.getenv("REDCap_API_format")
  }

  x <- RCurl::postForm(uri = uri, token = token, content = content, format = format, ...)

  attr(x, "accessed") <- Sys.time()
  class(x)            <- c(paste0("rcer_raw_", content), class(x))

  x
}


