# /* Header and Set up {{{ */
#'---
#'title: "REDCap Exporter"
#'author: "Peter DeWitt"
#'date: "`r Sys.Date()`"
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
knitr::opts_chunk$set(collapse = TRUE)

# /* }}} */
#'
#' The purpose of this vignette is to show how to export a REDCap project into a
#' R data package.  There are some prerequisites, described in detail in the
#' first section, you will need to address before running the examples.
#'
#' The primary objective of the `r qwraps2::Rpkg(REDCapExporter)` is to export
#' all the data from an REDCap project via the REDCap API and build a R data
#' package with useful documentation and tools.  The data package will make it
#' easy to archive data and distribute data, in an analysis ready format, within
#' a group of analysts.
#'
#' **Disclaimer and Warning:** It is the responsibility of the end user to
#' protect sensitive data.  Do not use `r qwraps2::Rpkg(REDCapExporter)` to
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
#' # Prerequisites and Tokens
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
#' There are many ways to deal with tokens.  One option would be two require the
#' end user to enter the key interactively via
#' [getPass](https://cran.r-project.org/package=getPass), e.g.,
#'
#+ label = "getPass"
# a_token <- getPass::getPass()
#'
#' However, there are at least two issues with this approach:
#'
#' 1. It is interactive and cannot be scripted.
#' 2. Storing the token in an object would make it
#' possible to divulge the token, either accidentally or via malicious intent.
#'
#' A better way to handle API tokens is to use the
#' [secret](https://cran.r-project.org/package=secret).  We encourage the reader
#' to read the "secrets" vignette.
#' `vignette(topic = "secrets", package = "secret")`
#'
#' We suggest the reader set up a vault with their API token as a secret.
#' Accessing the secret in scripts can be done non-interactively and will a
#' lower chance of accidental or malicious divulging of a token.
#'
#' For the rest of this vignette we will use `secret::get_secret()` to assess a
#' REDCap API token.
#'
#' ## Namespaces, Options, and System Environment Variables
#'
#' For this example we will load and attach the following namespaces and set
#' several options and system environment variables.
#'
#+ label = "namespacesAndOptions"
library(REDCapExporter)
library(data.table)
library(magrittr)
library(secret)
library(qwraps2)

options("datatable.print.topn"  = 3)
options("datatable.print.nrows" = 6)

# private key needed to access the vault
Sys.setenv(USER_KEY = "~/.ssh/vaults")

# REDCap API uri and token
Sys.setenv(REDCap_API_uri = "https://redcap.ucdenver.edu/api/")
Sys.setenv(REDCap_API_TOKEN = get_secret("2000_2001_Avalanche"))

# Set the option the format the data will be returned in.  Possible values are
# 'csv', 'xml', or 'json'. The default is 'csv', set when
# qwraps2::Rpkg(REDCapExporter) is loaded.
Sys.getenv("REDCap_API_format")

#'
# /* }}} */
#'
# /* General Tools {{{ */
#'
#' # General Tools
#'
#' The `r qwraps2::Rpkg(REDCapExporter)` package provides several functions and
#' methods which the user may find useful.  These functions and methods are used
#' within the package to export and create a R data package.  Use of the methods
#' for specific projects, say exporting data from a REDCap project for routine
#' reports or interim analyses.
#'
# /* Specific Export Methods {{{ */
#'
#' ## Specific Export Methods
#'
#' The method `export_content` can be used to
#' export specific parts of a REDCap project. Three of the arguments, `uri`,
#' `token`, and `format`, passed to
#' `export_content`, if omitted, will default to the system environment
#' variables.  Thus, only the `content` argument must be defined by the user.
#' Additional arguments for the API are passed via the `...`.  Check your
#' specific REDCap API documentation.
#'
str(export_content)

#'
#' For example, the project information and project metadata can be obtained
#' via:
avs_raw_project_info <- export_content(content = "project")
avs_raw_metadata     <- export_content(content = "metadata")

#'
#' The return object from `export_content` are character strings as you would
#' expect from a call to `postForm` from the
#' [`r qwraps2::Rpkg(RCurl)`](https://cran.r-project.org/package=RCurl) package.
#' A couple additional attributes have been added.  The `Sys.time` for the call
#' and the class `rcer_raw_*` where `*` is replaced by the value of the `content`
#' argument.
#'
str(avs_raw_project_info)
str(avs_raw_metadata)

