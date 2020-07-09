#' Format Record
#'
#' Use REDCap project metadata to build a well formatted \code{data.frame} for
#' the record.
#'
#' @param x a \code{rcer_rccore}, \code{rcer_raw_record}, or \code{rcer_record} object.
#' @param metadata a \code{rcer_metadata} or \code{rcer_raw_metadata} object.
#' Will be ignored if \code{col_type} is defined.
#' @param col_type a \code{rcer_col_type} object.
#' @param class return either a \code{data.frame} or \code{data.table}
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
#' avs <- format_record(avs_raw_record, avs_raw_metadata, class = "data.frame")
#' avs
#'
#' avs <- format_record(avs_raw_core, class = "data.frame")
#' head(avs)
#'
#' avs <- format_record(avs_raw_core, class = "data.table")
#' avs$atoi
#' as.numeric(avs$atoi)
#' avs[, `:=`(atoi_seconds = as.numeric(atoi),
#'            atoi_seconds_postseason = as.numeric(atoi_postseason),
#'            atoi = as.character(atoi),
#'            atoi_postseason = as.character(atoi_postseason))]
#' avs[, .SD, .SDcols = patterns("atoi")]
#'
#' @export
format_record <- function(x, metadata = NULL, col_type = NULL, class = "data.table", ...) {
  UseMethod("format_record")
}

#' @export
format_record.rcer_rccore <- function(x, metadata = NULL, col_type = NULL, class = "data.table", ...) {
  format_record(x = x$record_raw, metadata = x$metadata_raw, col_type = col_type, class = class, ...)
}

#' @export
format_record.rcer_raw_record <- function(x, metadata = NULL, col_type = NULL, class = "data.table", ...) {

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
      x[[n]] <- eval(ct[[n]], envir = x)
    }
  }

  # set the columns in the record corresponding to checkboxes as integer values
  for (n in metadata$field_name[metadata$field_type == "checkbox"]) {
    for(nn in grep(paste0(n, "___\\d+"), names(x))) {
      x[[nn]] <- as.integer(x[[nn]])
    }
  }


  if (inherits(x, "data.table") | class == "data.table") {
    x <- as.data.table(x)

    # check for S4 classes in the columns and provide a warning to the user
    S4cols <- Filter(isTRUE, sapply(x, isS4))
    if (length(S4cols)) {
      warning(paste0("At least one of the columns is an S4 class."
                     , "\n  data.table might not work correctly for\n  "
                     , paste(names(S4cols), collapse = ", ")
                     , "\n  check status of https://github.com/Rdatatable/data.table/issues/4315"
                     , "\n  and https://github.com/dewittpe/REDCapExporter/issues/17"
              ))
    }

  }

  x
}

#' @export
format_record.rcer_record <- format_record.rcer_raw_record

