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
#' @seealso \link{export_core}
#'
#' @return A \code{data.frame} or \code{data.table}
#'
#' @examples
#'
#' data("avs_raw_metadata")
#' data("avs_raw_record")
#'
#' avs <- format_record(avs_raw_record, avs_raw_metadata)
#' avs
#'
#' avs <- format_record(avs_raw_core)
#' head(avs)
#'
#' avs <- format_record(avs_raw_core)
#' avs$atoi
#' as.numeric(avs$atoi)
#' avs[, `:=`(atoi_seconds = as.numeric(atoi),
#'            atoi_seconds_postseason = as.numeric(atoi_postseason),
#'            atoi = as.character(atoi),
#'            atoi_postseason = as.character(atoi_postseason))]
#' avs[, .SD, .SDcols = patterns("atoi")]
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

  if (!is.null(metadata) & !is.null(col_type)) {
    message("Ignoring metadata, using col_type")
  }

  if (!(inherits(x, "rcer_record") | inherits(x, "rcer_raw_record"))) {
    stop("format_record expects the `record` argument to be a `rcer_raw_record` or `rcer_record` object.")
  }

  if (inherits(x, "rcer_raw_record")) {
    x <- as.data.frame(x)
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
      x[[n]] <-
        eval(ct[[n]], envir = x)
    }
  }

  x
}

#' @export
format_record.rcer_record <- format_record.rcer_raw_record

