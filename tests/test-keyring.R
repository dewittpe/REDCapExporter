library(REDCapExporter)

keyring_dir <- file.path(tempdir(), paste0("redcapexporter-keyring-", Sys.getpid()))
dir.create(keyring_dir, showWarnings = FALSE, recursive = TRUE)
op <- options(keyring_file_dir = keyring_dir)
on.exit(options(op), add = TRUE)
on.exit(unlink(keyring_dir, recursive = TRUE, force = TRUE), add = TRUE)

kr <- keyring::backend_file$new()

keyring_name <- paste0("testingring_", Sys.getpid())
service_name <- paste0("testingproject_", Sys.getpid())

# cleanup on exit
try(kr$keyring_delete(keyring_name), silent = TRUE)

# keyring can be created or verified
msg1 <- NULL
withCallingHandlers(
  {
    ok1 <- REDCapExporter_keyring_check(keyring_name)
  },
  message = function(m) {
    msg1 <<- conditionMessage(m)
    invokeRestart("muffleMessage")
  }
)

stopifnot(
  isTRUE(ok1),
  grepl("File based keyring", msg1),
  grepl(keyring_name, msg1),
  grepl("created|exists", msg1)
)

msg2 <- NULL
withCallingHandlers(
  {
    ok2 <- REDCapExporter_keyring_check(keyring_name)
  },
  message = function(m) {
    msg2 <<- conditionMessage(m)
    invokeRestart("muffleMessage")
  }
)

stopifnot(
  isTRUE(ok2),
  grepl("File based keyring", msg2),
  grepl(keyring_name, msg2),
  grepl("exists", msg2)
)

# Adding a token interactively should fail in non-interactive checks
err_add <- tryCatch(
  REDCapExporter_add_api_token(
    project = service_name,
    keyring = keyring_name
  ),
  error = function(e) e
)

stopifnot(inherits(err_add, "error"))

# Missing token should error
err_get_missing <- tryCatch(
  REDCapExporter_get_api_token(
    project = service_name,
    keyring = keyring_name
  ),
  error = function(e) e
)

stopifnot(inherits(err_get_missing, "error"))

# Set token directly through keyring backend
kr$keyring_unlock(keyring = keyring_name, password = "")
kr$set_with_value(
  service = service_name,
  password = "testingTOKEN",
  keyring = keyring_name
)
kr$keyring_lock(keyring = keyring_name)

# verify you can get the token
stopifnot(identical(
  REDCapExporter_get_api_token(
    project = service_name,
    keyring = keyring_name
  ),
  "testingTOKEN"
))

# verify add_api_token short-circuits when token exists
msg3 <- NULL
withCallingHandlers(
  {
    ok3 <- REDCapExporter_add_api_token(
      project = service_name,
      keyring = keyring_name
    )
  },
  message = function(m) {
    msg3 <<- conditionMessage(m)
    invokeRestart("muffleMessage")
  }
)

stopifnot(
  isTRUE(ok3),
  grepl("API token exists", msg3)
)

# cleanup
try(kr$key_delete(service = service_name, keyring = keyring_name), silent = TRUE)
try(kr$keyring_delete(keyring_name), silent = TRUE)
