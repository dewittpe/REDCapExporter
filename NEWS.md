# Version 0.3.3

## Testing Change

* The API used for testing is no longer working.  The test as been removed from
  this version of the package so the package can stay on CRAN while a better
  solution is found. (#18)

## Minor changes

* Fix spelling in documenttation

# Version 0.3.2

* fix issue in test-export.R - it could/would fail if there was a time out
  related to CURL.  Fix looks for an error and if the error is curl related the
  testing is skipped.  Other errors will still be thrown.

    > archer01_csv  <- export_core(uri = 'https://bbmc.ouhsc.edu/redcap/api/', token = '9A81268476645C4E5F03428B8AC3AA7B')
    Getting Project Info
    Error in curl::curl_fetch_memory(uri, handle = h) :
      Timeout was reached [bbmc.ouhsc.edu]:
    Connection timed out after 10001 milliseconds
    Calls: export_core ... export_content -> <Anonymous> -> raise_libcurl_error
    Execution halted

# Version 0.3.1

## Bug fix
* modify code in R/as.R to not use the `|>` operator so that the package code
  has more backward compatibility.

# Version 0.3.0

* updated source code to address deprecated roxygen2 documentation tags
* Extend the col_types to use lubridate arguments for working with dates and
  datetimes
* Add a vignette about formatting
* remove `as.data.table` only return data.frames.  End users can then coerce the
  data.frame to a tibble or data.table if they prefer.
* add additional columns to the example data to test and demonstrate the use of
  the package

## Bug Fixes

* improved the internal `read_text` function's checking of the Content-Type from
  the raw data.

* formatting of data from json

* col_type handling of checkboxes

* col_type correctly sets character instead of factor for "completed" fields

# Version 0.2.2

## Extensions

* made `format_record` a S3 generic.
  * Allows for a similar API as prior version
    * __USER VISIBLE CHANGE__  the functional argument `record` no longer
      exists, use the generic argument `x`
  * Allows for easier use by taking in a `rcer_rccore` object so the `metadata`
    or the `col_type` does not need to be explicitly defined.

# Version 0.2.1

## Bug Fixes

* The dependence on the RCurl package resulted in SSL errors on Windows.  The
  package no longer imports RCurl and uses curl instead.  (#16)

# Version 0.2.0

## Bug Fixes and Extensions

* support formatting for check boxes (integer columns in record) (#12)
* omit description text fields form auto formatting (#10)
* refactoring the `format_record` so columns not explicitly defined in the
  `col_type` are returned.  Prior version would have omitted the columns.  This
  also allows for `redcap_*` columns to pass through (#9)
* Add helper functions for building and working with a keyring for storage and
  access to API tokens (#14)
* Support more, if not all, column types (#15)

# Version 0.1.0
Initial release.
