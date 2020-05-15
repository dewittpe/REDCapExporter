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
