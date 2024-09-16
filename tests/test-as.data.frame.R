library(REDCapExporter)

target <- utils::read.csv(text = avs_raw_record, colClasses = "character")
current <- as.data.frame(avs_raw_record)

stopifnot(
  isTRUE(
    all.equal(target, current, check.attributes = FALSE)
  ),
  isTRUE(
    all.equal(unclass(target), unclass(current))
  )
)

