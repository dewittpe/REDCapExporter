library(REDCapExporter)

# Tests rely on publicly available REDCap and tokens published
# https://github.com/redcap-tools/redcap-test-datasets/tree/master

# project_name  token                             server_url                          pid  server         read_only  operational  notes
# archer        9A81268476645C4E5F03428B8AC3AA7B  https://bbmc.ouhsc.edu/redcap/api/  153  oklahoma-bbmc  TRUE       TRUE         simple structure; read-only
# archer        D70F9ACD1EDD6F151C6EA78683944E98  https://bbmc.ouhsc.edu/redcap/api/  213  oklahoma-bbmc  FALSE      TRUE         simple structure; read & write
# archer        0434F0E9CF53ED0587847AB6E51DE762  https://bbmc.ouhsc.edu/redcap/api/  212  oklahoma-bbmc  TRUE       TRUE         longitudinal structure; read-only
# archer        D72C6485B52FE9F75D27B696977FBA43  https://bbmc.ouhsc.edu/redcap/api/  268  oklahoma-bbmc  TRUE       TRUE         Russian characters; read-only

archer01_csv <-
  tryCatch(
    export_core(uri = 'https://bbmc.ouhsc.edu/redcap/api/', token = '9A81268476645C4E5F03428B8AC3AA7B'),
    error = function(e) {e}
    )

Sys.setenv("REDCap_API_URI" = 'https://bbmc.ouhsc.edu/redcap/api/')
Sys.setenv("REDCap_API_TOKEN" = '9A81268476645C4E5F03428B8AC3AA7B')
archer01_json <- tryCatch(export_core(format = "json"), error = function(e) {e})

if (inherits(archer01_csv, "error") | inherits(archer01_json, "error")) {
  if (inherits(archer01_csv, "curl_error") | inherits(archer01_json, "curl_error")) {
    # skip the rest of the testing
    print(sprintf("Skip test-export.R after curl error: %s", archer01_csv$message))
  } else {
    stop("in test-export.R an non curl related error occured when initially calling export_core")
  }
} else {

  stopifnot(
    inherits(archer01_csv, "rcer_rccore"),
    inherits(archer01_json, "rcer_rccore"),
    inherits(archer01_csv$project_raw, "rcer_raw_project"),
    inherits(archer01_json$project_raw, "rcer_raw_project"),
    inherits(archer01_csv$metadata_raw, "rcer_raw_metadata"),
    inherits(archer01_json$metadata_raw, "rcer_raw_metadata"),
    inherits(archer01_csv$project_raw, "rcer_raw_project"),
    inherits(archer01_json$project_raw, "rcer_raw_project"),
    inherits(archer01_csv$record_raw, "rcer_raw_record"),
    inherits(archer01_json$record_raw, "rcer_raw_record"),
    grepl("text/csv", attr(archer01_csv$record_raw, "Content-Type")),
    grepl("application/json", attr(archer01_json$record_raw, "Content-Type"))
  )

  a1 <- format_record(archer01_csv)
  a2 <- format_record(archer01_json)

# apparently the end of line characters are exported differently
  a1$address  <- gsub('\n', ' ', gsub('\r', '', a1$address))
  a2$address  <- gsub('\n', ' ', gsub('\r', '', a2$address))
  a1$comments <- gsub('\n', ' ', gsub('\r', '', a1$comments))
  a2$comments <- gsub('\n', ' ', gsub('\r', '', a2$comments))

  stopifnot(isTRUE(all.equal(a1, a2)))

}

#
#archer02 <- export_core(uri = 'https://bbmc.ouhsc.edu/redcap/api/', token = 'D70F9ACD1EDD6F151C6EA78683944E98')
#archer02 <- format_record(archer02)
#
#archer03 <- export_core(uri = 'https://bbmc.ouhsc.edu/redcap/api/', token = '0434F0E9CF53ED0587847AB6E51DE762')
#archer03 <- format_record(archer03)
#
#archer04 <- export_core(uri = 'https://bbmc.ouhsc.edu/redcap/api/', token = 'D72C6485B52FE9F75D27B696977FBA43')
#archer04 <- format_record(archer04)
