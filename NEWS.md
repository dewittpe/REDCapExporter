# Version 0.2.2

## Bug Fixes

* improved the internal `read_text` function's checking of the Content-Type from
  the raw data.

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
