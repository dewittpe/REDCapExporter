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
#' REDCap project via the REDCap (Research Electronic Data Capture) API.  The
#' examples in this vignette rely on use of a API token which cannot be divulged
#' and thus the end users will not be able to reproduce the following examples
#' exactly, but hopefully will be able to use these examples as a guide for
#' their own use.
#'
#' The raw return from the API calls has been provided and can be used as the
#' input for examples the end users can evaluate.
#'
#' The example data provided in this package are statistics from the 2000-2001
#' National Hockey League Stanley Cup Champion Colorado Avalanche.  The data was
#' transcribed from [Hockey Reference](https://www.hockey-reference.com/teams/COL/2001.html}
#' into a REDCap Project hosed at the University of Colorado Denver.
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
#' First, let's load and attach the REDCapExporter namespace
#+ label = "namespace", eval = TRUE
library(REDCapExporter)
#'
#' There are two methods in the
{{ qwraps2::CRANpkg(REDCapExporter) }}
#' package which will call REDCap API
{{ qwraps2::backtick(export_content) }}
#' and
{{ paste0(qwraps2::backtick(export_redcap_project), ".") }}
#' The latter calls the former when building an R data package from a REDCap
#' project.
#'
#' The specific behavior and results of these functions will depended on your
#' institution's REDCap instance and the user access permissions associated with
#' the token used to access the project.
#'
#' The next subsections provide details on these methods.
#'
#' ## Export Contents of a REDCap Project
#'
#' The
{{ qwraps2::backtick(export_content) }}
#' method has five arguments:
#+ label = "args_of_export_content", eval = TRUE
args(export_content)
#'
#' * The uri, token, and format arguements are set to NULL by default.  If the
#' value is NULL then the system environmental variable values are used.  The
#' end user need only define the content argument.  Additional arguments, if
#' needed, are passed to RCurl::postForm via the ellipsis.
#'
#' * content return specific parts of the REDCap project.
#'
#'     * content = "metadata" returns the data dictionary
#'
#'     * content = "record" returns the records for a project.  Note about export rights: Please be aware that Data Export user rights will be applied to this API request. For example, if you have 'No Access' data export rights in the project, then the API data export will fail and return an error. And if you have 'De-Identified' or 'Remove all tagged Identifier fields' data export rights, then some data fields *might* be removed and filtered out of the data set returned from the API. To make sure that no data is unnecessarily filtered out of your API request, you should have 'Full Data Set' export rights in the project.
#'
#'     * content = "project" exports some of the basic attributes of the given REDCap project, such as the project's title, if it is longitudinal, if surveys are enabled, the time the project was created and moved to production, etc.
#'
#'     * content = "user" exports the list of users for a project, including their user privileges and also email address, first name, and last name.  Note: if the user ahs been assigned to a user role, it will return the user with the role's defined privileges.
#'
#' Check the API documentation for your host for specific additonal options.
#' The likly uri is redcap.<institution>/api/help/.
#'
#' An example: the metadata, i.e., data dictionary, for the 2000-2001 Colorado
#' Avalanche data set can be retrived via
avs_raw_metadata <- export_content(content = "metadata")
#'
#' An example of the return is:
#'
#+ label = "example_raw_metadata", eval = TRUE
ls()
data(avs_raw_metadata)
ls()
str(avs_raw_metadata)
#'
#' Using the as.data.frame methods will help you get the return from REDCap into
#' a useable form:
#+ label = "as_data_frame", eval = TRUE
avs_metadata <- as.data.frame(avs_raw_metadata)
str(avs_metadata)

#'
#' ## Export Project
#'
#' With one call to
{{ qwraps2::backtick(export_redcap_project) }}
#' an R Data package will be created to make it easy to archive and/or
#' distribute the data associated with a REDCap Project.  A detailed vignette
#' has been provided for this topic, please see
{{ qwraps2::backtick(vignette(topic = "export", package = "REDCapExporter")) }}
#'
#' # Session Info
#'
print(sessionInfo(), local = FALSE)

