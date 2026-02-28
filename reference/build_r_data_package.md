# Build R Data Package

Build a R Data Package from the core contents of a REDCap Project.

## Usage

``` r
build_r_data_package(x, ...)

# S3 method for class 'rcer_rccore'
build_r_data_package(x, path = NULL, author_roles = NULL, verbose = TRUE, ...)

# Default S3 method
build_r_data_package(
  x,
  uri = NULL,
  token = NULL,
  format = NULL,
  path = NULL,
  author_roles = NULL,
  verbose = TRUE,
  ...
)
```

## Arguments

- x:

  a `rcer_rccore` object

- ...:

  arguments passed to
  [`format_record`](http://www.peteredewitt.com/REDCapExporter/reference/format_record.md)

- path:

  Path where the exported project source will be created/overwritten.

- author_roles:

  a list naming specific roles for each user id found in the user table
  from an exported project. By default all users with be contributors
  ('ctb'). You will need to define a author/creator.

- verbose:

  provide messages to tell the user what is happening

- uri:

  The URI for the REDCap API. If `NULL` (default) the value
  `Sys.getenv("REDCap_API_URI")` is used.

- token:

  The API token for the project you want to export from. If `NULL`
  (default) the value `Sys.getenv("REDCap_API_TOKEN")` is used.

- format:

  The format to return. If `NULL` (default) the value
  `Sys.getenv("REDCap_API_format")` is used.

## Details

To export the data from a REDCap project you will need to have an API
Token. Remember, the token is the equivalent of a username and password.
As such you should not list the token in plain text. Several alternative
methods for passing the token to this method will be provided in
examples and vignettes. We strongly encourage the use of the package
secret <https://cran.r-project.org/package=secret> to build vaults to
store tokens locally.

The initial export will consist of four pieces of data, the user data,
metadata, project info, and records.

## Examples

``` r
## Please read the vignette for examples:
## vignette(topic = "export", package = "REDCapExporter")

library(REDCapExporter)
# avs_raw_core <- export_core()
data(avs_raw_core)
tmppth <- tempdir()
build_r_data_package(avs_raw_core, tmppth, author_roles = list(dewittp = c("cre", "aut")))
#> Creating source package at /tmp/Rtmp0ZkF8D/rcd14465
#> ℹ Updating rcd14465 documentation
#> First time using roxygen2. Upgrading automatically...
#> ℹ Setting RoxygenNote to "7.3.3"
#> ℹ Loading rcd14465
#> Writing NAMESPACE
#> Writing project.Rd
#> Writing metadata.Rd
#> Writing user.Rd
#> Writing record.Rd
fs::dir_tree(tmppth)
#> /tmp/Rtmp0ZkF8D
#> ├── bslib-246362e7e3ff6191071d5f9b40ba8d62
#> │   ├── bootstrap.bundle.min.js
#> │   ├── bootstrap.bundle.min.js.map
#> │   └── bootstrap.min.css
#> ├── downlit
#> │   ├── REDCapExporter
#> │   ├── base
#> │   ├── pak
#> │   ├── stats
#> │   └── utils
#> ├── file1b46252173dc
#> ├── file1b467e9cffbb
#> └── rcd14465
#>     ├── DESCRIPTION
#>     ├── LICENSE
#>     ├── NAMESPACE
#>     ├── R
#>     │   └── datasets.R
#>     ├── data
#>     │   ├── metadata.rda
#>     │   ├── project.rda
#>     │   ├── record.rda
#>     │   └── user.rda
#>     ├── inst
#>     │   └── raw-data
#>     │       ├── metadata.rds
#>     │       ├── project.rds
#>     │       ├── record.rds
#>     │       └── user.rds
#>     └── man
#>         ├── metadata.Rd
#>         ├── project.Rd
#>         ├── record.Rd
#>         └── user.Rd
```
