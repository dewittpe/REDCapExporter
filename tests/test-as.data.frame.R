library(REDCapExporter)
library(data.table)

# Expect error if the input in not csv or json.  the error should come from the
# read_text call, which is not exported.
x <- avs_raw_metadata
attr(x, "Content-Type") <- c("not-csv", "not-json")
x <- tools::assertError(REDCapExporter:::read_text(x))
stopifnot(identical(x[[1]][["message"]], "Content-Type 'not-csv' is not yet supported."))

# Testing coercion of rcer_raw_metadata to data.frame and data.table
DF0 <- as.data.frame(avs_raw_metadata)
DF1 <- as.data.frame(avs_raw_metadata_json)
DT0 <- as.data.table(avs_raw_metadata)
DT1 <- as.data.table(avs_raw_metadata_json)

stopifnot(
  all.equal(DF0, DF1),
  all.equal(DT0, DT1),
  all.equal(DF0, DT0, check.attributes = FALSE),
  all.equal(DF1, DT1, check.attributes = FALSE)
)

# Testing coercion of rcer_raw_record to data.frame and data.table
rm(list = ls())

DF0 <- as.data.frame(avs_raw_record)
DF1 <- as.data.frame(avs_raw_record_json)
DT0 <- as.data.table(avs_raw_record)
DT1 <- as.data.table(avs_raw_record_json)

stopifnot(
  all.equal(DF0, DF1),
  all.equal(DT0, DT1),
  all.equal(DF0, DT0, check.attributes = FALSE),
  all.equal(DF1, DT1, check.attributes = FALSE)
)

# Testing coercion of rcer_raw_project to data.frame and data.table
rm(list = ls())
DF0 <- as.data.frame(avs_raw_project)
DF1 <- as.data.frame(avs_raw_project_json)
DT0 <- as.data.table(avs_raw_project)
DT1 <- as.data.table(avs_raw_project_json)

stopifnot(
  all.equal(DF0, DF1)
  ,
  all.equal(DT0, DT1)
  ,
  all.equal(DF0, DT0, check.attributes = FALSE)
  ,
  all.equal(DF1, DT1, check.attributes = FALSE)
)

