# Write DESCRIPTION File from REDCap Metadata

Create the DESCRIPTION file for the R data package based on an exported
REDCap project.

## Usage

``` r
write_description_file(access_time, user, roles, project_info, path)

write_authors(user, roles = NULL)
```

## Arguments

- access_time:

  The [`Sys.time()`](https://rdrr.io/r/base/Sys.time.html) when the API
  calls were made

- user:

  User(s), as noted in the REDCap project metadata. This parameter is
  singular as it refers to the "user" content one can access from the
  REDCap API.

- roles:

  roles the `user` holds with respect to the R data package. These roles
  have no relationship to REDCap roles.

- project_info:

  project metadata

- path:

  path to the root for the generated R data package.

## Details

This is a non-exported function and is not expected to be called by the
end user.

`write_description_file` creates the DESCRIPTION file for the exported R
data package and `write_authors` creates the "Authors@R" field of the
DESCRIPTION based on the "user" data extracted from the REDCap project.
