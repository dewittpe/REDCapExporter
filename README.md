# REDCapExporter

[![Build Status](https://travis-ci.com/dewittpe/REDCapExporter.svg?branch=master)](https://travis-ci.com/dewittpe/REDCapExporter)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/REDCapExporter)](https://cran.r-project.org/package=REDCapExporter)
[![CRAN RStudio mirror downloads](http://cranlogs.r-pkg.org/badges/REDCapExporter)](http://www.r-pkg.org/pkg/REDCapExporter)
[![CRAN RStudio mirror downloads](http://cranlogs.r-pkg.org/badges/grand-total/REDCapExporter)](http://www.r-pkg.org/pkg/REDCapExporter)
[![minimal R version](https://img.shields.io/badge/R%3E%3D-3.0.2-6666ff.svg)](https://cran.r-project.org/)

Download the data from a [REDCap](https://www.project-redcap.org/)
project and package the data into a useful R data package.

## Project Goals

While REDCap (*R*esearch *E*lectronic *D*ata *Cap*ture) is a fantastic tool for
data capture, the dissemination of the collected data in a format that multiple
data analysis can easily access and share can be improved.  The REDCapExporter
is a tool that will collect the data and generate a source R data package.  With
continued use, analysts will gain the following:

* A consistent documentation format for the collected data

* A consistent format/storage mode for REDCap data

* A set of tools to help easily clean collected data.

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

For example, in a R analysis script, the analysis can verify the version of
any package via the following:

    packageVersion("<pkg_name>", lib.loc = "<path>") <= "2.1"

The above will return `TRUE` or `FALSE`.  As such, the above can be the argument
in an `if()` statement.  If `FALSE`, `stop()` call can be used to stop the
scripts and let the analyst know the package (data) version is not as expected.

    # TODO, example of pkg_check, once it has been built



