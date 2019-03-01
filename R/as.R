#' @export
#' @method as.data.frame rcer_raw_metadata
as.data.frame.rcer_raw_metadata <- function(x, ...) {
  out <- read_text(x)
  class(out) <- c("rcer_metadata", class(out))
  out
}

#' @export
#' @method as.data.table rcer_raw_metadata
as.data.table.rcer_raw_metadata <- function(x, ...) {
  out <- data.table::as.data.table(as.data.frame(x))
  class(out) <- c("rcer_metadata", class(out))
  out
}


#' @export
#' @method as.data.frame rcer_raw_record
as.data.frame.rcer_raw_record <- function(x, ...) {
  out <- read_text(x)
  class(out) <- c("rcer_record", class(out))
  out
}

#' @export
#' @method as.data.table rcer_raw_record
as.data.table.rcer_raw_record <- function(x, ...) {
  out <- data.table::as.data.table(as.data.frame(x, ...))
  class(out) <- c("rcer_record", class(out))
  out
}

#' @export
#' @method as.data.frame rcer_raw_project_info
as.data.frame.rcer_raw_project_info <- function(x, ...) {
  out <- read_text(x)
  class(out) <- c("rcer_project_info", class(out))
  out
}

#' @export
#' @method as.data.table rcer_raw_project_info
as.data.table.rcer_raw_project_info <- function(x, ...) {
  out <- data.table::as.data.table(as.data.frame(x, ...))
  class(out) <- c("rcer_project_info", class(out))
  out
}


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
