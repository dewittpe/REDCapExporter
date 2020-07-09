# REDCapExporter

![R-CMD-check](https://github.com/dewittpe/REDCapExporter/workflows/R-CMD-check/badge.svg)
[![codecov](https://codecov.io/gh/dewittpe/REDCapExporter/branch/master/graph/badge.svg)](https://codecov.io/gh/dewittpe/REDCapExporter)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/REDCapExporter)](https://cran.r-project.org/package=REDCapExporter)
[![CRAN RStudio mirror downloads](http://cranlogs.r-pkg.org/badges/REDCapExporter)](http://www.r-pkg.org/pkg/REDCapExporter)
[![CRAN RStudio mirror downloads](http://cranlogs.r-pkg.org/badges/grand-total/REDCapExporter)](http://www.r-pkg.org/pkg/REDCapExporter)

Download the data from a [REDCap](https://www.project-redcap.org/)
project and package the data into a useful R data package.

## Project Goals

While REDCap (**R**esearch **E**lectronic **D**ata **Cap**ture) is a fantastic
tool for data capture, the dissemination of the collected data in a format that
multiple data analysis can easily access and share can be improved.  The
REDCapExporter package provides a set of tools to provide easy access to REDCap
data via the REDCap API with two aims:

1. Scripting functions to allow for easy access to, and formatting of, a data
   set within a REDCap project.
2. Produce a skeleton R data package to house, document, archive, and
   disseminate a data set.

### Why is this tool needed?

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

