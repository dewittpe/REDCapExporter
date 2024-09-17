#' Raw Exports From an Example REDCap Project
#'
#' These data sets are the results of calling \code{\link{export_content}}.  An
#' API token is required to reproduce these calls. No such token will be
#' provided publicly, so these data sets are provided so end users can run
#' examples for other tools provided in the REDCapExporter package.
#'
#' \code{avs_raw_project} provides meta data about the project itself in a csv format.
#' \code{avs_raw_project_json} is the same information in json format.
#'
#' \code{avs_raw_metadata} is the data dictionary for the REDCap Project in a
#' csv format.  This information can be used with \code{\link{format_record}} to
#' build a \code{data.frame} that is ready for analysis.
#' \code{avs_raw_metadata_json} is the same metadata information in json format.
#'
#' \code{avs_raw_user} REDCap Project user table in csv format.
#' \code{avs_raw_user_json} is the same information in json format.
#'
#' \code{avs_raw_record} REDCap Project records, i.e., 'the data' in csv format.
#' \code{avs_raw_record_json} is the same information in json format.
#'
#' @examples
#' \dontrun{
#' avs_raw_project  <- export_content(content = "project",  format = "csv")
#' avs_raw_metadata <- export_content(content = "metadata", format = "csv")
#' avs_raw_user     <- export_content(content = "user",     format = "csv")
#' avs_raw_record   <- export_content(content = "record",   format = "csv")
#' avs_raw_core     <- export_core(format = "csv")
#' }
#'
#' data(avs_raw_project)
#' data(avs_raw_user)
#' data(avs_raw_metadata)
#' data(avs_raw_record)
#' data(avs_raw_core)
#'
#' str(avs_raw_project)
#' str(avs_raw_user)
#' str(avs_raw_metadata)
#' str(avs_raw_record)
#' str(avs_raw_core)
#'
#' avs <- format_record(avs_raw_record, avs_raw_metadata)
#' str(avs)
#'
#' @name example_data
NULL

#' @rdname example_data
"avs_raw_project"

#' @rdname example_data
"avs_raw_metadata"

#' @rdname example_data
"avs_raw_user"

#' @rdname example_data
"avs_raw_record"

#' @rdname example_data
"avs_raw_core"

#' @rdname example_data
"avs_raw_project_json"

#' @rdname example_data
"avs_raw_metadata_json"

#' @rdname example_data
"avs_raw_user_json"

#' @rdname example_data
"avs_raw_record_json"

#' @rdname example_data
"avs_raw_core_json"
