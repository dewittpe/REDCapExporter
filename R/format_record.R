#' Format Record
#'
#' Use REDCap project metadata to build a well formatted \code{data.frame} for
#' the record.
#'
#' @param record   a \code{rcer_raw_record} object.
#' @param metadata a \code{rcer_metadata} or \code{rcer_raw_metadata} object.
#' Will be ignored if \code{col_type} is defined.
#' @param col_type a \code{rcer_col_type} object.
#' @param class return either a \code{data.frame} or \code{data.table}
#' @param ... other arguments passed to \code{\link{col_type}}
#'
#' @return A \code{data.frame} or \code{data.table}
#'
#' @examples
#'
#' data("avs_raw_metadata")
#' data("avs_raw_record")
#'
#' avs <- format_record(avs_raw_record, avs_raw_metadata)
#'
#' @export
format_record <- function(record, metadata = NULL, col_type = NULL, class = "data.table", ...) {

  if (!is.null(metadata) & !is.null(col_type)) {
    message("Ignoring metadata, using col_type")
  }

  if (!(inherits(record, "rcer_record") | inherits(record, "rcer_raw_record"))) {
    stop("format_record expects the `record` argument to be a `rcer_raw_record` or `rcer_record` object.")
  }

  if (inherits(record, "rcer_raw_record")) {
    record <- as.data.frame(record)
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
    if (n %in% names(record)) {
      record[[n]] <- eval(ct[[n]], envir = record)
    }
  }

  # set the columns in the record corresponding to checkboxes as integer values
  for (n in metadata$field_name[metadata$field_type == "checkbox"]) {
    for(nn in grep(paste0(n, "___\\d+"), names(record))) {
      record[[nn]] <- as.integer(record[[nn]])
    }
  }


  if (inherits(record, "data.table") | class == "data.table") {
    record <- as.data.table(record)
  }

  record
}


