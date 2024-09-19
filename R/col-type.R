#' Column Types
#'
#' Define a type for each column of the records for a REDCap project based on
#' the metadata for the project.
#'
#' REDCap text fields for dates and times are formatted via lubridate
#'
#' \tabular{ll}{
#'   REDCap                \tab lubridate parsing function \cr
#'   --------------------- \tab -------------------------- \cr
#'   date_mdy              \tab \code{\link[lubridate]{mdy}} \cr
#'   date_dmy              \tab \code{\link[lubridate]{dmy}} \cr
#'   date_ymd              \tab \code{\link[lubridate]{ymd}} \cr
#'   datetime_dmy          \tab \code{\link[lubridate]{dmy_hm}} \cr
#'   datetime_mdy          \tab \code{\link[lubridate]{mdy_hm}} \cr
#'   datetime_ymd          \tab \code{\link[lubridate]{ymd_hm}} \cr
#'   datetime_seconds_dmy  \tab \code{\link[lubridate]{dmy_hms}} \cr
#'   datetime_seconds_mdy  \tab \code{\link[lubridate]{mdy_hms}} \cr
#'   datetime_seconds_ymd  \tab \code{\link[lubridate]{ymd_hms}} \cr
#'   time                  \tab \code{\link[lubridate]{hm}} \cr
#'   time_mm_ss            \tab \code{\link[lubridate]{ms}} \cr
#' }
#'
#' Other text files are coerced as
#' \tabular{ll}{
#'   REDCap                \tab R coercion \cr
#'   --------------------- \tab -------------------------- \cr
#'   number                \tab as.numeric   \cr
#'   number_1dp            \tab as.numeric   \cr
#'   number_2dp            \tab as.numeric   \cr
#'   integer               \tab as.integer   \cr
#'   ..default..           \tab as.character \cr
#' }
#'
#' Variables inputted into REDCap via radio button or dropdown lists (multiple
#' choice - pick one) are coerced to factors by default but can be returned as
#' characters if the argument \code{factors = FALSE} is set.
#'
#' Calculated and slider (visual analog scale) variables are coerced via
#' \code{as.numeric}.
#'
#' Yes/No and True/False variables are include as integer values 0 = No or
#' False, and 1 for Yes or True.
#'
#' Checkboxes are the most difficult to work with between the metadata and
#' records.  A checkbox field_name in the metadata could be, for example,
#' "eg_checkbox" and the columns in the records will be "eg_checkbox___<code>"
#' were "code" could be numbers, or character strings.  REDCapExporter attempts
#' to coerce the "eg_checkbox___<code>" columns to integer values, 0 = unchecked
#' and 1 = checked.
#'
#' @param x a \code{rcer_metadata} or \code{rcer_raw_metadata} object
#' @param factors If \code{TRUE} (default) then variables reported via drop-down
#' lists and radio buttons are set up to be \code{factor}s.  If \code{FALSE},
#' then the column type will be \code{character}.
#' @param lubridate_args a list of arguments passed to the date and time parsing
#' calls.  See Details.
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
col_type <- function(x, factors = TRUE, lubridate_args = list(quiet = TRUE, tz = NULL, locale = Sys.getlocale("LC_TIME"), truncated = 0), ...) {
  UseMethod("col_type")
}

#' @export
col_type.rcer_raw_metadata <- function(x, factors = TRUE, lubridate_args = list(quiet = TRUE, tz = NULL, locale = Sys.getlocale("LC_TIME"), truncated = 0), ...) {
  col_type(as.data.frame(x), factors = factors, lubridate_args = lubridate_args, ...)
}

