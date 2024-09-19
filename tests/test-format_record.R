library(REDCapExporter)

# formatting the from the core

DF <- format_record(avs_raw_core)
classes <-
  c(record_id = "character",
    uniform_number = "character",
    firstname = "character",
    lastname = "character",
    hof = "integer",
    nationality = "character",
    position = "factor",
    birthdate = "Date",
    first_nhl_game = "Date",
    last_nhl_game = "Date",
    height = "integer",
    weight = "integer",
    shoots = "factor",
    catches = "factor",
    experience = "integer",
    roster_complete = "factor",
    gp = "integer",
    goals = "integer",
    assists = "integer",
    points = "numeric",
    plusmn = "integer",
    pimi = "integer",
    goals_ev = "integer",
    goals_pp = "integer",
    goals_sh = "integer",
    goals_gw = "integer",
    assists_ev = "integer",
    assists_pp = "integer",
    assists_sh = "integer",
    shots = "integer",
    shooting_percentage = "numeric",
    toi = "integer",
    atoi = "Period",
    regular_season_scoring_complete = "factor",
    wins = "integer",
    losses = "integer",
    ties_otl = "integer",
    goals_against = "integer",
    shots_against = "integer",
    saves = "integer",
    save_percentage = "numeric",
    gaa = "numeric",
    so = "integer",
    regular_season_goalies_complete = "factor",
    gp_postseason = "integer",
    goals_postseason = "integer",
    assists_postseason = "integer",
    points_postseason = "numeric",
    plusmn_postseason = "integer",
    pimi_postseason = "integer",
    goals_ev_postseason = "integer",
    goals_pp_postseason = "integer",
    goals_sh_postseason = "integer",
    goals_gw_postseason = "integer",
    assists_ev_postseason = "integer",
    assists_pp_postseason = "integer",
    assists_sh_postseason = "integer",
    shots_postseason = "integer",
    shooting_percentage_postseason = "numeric",
    toi_postseason = "integer",
    atoi_postseason = "Period",
    post_season_scoring_complete = "factor",
    wins_postseason = "integer",
    losses_postseason = "integer",
    ties_otl_postseason = "integer",
    goals_allowed_postseason = "integer",
    saves_postseason = "integer",
    save_percentage_postseason = "numeric",
    gaa_postseason = "numeric",
    so_postseason = "integer",
    post_season_goalies_complete = "factor",
    eg_checkbox___cb01 = "integer",
    eg_checkbox___cb02 = "integer",
    eg_checkbox___cb03 = "integer",
    extras_complete = "factor"
  )

stopifnot(identical(sapply(DF, class), classes))

# verify that the same result comes from calls with the same information but
# different sets of arguments
DF2 <- format_record(avs_raw_record, avs_raw_metadata)
DF3 <- format_record(avs_raw_record, col_type = col_type(avs_raw_metadata))
stopifnot(identical(DF, DF2))
stopifnot(identical(DF, DF3))

# expect an error if the project info is passed to format record
DF <- tryCatch(format_record(avs_raw_project), error = function(e) e)
stopifnot(inherits(DF, 'error'))

# expect an error when only the record is passed in
DF <- tryCatch(format_record(avs_raw_record), error = function(e) e)
stopifnot(inherits(DF, 'error'))

# expect an error when metadata is used without col_type and the metadata is not
# the correct class
DF <- tryCatch(format_record(avs_raw_record, metadata = avs_raw_core)
               , error = function(e) e)
stopifnot(inherits(DF, 'error'))

# expected and error when col_type is not null and an incorrect type
DF <- tryCatch(format_record(avs_raw_record, col_type = avs_raw_metadata), error = function(e) e)
stopifnot(inherits(DF, 'error'))

# expected and error when col_type is not null and an incorrect type even when
# meta data is provided and is correct
DF <- tryCatch(format_record(avs_raw_record, metadata = avs_raw_metadata, col_type = avs_raw_metadata), error = function(e) e)
stopifnot(inherits(DF, 'error'))

# verify that col_type(factors = FALSE) will return characters instead of
# factors
DF <- format_record(avs_raw_core, col_type = col_type(avs_raw_metadata, factors = FALSE))
classes[classes == "factor"] <- "character"
stopifnot(identical(sapply(DF, class), classes))
stopifnot(!any(sapply(DF, class) == "factor"))

# verify that you can set the timezone for the dates
DF0 <- format_record(avs_raw_core)

# this timezone specification is system and locale specific
#DF1 <- format_record(avs_raw_record, col_type = col_type(avs_raw_metadata, lubridate_args = list(tz = "US/Mountain")))
DF1 <- format_record(avs_raw_record, col_type = col_type(avs_raw_metadata, lubridate_args = list(tz = Sys.timezone())))
DF2 <- format_record(avs_raw_record, col_type = col_type(avs_raw_metadata, lubridate_args = list(tz = "UTC")))

stopifnot(inherits(DF0$birthdate, "Date"))
stopifnot(!inherits(DF1$birthdate, "Date"), inherits(DF1$birthdate, "POSIXct"), isTRUE(attr(DF1$birthdate, "tzone") == Sys.timezone()))
stopifnot(!inherits(DF2$birthdate, "Date"), inherits(DF2$birthdate, "POSIXct"), isTRUE(attr(DF2$birthdate, "tzone") == "UTC"))
