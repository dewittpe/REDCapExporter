# Export Content

Export specific data elements from REDCap

## Usage

``` r
export_content(content, uri = NULL, token = NULL, format = NULL, ...)
```

## Arguments

- content:

  The element to export, see Details.

- uri:

  The URI for the REDCap API. If `NULL` (default) the value
  `Sys.getenv("REDCap_API_URI")` is used.

- token:

  The API token for the project you want to export from. If `NULL`
  (default) the value `Sys.getenv("REDCap_API_TOKEN")` is used.

- format:

  The format to return. If `NULL` (default) the value
  `Sys.getenv("REDCap_API_format")` is used.

- ...:

  additional arguments passed to
  [`handle_setform`](https://jeroen.r-universe.dev/curl/reference/handle.html).

## Value

The raw return from the REDCap API with the class `rcer_raw_<content>`.

## Details

The `content` and `format` arguments are used to control the specific
items to be exported, and in what format. \*\*Review the API
documentation\*\*

The `uri`, `token`, and `format` arguments are set to `NULL` by default
and will look to the `Sys.getenv("REDCap_API_URI")`,
`Sys.getenv("REDCap_API_TOKEN")`, and `Sys.getenv("REDCap_API_format")`,
respectively, to define the values if not explicitly done so by the end
user.

## Examples

``` r
# A reproducible example would require a REDCap project, accessible via an
# API token.  An example of the return from these calls are provided as data
# with this package.

# avs_raw_metadata <- export_content(content = "metadata")
data(avs_raw_metadata)
str(avs_raw_metadata)
#>  'rcer_raw_metadata' chr "field_name,form_name,section_header,field_type,field_label,select_choices_or_calculations,field_note,text_valid"| __truncated__
#>  - attr(*, "url")= chr "https://redcap.ucdenver.edu/api/"
#>  - attr(*, "status_code")= int 200
#>  - attr(*, "times")= Named num [1:6] 0 0 0 0.0001 0.3102 ...
#>   ..- attr(*, "names")= chr [1:6] "redirect" "namelookup" "connect" "pretransfer" ...
#>  - attr(*, "Content-Type")= chr "text/csv; charset=utf-8"
#>  - attr(*, "accessed")= POSIXct[1:1], format: "2026-02-28 16:03:21"
```
