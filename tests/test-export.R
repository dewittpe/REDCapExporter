library(REDCapExporter)

# Tests rely on publicly available REDCap and tokens published
# https://github.com/redcap-tools/redcap-test-datasets/tree/master

# project_name  token                             server_url                          pid  server         read_only  operational  notes
# archer        9A81268476645C4E5F03428B8AC3AA7B  https://bbmc.ouhsc.edu/redcap/api/  153  oklahoma-bbmc  TRUE       TRUE         simple structure; read-only
# archer        D70F9ACD1EDD6F151C6EA78683944E98  https://bbmc.ouhsc.edu/redcap/api/  213  oklahoma-bbmc  FALSE      TRUE         simple structure; read & write
# archer        0434F0E9CF53ED0587847AB6E51DE762  https://bbmc.ouhsc.edu/redcap/api/  212  oklahoma-bbmc  TRUE       TRUE         longitudinal structure; read-only
# archer        D72C6485B52FE9F75D27B696977FBA43  https://bbmc.ouhsc.edu/redcap/api/  268  oklahoma-bbmc  TRUE       TRUE         Russian characters; read-only

on_cran <- function() {
  # copied from testthat:::on_cran
  env <- Sys.getenv("NOT_CRAN")
  if (identical(env, "")) {
    !interactive()
  } else {
    !isTRUE(as.logical(env))
  }
}

if (!on_cran()) {
  archer01_csv <-
    tryCatch(
      export_core(uri = 'https://bbmc.ouhsc.edu/redcap/api/', token = '9A81268476645C4E5F03428B8AC3AA7B'),
      error = function(e) {e}
    )

  expected_return <-
  c(
    project_raw  = "ERROR: You do not have permissions to use the API",
    metadata_raw = "ERROR: You do not have permissions to use the API",
    user_raw     = "ERROR: You do not have permissions to use the API",
    record_raw   = "ERROR: You do not have permissions to use the API"
  )

  stopifnot(
    !inherits(archer01_csv, "error"), # not an error - a retun happened, but it is not a useful return
    length(archer01_csv) == 4L,
    inherits(archer01_csv[[1]], "rcer_raw_project"),
    inherits(archer01_csv[[2]], "rcer_raw_metadata"),
    inherits(archer01_csv[[3]], "rcer_raw_user"),
    inherits(archer01_csv[[4]], "rcer_raw_record"),
    identical(sapply(archer01_csv, getElement, 1), expected_return)
  )
}

################################################################################
# OLD TESTS, for version < 0.3.3 these tests were used, but in Feb 2026 the API
# failed and so do the tests.  Not a REDCapExporter issue, an RedCap API issue.
#
# Commented out for now until a fix can be made.
#
###
###
### Sys.setenv("REDCap_API_URI" = 'https://bbmc.ouhsc.edu/redcap/api/')
### Sys.setenv("REDCap_API_TOKEN" = '9A81268476645C4E5F03428B8AC3AA7B')
### archer01_json <- tryCatch(export_core(format = "json"), error = function(e) {e})
###
### if (inherits(archer01_csv, "error") | inherits(archer01_json, "error")) {
###   if (inherits(archer01_csv, "curl_error") | inherits(archer01_json, "curl_error")) {
###     # skip the rest of the testing
###     print(sprintf("Skip test-export.R after curl error: %s", archer01_csv$message))
###   } else {
###     stop("in test-export.R an non curl related error occured when initially calling export_core")
###   }
### } else {
###
###   stopifnot(
###     inherits(archer01_csv, "rcer_rccore"),
###     inherits(archer01_json, "rcer_rccore"),
###     inherits(archer01_csv$project_raw, "rcer_raw_project"),
###     inherits(archer01_json$project_raw, "rcer_raw_project"),
###     inherits(archer01_csv$metadata_raw, "rcer_raw_metadata"),
###     inherits(archer01_json$metadata_raw, "rcer_raw_metadata"),
###     inherits(archer01_csv$project_raw, "rcer_raw_project"),
###     inherits(archer01_json$project_raw, "rcer_raw_project"),
###     inherits(archer01_csv$record_raw, "rcer_raw_record"),
###     inherits(archer01_json$record_raw, "rcer_raw_record"),
###     grepl("text/csv", attr(archer01_csv$record_raw, "Content-Type")),
###     grepl("application/json", attr(archer01_json$record_raw, "Content-Type"))
###   )
###
###   a1 <- format_record(archer01_csv)
###   a2 <- format_record(archer01_json)
###
### # apparently the end of line characters are exported differently
###   a1$address  <- gsub('\n', ' ', gsub('\r', '', a1$address))
###   a2$address  <- gsub('\n', ' ', gsub('\r', '', a2$address))
###   a1$comments <- gsub('\n', ' ', gsub('\r', '', a1$comments))
###   a2$comments <- gsub('\n', ' ', gsub('\r', '', a2$comments))
###
###   stopifnot(isTRUE(all.equal(a1, a2)))
###
### }
###
### #
### #archer02 <- export_core(uri = 'https://bbmc.ouhsc.edu/redcap/api/', token = 'D70F9ACD1EDD6F151C6EA78683944E98')
### #archer02 <- format_record(archer02)
### #
### #archer03 <- export_core(uri = 'https://bbmc.ouhsc.edu/redcap/api/', token = '0434F0E9CF53ED0587847AB6E51DE762')
### #archer03 <- format_record(archer03)
### #
### #archer04 <- export_core(uri = 'https://bbmc.ouhsc.edu/redcap/api/', token = 'D72C6485B52FE9F75D27B696977FBA43')
### #archer04 <- format_record(archer04)
