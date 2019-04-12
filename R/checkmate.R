#' CheckMate
#'
#' Based on a visual basic macro, checkmate examines the metadata for a project
#' and reports back on possible protected health information and other data
#' quality issues.
#'
#' @param x a \code{rcer_metadata} or \code{rcer_raw_metadata} object.
#'
#' @export
checkmate <- function(x) {
  UseMethod("checkmate")
}

#' @export
checkmate.rcer_raw_metadata <- function(x) {
  checkmate(as.data.frame(x))
}

#' @export
checkmate.rcer_metadata <- function(x) {
}

# Check for Free From Text and report the
# Free Form Text:
free_form_text <- function(x) {

  all_text_fields  <- which(x$field_type == "text")
  free_text_fields <- which(x$field_type == "text" & x$text_validation_type_or_show_slider_number == "")

  list(all_text_fields = all_text_fields,
       free_text_fields = free_text_fields
       # message =
       #   sprintf("%s\\% of the fields in this study are free form text (Number of Text Fields: %d) If responses can be categorized, consider using a dropdown field type to reduce risk of data entry error and make the data easier to analyze."
       #           , qwraps2::frmt(length(free_text_fields) / nrow(x) * 100, 1),
       #           nrow(all_text_fields)
       #           )
  )
}

form_length <- function(x) {
  fields_per_form <- table(x[, 2])

  cat(crayon::blue(paste0(sum(fields_per_form > 30), ' of ', length(fields_per_form), " forms in this study have more than 30 fields.\n")))

  if (any(fields_per_form < 30)) {
    cat(crayon::bgRed("Consider creating shorter forms for better data entry."), "\n")
  }

}

possible_phi <- function(x) {

  x[, c(5, 8)]

  # when extending this character vector do so in all lower case and in
  # alphabetical order
  possible_phi_vars <-
    c(
      "account number",
      "address",
      "birth",
      "cell number",
      "cell phone",
      "city",
      "dob",
      "e-mail",
      "email",
      "fax",
      "health plan number",
      "insurance number",
      "medical record number",
      "mrn",
      "name",
      "pager",
      "phone",
      "phone",
      "postal code",
      "social security number",
      "ssn",
      "state",
      "street",
      "website",
      "zip"
    )

}






#
# Possible PHI
#

#
# PssblPHIFA
#

#
# Cnsstnt
# Ccltns
# AddrssLng
# SggstMinMax
# SggstMinMaxDate
# TxtVldtr
# LabVldtr
# CnsstntAll
# main
