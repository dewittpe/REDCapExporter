#' Set up and use of a Keyring for REDCap API Tokens
#'
#' Tools for checking for, and setting up, a file based keyring for storing
#' REDCap API tokens.
#'
#' @param keyring a character vector identifying the name of the keyring,
#' defaults to \code{"REDCapExporter"}
#' @param password This is the password for the keyring.  The default is an
#' empty password.
#' @param project the name of the REDCap project the API token is identified by.
#' @param user user name to associate the token with.  Defaults to
#' \code{Sys.info()[["user"]]}.
#' @param overwrite logical, if \code{TRUE} overwrite the existing token.
#'
#' @seealso \code{vignette(topic = "api", package = "REDCapExporter")}
#'
#' @return \code{REDCapExporter_keyring_check} returns \code{TRUE}, invisibly,
#' as does \code{REDCapExporter_add_api_token}.
#' \code{REDCapExporter_get_api_token} returns the token invisibly as not to
#' print the value to the console by default.  Still, be careful with your
#' token.
#'
#' @examples
#' \dontrun{
#' REDCapExporter_keyring_check()
#' REDCapExporter_add_api_token("Project1")
#' Sys.setenv(REDCap_API_TOKEN = REDCapExporter_get_api_token("Project1"))
#' }
#'
#' @name REDCapExporter_keyring
NULL

#' @rdname REDCapExporter_keyring
#' @export
REDCapExporter_keyring_check <- function(keyring = "REDCapExporter", password = NULL) {
  if (is.null(password)) {
    password <- ""
  }

  kr <- keyring::backend_file$new()

  # check if the REDCapTokens keyring exists, if not, create it.
  if (!(keyring %in% kr$keyring_list()$keyring)) {
    kr$.__enclos_env__$private$keyring_create_direct(keyring = keyring, password = password)
    message(sprintf("File based keyring %s has been created", keyring))
  } else {
    message(sprintf("File based keyring %s exists", keyring))
  }
  invisible(TRUE)
}

#' @rdname REDCapExporter_keyring
#' @export
REDCapExporter_add_api_token <- function(project, keyring = "REDCapExporter", user = NULL, password = NULL, overwrite = FALSE) {
  if (is.null(password)) {
    password <- ""
  }

  kr <- keyring::backend_file$new()
  kr$keyring_unlock(keyring = keyring, password = password)

  if (is.null(user)) {
    user <- Sys.info()[["user"]]
  }

  cannot_get_token <- inherits(try(kr$get(service = project, username = user, keyring = keyring), silent = TRUE), "try-error")

  if (overwrite || cannot_get_token) {
    message(sprintf("Please enter your API token (at the Password: prompt)\n\nProject: %s\nUser: %s\nKeyring: %s\n",
                    project, user, keyring))
    kr$set(service = project, username = user, keyring = keyring)
  } else {
    message(sprintf("API token exisits for\n\nProject: %s\nUser: %s\nKeyring: %s\n",
                    project, user, keyring))
  }

  # lock the keyring
  kr$keyring_lock(keyring = keyring)
  invisible(TRUE)
}

#' @rdname REDCapExporter_keyring
#' @export
REDCapExporter_get_api_token <- function(project, keyring = "REDCapExporter", user = NULL, password = NULL) {
  if (is.null(password)) {
    password <- ""
  }

  kr <- keyring::backend_file$new()
  kr$keyring_unlock(keyring = keyring, password = password)
  token <- kr$get(service = project, username = user, keyring = keyring)
  kr$keyring_unlock(keyring = keyring, password = password)
  invisible(token)
}

