# Set up and use of a Keyring for REDCap API Tokens

Tools for checking for, and setting up, a file based keyring for storing
REDCap API tokens.

## Usage

``` r
REDCapExporter_keyring_check(keyring = "REDCapExporter", password = NULL)

REDCapExporter_add_api_token(
  project,
  keyring = "REDCapExporter",
  user = NULL,
  password = NULL,
  overwrite = FALSE
)

REDCapExporter_get_api_token(
  project,
  keyring = "REDCapExporter",
  user = NULL,
  password = NULL
)
```

## Arguments

- keyring:

  a character vector identifying the name of the keyring, defaults to
  `"REDCapExporter"`

- password:

  This is the password for the keyring. The default is an empty
  password.

- project:

  the name of the REDCap project the API token is identified by.

- user:

  user name to associate the token with. Defaults to
  `Sys.info()[["user"]]`.

- overwrite:

  logical, if `TRUE` overwrite the existing token.

## Value

`REDCapExporter_keyring_check` returns `TRUE`, invisibly, as does
`REDCapExporter_add_api_token`. `REDCapExporter_get_api_token` returns
the token invisibly as not to print the value to the console by default.
Still, be careful with your token.

## See also

[`vignette(topic = "api", package = "REDCapExporter")`](http://www.peteredewitt.com/REDCapExporter/articles/api.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# Check if a keyring exists. If it does not, create one.
REDCapExporter_keyring_check()

# add token if it does not already exist.  If a token
# already exists, then you will be told so unless overwrite is set to TRUE
REDCapExporter_add_api_token("Project1")

# get a token and set as an environmental variable
Sys.setenv(REDCap_API_TOKEN = REDCapExporter_get_api_token("Project1"))
} # }
```
