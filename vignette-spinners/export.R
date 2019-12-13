# /* Header and Set up {{{ */
#'---
#'title: "REDCap Exporter"
#'author: "Peter DeWitt"
#'output:
#'  rmarkdown::html_vignette:
#'    toc: true
#'    number_sections: true
#'vignette: >
#'  %\VignetteIndexEntry{export}
#'  %\VignetteEngine{knitr::rmarkdown}
#'  %\VignetteEncoding{UTF-8}
#'---
#'
#+ label = "setup", include = FALSE
knitr::opts_chunk$set(collapse = TRUE, eval = FALSE)

# /* }}} */
#'
#' The purpose of this vignette is to show how to export a REDCap project into a
#' R data package.  There are some prerequisites, described in detail in the
#' first section, you will need to address before running the examples.
#'
#' The primary objective of the
{{ qwraps2::Rpkg(REDCapExporter) }}
#' is to export all the data from an REDCap project via the REDCap API and build
#' a R data package with useful documentation and tools.  The data package will
#' make it easy to archive data and distribute data, in an analysis ready
#' format, within a group of analysts.
#'
#' Additionally, examples and use of the specific tools from the
{{ qwraps2::Rpkg("REDCapExporter") }}
#' package are provided.  If you are an analyst working on a live project, the
#' use of these tools might be helpful for building on the fly or routine data
#' reports.
#'
#' **Disclaimer and Warning:** It is the responsibility of the end user to
#' protect sensitive data.  Do not use
{{ qwraps2::Rpkg(REDCapExporter) }}
#' to
#' export data onto a computer that should not have sensitive data stored on it.
#' Further, do not distribute the resulting R package to any other machine or
#' person who does not have data access rights.
#'
#' For the example in this vignette we created a REDCap project storing the
#' roster and statistics for the 2000-2001 Stanley Cup Champion Colorado
#' Avalanche of the National Hockey League.  The data was acquired from the
#' web page
#' [Hockey Reference](https://www.hockey-reference.com/teams/COL/2001.html).
#'
# /* Prerequisites {{{ */
#'
#' # Prerequisites
#'
#' ## REDCap API Tokens
#'
#' You will need to have API Export rights for the REDCap project you are
#' looking to export into an R data package.  Contact the project owner, system
#' admin, or go through your institution's REDCap page to acquire an API token.
#'
#' Remember, your API token is the equivalent of a username/password
#' combination.  Thus, you must treat the token with the same, or more, level of
#' security you would treat any username/password combination.  **DO NOT PUT THE
#' TOKEN IN PLAIN TEXT!**
#'
#' We suggest the reader set up a vault with their API token as a secret.
#' via the
{{ qwraps2::CRANpkg(secret) }}
#' package.  We encourage the reader to read the "secrets" vignette in R via:
{{ qwraps2::backtick(vignette(topic = "secrets", package = "secret")) }}
#'.
#'
#' For the rest of this vignette we will use
{{ qwraps2::backtick(secret::get_secret) }}
#' to access a REDCap API token.
#'
#' ## Namespaces, Options, and System Environment Variables
#'
#' For this example we will load and attach the following namespaces and set
#' several options and system environment variables.
#'
#+ label = "namespacesAndOptions", message = FALSE
library(REDCapExporter)
library(data.table)
library(magrittr)
library(secret)
library(qwraps2)

options("datatable.print.topn"  = 3)
options("datatable.print.nrows" = 6)

# Set the private key needed to access the vault, if needed.
Sys.setenv(USER_KEY = "~/.ssh/vaults")

# REDCap API uri and token
Sys.setenv(REDCap_API_URI = "https://redcap.ucdenver.edu/api/")
Sys.setenv(REDCap_API_TOKEN = get_secret("2000_2001_Avalanche"))

# Set the option the format the data will be returned in.  Possible values are
# 'csv', 'xml', or 'json'.   Methods to build data sets from csv and json have
# been built, xml is not yet supported.  csv is the default format.
Sys.getenv("REDCap_API_format")

#'
# /* }}} */
#'
# /* Exporting a REDCap Project {{{ */
#'
#' # Exporting a REDCap Project to a R Data Package
#'
#' ## Basic Export
#'
#' Exporting a REDCap project to a R data package is done with a call to
{{ qwraps2::backtick(export_redcap_project) }}
#'.  The output of the call is a syntactically valid source R package directory.
#' The arguments for the call are
str(export_redcap_project)

