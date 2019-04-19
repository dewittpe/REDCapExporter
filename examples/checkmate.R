#### testing and dev work
devtools::load_all()
library(data.table)
library(magrittr)
library(secret)
library(qwraps2)

options("datatable.print.topn"  = 3)
options("datatable.print.nrows" = 6)

# Set the private key needed to access the vault, if needed.
Sys.setenv(USER_KEY = "~/.ssh/vaults")

# REDCap API uri and token
Sys.setenv(REDCap_API_URI = "https://redcap.ucdenver.edu/api/")
Sys.setenv(REDCap_API_TOKEN = get_secret("2000_2001_Avalanche"))

avs_raw_metadata     <- export_content(content = "metadata")
x <- avs_metadata <- as.data.table(avs_raw_metadata)
avs_metadata[, c(4, 8)]

free_form_text(x)
form_length(x)
