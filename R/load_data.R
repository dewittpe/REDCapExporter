#' Format Records
#'
#' Use REDCap project metadata to build a well formatted \code{data.frame} for
#' the record.
#'
#' @param metadata a \code{rcer_metadata} or \code{rcer_raw_metadata} object.
#' @param record   a \code{rcer_raw_record} object.
#' @param ... other arguments passed to \code{\link{col_type}}
#'
#' @return A \code{data.frame}
#'
#' @export
format_record <- function(metadata, record, ...) {
  
  if (!(inherits(metadata, "rcer_metadata") | inherits(metadata, "rcer_raw_metadata"))) {
    stop("format_record expects the `metadata` argument to be a `rcer_raw_metadata` or `rcer_metadata` object.")
  }

  if (!(inherits(record, "rcer_record") | inherits(record, "rcer_raw_record"))) {
    stop("format_record expects the `record` argument to be a `rcer_raw_record` or `rcer_record` object.") 
  }

  if (inherits(metadata, "rcer_raw_metadata")) {
    metadata <- as.data.frame(metadata)
  }
  
  if (inherits(record, "rcer_raw_record")) {
    record <- as.data.frame(record)
  }

  ct <- col_type(metadata, ...)

  as.data.frame(lapply(ct, function(x) {eval(x, envir = record)}), stringsAsFactors = FALSE)
}


