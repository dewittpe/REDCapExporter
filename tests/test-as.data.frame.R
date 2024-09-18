library(REDCapExporter)

# Expect error if the input in not csv or json.  the error should come from the
# read_text call, which is not exported.
x <- avs_raw_metadata
attr(x, "Content-Type") <- c("not-csv", "not-json")
x <- tools::assertError(REDCapExporter:::read_text(x))
stopifnot(identical(x[[1]][["message"]], "Content-Type 'not-csv' is not yet supported."))

# Testing coercion of rcer_raw_metadata to data.frame and data.table
DF0 <- as.data.frame(avs_raw_metadata)
DF1 <- as.data.frame(avs_raw_metadata_json)

stopifnot(all.equal(DF0, DF1))

# Testing coercion of rcer_raw_record to data.frame and data.table
rm(list = ls())

DF0 <- as.data.frame(avs_raw_record)
DF1 <- as.data.frame(avs_raw_record_json)

stopifnot(all.equal(DF0, DF1))

# Testing coercion of rcer_raw_project to data.frame and data.table
rm(list = ls())
DF0 <- as.data.frame(avs_raw_project)
DF1 <- as.data.frame(avs_raw_project_json)

stopifnot(all.equal(DF0, DF1))

# Testing coercion of rcer_raw_user to data.frame and data.table
rm(list = ls())
DF0 <- as.data.frame(avs_raw_user)
DF1 <- as.data.frame(avs_raw_user_json)

stopifnot(all.equal(DF0, DF1))

