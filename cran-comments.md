# Version 0.2.1
- Initial submission 15 May 2020

## Testing Environments

* Travis CI: Ubuntu 16.04
  * R 3.6.3
  * R 4.0.0
  * R Under development (unstable) (2020-05-15 r78470)

* win-builder.r-project.org
  * R 3.6.3
  * R 4.0.0
  * R Under development (unstable) (2020-05-11 r78411)

* Local (macOS Catalina 10.15.4)

## R CMD Check results

* Travis CI -- all version of R

    Status OK

* win-builder.r-project.org -- all version of R

    Status OK

* Local

    Status OK

## Downstream dependencies

* none


# Version 0.2.0
- Initial submission 25 February 2020

## Testing Environments

* Travis CI: Ubuntu 16.04 (xenial)
  * R 3.5.3
  * R 3.6.1
  * R Under Development (unstable) (2019-12-18 r77599)

* win-builder.r-project.org

* Local (macOS Catalina 10.15.3)
  * R 3.6.2

## R CMD check results

* Travis CI -- all version of R

    Status OK

* win-builder.r-project.org -- all version of R

    Status OK

* Local

    Status OK

## Downstream dependencies
- none

# Version 0.1.0
- Initial submission 3 December 2019
- First resubmission 3 December 2019
- Second resubmission 18 December 2019

Due to the extended documentation and some redesign of the code base to support
examples which can be evaluated in interactive sessions by the end users I have
bumped the version number form the initial submission of 0.0.3 to the submitted
0.1.0.

## Testing Environments

* Travis CI: Ubuntu 16.04 (xenial)
  * R 3.5.3
  * R 3.6.1
  * R Under Development (unstable) (2019-12-18 r77599)

* win-builder.r-project.org
  * R 3.6.1
  * R Under development (unstable) (2019-12-17 r77592)

* Local (Ubuntu 18.04.3 LTS)
  * R 3.5.3
  * R 3.6.2
  * R Under Development (unstable) (2019-12-17 r77592)

## R CMD check results

* Travis CI -- all version of R

    Status OK

* win-builder -- all version of R

    New submission

    Possibly mis-spelled words in DESCRIPTION:
      REDCap (2:55, 5:58, 6:46)

REDCap is the correct style for the acronym Research Electronic Data Capture.  I
see this note on win-builder but not on the linux builds.

* Local

    Note: new submission

## Downstream dependencies
- none

## Note from CRAN from initial submission
>Thanks, we see:
>
>   Possibly mis-spelled words in DESCRIPTION:
>     formated (6:57)
>
> Please fix and resubmit.
>
> Please also add a web reference to the API in the form <[https://....]https://....> to
> the Description field.

I have corrected a spelling error in the DESCRIPTION file and added a web
reference for the API as requested.

## Note from CRAN from First resubmission

> Please do not repeat the package name in the title.

I have changed the title of the package.


> Please add missing .Rd documentation for all functions, e..g.
> write_descritption_file() in write.R

The missing documentation was for intentionally non-exported functions.
Documentation has been created for the non-exported functions:

* `write_description_file`
* `write_authors`
* `as.data.frame`
* `as.data.table`
* `read_text`

> I also suggest renaming this function to write_description_file().

Done.  Thank you for identifying the spelling error.

> Please add small executable examples in your Rd-files to illustrate the
> use of the exported function but also enable automatic testing.

I have added several data sets and redesigned some of the functions in the
package to allow for examples.  The original design required calls to an
external API.  The redesign uses snapshots of exapected returns from the API to
be used in the examples and vignettes.

> Please fix and resubmit, and document what was changed in the submission
> comments.


