library(REDCapExporter)

# Unsupported content type should error
x_bad <- avs_raw_metadata
attr(x_bad, "Content-Type") <- c("not-csv", "not-json")

err <- tryCatch(
  REDCapExporter:::read_text(x_bad),
  error = function(e) e
)

stopifnot(
  inherits(err, "error"),
  grepl("Content-Type .* not yet supported", err$message)
)

# Metadata coercion
md_csv  <- as.data.frame(avs_raw_metadata)
md_json <- as.data.frame(avs_raw_metadata_json)
stopifnot(isTRUE(all.equal(md_csv, md_json)))

# Record coercion
rec_csv  <- as.data.frame(avs_raw_record)
rec_json <- as.data.frame(avs_raw_record_json)
stopifnot(isTRUE(all.equal(rec_csv, rec_json)))

# Project coercion
proj_csv  <- as.data.frame(avs_raw_project)
proj_json <- as.data.frame(avs_raw_project_json)
stopifnot(isTRUE(all.equal(proj_csv, proj_json)))

# User coercion
usr_csv  <- as.data.frame(avs_raw_user)
usr_json <- as.data.frame(avs_raw_user_json)
stopifnot(isTRUE(all.equal(usr_csv, usr_json)))

