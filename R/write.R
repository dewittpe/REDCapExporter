#' Write the DESCRIPTION file for an Exported REDCap Project
#' 
write_descritption_file <- function(access_time, user, project_info, path) {

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
      "Authors@R: ", write_authors(user), "\n",
      "Description: Data and documentation from the REDCap Project.", "\n",
      "License: file LICENSE\n",
      "Encoding: UTF-8\n",
      "LazyData: true\n",
      "Suggests:\n    knitr\n",
      "VignetteBuilder: knitr\n",
      sep = "", file = paste(path, "DESCRIPTION", sep = "/"), append = FALSE)

  invisible()
}

#' Write the Authors for the DESCRIPTION file
write_authors <- function(user) {
  UseMethod("write_authors")
}

write_authors.rcer_raw_user <- function(user) {
  write_authors(as.data.frame(user))
}

write_authors.rcer_user <- function(user) { 
  paste0("c(", paste(sprintf("person(\"%s\", \"%s\", \"%s\")", user$firstname, user$lastname, user$email), collapse = ",\n             "), ")")
}
