test_that("format_record is same dim as unformated data.frame",
          {
            expect_equal(
                         dim(as.data.frame(avs_raw_record))
                         ,
                         dim(format_record(avs_raw_record, avs_raw_metadata, class = "data.frame"))
            )
          })

test_that("S4 classes in data.table returns a warning",
          {
            expect_warning(format_record(avs_raw_core, class = "data.table"))
            expect_warning(format_record(avs_raw_record, avs_raw_metadata, class = "data.table"))
            expect_warning(format_record(as.data.table(avs_raw_record), avs_raw_metadata))
          })

test_that("format_record builds the expected data.frame from rcer_rccore object",
          {
            DF <- format_record(avs_raw_core, class = "data.frame")
            classes <-
              c(record_id = "character", uniform_number = "character", firstname = "character",
                lastname = "character", hof = "integer", nationality = "character",
                position = "factor", birthdate = "Date", height = "integer",
                weight = "integer", shoots = "factor", catches = "factor", experience = "integer",
                roster_complete = "factor", gp = "integer", goals = "integer",
                assists = "integer", points = "numeric", plusmn = "integer",
                pimi = "integer", goals_ev = "integer", goals_pp = "integer",
                goals_sh = "integer", goals_gw = "integer", assists_ev = "integer",
                assists_pp = "integer", assists_sh = "integer", shots = "integer",
                shooting_percentage = "numeric", toi = "integer", atoi = "Period",
                regular_season_scoring_complete = "factor", wins = "integer",
                losses = "integer", ties_otl = "integer", goals_against = "integer",
                shots_against = "integer", saves = "integer", save_percentage = "numeric",
                gaa = "numeric", so = "integer", regular_season_goalies_complete = "factor",
                gp_postseason = "integer", goals_postseason = "integer", assists_postseason = "integer",
                points_postseason = "numeric", plusmn_postseason = "integer",
                pimi_postseason = "integer", goals_ev_postseason = "integer",
                goals_pp_postseason = "integer", goals_sh_postseason = "integer",
                goals_gw_postseason = "integer", assists_ev_postseason = "integer",
                assists_pp_postseason = "integer", assists_sh_postseason = "integer",
                shots_postseason = "integer", shooting_percentage_postseason = "numeric",
                toi_postseason = "integer", atoi_postseason = "Period", post_season_scoring_complete = "factor",
                wins_postseason = "integer", losses_postseason = "integer", ties_otl_postseason = "integer",
                goals_allowed_postseason = "integer", saves_postseason = "integer",
                save_percentage_postseason = "numeric", gaa_postseason = "numeric",
                so_postseason = "integer", post_season_goalies_2_complete = "factor"
              )

            expect_equal(sapply(DF, class), classes)
          })
