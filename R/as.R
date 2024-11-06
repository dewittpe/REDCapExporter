#' as.*
#'
#' Coerce REDCapExporter objects to data.frame.
#'
#' These functions are S3 methods for \code{\link{as.data.frame}} for the raw
#' exports from the REDCap API.
#'
#' @inheritParams base::as.data.frame
#'
#' @examples
#'
#' data("avs_raw_record")
#'
#' avs_record <- as.data.frame(avs_raw_record)
#'
#' str(avs_record)
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
#' @method as.data.frame rcer_raw_record
as.data.frame.rcer_raw_record <- function(x, ...) {
  out <- read_text(x)
  class(out) <- c("rcer_record", class(out))
  out
}

#' @export
#' @rdname as
#' @method as.data.frame rcer_raw_project
as.data.frame.rcer_raw_project <- function(x, ...) {
  out <- read_text(x)
  class(out) <- c("rcer_project", class(out))
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

#' Read Text
#'
#' Read raw REDCap API return.  Built to parse csv or json.
#'
#' This is a non-exported function and not expected to be called by the end
#' user.  Used by the \code{as.data.frame} methods.
#'
#' @param x the raw return from the API call to REDCap
#' @return a \code{data.frame}
#'
read_text <- function(x) {
  if (grepl("text/csv", attr(x, "Content-Type")[1])) {
    out <- utils::read.csv(text = x, colClasses = "character")

    if ("forms_export" %in% names(out)) {
      # the following is great for R 4.2 or newer, need to make this work for older versions of R too.
      #f <-
      #  strsplit(out[["forms"]], ",") |>
      #  lapply(strsplit, ":") |>
      #  lapply(lapply, function(x) stats::setNames(data.frame(x[2]), x[1])) |>
      #  lapply(as.data.frame) |>
      #  do.call(rbind, args = _)
      f <- strsplit(out[["forms"]], ",")
      f <- lapply(f, strsplit, ":")
      f <- lapply(f, lapply, function(x) stats::setNames(data.frame(x[2]), x[1]))
      f <- lapply(f, as.data.frame)
      f <- do.call(rbind, args = f)
      names(f) <- paste0("forms.", names(f))

      #fe <-
      #  strsplit(out[["forms_export"]], ",") |>
      #  lapply(strsplit, ":") |>
      #  lapply(lapply, function(x) stats::setNames(data.frame(x[2]), x[1])) |>
      #  lapply(as.data.frame) |>
      #  do.call(rbind, args = _)
      fe <- strsplit(out[["forms_export"]], ",")
      fe <- lapply(fe, strsplit, ":")
      fe <- lapply(fe, lapply, function(x) stats::setNames(data.frame(x[2]), x[1]))
      fe <- lapply(fe, as.data.frame)
      fe <- do.call(rbind, args = fe)
      names(fe) <- paste0("forms_export.", names(fe))

      out[["forms"]] <- NULL
      out[["forms_export"]] <- NULL
      out <- cbind(out, f, fe)

    }

  } else if (grepl("application/json", attr(x, "Content-Type")[1])) {
    out <- rjson::fromJSON(json_str = x, simplify = FALSE)
    if (is.list(out[[1]])) {
      out <- lapply(out, as.data.frame, stringsAsFactors = FALSE)
      out <- do.call(rbind, out)
    } else {
      out <- as.data.frame(out, stringsAsFactors = FALSE)
    }
    out <- as.data.frame(lapply(out, as.character))
  } else {
    stop(sprintf("Content-Type '%s' is not yet supported.",
                 attr(x, "Content-Type")[1]))
  }

  out
}
