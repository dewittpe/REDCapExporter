#' Column Types
#'
#' Define a type for each column of the records for a REDCap project based on
#' the metadata for the project.
#'
#' @param x a \code{rcer_metadata} or \code{rcer_raw_metadata} object
#' @param factors If \code{TRUE} (default) then variables reported via drop-down
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

  ## Text Fields
  text_fields <-
    Map(function(nm, tp) {
          cl <-
            switch(tp,
                   number               = substitute(as.numeric(xx),                       list(xx = as.name(nm))),
                   number_1dp           = substitute(as.numeric(xx),                       list(xx = as.name(nm))),
                   number_2dp           = substitute(as.numeric(xx),                       list(xx = as.name(nm))),
                   integer              = substitute(as.integer(xx),                       list(xx = as.name(nm))),
                   date_mdy             = substitute(lubridate::ymd(xx,     quiet = TRUE), list(xx = as.name(nm))),
                   date_dmy             = substitute(lubridate::ymd(xx,     quiet = TRUE), list(xx = as.name(nm))),
                   date_ymd             = substitute(lubridate::ymd(xx,     quiet = TRUE), list(xx = as.name(nm))),
                   datetime_dmy         = substitute(lubridate::ymd_hm(xx,  quiet = TRUE), list(xx = as.name(nm))),
                   datetime_mdy         = substitute(lubridate::ymd_hm(xx,  quiet = TRUE), list(xx = as.name(nm))),
                   datetime_ymd         = substitute(lubridate::ymd_hm(xx,  quiet = TRUE), list(xx = as.name(nm))),
                   datetime_seconds_dmy = substitute(lubridate::ymd_hms(xx, quiet = TRUE), list(xx = as.name(nm))),
                   datetime_seconds_mdy = substitute(lubridate::ymd_hms(xx, quiet = TRUE), list(xx = as.name(nm))),
                   datetime_seconds_ymd = substitute(lubridate::ymd_hms(xx, quiet = TRUE), list(xx = as.name(nm))),
                   time                 = substitute(lubridate::hm(xx,      quiet = TRUE), list(xx = as.name(nm))),
                   time_mm_ss           = substitute(lubridate::ms(xx,      quiet = TRUE), list(xx = as.name(nm))),
                                          substitute(as.character(xx),                     list(xx = as.name(nm)))
            )
          cl
          },
        nm = x$field_name[x$field_type %in% c("notes", "text")],
        tp = x$text_validation_type_or_show_slider_number[x$field_type %in% c("notes", "text")])

  text_fields <- lapply(text_fields, as.call)


  ## Multiple Choice
  mc_fields <-
    Map(function(nm, choices) {
          sp <- strsplit(choices, split = " \\| ")[[1]]
          lvls <- sub("^(\\d),\\s.+$", "\\1", sp)
          lbls <- sub("^\\d,\\s(.+)$", "\\1", sp)
          cl <- list(quote(factor),
                     x = as.name(nm),
                     levels = lvls,#sp[[1]]$lvls,
                     labels = lbls)#sp[[1]]$lbls)
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

  # calc fields and slider (visual analog scale)
  calc_fields <-
    Map(function(nm) {
           cl <- list()
           cl[[1]] <- quote(as.numeric)
           cl[[2]] <- as.name(nm)
           as.call(cl)
        },
        nm = x$field_name[x$field_type %in% c("calc", "slider")])

  # yes/no and true/false
  yn_fields <-
    Map(function(nm) {
             cl <- list()
             cl[[1]] <- quote(as.integer)
             cl[[2]] <- as.name(nm)
             as.call(cl)
           },
    nm = x$field_name[x$field_type %in% c("yesno", "truefalse")])

  # tools for showing that a form is complete
  complete_fields <-
    Map(function(nm) {
          cl <- list()
          cl[[1]] <- quote(factor)
          cl[[2]] <- as.name(nm)
          cl[['levels']] <- c(0, 1, 2)
          cl[['labels']] <- c("Incomplete", "Unverified", "Complete")
          as.call(cl)
    },
    nm = paste(unique(x$form_name), "complete", sep = "_")
    )

  # set the order of the types to match the order of the field names
  # check boxes are omitted as well as there is likely more than one column in
  # the records object.  See `format_record`
  rdr <- x$field_name[!(x$field_type %in% c("checkbox", "descriptive", "file"))]


  out <- c(text_fields, mc_fields, calc_fields, yn_fields)[rdr]
  out <- c(out, complete_fields)
  class(out) <- c("rcer_col_type", class(out))
  out
}

