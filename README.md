<!-- README.md is generated from README.Rmd. Please edit that file -->



# REDCapExporter

<!-- badges: start -->
![R-CMD-check](https://github.com/dewittpe/REDCapExporter/workflows/R-CMD-check/badge.svg)
[![Codecov test coverage](https://codecov.io/gh/dewittpe/REDCapExporter/graph/badge.svg)](https://app.codecov.io/gh/dewittpe/REDCapExporter)
[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/REDCapExporter)](https://cran.r-project.org/package=REDCapExporter)
[![CRAN RStudio mirror downloads](https://cranlogs.r-pkg.org/badges/REDCapExporter)](http://www.r-pkg.org/pkg/REDCapExporter)
[![CRAN RStudio mirror downloads](https://cranlogs.r-pkg.org/badges/grand-total/REDCapExporter)](http://www.r-pkg.org/pkg/REDCapExporter)
<!-- badges: end -->

The goal of REDCapExporter is to provide a simple and relativley secure way to
downloading and formating data from a [REDCap](https://www.project-redcap.org/)
project.

While REDCap (**R**esearch **E**lectronic **D**ata **Cap**ture) is a fantastic
tool for data capture, the dissemination of the collected data in a format that
multiple data analysis can easily access and share can be improved.  The
REDCapExporter package provides a set of tools to provide easy access to REDCap
data via the REDCap API with two aims:

1. Scripting functions to allow for easy access to, and formatting of, a data
   set within a REDCap project.
2. Produce a skeleton R data package to house, document, archive, and
   disseminate a data set.

_Why is REDCapExporter needed?_

If you are familiar with REDCap then you know that exporting the data from the
web interface is straight forward, easy to use, and powerful.  However, there is
a fair amount of (meta) data that could be valuable to data analysis which is
not included in the export.  The REDCapExporter aims to report and cross link
the meta data, collected data, and (expanded) documentation in one location.
The resulting `.tar.gz` data package is easy to disseminate.

Version control of data is difficult.  Small data files can easily be added to
git repositories, and larger files using git-lfs.  Subversion can handle larger
data sets with its own pros and cons.  However, adding the data to multiple
repositories will consume a lot of disk space unnecessarily  and there are issues
arising from sensitive data being versioned and while using public repository
hosts.  A R data package will provide an implicit versioning of data while
keeping only one copy of the data on the local disk.

## Installation

Install the released version from CRAN:

``` r
install.packages("REDCapExporter", repos = "https://cran.rstudio.com")
```

You can install the development version of REDCapExporter from
[GitHub](https://github.com/) with:


``` r
# install.packages("pak")
pak::pak("dewittpe/REDCapExporter")
```

## Expected Use Case

You have multiple REDCap projects and you have an API token for each project
allowing for data download.

### Dealing with API Tokens

There are several ways to do this.  A simple way is based on the
[keyring](https://keyring.r-lib.org/) package.


``` r
library(REDCapExporter)

# Check if a file based keyring called "REDCapExporter" exists and create one if
# not.
REDCapExporter_keyring_check()

# Add, or verify existance of, an API token for PROJECT1
REDCapExporter_add_api_token("PROJECT1")

# Add, or verify existance of, an API token for PROJECT2
REDCapExporter_add_api_token("PROJECT2")
```

To set the token to use for the current session, 
set an environmental variable and use
`REDCapExporter_get_api_token` to retrive the token from the keyring.


``` r
Sys.setenv(REDCap_API_TOKEN = REDCapExporter_get_api_token("PROJECT1"))
```

### Export data from REDCap

You may set one more environmental variable, or specify it explicitly in the call
to `export_core`.  It is recommended to set the environmental variable for easy
of use.


``` r
Sys.setenv(REDCap_API_URI = "https://<your-redcap-domain>/api/")
```

Export the data from REDCap and format it, based on the metadata of the REDCap
project via:


``` r
project1_redcap_core <- export_core()
project1 <- format_record(project1_redcap_core)
```

### Example

The example data provided in this package are statistics from the 2000-2001
National Hockey League Stanley Cup Champion Colorado Avalanche.  The data was
transcribed from [Hockey Reference](https://www.hockey-reference.com/teams/COL/2001.html)
into a REDCap Project hosed at the University of Colorado Denver.

The data set `avs_raw_core` was generated via the following, after setting up my
keyring and token as described above.

``` r
library(REDCapExporter)
Sys.setenv(REDCap_API_URI = "https://redcap.ucdenver.edu/api/")
Sys.setenv(REDCap_API_TOKEN = REDCapExporter_get_api_token("2000_2001_Avalanche"))
avs_raw_core <- export_core()
#> Getting Project Info
#> Getting project metadata
#> Getting user data
#> Getting project record
avsDF <- format_record(avs_raw_core)
```

A simple summary statistic from the data set: the number of goals scored by
position:


``` r
aggregate(goals ~ position, data = avsDF, FUN = sum)
#>     position goals
#> 1       Goal     0
#> 2  Left Wing    71
#> 3 Right Wing    72
#> 4     Center    93
#> 5    Defence    34
```









