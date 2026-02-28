# REDCap Projects as R Data Packages

The purpose of this vignette is to show how to export a REDCap project
into a R data package.

Possible use cases for this are:

1.  You have data in a REDCap project that needs to be archived.

2.  Snapshots of REDCap projects.

3.  Sharing data with other analysts who have authority to see and work
    on the data, but for some reason may not have access to REDCap.

This vignette will assume you are able to call `export_core`
successfully. Given that call requires access to REDCap, the example
data set `avs_raw_core` is provided.

``` r
data(avs_raw_core, package = "REDCapExporter")
str(avs_raw_core)
## List of 4
##  $ project_raw : 'rcer_raw_project' chr "project_id,project_title,creation_time,production_time,in_production,project_language,purpose,purpose_other,pro"| __truncated__
##   ..- attr(*, "url")= chr "https://redcap.ucdenver.edu/api/"
##   ..- attr(*, "status_code")= int 200
##   ..- attr(*, "times")= Named num [1:6] 0 0 0 0.000115 0.179744 ...
##   .. ..- attr(*, "names")= chr [1:6] "redirect" "namelookup" "connect" "pretransfer" ...
##   ..- attr(*, "Content-Type")= chr "text/csv; charset=utf-8"
##   ..- attr(*, "accessed")= POSIXct[1:1], format: "2026-02-28 16:03:22"
##  $ metadata_raw: 'rcer_raw_metadata' chr "field_name,form_name,section_header,field_type,field_label,select_choices_or_calculations,field_note,text_valid"| __truncated__
##   ..- attr(*, "url")= chr "https://redcap.ucdenver.edu/api/"
##   ..- attr(*, "status_code")= int 200
##   ..- attr(*, "times")= Named num [1:6] 0 0 0 0.00011 0.17918 ...
##   .. ..- attr(*, "names")= chr [1:6] "redirect" "namelookup" "connect" "pretransfer" ...
##   ..- attr(*, "Content-Type")= chr "text/csv; charset=utf-8"
##   ..- attr(*, "accessed")= POSIXct[1:1], format: "2026-02-28 16:03:22"
##  $ user_raw    : 'rcer_raw_user' chr "username,email,firstname,lastname,expiration,data_access_group,data_access_group_id,design,alerts,user_rights,d"| __truncated__
##   ..- attr(*, "url")= chr "https://redcap.ucdenver.edu/api/"
##   ..- attr(*, "status_code")= int 200
##   ..- attr(*, "times")= Named num [1:6] 0 0 0 0.000112 0.207088 ...
##   .. ..- attr(*, "names")= chr [1:6] "redirect" "namelookup" "connect" "pretransfer" ...
##   ..- attr(*, "Content-Type")= chr "text/csv; charset=utf-8"
##   ..- attr(*, "accessed")= POSIXct[1:1], format: "2026-02-28 16:03:22"
##  $ record_raw  : 'rcer_raw_record' chr "record_id,uniform_number,firstname,lastname,hof,nationality,position,birthdate,first_nhl_game,last_nhl_game,hei"| __truncated__
##   ..- attr(*, "url")= chr "https://redcap.ucdenver.edu/api/"
##   ..- attr(*, "status_code")= int 200
##   ..- attr(*, "times")= Named num [1:6] 0 0 0 0.000231 0.287257 ...
##   .. ..- attr(*, "names")= chr [1:6] "redirect" "namelookup" "connect" "pretransfer" ...
##   ..- attr(*, "Content-Type")= chr "text/csv; charset=utf-8"
##   ..- attr(*, "accessed")= POSIXct[1:1], format: "2026-02-28 16:03:22"
##  - attr(*, "class")= chr "rcer_rccore"
```

