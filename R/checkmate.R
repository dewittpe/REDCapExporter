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

check_for_phi <- function(x) {
  UseMethod('check_for_phi')
}

check_for_phi.rcer_metadata <- function(x) {

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

