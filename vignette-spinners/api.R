# /* Header and Set up {{{ */
#'---
#'title: "REDCap Exporter: Interaction with the REDCap API"
#'author: "Peter DeWitt"
#'output:
#'  rmarkdown::html_vignette:
#'    toc: true
#'    number_sections: true
#'vignette: >
#'  %\VignetteIndexEntry{api}
#'  %\VignetteEngine{knitr::rmarkdown}
#'  %\VignetteEncoding{UTF-8}
#'---
#'
#+ label = "setup", include = FALSE
# By default, chunks will not be evaluated.  This way the API token will not be
# required to build this vignette.
knitr::opts_chunk$set(collapse = TRUE, eval = FALSE)
loadNamespace("REDCapExporter")

# /* }}} */
#'
#' The purpose of this vignette is to show examples of exporting elements of a
#' REDCap project via the REDCap API.  The examples in this vignette rely on use
#' of a API token which cannot be divulged and thus the end users will not
#' be able to reproduce the following examples exactly, but hopefully will be
#' able to use these examples as a guide for their own use.
#'
#' The raw return from the API calls has been provided and can be used as the
#' input for examples the end users can evaluate.
#'
#' 
#'
#' # REDCap API Tokens
#'
#' You will need to have API Export rights for the REDCap project you are
#' looking to export into an R data package.  Contact the project owner, system
#' admin, or go through your institution's REDCap webpage to acquire an API token.
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
#' for details on the use of the secret package.
#'
#'
# /* Set the private key needed to access the vault, if needed.
Sys.setenv(USER_KEY = "~/.ssh/vaults")
# */
#'
#' There are two system environment variables we recommend setting to make
#' the API calls simple.
#'
#+ label = "REDCap_sysvar"
Sys.setenv(REDCap_API_URI = "https://redcap.ucdenver.edu/api/")
Sys.setenv(REDCap_API_TOKEN = secret::get_secret("2000_2001_Avalanche"))

#'
#' A third environmental variables is the format for data to be returned in.
#' Possible values for the API are 'csv', 'xml', or 'json'.   However, within
#' the 
{{ qwraps2::CRANpkg(REDCapExporter) }}
#' package methods have been built to support csv or json; xml is not yet
#' supported.  csv is the default format.
Sys.getenv("REDCap_API_format")
#'
#' # Exporting a REDCap Project
#'
#' There are two methods in the
{{ qwraps2::CRANpkg(REDCapExporter) }}
#'
#'
#'
#' # Session Info
#'
print(sessionInfo(), local = FALSE)

