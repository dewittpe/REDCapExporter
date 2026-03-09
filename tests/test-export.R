library(REDCapExporter)

# Tests rely on publicly available REDCap test datasets and tokens.
# The REDCapR project moved its public test credentials from bbmc.ouhsc.edu
# to redcap-dev-2.ouhsc.edu in February 2026 (see REDCapR repo history and
# inst/misc/example.credentials). We follow that public test endpoint here.
# The API tokens below are intended to be public and used for testing.

# project_name  token                             server_url                                pid  server        read_only  operational  notes
# simple        9A068C425B1341D69E83064A2D273A70  https://redcap-dev-2.ouhsc.edu/redcap/api/  33   ouhsc-dev-2  TRUE       TRUE         simple structure; read-only

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
      export_core(uri = 'https://redcap-dev-2.ouhsc.edu/redcap/api/', token = '9A068C425B1341D69E83064A2D273A70'),
      error = function(e) {e}
    )

  if (inherits(archer01_csv, "error")) {
    if (inherits(archer01_csv, "curl_error")) {
      message(sprintf("Skip test-export.R after curl error: %s", archer01_csv$message))
    } else {
      stop("in test-export.R a non-curl error occurred when calling export_core")
    }
  } else {
    stopifnot(
      length(archer01_csv) == 4L,
      inherits(archer01_csv[[1]], "rcer_raw_project"),
      inherits(archer01_csv[[2]], "rcer_raw_metadata"),
      inherits(archer01_csv[[3]], "rcer_raw_user"),
      inherits(archer01_csv[[4]], "rcer_raw_record")
    )
  }
}