#'
#' The uri and token can be passed explicitly here, if omitted, the values in
#' the system environment variables will be used.
#' The path argument is a directory on your machine were the R data package is
#' going to be built.  For this vignette we will use a temporary directory.
#'
temppath <- tempdir()

#'
#' Exporting the project will require you to provide at some information about
#' the users. In this context, users are the persons who have, or had, access to the
#' REDCap project and are listed under the UserRights section of the REDCap
#' proejct.  The user data from REDCap is used to construct the Author section
#' of the DESCRIPTION file for the R data package to be constucted.  By default,
#' all users are listed as 'contributors'.  Modification of the roles can be
#' provide by a named list object.  In the example below, the user dewittp is
#' going to assigned the creator and author role.  To be a valid R package, at
#' least one user will need to have the creator role assigned.
#'
#'
export_redcap_project(path = temppath,
                      author_roles = list(dewittp = c("cre", "aut")))

#'
#' The resulting directory is:
fs::dir_tree(temppath)

#'
#' ## Details on exported Files
#'
#' First, the package directory name.  Exported packages from
{{ qwraps2::Rpkg(REDCapExporter) }}
#' will have the directory name rcd<package-id>.  This name is also used in the
#' DESCRIPTION file.
#'
#' The DESCRIPTION file is
prj_dir <- list.dirs(temppath)
prj_dir <- prj_dir[grepl("/rcd\\d+$", prj_dir)]
t(read.dcf(paste(prj_dir, "DESCRIPTION", sep = "/")))

#'
#' The title comes from the project info recorded in REDCap.  The version number
#' is set as the year.month.day.hour.minute of the export.  As noted above, the
#' Author field is built from the user data stored in REDCap.
#'
#' The LICENSE file notes that the package is proprietary and should not be
#' installed or distributed to others who are not authorized to have access to
#' the data.
cat(readLines(paste(prj_dir[1], "LICENSE", sep = "/")), sep = "\n")

#'
#' The raw data exports are stored as .rds files under inst/raw-data so that
#' these files will be available in R sesssions after installing the package.
#'
#' The data directory has data.table versions of the data sets.
#'
#' The R/datasets.R file provides the documentation for the data sets which can
#' be accessed in an interactive R session.
#'
#' ## Other notes
#'
#' ### Check the R Data Package
#'
#' The generated R data package should pass the basic R CMD check.
check <- devtools::check(pkg = prj_dir, quiet = TRUE)
check

#'
#' ### Using the Exported Package
#'
#' Let's install the package and explore the contents.

install.packages(grep("*.tar.gz", list.files(path = prj_dir, recursive = TRUE, full.names = TRUE), value = TRUE),
                 lib = temppath)

library(rcd14465, lib.loc = temppath)

#'
#' The available data sets:
data(package = "rcd14465")$results

#'
#' A simple data analysis question: how many goals were scored by position?
as.data.table(record)[, sum(goals), by = position]

#'
# /* End of "Exporting a REDCap Project" }}} */
#'
# /* General Tools {{{ */
#'
#' # General Tools
#'
#' The
{{ qwraps2::Rpkg(REDCapExporter) }}
#' package provides several functions and methods which the user may find
#' useful.  These functions and methods are used within the package to export
#' and create a R data package.  Use of the methods for specific projects, say
#' exporting data from a REDCap project for routine reports or interim analyses.
#'
# /* Specific Export Methods {{{ */
#'
#' ## Specific Export Methods
#'
#' The method
{{ qwraps2::backtick("export_content") }}
#' can be used to 
#' export specific parts of a REDCap project. Three of the arguments, uri,
#' token, and format, if omitted, will default to the system environment
#' variables.  Thus, only the content argument must be defined by the user.
#' Additional arguments for the API are passed via the ellipses.
#' Check your specific REDCap API documentation.
#'
str(export_content)

#'
#' For example, the project information and project metadata can be obtained
#' via:
avs_raw_project_info <- export_content(content = "project")
avs_raw_metadata     <- export_content(content = "metadata")

#'
#' The return object from 
{{ qwraps2::backtick(export_content) }}
#' are character strings as you would
#' expect from a call to 
{{ qwraps2::backtick(postForm) }}
#' from the
{{ qwraps2::CRANpkg(RCurl) }}
#' package.  A couple additional attributes have been added.  The 
{{ qwraps2::backtick(Sys.time) }}
#' for the call and the class 
{{ qwraps2::backtick("rcer_raw_*") }}
#' where * is replaced by the value of the content argument.
#'
str(avs_raw_project_info)
str(avs_raw_metadata)

