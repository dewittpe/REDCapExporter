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
#> Creating source package at /tmp/RtmpLXobhx/rcd14465
#> ℹ Loading rcd14465
#> Writing NAMESPACE
#> Writing project.Rd
#> Writing metadata.Rd
#> Writing user.Rd
#> Writing record.Rd
list.files(tmppth, recursive = TRUE, all.files = TRUE, no.. = TRUE)
#>  [1] "bslib-71d7f13118c36706c39339f77436fb7b/.sass_cache_keys"           
#>  [2] "bslib-71d7f13118c36706c39339f77436fb7b/bootstrap.bundle.min.js"    
#>  [3] "bslib-71d7f13118c36706c39339f77436fb7b/bootstrap.bundle.min.js.map"
#>  [4] "bslib-71d7f13118c36706c39339f77436fb7b/bootstrap.min.css"          
#>  [5] "downlit/REDCapExporter"                                            
#>  [6] "downlit/base"                                                      
#>  [7] "downlit/pak"                                                       
#>  [8] "downlit/stats"                                                     
#>  [9] "downlit/utils"                                                     
#> [10] "file1adb1e5cbd8c"                                                  
#> [11] "file1adb46919aa4"                                                  
#> [12] "rcd14465/DESCRIPTION"                                              
#> [13] "rcd14465/LICENSE"                                                  
#> [14] "rcd14465/NAMESPACE"                                                
#> [15] "rcd14465/R/datasets.R"                                             
#> [16] "rcd14465/data/metadata.rda"                                        
#> [17] "rcd14465/data/project.rda"                                         
#> [18] "rcd14465/data/record.rda"                                          
#> [19] "rcd14465/data/user.rda"                                            
#> [20] "rcd14465/inst/raw-data/metadata.rds"                               
#> [21] "rcd14465/inst/raw-data/project.rds"                                
#> [22] "rcd14465/inst/raw-data/record.rds"                                 
#> [23] "rcd14465/inst/raw-data/user.rds"                                   
#> [24] "rcd14465/man/metadata.Rd"                                          
#> [25] "rcd14465/man/project.Rd"                                           
#> [26] "rcd14465/man/record.Rd"                                            
#> [27] "rcd14465/man/user.Rd"                                              
```
