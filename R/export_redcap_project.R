#' Export Content
#'
#' Export specific data elements from REDCap
#'
#' The \code{content} and \code{format} arguments are used to control the
#' specific items to be exported, and in what format.  **Review the API
#' documentation**
#'
#' The \code{uri}, \code{token}, and \code{format} arguments are set to
#' \code{NULL} by default and will look to the
#' \code{Sys.getenv("REDCap_API_URI")},
#' \code{Sys.getenv("REDCap_API_TOKEN")}, and
#' \code{Sys.getenv("REDCap_API_format")}, respectively, to define the values if
#' not explicitly done so by the end user.
#'
#' @param content The element to export, see Details.
#' @param uri The URI for the REDCap API.  If \code{NULL} (default) the value
#' \code{Sys.getenv("REDCap_API_URI")} is used.
#' @param token The API token for the project you want to export from. If
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

#' Export Core
#'
#' Export Core Contents of a REDCap Project.
#'
#' @param uri The URI for the REDCap API.  If \code{NULL} (default) the value
#' \code{Sys.getenv("REDCap_API_URI")} is used.
#' @param token The API token for the project you want to export from. If
#' \code{NULL} (default) the value \code{Sys.getenv("REDCap_API_TOKEN")} is
#' used.
#' @param format The format to return. If \code{NULL} (default) the value
#' \code{Sys.getenv("REDCap_API_format")} is used.
#' @param verbose provide messages to tell the user what is happening
#' @param ... not currently used
#'
#' @return A \code{rcer_rccore} object: a list with the project info, metadata,
#' user table, and records, all in a "raw" format direct from the API.
#'
#' @examples
#'
#' # A reproducible example would require a REDCap project, accessable via an
#' # API token.  An example of the return from these calls are provided as data
#' # with this package.
#'
#' # avs_raw_core <- export_core()
#'
#' data(avs_raw_core)
#' str(avs_raw_core)
#'
#' @export
export_core <- function(uri = NULL, token = NULL, format = NULL, verbose = TRUE, ...) {
  if (verbose) message("Getting Project Info")
  project_raw <- export_content(uri = uri, token = token, content = "project", format = format)

  if (verbose) message("Getting project metadata")
  metadata_raw <- export_content(uri = uri, token = token, content = "metadata", format = format)

  if (verbose) message("Getting user data")
  user_raw <- export_content(uri = uri, token = token, content = "user", format = format)

  if (verbose) message("Getting project record")
  record_raw <- export_content(uri = uri, token = token, content = "record", format = format)

  x <- list(project_raw = project_raw,
            metadata_raw = metadata_raw,
            user_raw = user_raw,
            record_raw = record_raw)
  class(x) <- c("rcer_rccore")
  x
}
