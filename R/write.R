# Write the DESCRIPTION file for an Exported REDCap Project
write_descritption_file <- function(access_time, user, roles, project_info, path) {

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
write_authors <- function(user, roles = NULL) {
  UseMethod("write_authors")
}

write_authors.rcer_raw_user <- function(user, roles = NULL) {
  write_authors(as.data.frame(user))
}

write_authors.rcer_user <- function(user, roles = NULL) {
  if (is.null(roles)) {
    if (nrow(user) == 1L) {
      warning("Setting singel user's author role as cre")
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