#'
#' We opted to have 
{{ qwraps2::backtick(export_content) }}
#' return a character string such that the end
#' user can may select the format for the return and use the tool of their
#' choice for creating a data.frame or other objects.  However, as you will
#' see in the next section there are default methods for building data frames.
#'
# /* end specific export methods }}} */
#'
# /* Data Import Tools {{{ */
#'
#' ## Data Import Tools
#'
#' When working with REDCap data it is likely that you will have more columns
#' than you would want to have to code a data import method for yourself.  This
#' is especially true if you need to deal with columns that may look like
#' numeric values but are really categorical.  We provide some tools to help
#' with the data import process.
#'
#' First, you will need to get the project metadata and record.
#'
avs_raw_metadata <- export_content(content = "metadata")
avs_raw_metadata

avs_raw_record   <- export_content(content = "record")
avs_raw_record

#'
#' There are 
{{ qwraps2::backtick(as.data.frame) }}
#' and 
{{ qwraps2::backtick(as.data.table) }}
#' methods for translating the raw export to the noted class.
#'
avs_metadata <- as.data.frame(avs_raw_metadata)
avs_record   <- as.data.frame(avs_raw_record)

#'
#' The initial mapping to a data frame treats all columns as character.
#'
all(sapply(avs_metadata, mode) == "character")
all(sapply(avs_record, mode) == "character")

#'
#' To create a  data frame  with useful data storage modes in each column you
#' can use 
{{ qwraps2::backtick(format_record) }}
#'.  The easiest option is to pass the record and
#' metadata to
{{ qwraps2::backtick(format_record) }}
#' as shown below.
temp1 <- format_record(record = avs_record, metadata = avs_raw_metadata)
str(temp1[1:10])

#'
#' The mode for each column is defined by the function call 
{{ qwraps2::backtick(col_type) }}
#'. The default modes are set via the metadata:
#'
#/*
#' | Field Type                                                             | mode             |
#' | :----------                                                            | :----            |
#' | Text Fields: `field_type == "text"`                                    |                  |
#' | &nbsp;&nbsp; `text_validation_type_or_show_slider_number == "number"`  | `as.numeric`     |
#' | &nbsp;&nbsp; `text_validation_type_or_show_slider_number == "integer"` | `as.integer`     |
#' | &nbsp;&nbsp; `text_validation_type_or_show_slider_number == "date_*"`  | `lubridate::ymd` |
#' | &nbsp;&nbsp; Default                                                   | `as.character`   |
#' | Multiple Choice: `field_type %in% c("radio", "dropdown")`              |                  |
#' |                                                                        | `as.factor`      |
#' | Calculated Fields: `field_type == "calc"`                              |                  |
#' |                                                                        | `as.numeric`     |
#' | Yes / No: `field_type == "yesno"`                                      |                  |
#' |                                                                        | `as.integer`     |
#*/
#'
#' NOTES:
#'
#' * Dates can be entered into REDCap as mdy, dmy, or ymd.  However, it
#' appears that the record will have the date in ymd format regardless of the
#' input format.
#'
#' * Multiple Choice fields can be set as character by passing
{{ qwraps2::backtick('factor = FALSE', dequote = TRUE) }}
#' to 
{{ qwraps2::backtick(col_type) }}
#'.
#'
#' * Additional defaults are to be defined.
#'
#' If the user wishes to define the storage mode for a specific subset of
#' columns we recommend the user call
{{ qwraps2::backtick(col_type) }}
#' explicitly, store the result,
#' modify as needed, then pass the modified object to 
{{ qwraps2::backtick(format_record) }}
#'. For example, we will set 
{{ qwraps2::backtick(hof) }}
#' which is yes/no variable to logical, and modify
#' the height column to be in meters instead of inches.

ct <- col_type(avs_metadata)
ct$hof <- expression(as.logical(as.integer(hof)))
ct$height <- expression(0.0254 * as.numeric(height))

temp2 <- format_record(avs_raw_record, col_type = ct)
str(temp2[1:10])

#'
# /* End of data import Tools }}} */
#'
# /* end of General tools }}} */
#'
# /* Session Info {{{ */
#'
#' # Session Info
#'
print(sessionInfo(), local = FALSE)
#
# /* }}} */

