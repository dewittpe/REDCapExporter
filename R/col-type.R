#' Column Types
#'
#' Define a type for each column of the records for a REDCap project based on
#' the metadata for the project.
#'
#' @export
col_type <- function(x, ...) {
  UseMethod("col_type")
}

#' @export
col_type.rcer_metadata <- function(x, ...) {

  # part1 <-
  #   lapply(x$text_validation_type_or_show_slider_number,
  #          switch,
  #          number = "numeric",
  #          integer = "integer",
  #          date_ymd = "character",
  #          "character") %>%
  #   setNames(x$field_name) %>%
  #   do.call(c, .)
  # 
  # part2 <-
  #   with(x[field_type %in% c("radio", "dropdown")],
  #        {
  #          strsplit(select_choices_or_calculations, split = " \\| ") %>%
  #            lapply(strsplit, split = ", ") %>%
  #            lapply(function(x) {do.call(rbind, x)}) %>%
  #            lapply(function(x) list(lvls = x[, 1], lbls = x[, 2])) %>%
  #            setNames(field_name)
  #        })
  # 
  # list(part1, part2)

  cat("hellow world")
}