#'
#' We opted to have `export_content` return a character string such that the end
#' user can may select the format for the return and use the tool of their
#' choice for creating a `data.frame`.  For example, creating a `data.table`
#' from the csv or json formats.
from_csv <- data.table::fread(input = avs_raw_metadata, colClasses = "character")

from_json <-
  export_content(content = "metadata", format = "json") %>%
  rjson::fromJSON(json_str = .) %>%
  lapply(as.data.table) %>%
  rbindlist

identical(from_csv, from_json)

#'
#' A easier way to get the raw export into a \code{data.frame} or
#' \code{data.table} is to use the `as.data.frame` or `as.data.table` methods.
csv_metadata  <- export_content(content = "metadata", format = "csv")
json_metadata <- export_content(content = "metadata", format = "json")

df_from_csv  <- as.data.frame(csv_metadata)
df_from_json <- as.data.frame(json_metadata)
identical(df_from_csv, df_from_json)

dt_from_csv  <- as.data.table(csv_metadata)
dt_from_json <- as.data.table(json_metadata)
identical(dt_from_csv, dt_from_json)

# /* end specific export methods }}} */
#'
# /* Data Import Tools {{{ */
#'
#' ## Data Import Tools
#'
#' When working with REDCap data it is likely that you will have more collumns
#' than you would want to have to code a data import method for yourself.  This
#' is especially true if you need to deal with columns that may look like
#' numeric values but are really categorical.  We provide some tools to help
#' with the data import process.
#'
#' First, you will need to get the project metadata and record.
avs_raw_metadata <- export_content(content = "metadata")
avs_raw_record   <- export_content(content = "record")

avs_metadata <- as.data.table(avs_raw_metadata)
avs_record   <- as.data.table(avs_raw_record)

#'
#' The function `col_type` will take the metadata and return a list of calls to
#' set the specific storage modes of the projet record.
identical(col_type(avs_raw_metadata), col_type(avs_metadata))

ct <- col_type(avs_metadata)
str(ct)

#'
#' The function `format_records()` will build a `data.frame` for the the project
#' records using the columns types defined by `col_type()`.
# format_records(avs_metadata, avs_raw_records)

temp1 <- format_record(avs_raw_metadata, avs_raw_record)
temp2 <- format_record(avs_raw_metadata, avs_record)
temp3 <- format_record(avs_metadata,     avs_raw_record)
temp4 <- format_record(avs_metadata,     avs_record)

identical(temp1, temp2)
identical(temp1, temp3)
identical(temp1, temp4)

str(temp1)

#'
# /* End of General Tools }}} */
#'
# /* end of General tools }}} */
#'
# /* Exporting a REDCap Project {{{ */
#'
#' # Exporting a REDCap Project to a R Data Package.
#'
#' Exporting a REDCap project to a R data package is done with a call to
#' `export_redcap_project()`.
#'
str(export_redcap_project)

#'
#' The `path` argument is a directory on your machine were the R data package is
#' going to be built.  For this vignette we will use a temporary directory.
#'
temppath <- tempdir()

#'
#' The
#' exported package name and directory will be `rcd<project-id>`, that is, `rcd`
#' for 'REDCap Data' and the project-id which, for this example is:
as.data.frame(avs_raw_project_info)$project_id
avs_raw_user <- export_content(content = "user")
avs_user <- as.data.frame(avs_raw_user)

#'
#' Thus we expect the source package to be at
prj_path <-
  paste(temppath, paste0("rcd", as.data.frame(avs_raw_project_info)$project_id), sep = "/")
prj_path

#'
#' Exporting the project will require you to provide at some information about
#' the users.  You need to list at least one of the `usernames` from the user
#' data and give that person the 'cre' role.
export_redcap_project(path = temppath,
                      author_roles = list(dewittp = c("cre", "aut")))

#'
#' Let's look at some of the files which have been placed into the project path.
#' We will start with the DESCRIPTION file.
read.dcf(paste(prj_path, "DESCRIPTION", sep = "/"))

#'
#' The package name is as noted above, the verions number is worth noting, the
#' version is the year.month.day.hour.minute for when the data was exported from
#' REDCap.
#'

# devtools::check(pkg = prj_path)

#'
# /* End of "Exporting a REDCap Project" }}} */
#'
# /* Session Info {{{ */
#'
#' # Session Info
#'
print(sessionInfo(), local = FALSE)
#
# /* }}} */
