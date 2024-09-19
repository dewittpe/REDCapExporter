library(REDCapExporter)

# Test if a new keyring can be built
kr <- keyring::backend_file$new()
try(kr$keyring_delete("testingring"), silent = TRUE)
#kr$keyring_create(password = "")
#kr$keyring_list()

x <- tryCatch(REDCapExporter_keyring_check("testingring"), message = function(m) {m})
stopifnot(identical(x$message, "File based keyring testingring has been created\n"))
x <- tryCatch(REDCapExporter_keyring_check("testingring"), message = function(m) {m})
stopifnot(identical(x$message, "File based keyring testingring exists\n"))
stopifnot(isTRUE(REDCapExporter_keyring_check("testingring")))

# Expect that this will error because we are not interactive and a password
# prompt cannot be filled in
x <-
  tryCatch(
    REDCapExporter_add_api_token(project = 'testingproject', keyring = 'testingring'),
    error = function(e) e
  )

stopifnot(inherits(x, "error"))
stopifnot(isTRUE(grepl("Aborted setting keyring key", x$message)))

# expect the get api token to fail as the token for the testingproject has not
# been set
x <-
  tryCatch(
           REDCapExporter_get_api_token(project = 'testingproject', keyring = 'testingring'),
    error = function(e) e
  )

stopifnot(inherits(x, "error"))
stopifnot(isTRUE(grepl("specified item could not be found in the keychain", x$message)))

# create token
kr$set_with_value(service = "testingproject", password = "testingTOKEN", keyring = "testingring")

# verify you can get the token
stopifnot(
  identical(
    REDCapExporter_get_api_token(project = 'testingproject', keyring = 'testingring')
    ,
    "testingTOKEN"
    ))


# the REDCapExporter_add_api_token should return a message that the token
# already exists
stopifnot(
  REDCapExporter_add_api_token(project = 'testingproject', keyring = 'testingring')
)

x <- tryCatch(
  REDCapExporter_add_api_token(project = 'testingproject', keyring = 'testingring'),
  message = function(m) {m}
)

stopifnot(isTRUE(grepl("API token exisits", x$message)))

