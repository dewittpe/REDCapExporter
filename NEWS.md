# Version 0.1.0.9000

## Bug Fixes and Extensions

* support formating for checkboxes (integer columns in record) (#12)
* omit description text fields form auto formatting (#10)
* refactor the `format_record` so columns not explicilty defined in the
  `col_type` are returned.  Prior version would have omitted the columns.  This
  also allows for `redcap_*` columns to pass through (#9)
* Add helper functions for building and working with a keyring for storage and
  access to API tokens (#14)

# Version 0.1.0
Initial release.
