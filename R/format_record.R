#' Format Record
#'
#' Use REDCap project metadata to build a well formatted \code{data.frame} for
#' the record.
#'
#' @param x a \code{rcer_rccore}, \code{rcer_raw_record}, or \code{rcer_record} object.
#' @param metadata a \code{rcer_metadata} or \code{rcer_raw_metadata} object.
#' Will be ignored if \code{col_type} is defined.
#' @param col_type a \code{rcer_col_type} object.
#' @param ... other arguments passed to \code{\link{col_type}}
#'
#' @seealso \code{\link{export_core}}, \code{\link{export_content}}, \code{vignette("formatting", package = "REDCapExporter")}
#'
#' @return A \code{data.frame}
#'
#' @examples
#'
#' data("avs_raw_metadata")
#' data("avs_raw_record")
#'
#' # Formatting the record can be called in different ways and the same result
#' # will be generated
#' identical(
#'   format_record(avs_raw_record, avs_raw_metadata),
#'   format_record(avs_raw_core)
#' )
#'
#' avs <- format_record(avs_raw_record, avs_raw_metadata)
#' avs
#'
#' @export
format_record <- function(x, metadata = NULL, col_type = NULL, ...) {
  UseMethod("format_record")
}

#' @export
format_record.rcer_rccore <- function(x, metadata = NULL, col_type = NULL, ...) {
  format_record(x = x$record_raw, metadata = x$metadata_raw, col_type = col_type, ...)
}

#' @export
format_record.rcer_raw_record <- function(x, metadata = NULL, col_type = NULL, ...) {
  format_record(as.data.frame(x), metadata = metadata, col_type = col_type, ...)
}

#' @export
format_record.rcer_record <- function(x, metadata = NULL, col_type = NULL, ...) {

  if (!is.null(metadata) & !is.null(col_type)) {
    message("Ignoring metadata, using col_type")
  }

  if (is.null(metadata) & is.null(col_type)) {
    stop("Either 'metadata' or 'col_type' need to be specified.")
  }

  if (is.null(col_type)) {
    if (!(inherits(metadata, "rcer_metadata") | inherits(metadata, "rcer_raw_metadata"))) {
      stop("format_record expects the `metadata` argument to be a `rcer_raw_metadata` or `rcer_metadata` object.")
    }

    if (inherits(metadata, "rcer_raw_metadata")) {
      metadata <- as.data.frame(metadata)
    }

    ct <- col_type(metadata, ...)

  } else {
    if (!inherits(col_type, "rcer_col_type")) {
      stop("col_type needs to be rcer_col_type object")
    }
    ct <- col_type
  }

  for (n in names(ct)) {
    if (n %in% names(x)) {
      x[[n]] <- eval(ct[[n]], envir = x)
    }
  }

  x
}

