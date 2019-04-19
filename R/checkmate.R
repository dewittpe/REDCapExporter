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

  cat(crayon::blue(paste0(qwraps2::frmt(length(free_text_fields) / nrow(x) * 100, 1), "% of field are free text.")),
      crayon::blue("If responses can be categorized, consider using a dropdown field type to reduce risk of data entry error and make the data easier to analyze."),
      sep = "\n")

  invisible( x[free_text_fields, ] )

}

form_length <- function(x) {
  fields_per_form <- table(x[, 2])

  cat(crayon::blue(paste0(sum(fields_per_form > 30), ' of ', length(fields_per_form), " forms in this study have more than 30 fields.\n")))

  if (any(fields_per_form > 30)) {
    cat(crayon::bgRed("Consider creating shorter forms for better data entry."), "\n")
  }

  invisible(fields_per_form)

}

possible_phi <- function(x) {

  # when extending this character vector do so in all lower case and in
  # alphabetical order
  field_label_phi <-
    c(
      "account number", "address", "birth", "cell number", "cell phone", "city",
      "dob", "e-mail", "email", "fax", "health plan number", "insurance number",
      "medical record number", "mrn", "name", "pager", "phone", "phone",
      "postal code", "social security number", "ssn", "state", "street",
      "website", "zip"
    )
  text_validator_phi <- c("email", "phone", "ssn", "postal", "zipcode")
  field_annotation_phi <- c("latitude", "longitude", "default")

  x[, c(5, 8, 11, 18)]

  field_label_tests      <- lapply(field_label_phi,    grepl, x = x$field_label, ignore.case = TRUE)
  text_validator_tests   <- lapply(text_validator_phi, grepl, x = x$text_validation_type_or_show_slider_number, ignore.case = TRUE)
  field_annotation_tests <- lapply(field_annotation_phi, grepl, x = x$field_annotation, ignore.case = TRUE)

  field_label_tests      <- Filter(any, stats::setNames(field_label_tests, paste0("fld_lbl_phi_", field_label_phi)))
  text_validator_tests   <- Filter(any, stats::setNames(text_validator_tests, paste0("txt_vld_phi_", text_validator_phi)))
  field_annotation_tests <- Filter(any, stats::setNames(field_annotation_tests, paste0("fld_ann_phi_", field_annotation_phi)))

  rtn <- cbind(x[, c(5, 8, 11, 18)],
               as.data.frame(field_label_tests),
               as.data.frame(text_validator_tests),
               as.data.frame(field_annotation_tests))[apply(do.call(cbind, c(field_label_tests, text_validator_tests, field_annotation_tests)), 1, any) , ]

  if (all(rtn$identifier == "y")) {
    cat(crayon::blue("All detected possible PHI has been marked as `identifier`."), "\n")
  } else {
    cat(crayon::bgRed("Not all detected possible PHI has been marked as `identifier`."), "\n")
  }

  invisible(rtn)

}


# Cnsstnt(wordCheck) .... I'm not sure what this is doing, see line 235 of
# inst/checkMate/Module1.bas
consistancy <- function(x) {
  x[, 5]
}


#
# Ccltns ... I'm not sure what this is doing, see line 288 of
# inst/checkMate/Module1.bas


# AddrssLng ...
address_long <- function(x) {

  long_address <-
    apply(
          matrix(c(grepl("street", x$field_label, ignore.case = TRUE),
                   grepl("city",   x$field_label, ignore.case = TRUE),
                   grepl("state",  x$field_label, ignore.case = TRUE),
                   grepl("zip",    x$field_label, ignore.case = TRUE)),
                 ncol = 4),
          1, any)

  if (long_address) {
    cat(crayon::bgRed("Break out the street, city, state, zip suggested by vanderbilt"), "\n")
  }

}

# SggstMinMax
suggest_min_max <- function(x) {
  x[, c(8, 9, 10)]

  out <- x[grepl("number|integer|date_", x$text_validation_type_or_show_slider_number), c(1,2,5,8,9,10)]
  out <- out[out$text_validation_min == "" | out$text_validation_max == "", ]

  if (nrow(out)) {
    cat(crayon::blue("There are fields validated as integer, number, or date which do not have min or max values set.", "\n"))
  } else {
    cat(crayon::blue("All integer, number, and date fields are have min and max values set."), "\n")
  }

  invisible(out)
}

# SggstMinMaxDate
# TxtVldtr
# LabVldtr
# CnsstntAll
# main
