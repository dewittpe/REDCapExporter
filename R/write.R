#' Write DESCRIPTION File from REDCap Metadata
#'
#' Create the DESCRIPTION file for the R Data package based on an Exported
#' REDCap Project
#'
#' This is a non-exported function and is not expected to be called by the end
#' user.
#'
#' \code{write_description_file} creates the DESCRIPTION file for the
#' exported R data package and \code{write_authors} creates the "Authors@R"
#' field of the DESCRIPTION based on the "user" data extracted from the REDCap
#' project.
#'
#' @param access_time The \code{Sys.time()} when the API calls were made
#' @param user User(s), as noted in the REDCap project meta data.  This
#' parameter is singular as it refers to the "user" content one can access from
#' the REDCap API.
#' @param roles roles the \code{user} hold with respect to the R data package.
#' These roles have no relationship to REDCap roles.
#' @param project_info project metadata
#' @param path path to the root for the generated R data package.
#'
write_description_file <- function(access_time, user, roles, project_info, path) {

  pkg_version <-
    paste(formatC(lubridate::year(access_time), width = 4),
          formatC(lubridate::month(access_time), width = 2, flag = 0),
          formatC(lubridate::day(access_time), width = 2, flag = 0),
          formatC(lubridate::hour(access_time), width = 2, flag = 0),
          formatC(lubridate::minute(access_time), width = 2, flag = 0),
          sep = ".")

  cat("Package: ", paste0("rcd", project_info$project_id), "\n",
      "Title: ",   project_info$project_title, "\n",
      "Version: ", pkg_version, "\n",
      "Authors@R: ", write_authors(user, roles), "\n",
      "Description: Data and documentation from the REDCap Project.", "\n",
      "License: file LICENSE\n",
      "Encoding: UTF-8\n",
      "LazyData: true\n",
      "Suggests:\n    knitr\n",
      "VignetteBuilder: knitr\n",
      sep = "", file = paste(path, "DESCRIPTION", sep = "/"), append = FALSE)

  invisible()
}

# Write the Authors for the DESCRIPTION file
#' @rdname write_description_file
write_authors <- function(user, roles = NULL) {
  UseMethod("write_authors")
}

#' @export
write_authors.rcer_raw_user <- function(user, roles = NULL) {
  write_authors(as.data.frame(user))
}

#' @export
write_authors.rcer_user <- function(user, roles = NULL) {
  if (is.null(roles)) {
    if (nrow(user) == 1L) {
      warning("Setting single user's author role as cre")
      roles <- "cre"
    } else {
      stop("Multiple Users.  You need to define the cre.  All others will default to ctb.")
    }
  }

  forDESCRIPTION <-
    data.frame(username = user$username,
               given  = user$firstname,
               family = user$lastname,
               email  = user$email,
               stringsAsFactors = FALSE)

  df_roles <- data.frame(username = names(roles),
                         role     = unname(I(roles)),
                         stringsAsFactors = FALSE)

  forDESCRIPTION <- merge(forDESCRIPTION, df_roles, by = "username", all.x = TRUE)
  forDESCRIPTION$role[is.na(forDESCRIPTION$role)] <- 'c("ctb")'
  forDESCRIPTION

  paste0("c(",
         paste(
               sprintf("person(given = \"%s\", family = \"%s\", email = \"%s\", role = %s)",
                       forDESCRIPTION$given, forDESCRIPTION$family, forDESCRIPTION$email, forDESCRIPTION$role),
               collapse = ",\n             "), ")")
}
