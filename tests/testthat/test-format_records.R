data("avs_raw_record")

test_that("as.data.frame returns a data.frame of characters",
          {
            expect_equivalent(
                              utils::read.csv(text = avs_raw_record, colClasses = "character")
                              ,
                              as.data.frame(avs_raw_record)
            )
          })

test_that("format_record is same dim as unformated data.frame",
          {
            expect_equal(
                         dim(as.data.frame(avs_raw_record))
                         ,
                         dim(format_record(avs_raw_record, avs_raw_metadata))
            )
          })
