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
#' @param other_exports Other things to export from REDCap **To be implimented**
#' @param path Path where the exported project source will be
#' created/overwritten.
#'
#' @examples
#' ## Please read the vignette for examples:
#' ## vignette(topic = "export", package = "REDCapExporteR")
#' @export
export_redcap_project <- function(uri, token, other_exports, path = NULL) {
  project_info_raw <- export_content(uri = uri, token = token, content = "project")
  metadata_raw     <- export_content(uri = uri, token = token, content = "metadata")
  user_raw         <- export_content(uri = uri, token = token, content = "user")
  records_raw      <- export_content(uri = uri, token = token, content = "record")

  access_time  <- Sys.time()

  project_info <- data.table::fread(project_info_raw)
  user         <- data.table::fread(user_raw)

  # VERIFY WHO IS DOING THE EXPORT
  # user[api_export == 1, username:lastname]

  if (is.null(path)) {
    path <- "."
  }
  path <- normalizePath(paste0(path, "/rcd", project_info$project_id), mustWork = FALSE)

  if (dir.exists(path)) {
    message(sprintf("Exporting to %s\nFiles will be overwritten and updated.", path))
  } else {
    message(sprintf("Creating source package at %s", path))
    dir.create(path)
  }

  # Create the DESCRIPTION FILE
  write_descritption_file(access_time, user, project_info, path)

  # LICENSE File
  cat("Proprietary\n\n
      Do not distribute to anyone or to machines which are not authorized to hold the data.",
      file = paste(path, "LICENSE", sep = "/"))

  # Write Data
  dir.create(paste(path, "inst", "raw-data", sep = "/"), showWarnings = FALSE, recursive = TRUE)
  saveRDS(project_info_raw, file = paste(path, "inst", "raw-data", "project_info.rds", sep = "/"))
  saveRDS(metadata_raw,     file = paste(path, "inst", "raw-data", "metadata.rds",     sep = "/"))
  saveRDS(user_raw,         file = paste(path, "inst", "raw-data", "user.rds",         sep = "/"))
  saveRDS(records_raw,      file = paste(path, "inst", "raw-data", "records.rds",      sep = "/"))


  invisible()
}

#' Export Content
#'
#' Export specific data elemetns from REDCap
#'
#' The \code{content} and \code{format} arguements are used to control the
#' specific items to be exported, and in what format.  **Review the API
#' documentation**
#'
#' @param uri The URI for the REDCap API.
#' @param token The API token for the projedct you want to export from.
#' @param content The element to export, see Details.
#' @param format The format to return.
#' @param ... additional arguments passed to \code{\link[RCurl]{postForm}}.
#'
#' @export
export_content <- function(uri, token, content, format = "csv", ...) {

  if (missing(uri)) {
    uri <- Sys.getenv("REDCap_API_uri")
  }

  if (missing(token)) {
    token <- Sys.getenv("REDCap_API_TOKEN")
  }

  if (missing(format)) {
    format <- Sys.getenv("REDCap_API_format")
  }

  x <- RCurl::postForm(uri = uri, token = token, content = content, format = format, ...)

  attr(x, "accessed") <- Sys.time()
  class(x)            <- c(paste0("rcer_", content), class(x))

  x
}

write_descritption_file <- function(access_time, user, project_info, path) {

  pkg_version <-
    paste(formatC(lubridate::year(access_time), width = 4),
          formatC(lubridate::month(access_time), width = 2, flag = 0),
          formatC(lubridate::day(access_time), width = 2, flag = 0),
          formatC(lubridate::hour(access_time), width = 2, flag = 0),
          formatC(lubridate::minute(access_time), width = 2, flag = 0),
          sep = ".")

  cat("Package: ", paste0("rcd", project_info$project_id), "\n",
      "Title: ",   project_info$project_title, "\n",
      "Version: ", pkg_version, "\n",
      "Authors@R: ", write_authors(user), "\n",
      "Description: Data and documentation from the REDCap Project.", "\n",
      "License: file LICENSE\n",
      "Encoding: UTF-8\n",
      "LazyData: true\n",
      "Suggests:\n    knitr\n",
      "VignetteBuilder: knitr\n",
      sep = "", file = paste(path, "DESCRIPTION", sep = "/"), append = FALSE)

  invisible()
}

write_authors <- function(user) {
  paste0("c(", paste(sprintf("person(\"%s\", \"%s\", \"%s\")", user$firstname, user$lastname, user$email), collapse = ",\n             "), ")")
}

