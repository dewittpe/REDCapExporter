#'---
#'title: "Formatting Data Exported from REDCap"
#'output:
#'  rmarkdown::html_vignette:
#'    toc: true
#'    number_sections: false
#'vignette: >
#'  %\VignetteIndexEntry{Formatting Data Exported from REDCap}
#'  %\VignetteEngine{knitr::rmarkdown}
#'  %\VignetteEncoding{UTF-8}
#'---
#'
#+ label = "setup", include = FALSE
knitr::opts_chunk$set(collapse = TRUE)

#'
#' This vignette covers different methods for formatting the records from REDCap
#' into an analysis ready data set.  It is assumed that the reader is familiar
#' with the process for exporting data from REDCap to R as described in
{{ qwraps2::backtick(vignette("api", package = "REDCapExporter")) }}
#'
#' For the purposes of this vignette we will use the example data sets provided
#' in the package from the 2000-2001 National Hockey League Stanley Cup Champion
#' Colorado Avalanche.  The data was transcribed from [Hockey
#' Reference](https://www.hockey-reference.com/teams/COL/2001.html) into a
#' REDCap Project hosed at the University of Colorado Denver.
#'
#' The data sets we will work with in this vignette are:
#+ label = "namespace", eval = TRUE, results = "hide"
#/*
devtools::load_all() # load the dev version while editing
#*/
library(REDCapExporter)
avs_raw_core      # object returned from export_core(format = "csv")
avs_raw_metadata  # object returned from export_content(content = "metadata", format = "csv")
avs_raw_record    # object returned from export_content(content = "record", format = "csv")

#'
#' There are two conceptual formatting tools provided by REDCapExporter:
#'
#' 1.
{{ qwraps2::backtick(as.data.frame) }}
#'
#' 2.
{{ qwraps2::backtick(format_record) }}

#'
#' # Coercion to data.frame
#'
#' The object returned from
{{ qwraps2::backtick(export_content) }}
#' is a string in either csv or json format.  To have that information as a
#' data.frame call
{{ paste0(qwraps2::backtick(as.data.frame), ".")}}
#'
#' This method works for the metadata and records directly.
#'
#+ echo = TRUE, results = "markup"
avs_metadata_DF <- as.data.frame(avs_raw_metadata)
avs_record_DF   <- as.data.frame(avs_raw_record)

#'
#' For
{{ qwraps2::backtick(rcer_rccore) }}
#' objects returned by
{{ qwraps2::backtick(export_core) }}
#' all the elements can be coerced to data.frames via
{{ qwraps2::backtick(lapply) }}
#+ echo = TRUE, results = "markup"
avs_core_DFs  <- lapply(avs_raw_core, as.data.frame)

#'
#' The behavior of
{{ qwraps2::backtick(as.data.frame) }}
#' for these objects is to return a data.frame with all character columns.
#+ echo = TRUE, results = 'markup'
avs_metadata_DF |> sapply(class) |> sapply(is.character) |> all()
avs_record_DF   |> sapply(class) |> sapply(is.character) |> all()

#'
#' Obviously, this is not ideal for analysis.  It does give the user a known
#' starting point for formatting the records explicitly.  However,
#' REDCapExporter provides the
{{ qwraps2::backtick(format_record) }}
#' method to simplify this task by using the metadata from the REDCap project.
#'
#' # format_record
#'
{{ qwraps2::backtick(format_record) }}
#' uses the metadata to inform the storage mode of the elements of a data.frame.
#' For example, after exporting the core of a REDCap project we can build a
#' data.frame
{{ qwraps2::backtick(avsDF) }}
#' via
#+ echo = TRUE, results = "markup"
avsDF <- format_record(avs_raw_core)
str(avsDF, max.level = 0)

#'
#' Note: the above uses the core export from REDCap.  You can use just the
#' record and metadata to get the same result:
#+ echo = TRUE, result = "markup"
identical(
  format_record(avs_raw_core),
  format_record(avs_raw_record, avs_raw_metadata)
)

#'
#' Let's look at the
{{ qwraps2::backtick(avsDF) }}
#' object (presented as a nice human readable table)
#'
#+ echo = FALSE, results = "asis"
avsDF |>
  kableExtra::kbl(format = "html", row.names = FALSE) |>
  kableExtra::kable_styling(bootstrap_options = c("striped", "hover"),
                            fixed_thead = TRUE) |>
  kableExtra::scroll_box(height = "200px", width = "700px")

#'
#' Now, consider the classes of the columns.  Start by looking at
#' a few columns which look like they are numeric values, record_id,
#' uniform_number, height, and points.
#+ echo = TRUE, results = "markup"
cols <- c("record_id", "uniform_number", "height", "points")
head(avsDF[, cols], n = 3)
sapply(avsDF[, cols], class)