`avs_raw_core` is the result of calling `export_core` and contains data
on the 2000-2001 Stanley Cup Champion Colorado Avalanche. The data was
transcribed from [Hockey
Reference](https://www.hockey-reference.com/teams/COL/2001.html) into a
REDCap Project hosed at the University of Colorado Denver.

## Exporting a REDCap Project to a R Data Package

Exporting a REDCap project to a R data package is done with a call to
`build_r_data_package`. If the user passes the uri for the API and an
API token a call to `export_core` will be made. Alternatively,
`build_r_data_package` is an S3 method and can be applied to a
`rcer_rccore` object.

To build the skeleton of a R data package you will need to pass in the
core export from the REDCap project, a path for were the source code for
the data package will be written, and some some information about the
users. In this context, users are the persons who have, or had, access
to the REDCap project and are listed under the UserRights section of the
REDCap project. The user data from REDCap is used to construct the
Author section of the DESCRIPTION file for the R data package to be
constructed. By default, all users are listed as ‘contributors’.
Modification of the roles can be provide by a named list object. In the
example below, the user dewittp is going to assigned the creator and
author role. To be a valid R package, at least one user will need to
have the creator role assigned.

``` r
temppath <- tempdir()

build_r_data_package(
  x            = avs_raw_core,
  path         = temppath,
  author_roles = list(dewittp = c("cre", "aut"))
)
## Creating source package at /tmp/RtmpUdhb7k/rcd14465
## ℹ Updating rcd14465 documentation
## First time using roxygen2. Upgrading automatically...
## ℹ Setting RoxygenNote to "7.3.3"
## ℹ Loading rcd14465
## Writing NAMESPACE
## Writing project.Rd
## Writing metadata.Rd
## Writing user.Rd
## Writing record.Rd
```

The resulting directory is: echo = FALSE, results = “markup”

``` r
fs::dir_tree(temppath)
## /tmp/RtmpUdhb7k
## ├── file1cca157d000
## ├── file1cca19f3b71e
## ├── file1cca3036cf7d
## ├── rcd14465
## │   ├── DESCRIPTION
## │   ├── LICENSE
## │   ├── NAMESPACE
## │   ├── R
## │   │   └── datasets.R
## │   ├── data
## │   │   ├── metadata.rda
## │   │   ├── project.rda
## │   │   ├── record.rda
## │   │   └── user.rda
## │   ├── inst
## │   │   └── raw-data
## │   │       ├── metadata.rds
## │   │       ├── project.rds
## │   │       ├── record.rds
## │   │       └── user.rds
## │   └── man
## │       ├── metadata.Rd
## │       ├── project.Rd
## │       ├── record.Rd
## │       └── user.Rd
## └── rmarkdown-str1cca627e2ab7.html
```

### Details on exported Files

First, the package directory name. Exported packages from
*REDCapExporter* will have the directory name rcd. This name is also
used in the DESCRIPTION file.

The DESCRIPTION file is

``` r
prj_dir <- list.dirs(temppath)
prj_dir <- prj_dir[grepl("/rcd\\d+$", prj_dir)]
t(read.dcf(paste(prj_dir, "DESCRIPTION", sep = "/")))
##                 [,1]                                                                                                                                                                                                                                                                                                                                                      
## Package         "rcd14465"                                                                                                                                                                                                                                                                                                                                                
## Title           "2000-2001 Colorado Avalanche"                                                                                                                                                                                                                                                                                                                            
## Version         "2026.02.28.16.47"                                                                                                                                                                                                                                                                                                                                        
## Authors@R       "c(person(given = \"Tell\", family = \"Bennett\", email = \"tell.bennett@ucdenver.edu\", role = c(\"ctb\")),\nperson(given = \"Peter\", family = \"DeWitt\", email = \"peter.dewitt@cuanschutz.edu\", role = c(\"cre\", \"aut\")),\nperson(given = \"Alexandria\", family = \"Jensen\", email = \"alexandria.jensen@cuanschutz.edu\", role = c(\"ctb\")))"
## Description     "Data and documentation from the REDCap Project."                                                                                                                                                                                                                                                                                                         
## License         "file LICENSE"                                                                                                                                                                                                                                                                                                                                            
## Encoding        "UTF-8"                                                                                                                                                                                                                                                                                                                                                   
## LazyData        "true"                                                                                                                                                                                                                                                                                                                                                    
## Suggests        "knitr"                                                                                                                                                                                                                                                                                                                                                   
## VignetteBuilder "knitr"                                                                                                                                                                                                                                                                                                                                                   
## RoxygenNote     "7.3.3"
```

The title comes from the project info recorded in REDCap. The version
number is set as the year.month.day.hour.minute of the export. As noted
above, the Author field is built from the user data stored in REDCap.

The LICENSE file notes that the package is proprietary and should not be
installed or distributed to others who are not authorized to have access
to the data.

``` r
cat(readLines(paste(prj_dir[1], "LICENSE", sep = "/")), sep = "\n")
## Proprietary
## 
## 
##       Do not distribute to anyone or to machines which are not authorized to hold the data.
```

The raw data exports are stored as .rds files under inst/raw-data so
that these files will be available in R sessions after installing the
package.

The data directory has data.frame versions of the data sets.

The R/datasets.R file provides the documentation for the data sets which
can be accessed in an interactive R session.

### Using the Exported Package

Let’s install the package and explore the contents.

``` r
tar_ball <- devtools::build(pkg = prj_dir)
## ── R CMD build ─────────────────────────────────────────────────────────────────
## * checking for file ‘/tmp/RtmpUdhb7k/rcd14465/DESCRIPTION’ ... OK
## * preparing ‘rcd14465’:
## * checking DESCRIPTION meta-information ... OK
## * checking for LF line-endings in source and make files and shell scripts
## * checking for empty or unneeded directories
##   NB: this package now depends on R (>= 3.5.0)
##   WARNING: Added dependency on R >= 3.5.0 because serialized objects in
##   serialize/load version 3 cannot be read in older versions of R.
##   File(s) containing such objects:
##     ‘rcd14465/data/metadata.rda’ ‘rcd14465/data/project.rda’
##     ‘rcd14465/data/record.rda’ ‘rcd14465/data/user.rda’
##     ‘rcd14465/inst/raw-data/metadata.rds’
##     ‘rcd14465/inst/raw-data/project.rds’
##     ‘rcd14465/inst/raw-data/record.rds’ ‘rcd14465/inst/raw-data/user.rds’
## * building ‘rcd14465_2026.02.28.16.47.tar.gz’
tar_ball
## [1] "/tmp/RtmpUdhb7k/rcd14465_2026.02.28.16.47.tar.gz"

install.packages(pkgs = tar_ball, lib = temppath)
## inferring 'repos = NULL' from 'pkgs'
```

``` r
library(rcd14465, lib.loc = temppath)
```

The available data sets:

``` r
data(package = "rcd14465")$results
##      Package    LibPath           Item       Title     
## [1,] "rcd14465" "/tmp/RtmpUdhb7k" "metadata" "Metadata"
## [2,] "rcd14465" "/tmp/RtmpUdhb7k" "project"  "Project" 
## [3,] "rcd14465" "/tmp/RtmpUdhb7k" "record"   "Record"  
## [4,] "rcd14465" "/tmp/RtmpUdhb7k" "user"     "User"
```

A simple data analysis question: how many goals were scored by position?

``` r
aggregate(goals ~ position, data = record, FUN = sum)
##     position goals
## 1       Goal     0
## 2  Left Wing    71
## 3 Right Wing    72
## 4     Center    93
## 5    Defence    34
```
