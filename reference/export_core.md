# Export Core

Export Core Contents of a REDCap Project.

## Usage

``` r
export_core(uri = NULL, token = NULL, format = NULL, verbose = TRUE, ...)
```

## Arguments

- uri:

  The URI for the REDCap API. If `NULL` (default) the value
  `Sys.getenv("REDCap_API_URI")` is used.

- token:

  The API token for the project you want to export from. If `NULL`
  (default) the value `Sys.getenv("REDCap_API_TOKEN")` is used.

- format:

  The format to return. If `NULL` (default) the value
  `Sys.getenv("REDCap_API_format")` is used.

- verbose:

  provide messages to tell the user what is happening

- ...:

  not currently used

## Value

A `rcer_rccore` object: a list with the project info, metadata, user
table, and records, all in a "raw" format direct from the API.

## Examples

``` r

# A reproducible example would require a REDCap project, accessible via an
# API token.  An example of the return from these calls are provided as data
# with this package.

# avs_raw_core <- export_core()

data(avs_raw_core)
str(avs_raw_core)
#> List of 4
#>  $ project_raw : 'rcer_raw_project' chr "project_id,project_title,creation_time,production_time,in_production,project_language,purpose,purpose_other,pro"| __truncated__
#>   ..- attr(*, "url")= chr "https://redcap.ucdenver.edu/api/"
#>   ..- attr(*, "status_code")= int 200
#>   ..- attr(*, "times")= Named num [1:6] 0 0 0 0.000325 0.17077 ...
#>   .. ..- attr(*, "names")= chr [1:6] "redirect" "namelookup" "connect" "pretransfer" ...
#>   ..- attr(*, "Content-Type")= chr "text/csv; charset=utf-8"
#>   ..- attr(*, "accessed")= POSIXct[1:1], format: "2026-06-17 23:33:54"
#>  $ metadata_raw: 'rcer_raw_metadata' chr "field_name,form_name,section_header,field_type,field_label,select_choices_or_calculations,field_note,text_valid"| __truncated__
#>   ..- attr(*, "url")= chr "https://redcap.ucdenver.edu/api/"
#>   ..- attr(*, "status_code")= int 200
#>   ..- attr(*, "times")= Named num [1:6] 0 0 0 0.000238 0.229578 ...
#>   .. ..- attr(*, "names")= chr [1:6] "redirect" "namelookup" "connect" "pretransfer" ...
#>   ..- attr(*, "Content-Type")= chr "text/csv; charset=utf-8"
#>   ..- attr(*, "accessed")= POSIXct[1:1], format: "2026-06-17 23:33:54"
#>  $ user_raw    : 'rcer_raw_user' chr "username,email,firstname,lastname,expiration,data_access_group,data_access_group_id,data_access_group_label,des"| __truncated__
#>   ..- attr(*, "url")= chr "https://redcap.ucdenver.edu/api/"
#>   ..- attr(*, "status_code")= int 200
#>   ..- attr(*, "times")= Named num [1:6] 0 0 0 0.000154 0.159667 ...
#>   .. ..- attr(*, "names")= chr [1:6] "redirect" "namelookup" "connect" "pretransfer" ...
#>   ..- attr(*, "Content-Type")= chr "text/csv; charset=utf-8"
#>   ..- attr(*, "accessed")= POSIXct[1:1], format: "2026-06-17 23:33:54"
#>  $ record_raw  : 'rcer_raw_record' chr "record_id,uniform_number,firstname,lastname,hof,nationality,position,birthdate,first_nhl_game,last_nhl_game,hei"| __truncated__
#>   ..- attr(*, "url")= chr "https://redcap.ucdenver.edu/api/"
#>   ..- attr(*, "status_code")= int 200
#>   ..- attr(*, "times")= Named num [1:6] 0 0 0 0.000138 0.344835 ...
#>   .. ..- attr(*, "names")= chr [1:6] "redirect" "namelookup" "connect" "pretransfer" ...
#>   ..- attr(*, "Content-Type")= chr "text/csv; charset=utf-8"
#>   ..- attr(*, "accessed")= POSIXct[1:1], format: "2026-06-17 23:33:55"
#>  - attr(*, "class")= chr "rcer_rccore"
```
