# Version 0.0.3
- Initial submission 3 December 2019
- First resubmission 3 December 2019
- Second resubmission 10 December 2019

## Testing Environments

## R CMD check results

## Downstream dependencies
- none

## Note from CRAN from initial submission
>Thanks, we see:
>
>   Possibly mis-spelled words in DESCRIPTION:
>     formated (6:57)
>
>Please fix and resubmit.
>
>Please also add a web reference to the API in the form <[https://....]https://....> to
>the Description field.

I have corrected a spelling error in the DESCRIPTION file and added a web
reference for the API as requested.

## Note from CRAN from First resubmission

> Please do not repeat the package name in the title.

I have changed the title of the package.


>Please add missing .Rd documentation for all functions, e..g.
>write_descritption_file() in write.R

The missing documentation was for intentionally non-exported functions.
Documentation has been created for the non-exported functions:

* `write_description_file`
* `write_authors`
* `as.data.frame`
* `as.data.table`
* `read_text`

>I also suggest renaming this function to write_description_file().

Done.  Thank you for identifying the spelling error.

>Please add small executable examples in your Rd-files to illustrate the
>use of the exported function but also enable automatic testing.

>Please fix and resubmit, and document what was changed in the submission
>comments.


