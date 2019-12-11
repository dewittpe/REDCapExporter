library(secret)
Sys.setenv(USER_KEY = "~/.ssh/vaults")
Sys.setenv(REDCap_API_URI = "https://redcap.ucdenver.edu/api/")
Sys.setenv(REDCap_API_TOKEN = get_secret("2000_2001_Avalanche"))
source("../R/export_redcap_project.R")

avs_raw_project_info <- export_content(content = "project")
avs_raw_metadata     <- export_content(content = "metadata")
avs_raw_user         <- export_content(content = "user")
avs_raw_record       <- export_content(content = "record")

save(avs_raw_project_info, file = "../data/avs_raw_project_info.rda")
save(avs_raw_metadata,     file = "../data/avs_raw_metadata.rda")
save(avs_raw_user,         file = "../data/avs_raw_user.rda")
save(avs_raw_record,       file = "../data/avs_raw_record.rda")

cat("#' Raw Exports From an Example REDCap Project",
    "#'",
    "#' @name example_data",
    "NULL",
    "",
    "#' @rdname example_data",
    "\"avs_raw_project_info\"",
    "",
    "#' @rdname example_data",
    "\"avs_raw_metadata\"",
    "",
    "#' @rdname example_data",
    "\"avs_raw_user\"",
    "",
    "#' @rdname example_data",
    "\"avs_raw_record\"",
    sep = "\n",
    file = "../R/datasets.R"
    )