#'
#' Why are record_id and uniform_number, stored as characters whereas height and
#' points (sum of goals scored and assists) integer and numeric values
#' respectively?  The answer is in the metadata.
#'
#+ echo = TRUE, results = "hide"
avs_metadata_DF[avs_metadata_DF$field_name %in% cols, ]

#'
#+ echo = FALSE, results = "asis"
avs_metadata_DF[avs_metadata_DF$field_name %in% cols, ] |>
  kableExtra::kbl(format = "html", row.names = FALSE) |>
  kableExtra::kable_styling(bootstrap_options = c("striped", "hover"),
                            fixed_thead = TRUE) |>
  kableExtra::scroll_box(height = "200px", width = "700px")

#'
#' Notice that for the record_id and uniform_number the field_type is "text"
#' with no value for "select_choices_or_calculations" and no value for
#' "text_validation_type_or_show_slider_number".  This is interpreted, then, as
#' just a text field and should be character vector in the data.frame.
#' Obviously the user could coerce to integer of numeric is desired and if
#' appropriate.
#'
#' For height, note that the field_type is "text" and the
#' "text_validation_type_or_show_slider_number" is "integer", hence the coercion
#' from the raw data to integer when building the data.frame.  Lastly, the
#' points are a calculated field and set to numeric.
#'
#' REDCapExporter attempts to make reasonable assumptions for the data types
#' base on the metadata.  For example, dates in REDCap can by entered and
#' validated in Year-Month-Day, Month-Day-Year, and Day-Month-Year formats.  The
#' raw data is all in Year-Month-Day format.
#+ label = "date_metadata", echo = FALSE, results = "asis"
avs_metadata_DF[
  avs_metadata_DF$field_name %in% c('birthdate', 'first_nhl_game', 'last_nhl_game'),
  c("field_name", "field_type", "field_label", "field_note", "text_validation_type_or_show_slider_number")
  ] |>
  kableExtra::kbl(format = "html", row.names = FALSE) |>
  kableExtra::kable_styling(bootstrap_options = c("striped", "hover"),
                            fixed_thead = TRUE) |>
  kableExtra::scroll_box(height = "200px", width = "700px")

#'
#' The coercion that will be used when calling
{{ qwraps2::backtick(format_record) }}
#' is defined by an implicit call to
{{ qwraps2::backtick(col_type) }}
#' which uses the metadata, in raw or formatted form, to determine the
#' coercion.
#'
identical(col_type(avs_raw_metadata), col_type(avs_metadata_DF))
ct <- col_type(avs_metadata_DF)

#'
#' Each of the elements of
{{ qwraps2::backtick(ct) }}
#' are applied to the column of the data frame with the same name.
#' Examples:  The record_id is to be a character string by default.
ct[["record_id"]]
#'
#' If the user would prefer the record_id to be an integer we can modify
{{ qwraps2::backtick(ct) }}
#' and apply it explicitly when calling
{{ paste0(qwraps2::backtick(format_record), ".") }}
#'
#+ echo = TRUE, results = "markup"
ct[["record_id"]] |> str()
ct[["record_id"]] <- expression(as.integer(record_id))
avsDF2 <- format_record(avs_raw_core, col_type = ct)

#'
#' Two notes to make here, first, we can see that the storage mode
#' is different between
{{ qwraps2::backtick(avsDF$record_id) }}
#' and
{{ paste0(qwraps2::backtick(avsDF2$record_id), ".") }}
#+ echo = TRUE, results = "markup"
class(avsDF$record_id)
class(avsDF2$record_id)

#'
#' Second, there is a message (not a warning), that the metadata that is part of
#' the
{{ qwraps2::backtick(avs_raw_core) }}
#' object, is not being used to define the column types.
#'
#' If you want to suppress that message you can use
#+ echo = TRUE, results = "hide"
suppressMessages(format_record(avs_raw_core, col_type = ct))

#'
#' or use the records as the object passed to
{{ qwraps2::backtick(format_record) }}
#+ echo = TRUE, results = "hide"
format_record(avs_record_DF, col_type = ct)

#'
#' By default, variables recorded in REDCap via radio buttons or dropdown lists
#' are formatted as factors.  For example, the position of the player is a
#' factor.
class(avsDF$position)
summary(avsDF$position)

#'
#' If you'd prefer to have all these variables stored as characters instead of
#' factors you can modify the call to
{{ qwraps2::backtick(col_type) }}
#+ echo = TRUE, results = "markup"
ct <- col_type(avs_raw_metadata, factors = FALSE)
avsDF2 <- format_record(avs_raw_record, col_type = ct)
class(avsDF2$position)
summary(avsDF2$position)
table(avsDF2$position)

#'
#' The default formatting is documented in the manual file
#' The implemented code is within the S3 method:
#+ echo = TRUE, eval = FALSE
#/*
while(FALSE) {
#*/
?col_type
#/*
}
#*/


