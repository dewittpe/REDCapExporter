# avs-export.R
#
# expected working directory is the project root
#
# Purpose: extract example REDCap data via the REDCap API and save the data in
# the package for use in examples and vignettes.
#
# library(secret)
# Sys.setenv(USER_KEY = "~/.ssh/vaults")
source("./R/export_redcap_project.R")
source("./R/keyring.R")

REDCapExporter_keyring_check()
REDCapExporter_add_api_token("2000_2001_Avalanche")
REDCapExporter_get_api_token("2000_2001_Avalanche")

Sys.setenv(REDCap_API_URI = "https://redcap.ucdenver.edu/api/")
Sys.setenv(REDCap_API_TOKEN = REDCapExporter_get_api_token("2000_2001_Avalanche"))

avs_raw_project <- export_content(content = "project",  format = "csv")
avs_raw_metadata     <- export_content(content = "metadata", format = "csv")
avs_raw_user         <- export_content(content = "user",     format = "csv")
avs_raw_record       <- export_content(content = "record",   format = "csv")
avs_raw_core         <- export_core(format = "csv")

save(avs_raw_project, file = "./data/avs_raw_project.rda")
save(avs_raw_metadata,     file = "./data/avs_raw_metadata.rda")
save(avs_raw_user,         file = "./data/avs_raw_user.rda")
save(avs_raw_record,       file = "./data/avs_raw_record.rda")
save(avs_raw_core,         file = "./data/avs_raw_core.rda")

avs_raw_project_json <- export_content(content = "project",  format = "json")
avs_raw_metadata_json     <- export_content(content = "metadata", format = "json")
avs_raw_user_json         <- export_content(content = "user",     format = "json")
avs_raw_record_json       <- export_content(content = "record",   format = "json")
avs_raw_core_json         <- export_core(format = "json")

save(avs_raw_project_json, file = "./data/avs_raw_project_json.rda")
save(avs_raw_metadata_json,     file = "./data/avs_raw_metadata_json.rda")
save(avs_raw_user_json,         file = "./data/avs_raw_user_json.rda")
save(avs_raw_record_json,       file = "./data/avs_raw_record_json.rda")
save(avs_raw_core_json,         file = "./data/avs_raw_core_json.rda")
