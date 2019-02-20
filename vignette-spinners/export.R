# /* Header and Set up {{{ */
#'---
#'title: "REDCap ExporteR"
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
#' end user to enter the key interactively.  For example:
# /*
if (interactive()) { } else {
# */
#+ label = "getPass_example"
not_a_real_token <- getPass::getPass()
# /*
}
# */
#'
#' However, there are at least two issues with this approach:
#'
#' 1. It is interactive and cannot be scripted.
#' 2. In the example above, storing the token in an object would make it
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
# /* }}} */
#'
# /* Exporting a REDCap Project {{{ */
#' # Exporting a REDCap Project
#'
#' The primary objective of the {{qwraps2::Rpkg(REDCapExporteR)}} is to export
#' all the data from an REDCap project via the REDCap API and build a R data
#' package with useful documentation and tools.  The data package will make it
#' easy to archive data and distribute data, in an analysis ready format, within
#' a group of analysts.
#'
#' **Disclaimer: It is the responsibility of the end user to protect sensitive
#' data.  Do not use `r qwraps2::Rpkg(REDCapExporteR)` to export data onto a
#' computer that should not have sensitive data stored on it.  Further, do not
#' distribute the resulting R package to any other machine or person who does
#' not have data access rights.**
#'
#' For the example in this vignette we used
#'
#'
# /* }}} */
#'
#' # Session Info
#'
print(sessionInfo(), local = FALSE)
