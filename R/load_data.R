#' Build Column Types
#'
#' Use the project metadata to build the storage mode for the columns of the
#' records.
#'
#' @param metadata Project metadata as a \code{data.table}.
#'
#' @examples
#' \dontrun{
#' 
#' library(secret)
#' uri   <- "https://redcap.ucdenver.edu/api/"
#' token <-  get_secret("project10734", key = "~/.ssh/vaults")
#' metadata_raw <- export_content(uri = uri, token = token, content = "metadata")
#' metadata <- data.table::fread(metadata_raw)
#' build_col_types(metadata)
#'
#' token <-  get_secret("project13219", key = "~/.ssh/vaults")
#' metadata_raw <- export_content(uri = uri, token = token, content = "metadata")
#' metadata <- data.table::fread(metadata_raw)
#' build_col_types(metadata)
#' 
#'
#' }
#' @export
build_col_types <- function(metadata) {

  col_types <- lapply(metadata$text_validation_type_or_show_slider_number,
                      switch,
                      number = "numeric",
                      integer = "integer",
                      date_ymd = "character",
                      "character")
  col_types <- setNames(col_types, metadata$field_name)
  col_types <- do.call(c, col_types)

  col_types[metadata$field_type == "yesno"] <- "integer"

  col_types
}



