# Column Types

Define a type for each column of the records for a REDCap project based
on the metadata for the project.

## Usage

``` r
col_type(
  x,
  factors = TRUE,
  lubridate_args = list(quiet = TRUE, tz = NULL, locale = Sys.getlocale("LC_TIME"),
    truncated = 0),
  ...
)
```

## Arguments

- x:

  a `rcer_metadata` or `rcer_raw_metadata` object

- factors:

  If `TRUE` (default) then variables reported via drop-down lists and
  radio buttons are set up to be `factor`s. If `FALSE`, then the column
  type will be `character`.

- lubridate_args:

  a list of arguments passed to the date and time parsing calls. See
  Details.

- ...:

  not currently used

## Value

a `rcer_col_type` object

## Details

REDCap text fields for dates and times are formatted via lubridate

|                      |                                                                     |
|----------------------|---------------------------------------------------------------------|
| REDCap               | lubridate parsing function                                          |
| ———————              | ————————–                                                           |
| date_mdy             | [`mdy`](https://lubridate.tidyverse.org/reference/ymd.html)         |
| date_dmy             | [`dmy`](https://lubridate.tidyverse.org/reference/ymd.html)         |
| date_ymd             | [`ymd`](https://lubridate.tidyverse.org/reference/ymd.html)         |
| datetime_dmy         | [`dmy_hm`](https://lubridate.tidyverse.org/reference/ymd_hms.html)  |
| datetime_mdy         | [`mdy_hm`](https://lubridate.tidyverse.org/reference/ymd_hms.html)  |
| datetime_ymd         | [`ymd_hm`](https://lubridate.tidyverse.org/reference/ymd_hms.html)  |
| datetime_seconds_dmy | [`dmy_hms`](https://lubridate.tidyverse.org/reference/ymd_hms.html) |
| datetime_seconds_mdy | [`mdy_hms`](https://lubridate.tidyverse.org/reference/ymd_hms.html) |
| datetime_seconds_ymd | [`ymd_hms`](https://lubridate.tidyverse.org/reference/ymd_hms.html) |
| time                 | [`hm`](https://lubridate.tidyverse.org/reference/hms.html)          |
| time_mm_ss           | [`ms`](https://lubridate.tidyverse.org/reference/hms.html)          |

Other text files are coerced as

|             |              |
|-------------|--------------|
| REDCap      | R coercion   |
| ———————     | ————————–    |
| number      | as.numeric   |
| number_1dp  | as.numeric   |
| number_2dp  | as.numeric   |
| integer     | as.integer   |
| ..default.. | as.character |

Variables inputted into REDCap via radio button or dropdown lists
(multiple choice - pick one) are coerced to factors by default but can
be returned as characters if the argument `factors = FALSE` is set.

Calculated and slider (visual analog scale) variables are coerced via
`as.numeric`.

Yes/No and True/False variables are include as integer values 0 = No or
False, and 1 for Yes or True.

Checkboxes are the most difficult to work with between the metadata and
records. A checkbox field_name in the metadata could be, for example,
"eg_checkbox" and the columns in the records will be
"eg_checkbox\_\_\_\<code\>" were "code" could be numbers, or character
strings. REDCapExporter attempts to coerce the
"eg_checkbox\_\_\_\<code\>" columns to integer values, 0 = unchecked and
1 = checked.

## Examples

``` r
data("avs_raw_metadata")
col_type(avs_raw_metadata)
#> $record_id
#> as.character(record_id)
#> 
#> $uniform_number
#> as.character(uniform_number)
#> 
#> $firstname
#> as.character(firstname)
#> 
#> $lastname
#> as.character(lastname)
#> 
#> $nationality
#> as.character(nationality)
#> 
#> $birthdate
#> lubridate::ymd(birthdate, quiet = TRUE, tz = NULL, locale = "C.UTF-8", 
#>     truncated = 0)
#> 
#> $first_nhl_game
#> lubridate::ymd(first_nhl_game, quiet = TRUE, tz = NULL, locale = "C.UTF-8", 
#>     truncated = 0)
#> 
#> $last_nhl_game
#> lubridate::ymd(last_nhl_game, quiet = TRUE, tz = NULL, locale = "C.UTF-8", 
#>     truncated = 0)
#> 
#> $height
#> as.integer(height)
#> 
#> $weight
#> as.integer(weight)
#> 
#> $experience
#> as.integer(experience)
#> 
#> $gp
#> as.integer(gp)
#> 
#> $goals
#> as.integer(goals)
#> 
#> $assists
#> as.integer(assists)
#> 
#> $plusmn
#> as.integer(plusmn)
#> 
#> $pimi
#> as.integer(pimi)
#> 
#> $goals_ev
#> as.integer(goals_ev)
#> 
#> $goals_pp
#> as.integer(goals_pp)
#> 
#> $goals_sh
#> as.integer(goals_sh)
#> 
#> $goals_gw
#> as.integer(goals_gw)
#> 
#> $assists_ev
#> as.integer(assists_ev)
#> 
#> $assists_pp
#> as.integer(assists_pp)
#> 
#> $assists_sh
#> as.integer(assists_sh)
#> 
#> $shots
#> as.integer(shots)
#> 
#> $toi
#> as.integer(toi)
#> 
#> $atoi
#> lubridate::ms(ifelse(atoi == "", NA_character_, atoi))
#> 
#> $wins
#> as.integer(wins)
#> 
#> $losses
#> as.integer(losses)
#> 
#> $ties_otl
#> as.integer(ties_otl)
#> 
#> $goals_against
#> as.integer(goals_against)
#> 
#> $shots_against
#> as.integer(shots_against)
#> 
#> $saves
#> as.integer(saves)
#> 
#> $gaa
#> as.numeric(gaa)
#> 
#> $so
#> as.integer(so)
#> 
#> $gp_postseason
#> as.integer(gp_postseason)
#> 
#> $goals_postseason
#> as.integer(goals_postseason)
#> 
#> $assists_postseason
#> as.integer(assists_postseason)
#> 
#> $plusmn_postseason
#> as.integer(plusmn_postseason)
#> 
#> $pimi_postseason
#> as.integer(pimi_postseason)
#> 
#> $goals_ev_postseason
#> as.integer(goals_ev_postseason)
#> 
#> $goals_pp_postseason
#> as.integer(goals_pp_postseason)
#> 
#> $goals_sh_postseason
#> as.integer(goals_sh_postseason)
#> 
#> $goals_gw_postseason
#> as.integer(goals_gw_postseason)
#> 
#> $assists_ev_postseason
#> as.integer(assists_ev_postseason)
#> 
#> $assists_pp_postseason
#> as.integer(assists_pp_postseason)
#> 
#> $assists_sh_postseason
#> as.integer(assists_sh_postseason)
#> 
#> $shots_postseason
#> as.integer(shots_postseason)
#> 
#> $toi_postseason
#> as.integer(toi_postseason)
#> 
#> $atoi_postseason
#> lubridate::ms(ifelse(atoi_postseason == "", NA_character_, atoi_postseason))
#> 
#> $wins_postseason
#> as.integer(wins_postseason)
#> 
#> $losses_postseason
#> as.integer(losses_postseason)
#> 
#> $ties_otl_postseason
#> as.integer(ties_otl_postseason)
#> 
#> $goals_allowed_postseason
#> as.integer(goals_allowed_postseason)
#> 
#> $saves_postseason
#> as.integer(saves_postseason)
#> 
#> $save_percentage_postseason
#> as.numeric(save_percentage_postseason)
#> 
#> $gaa_postseason
#> as.numeric(gaa_postseason)
#> 
#> $so_postseason
#> as.integer(so_postseason)
#> 
#> $position
#> factor(x = position, levels = c("0", "1", "2", "3", "4"), labels = c("Goal", 
#> "Left Wing", "Right Wing", "Center", "Defence"))
#> 
#> $shoots
#> factor(x = shoots, levels = c("0", "1"), labels = c("Left", "Right"
#> ))
#> 
#> $catches
#> factor(x = catches, levels = c("0", "1"), labels = c("Left", 
#> "Right"))
#> 
#> $points
#> as.numeric(points)
#> 
#> $shooting_percentage
#> as.numeric(shooting_percentage)
#> 
#> $save_percentage
#> as.numeric(save_percentage)
#> 
#> $points_postseason
#> as.numeric(points_postseason)
#> 
#> $shooting_percentage_postseason
#> as.numeric(shooting_percentage_postseason)
#> 
#> $hof
#> as.integer(hof)
#> 
#> $eg_checkbox___cb01
#> as.integer(eg_checkbox___cb01)
#> 
#> $eg_checkbox___cb02
#> as.integer(eg_checkbox___cb02)
#> 
#> $eg_checkbox___cb03
#> as.integer(eg_checkbox___cb03)
#> 
#> $roster_complete
#> factor(roster_complete, levels = c(0, 1, 2), labels = c("Incomplete", 
#> "Unverified", "Complete"))
#> 
#> $regular_season_scoring_complete
#> factor(regular_season_scoring_complete, levels = c(0, 1, 2), 
#>     labels = c("Incomplete", "Unverified", "Complete"))
#> 
#> $regular_season_goalies_complete
#> factor(regular_season_goalies_complete, levels = c(0, 1, 2), 
#>     labels = c("Incomplete", "Unverified", "Complete"))
#> 
#> $post_season_scoring_complete
#> factor(post_season_scoring_complete, levels = c(0, 1, 2), labels = c("Incomplete", 
#> "Unverified", "Complete"))
#> 
#> $post_season_goalies_complete
#> factor(post_season_goalies_complete, levels = c(0, 1, 2), labels = c("Incomplete", 
#> "Unverified", "Complete"))
#> 
#> $extras_complete
#> factor(extras_complete, levels = c(0, 1, 2), labels = c("Incomplete", 
#> "Unverified", "Complete"))
#> 
#> attr(,"class")
#> [1] "rcer_col_type" "list"         
```