#' @export
col_type.rcer_metadata <- function(x, factors = TRUE, lubridate_args = list(quiet = TRUE, tz = NULL, locale = Sys.getlocale("LC_TIME"), truncated = 0), ...) {

  if (is.null(lubridate_args$quiet)) {
    lubridate_args$quiet <- TRUE
  }
  if (is.null(lubridate_args$locale)) {
    lubridate_args$locale <- Sys.getlocale("LC_TIME")
  }
  if (is.null(lubridate_args$truncated)) {
    lubridate_args$truncated <- 0
  }

  ## Text Fields
  text_fields <-
    Map(function(nm, tp) {
          cl <-
            switch(tp,
                   number               = substitute(as.numeric(xx), list(xx = as.name(nm))),
                   number_1dp           = substitute(as.numeric(xx), list(xx = as.name(nm))),
                   number_2dp           = substitute(as.numeric(xx), list(xx = as.name(nm))),
                   integer              = substitute(as.integer(xx), list(xx = as.name(nm))),

                   date_mdy             = substitute(lubridate::ymd(xx, quiet = LAQ, tz = LATZ, locale = LALOCALE, truncated = LATRUNCTATED), list(xx = as.name(nm), LAQ = lubridate_args$quiet, LALOCALE = lubridate_args$locale, LATZ = lubridate_args$tz, LATRUNCTATED = lubridate_args$truncated)),
                   date_dmy             = substitute(lubridate::ymd(xx, quiet = LAQ, tz = LATZ, locale = LALOCALE, truncated = LATRUNCTATED), list(xx = as.name(nm), LAQ = lubridate_args$quiet, LALOCALE = lubridate_args$locale, LATZ = lubridate_args$tz, LATRUNCTATED = lubridate_args$truncated)),
                   date_ymd             = substitute(lubridate::ymd(xx, quiet = LAQ, tz = LATZ, locale = LALOCALE, truncated = LATRUNCTATED), list(xx = as.name(nm), LAQ = lubridate_args$quiet, LALOCALE = lubridate_args$locale, LATZ = lubridate_args$tz, LATRUNCTATED = lubridate_args$truncated)),

                   datetime_mdy         = substitute(lubridate::ymd_hm(xx, quiet = LAQ, tz = LATZ, locale = LALOCALE, truncated = LATRUNCTATED), list(xx = as.name(nm), LAQ = lubridate_args$quiet, LALOCALE = lubridate_args$locale, LATZ = lubridate_args$tz, LATRUNCTATED = lubridate_args$truncated)),
                   datetime_dmy         = substitute(lubridate::ymd_hm(xx, quiet = LAQ, tz = LATZ, locale = LALOCALE, truncated = LATRUNCTATED), list(xx = as.name(nm), LAQ = lubridate_args$quiet, LALOCALE = lubridate_args$locale, LATZ = lubridate_args$tz, LATRUNCTATED = lubridate_args$truncated)),
                   datetime_ymd         = substitute(lubridate::ymd_hm(xx, quiet = LAQ, tz = LATZ, locale = LALOCALE, truncated = LATRUNCTATED), list(xx = as.name(nm), LAQ = lubridate_args$quiet, LALOCALE = lubridate_args$locale, LATZ = lubridate_args$tz, LATRUNCTATED = lubridate_args$truncated)),

                   datetime_seconds_mdy = substitute(lubridate::ymd_hms(xx, quiet = LAQ, tz = LATZ, locale = LALOCALE, truncated = LATRUNCTATED), list(xx = as.name(nm), LAQ = lubridate_args$quiet, LALOCALE = lubridate_args$locale, LATZ = lubridate_args$tz, LATRUNCTATED = lubridate_args$truncated)),
                   datetime_seconds_dmy = substitute(lubridate::ymd_hms(xx, quiet = LAQ, tz = LATZ, locale = LALOCALE, truncated = LATRUNCTATED), list(xx = as.name(nm), LAQ = lubridate_args$quiet, LALOCALE = lubridate_args$locale, LATZ = lubridate_args$tz, LATRUNCTATED = lubridate_args$truncated)),
                   datetime_seconds_ymd = substitute(lubridate::ymd_hms(xx, quiet = LAQ, tz = LATZ, locale = LALOCALE, truncated = LATRUNCTATED), list(xx = as.name(nm), LAQ = lubridate_args$quiet, LALOCALE = lubridate_args$locale, LATZ = lubridate_args$tz, LATRUNCTATED = lubridate_args$truncated)),

                   time                 = substitute(lubridate::hm(ifelse(xx == "", NA_character_, xx)), list(xx = as.name(nm))),
                   time_mm_ss           = substitute(lubridate::ms(ifelse(xx == "", NA_character_, xx)), list(xx = as.name(nm))),
                                          substitute(as.character(xx), list(xx = as.name(nm)))
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
          lvls <- substring(sp, first = 1, last = regexpr(",", sp) - 1)
          lbls <- trimws(substring(sp, first = regexpr(",", sp) + 1, last = nchar(sp)))
          cl <- list(quote(factor),
                     x = as.name(nm),
                     levels = lvls,
                     labels = lbls)
          as.call(cl)
        },
        nm = x$field_name[x$field_type %in% c("radio", "dropdown")],
        choices = x$select_choices_or_calculations[x$field_type %in% c("radio", "dropdown")]
        )

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

  # checkboxes
  checkboxes <-
    Map(function(nm, choices) {
          sp <- strsplit(choices, split = " \\| ")[[1]]
          lvls <- sub("^(.+),\\s.+$", "\\1", sp)
          cls <- vector(mode = "list", length = length(lvls))
          for (i in seq_along(cls)) {
            cls[[i]] <- list()
            cls[[i]][[1]] <- quote(as.integer)
            cls[[i]][[2]] <- as.name(paste(nm, lvls[i], sep = "___"))
            cls[[i]] <- as.call(cls[[i]])
          }
          cls <- stats::setNames(cls, paste(nm, lvls, sep = "___"))
        },
        nm = x$field_name[x$field_type %in% c("checkbox")],
        choices = x$select_choices_or_calculations[x$field_type %in% c("checkbox")]
        )

  chbxnms <- unlist(lapply(checkboxes, names), recursive = TRUE, use.names = FALSE)
  checkboxes <- stats::setNames(unlist(checkboxes, recursive = FALSE), chbxnms)

  if (!factors) {
    mc_fields <-
      Map(function(xx) {
            cl <- list()
            cl[[1]] <- quote(as.character)
            cl[[2]] <- xx
            as.call(cl)
        },
        mc_fields)
    complete_fields <-
      Map(function(xx) {
            cl <- list()
            cl[[1]] <- quote(as.character)
            cl[[2]] <- xx
            as.call(cl)
        },
        complete_fields)
  }


  out <- c(text_fields, mc_fields, calc_fields, yn_fields, checkboxes, complete_fields)
  class(out) <- c("rcer_col_type", class(out))
  out
}

