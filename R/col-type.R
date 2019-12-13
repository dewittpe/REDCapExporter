#' Column Types
#'
#' Define a type for each column of the records for a REDCap project based on
#' the metadata for the project.
#'
#' @param x a \code{rcer_metadata} or \code{rcer_raw_metadata} object
#' @param factors If \code{TRUE} (default) then variables inputed via drop-down
#' lists and radio buttons are set up to be \code{factor}s.  If \code{FALSE},
#' then the column type will be \code{character}.
#' @param ... not currently used
#'
#' @return a \code{rcer_col_type} object
#'
#' @examples
#'
#' data("avs_raw_metadata")
#' col_type(avs_raw_metadata)
#'
#' @export
col_type <- function(x, factors = TRUE, ...) {
  UseMethod("col_type")
}

#' @export
col_type.rcer_raw_metadata <- function(x, factors = TRUE, ...) {
  col_type(as.data.frame(x), factors = factors, ...)
}

#' @export
col_type.rcer_metadata <- function(x, factors = TRUE, ...) {

  # Field Types:
  #   text box
  #     validation:
  #       None
  #       Date (D-M-Y)
  #       Date (M-D-Y)
  #       Date (Y-M-D)
  #       Datetime (D-M-Y-H:M)
  #       Datetime (M-D-Y H:M)
  #       DateTime (Y-M-D H:M)
  #       Datetime w/ seconds (D-M-Y-H:M:S)
  #       Datetime w/ seconds (M-D-Y H:M:S)
  #       DateTime w/ seconds (Y-M-D H:M:S)
  #       Email
  #       Integer
  #       Letters Only
  #       Number
  #       Number (1 decimal place)
  #       Number (2 decimal places)
  #       Phone (North America)
  #       Postal Code (Canada)
  #       Social Security Number (US)
  #       Time (HH:MM)
  #       Zip Code (US)
  #   notes box
  #   calculated field
  #   multiple choice - drop-down list (single answer)
  #   multiple choice - radio buttons (signle answer)
  #   checkboxes (multiple answers)
  #   yes - no
  #   true - false
  #   silder / visual analog scale
  #   file upload
  #   descriptive text


  ## Text Fields
  text_fields <-
    Map(function(nm, tp) {
          cl <- list()
          cl[[1]] <-
            switch(tp,
                   number   = quote(as.numeric),  #sprintf("as.numeric(%s)", nm),
                   integer  = quote(as.integer),  #sprintf("as.integer(%s)", nm),
                   date_mdy = quote(lubridate::ymd), # **WHY?** It appears exported dates are ymd format?  Verify
                   date_dmy = quote(lubridate::ymd), # **WHY?** It appears exported dates are ymd format?  Verify
                   date_ymd = quote(lubridate::ymd), # **WHY?** It appears exported dates are ymd format?  Verify
                              quote(as.character) #sprintf("as.character(%s)", nm)
                   )
          cl[[2]] <- as.name(nm)
          cl
          },
        nm = x$field_name[x$field_type == "text"],
        tp = x$text_validation_type_or_show_slider_number[x$field_type == "text"])

  text_fields <- lapply(text_fields, as.call)


  ## Multiple Choice
  mc_fields <-
    Map(function(nm, choices) {
          sp <- strsplit(choices, split = " \\| ")
          sp <- lapply(sp, strsplit, split = ", ")
          sp <- lapply(sp, function(xx) do.call(rbind, xx))
          sp <- lapply(sp, function(xx) list(lvls = xx[, 1], lbls = xx[, 2]))
          cl <- list(quote(factor),
                     x = as.name(nm),
                     levels = sp[[1]]$lvls,
                     labels = sp[[1]]$lbls)
          as.call(cl)
        },
        nm = x$field_name[x$field_type %in% c("radio", "dropdown")],
        choices = x$select_choices_or_calculations[x$field_type %in% c("radio", "dropdown")]
        )

  if (!factors) {
    mc_fields <-
      Map(function(xx) {
            cl <- list()
            cl[[1]] <- quote(as.character)
            cl[[2]] <- xx
            as.call(cl)
          },
          mc_fields)
  }

  # calc fields
  calc_fields <-
    Map(function(nm) {
           cl <- list()
           cl[[1]] <- quote(as.numeric)
           cl[[2]] <- as.name(nm)
           as.call(cl)
        },
        nm = x$field_name[x$field_type %in% "calc"])

  # yes/no
  yn_fields <-
    Map(function(nm) {
             cl <- list()
             cl[[1]] <- quote(as.integer)
             cl[[2]] <- as.name(nm)
             as.call(cl)
           },
    nm = x$field_name[x$field_type %in% "yesno"])


  out <- c(text_fields, mc_fields, calc_fields, yn_fields)[x$field_name]
  class(out) <- c("rcer_col_type", class(out))
  out
}

