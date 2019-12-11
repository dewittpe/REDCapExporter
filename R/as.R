#' as.*
#'
#' Coerce REDCapExporter objects to data.frame or data.table
#'
#' These functions are S3 methods for \code{\link{as.data.frame}} and
#' \code{\link[data.table]{as.data.table}}.
#'
#' @inheritParams base::as.data.frame
#' @inheritParams data.table::as.data.table
#'
#' @name as
NULL

#' @export
#' @rdname as
#' @method as.data.frame rcer_raw_metadata
as.data.frame.rcer_raw_metadata <- function(x, ...) {
  out <- read_text(x)
  class(out) <- c("rcer_metadata", class(out))
  out
}

#' @export
#' @rdname as
#' @method as.data.table rcer_raw_metadata
as.data.table.rcer_raw_metadata <- function(x, ...) {
  out <- data.table::as.data.table(as.data.frame(x))
  class(out) <- c("rcer_metadata", class(out))
  out
}


#' @export
#' @rdname as
#' @method as.data.frame rcer_raw_record
as.data.frame.rcer_raw_record <- function(x, ...) {
  out <- read_text(x)
  class(out) <- c("rcer_record", class(out))
  out
}

#' @export
#' @rdname as
#' @method as.data.table rcer_raw_record
as.data.table.rcer_raw_record <- function(x, ...) {
  out <- data.table::as.data.table(as.data.frame(x, ...))
  class(out) <- c("rcer_record", class(out))
  out
}

#' @export
#' @rdname as
#' @method as.data.frame rcer_raw_project
as.data.frame.rcer_raw_project <- function(x, ...) {
  out <- read_text(x)
  class(out) <- c("rcer_project_info", class(out))
  out
}

#' @export
#' @rdname as
#' @method as.data.table rcer_raw_project
as.data.table.rcer_raw_project <- function(x, ...) {
  out <- data.table::as.data.table(as.data.frame(x, ...))
  class(out) <- c("rcer_project_info", class(out))
  out
}

#' @export
#' @rdname as
#' @method as.data.frame rcer_raw_user
as.data.frame.rcer_raw_user <- function(x, ...) {
  out <- read_text(x)
  class(out) <- c("rcer_user", class(out))
  out
}

#' @export
#' @rdname as
#' @method as.data.table rcer_raw_user
as.data.table.rcer_raw_user <- function(x, ...) {
  out <- data.table::as.data.table(as.data.frame(x, ...))
  class(out) <- c("rcer_user", class(out))
  out
}


#' Read Text
#'
#' Read raw REDCap API return.  Built to parse csv or json.
#'
#' This is a non-exported function and not expected to be called by the end
#' user.
#'
#' @param x the raw return from the API call to REDCap
#' @return a \code{data.frame}
#'
read_text <- function(x) {
  if (attr(x, "Content-Type")[1] == "text/csv") {
    out <- utils::read.csv(text = x, colClasses = "character")
  } else if (attr(x, "Content-Type")[1] == "application/json") {
    out <- rjson::fromJSON(json_str = x)
    out <- lapply(out, as.data.frame, stringsAsFactors = FALSE)
    out <- do.call(rbind, out)
  } else {
    stop(sprintf("Content-Type %s is not yet supported.",
                 attr(x, "Content-Type")[1]))
  }
  out
}
