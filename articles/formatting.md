# Formatting Data Exported from REDCap

This vignette covers different methods for formatting the records from
REDCap into an analysis ready data set. It is assumed that the reader is
familiar with the process for exporting data from REDCap to R as
described in
[`vignette("api", package = "REDCapExporter")`](http://www.peteredewitt.com/REDCapExporter/articles/api.md)

For the purposes of this vignette we will use the example data sets
provided in the package from the 2000-2001 National Hockey League
Stanley Cup Champion Colorado Avalanche. The data was transcribed from
[Hockey Reference](https://www.hockey-reference.com/teams/COL/2001.html)
into a REDCap Project hosed at the University of Colorado Denver.

The data sets we will work with in this vignette are:

``` r
library(REDCapExporter)
avs_raw_core      # object returned from export_core(format = "csv")
avs_raw_metadata  # object returned from export_content(content = "metadata", format = "csv")
avs_raw_record    # object returned from export_content(content = "record", format = "csv")
```

There are two conceptual formatting tools provided by REDCapExporter:

1.  `as.data.frame`

2.  `format_record`

## Coercion to data.frame

The object returned from `export_content` is a string in either csv or
json format. To have that information as a data.frame call
`as.data.frame`.

This method works for the metadata and records directly.

``` r
avs_metadata_DF <- as.data.frame(avs_raw_metadata)
avs_record_DF   <- as.data.frame(avs_raw_record)
```

For `rcer_rccore` objects returned by `export_core` all the elements can
be coerced to data.frames via `lapply`

``` r
avs_core_DFs  <- lapply(avs_raw_core, as.data.frame)
```

The behavior of `as.data.frame` for these objects is to return a
data.frame with all character columns.

``` r
avs_metadata_DF |> sapply(class) |> sapply(is.character) |> all()
## [1] TRUE
avs_record_DF   |> sapply(class) |> sapply(is.character) |> all()
## [1] TRUE
```

Obviously, this is not ideal for analysis. It does give the user a known
starting point for formatting the records explicitly. However,
REDCapExporter provides the `format_record` method to simplify this task
by using the metadata from the REDCap project.

## format_record

`format_record` uses the metadata to inform the storage mode of the
elements of a data.frame. For example, after exporting the core of a
REDCap project we can build a data.frame `avsDF` via

``` r
avsDF <- format_record(avs_raw_core)
str(avsDF, max.level = 0)
## Classes 'rcer_record' and 'data.frame':  32 obs. of  75 variables:
```

Note: the above uses the core export from REDCap. You can use just the
record and metadata to get the same result:

``` r
identical(
  format_record(avs_raw_core),
  format_record(avs_raw_record, avs_raw_metadata)
)
## [1] TRUE
```

Let’s look at the `avsDF` object (presented as a nice human readable
table)

| record_id | uniform_number | firstname | lastname   | hof | nationality    | position   | birthdate  | first_nhl_game | last_nhl_game | height | weight | shoots | catches | experience | roster_complete |  gp | goals | assists | points | plusmn | pimi | goals_ev | goals_pp | goals_sh | goals_gw | assists_ev | assists_pp | assists_sh | shots | shooting_percentage |  toi |    atoi | regular_season_scoring_complete | wins | losses | ties_otl | goals_against | shots_against | saves | save_percentage |  gaa |  so | regular_season_goalies_complete | gp_postseason | goals_postseason | assists_postseason | points_postseason | plusmn_postseason | pimi_postseason | goals_ev_postseason | goals_pp_postseason | goals_sh_postseason | goals_gw_postseason | assists_ev_postseason | assists_pp_postseason | assists_sh_postseason | shots_postseason | shooting_percentage_postseason | toi_postseason | atoi_postseason | post_season_scoring_complete | wins_postseason | losses_postseason | ties_otl_postseason | goals_allowed_postseason | saves_postseason | save_percentage_postseason | gaa_postseason | so_postseason | post_season_goalies_complete | eg_checkbox\_\_\_cb01 | eg_checkbox\_\_\_cb02 | eg_checkbox\_\_\_cb03 | extras_complete |
|:----------|:---------------|:----------|:-----------|----:|:---------------|:-----------|:-----------|:---------------|:--------------|-------:|-------:|:-------|:--------|-----------:|:----------------|----:|------:|--------:|-------:|-------:|-----:|---------:|---------:|---------:|---------:|-----------:|-----------:|-----------:|------:|--------------------:|-----:|--------:|:--------------------------------|-----:|-------:|---------:|--------------:|--------------:|------:|----------------:|-----:|----:|:--------------------------------|--------------:|-----------------:|-------------------:|------------------:|------------------:|----------------:|--------------------:|--------------------:|--------------------:|--------------------:|----------------------:|----------------------:|----------------------:|-----------------:|-------------------------------:|---------------:|----------------:|:-----------------------------|----------------:|------------------:|--------------------:|-------------------------:|-----------------:|---------------------------:|---------------:|--------------:|:-----------------------------|----------------------:|----------------------:|----------------------:|:----------------|
| 1         | 1              | David     | Aebischer  |   0 | Swiss          | Goal       | 1978-02-07 | 2001-04-07     | 2007-10-10    |     73 |    185 | NA     | Left    |          0 | Complete        |  26 |     0 |       1 |      1 |      0 |    0 |        0 |        0 |        0 |        0 |         NA |         NA |         NA |     0 |            0.000000 | 1393 | 53M 34S | Complete                        |   12 |      7 |        3 |            52 |           538 |   486 |       0.9033457 | 2.24 |   3 | Complete                        |             1 |                0 |                  0 |                 0 |                 0 |               0 |                   0 |                   0 |                   0 |                   0 |                    NA |                    NA |                    NA |                0 |                             NA |              1 |             32S | Complete                     |               0 |                 0 |                  NA |                        0 |                0 |                      0.000 |            0.0 |             0 | Complete                     |                     1 |                     0 |                     0 | Incomplete      |
| 2         | 46             | Yuri      | Babenko    |   0 | USSR           | Center     | 1978-01-02 | 2000-11-22     | 2000-11-29    |     73 |    200 | Left   | NA      |          0 | Complete        |   3 |     0 |       0 |      0 |      0 |    0 |        0 |        0 |        0 |        0 |          0 |          0 |          0 |     2 |            0.000000 |   32 | 10M 34S | Complete                        |   NA |     NA |       NA |            NA |            NA |    NA |              NA |   NA |  NA | Complete                        |             0 |               NA |                 NA |                NA |                NA |              NA |                  NA |                  NA |                  NA |                  NA |                    NA |                    NA |                    NA |               NA |                             NA |             NA |              NA | Complete                     |              NA |                NA |                  NA |                       NA |               NA |                         NA |             NA |            NA | Complete                     |                     0 |                     1 |                     0 | Incomplete      |
| 3         | 45             | Rick      | Berry      |   0 | Canada         | Defence    | 1978-11-04 | 2001-01-07     | 2004-04-04    |     74 |    210 | Left   | NA      |          0 | Complete        |  19 |     0 |       4 |      4 |      5 |   38 |        0 |        0 |        0 |        0 |          4 |          0 |          0 |    10 |            0.000000 |  231 |  12M 8S | Complete                        |   NA |     NA |       NA |            NA |            NA |    NA |              NA |   NA |  NA | Complete                        |             0 |               NA |                 NA |                NA |                NA |              NA |                  NA |                  NA |                  NA |                  NA |                    NA |                    NA |                    NA |               NA |                             NA |             NA |              NA | Complete                     |              NA |                NA |                  NA |                       NA |               NA |                         NA |             NA |            NA | Complete                     |                     0 |                     0 |                     0 | Incomplete      |
| 4         | 4              | Rob       | Blake      |   1 | Canada         | Defence    | 1969-12-10 | 1990-03-27     | 2010-05-23    |     76 |    220 | Right  | NA      |         11 | Complete        |  13 |     2 |       8 |     10 |     11 |    8 |        1 |        1 |        0 |        1 |          6 |          2 |          0 |    44 |            4.545454 |  339 |  26M 3S | Complete                        |   NA |     NA |       NA |            NA |            NA |    NA |              NA |   NA |  NA | Complete                        |            23 |                6 |                 13 |                19 |                 6 |              16 |                   3 |                   3 |                   0 |                   0 |                    NA |                    NA |                    NA |               83 |                       7.228916 |            677 |         29M 26S | Complete                     |              NA |                NA |                  NA |                       NA |               NA |                         NA |             NA |            NA | Complete                     |                     0 |                     0 |                     0 | Incomplete      |
| 5         | 77             | Ray       | Bourque    |   1 | Canada         | Defence    | 1960-12-28 | 1979-10-11     | 2001-06-09    |     71 |    219 | Left   | NA      |         21 | Complete        |  80 |     7 |      52 |     59 |     25 |   48 |        3 |        2 |        2 |        0 |         21 |         31 |          0 |   216 |            3.240741 | 2088 |  26M 6S | Complete                        |   NA |     NA |       NA |            NA |            NA |    NA |              NA |   NA |  NA | Complete                        |            21 |                4 |                  6 |                10 |                 9 |              12 |                   1 |                   3 |                   0 |                   1 |                    NA |                    NA |                    NA |               49 |                       8.163265 |            599 |         28M 32S | Complete                     |              NA |                NA |                  NA |                       NA |               NA |                         NA |             NA |            NA | Complete                     |                     0 |                     1 |                     0 | Incomplete      |
| 6         | 7              | Greg      | de Vries   |   0 | Canada         | Defence    | 1973-01-04 | 1996-01-17     | 2009-04-10    |     74 |    205 | Left   | NA      |          5 | Complete        |  79 |     5 |      12 |     17 |     23 |   51 |        5 |        0 |        0 |        0 |         11 |          0 |          1 |    76 |            6.578947 | 1351 |  17M 6S | Complete                        |   NA |     NA |       NA |            NA |            NA |    NA |              NA |   NA |  NA | Complete                        |            23 |                0 |                  1 |                 1 |                 5 |              20 |                   0 |                   0 |                   0 |                   0 |                    NA |                    NA |                    NA |               20 |                       0.000000 |            328 |         14M 17S | Complete                     |              NA |                NA |                  NA |                       NA |               NA |                         NA |             NA |            NA | Complete                     |                     1 |                     0 |                     0 | Incomplete      |
| 7         | 18             | Adam      | Deadmarsh  |   0 | Canada         | Right Wing | 1975-05-10 | 1995-01-21     | 2002-12-15    |     72 |    205 | Right  | NA      |          6 | Complete        |  39 |    13 |      13 |     26 |     -2 |   59 |        6 |        7 |        0 |        2 |          7 |          6 |          0 |    86 |           15.116279 |  687 | 17M 38S | Complete                        |   NA |     NA |       NA |            NA |            NA |    NA |              NA |   NA |  NA | Complete                        |             0 |               NA |                 NA |                NA |                NA |              NA |                  NA |                  NA |                  NA |                  NA |                    NA |                    NA |                    NA |               NA |                             NA |             NA |              NA | Complete                     |              NA |                NA |                  NA |                       NA |               NA |                         NA |             NA |            NA | Complete                     |                     1 |                     1 |                     0 | Incomplete      |
| 8         | 11             | Chris     | Dingman    |   0 | Canada         | Left Wing  | 1976-07-06 | 1997-10-01     | 2006-04-25    |     76 |    235 | Left   | NA      |          3 | Complete        |  41 |     1 |       1 |      2 |     -3 |  108 |        1 |        0 |        0 |        0 |          1 |          0 |          0 |    33 |            3.030303 |  264 |  6M 26S | Complete                        |   NA |     NA |       NA |            NA |            NA |    NA |              NA |   NA |  NA | Complete                        |            16 |                0 |                  4 |                 4 |                 3 |              14 |                   0 |                   0 |                   0 |                   0 |                    NA |                    NA |                    NA |                8 |                       0.000000 |            101 |          6M 18S | Complete                     |              NA |                NA |                  NA |                       NA |               NA |                         NA |             NA |            NA | Complete                     |                     1 |                     1 |                     0 | Incomplete      |
| 9         | 37             | Chris     | Drury      |   0 | USA            | Left Wing  | 1976-08-20 | 1998-10-10     | 2011-04-23    |     70 |    191 | Right  | NA      |          2 | Complete        |  71 |    24 |      41 |     65 |      6 |   47 |       13 |       11 |        0 |        5 |         22 |         18 |          0 |   204 |           11.764706 | 1281 |  18M 3S | Complete                        |   NA |     NA |       NA |            NA |            NA |    NA |              NA |   NA |  NA | Complete                        |            23 |               11 |                  5 |                16 |                 5 |               4 |                   9 |                   2 |                   0 |                   2 |                    NA |                    NA |                    NA |               62 |                      17.741936 |            439 |          19M 6S | Complete                     |              NA |                NA |                  NA |                       NA |               NA |                         NA |             NA |            NA | Complete                     |                     0 |                     0 |                     0 | Incomplete      |
| 10        | 52             | Adam      | Foote      |   0 | Canada         | Defence    | 1971-07-10 | 1991-10-19     | 2011-04-10    |     74 |    220 | Right  | NA      |          9 | Complete        |  35 |     3 |      12 |     15 |      6 |   42 |        1 |        1 |        1 |        1 |          7 |          5 |          0 |    59 |            5.084746 |  888 | 25M 22S | Complete                        |   NA |     NA |       NA |            NA |            NA |    NA |              NA |   NA |  NA | Complete                        |            23 |                3 |                  4 |                 7 |                 5 |              47 |                   2 |                   1 |                   0 |                   1 |                    NA |                    NA |                    NA |               28 |                      10.714286 |            652 |         28M 22S | Complete                     |              NA |                NA |                  NA |                       NA |               NA |                         NA |             NA |            NA | Complete                     |                     1 |                     1 |                     0 | Incomplete      |
| 11        | 21             | Peter     | Forsberg   |   1 | Sweeden        | Center     | 1973-07-20 | 1995-01-11     | 2011-02-12    |     72 |    205 | Left   | NA      |          6 | Complete        |  73 |    27 |      62 |     89 |     23 |   54 |       12 |       12 |        2 |        5 |         34 |         24 |          4 |   178 |           15.168539 | 1518 | 20M 48S | Complete                        |   NA |     NA |       NA |            NA |            NA |    NA |              NA |   NA |  NA | Complete                        |            11 |                4 |                 10 |                14 |                 5 |               6 |                   3 |                   1 |                   0 |                   2 |                    NA |                    NA |                    NA |               23 |                      17.391304 |            241 |         21M 55S | Complete                     |              NA |                NA |                  NA |                       NA |               NA |                         NA |             NA |            NA | Complete                     |                     0 |                     0 |                     0 | Incomplete      |
| 12        | 5              | Alexei    | Gusarov    |   0 | USSR           | Defence    | 1964-07-08 | 1990-12-15     | 2001-05-21    |     75 |    185 | Left   | NA      |         10 | Complete        |   9 |     0 |       1 |      1 |      2 |    6 |        0 |        0 |        0 |        0 |          1 |          0 |          0 |     4 |            0.000000 |  135 | 14M 59S | Complete                        |   NA |     NA |       NA |            NA |            NA |    NA |              NA |   NA |  NA | Complete                        |             0 |               NA |                 NA |                NA |                NA |              NA |                  NA |                  NA |                  NA |                  NA |                    NA |                    NA |                    NA |               NA |                             NA |             NA |              NA | Complete                     |              NA |                NA |                  NA |                       NA |               NA |                         NA |             NA |            NA | Complete                     |                     1 |                     0 |                     0 | Incomplete      |
| 13        | 23             | Milan     | Hejduk     |   0 | Czechoslovakia | Right Wing | 1976-02-14 | 1998-10-10     | 2013-04-27    |     72 |    190 | Right  | NA      |          2 | Complete        |  80 |    41 |      38 |     79 |     32 |   36 |       28 |       12 |        1 |        9 |         21 |         15 |          2 |   213 |           19.248826 | 1589 | 19M 52S | Complete                        |   NA |     NA |       NA |            NA |            NA |    NA |              NA |   NA |  NA | Complete                        |            23 |                7 |                 16 |                23 |                 8 |               6 |                   3 |                   4 |                   0 |                   1 |                    NA |                    NA |                    NA |               51 |                      13.725490 |            496 |         21M 33S | Complete                     |              NA |                NA |                  NA |                       NA |               NA |                         NA |             NA |            NA | Complete                     |                     0 |                     0 |                     0 | Incomplete      |
| 14        | 13             | Dan       | Hinote     |   0 | USA            | Center     | 1977-01-30 | 1999-10-05     | 2009-04-21    |     72 |    187 | Right  | NA      |          1 | Complete        |  76 |     5 |      10 |     15 |      1 |   51 |        4 |        1 |        0 |        1 |          8 |          2 |          0 |    69 |            7.246377 |  787 | 10M 21S | Complete                        |   NA |     NA |       NA |            NA |            NA |    NA |              NA |   NA |  NA | Complete                        |            23 |                2 |                  4 |                 6 |                 4 |              21 |                   2 |                   0 |                   0 |                   0 |                    NA |                    NA |                    NA |               16 |                      12.500000 |            192 |          8M 22S | Complete                     |              NA |                NA |                  NA |                       NA |               NA |                         NA |             NA |            NA | Complete                     |                     0 |                     1 |                     0 | Incomplete      |
| 15        | 24             | Jon       | Klemm      |   0 | Canada         | Defence    | 1970-01-08 | 1992-02-23     | 2008-04-03    |     74 |    205 | Right  | NA      |          8 | Complete        |  78 |     4 |      11 |     15 |     22 |   54 |        2 |        2 |        0 |        2 |          6 |          3 |          2 |    97 |            4.123711 | 1554 | 19M 56S | Complete                        |   NA |     NA |       NA |            NA |            NA |    NA |              NA |   NA |  NA | Complete                        |            22 |                1 |                  2 |                 3 |                 7 |              16 |                   1 |                   0 |                   0 |                   1 |                    NA |                    NA |                    NA |               14 |                       7.142857 |            357 |         16M 15S | Complete                     |              NA |                NA |                  NA |                       NA |               NA |                         NA |             NA |            NA | Complete                     |                     1 |                     1 |                     0 | Incomplete      |
| 16        | 9              | Brad      | Larsen     |   0 | Canada         | Left Wing  | 1977-06-28 | NA             | NA            |     72 |    210 | Left   | NA      |          1 | Incomplete      |   9 |     0 |       0 |      0 |      1 |    0 |        0 |        0 |        0 |        0 |          0 |          0 |          0 |     3 |            0.000000 |   84 |  9M 17S | Complete                        |   NA |     NA |       NA |            NA |            NA |    NA |              NA |   NA |  NA | Complete                        |             0 |               NA |                 NA |                NA |                NA |              NA |                  NA |                  NA |                  NA |                  NA |                    NA |                    NA |                    NA |               NA |                             NA |             NA |              NA | Complete                     |              NA |                NA |                  NA |                       NA |               NA |                         NA |             NA |            NA | Complete                     |                     0 |                     0 |                     0 | Incomplete      |
| 17        | 29             | Eric      | Messier    |   0 | Canada         | Left Wing  | 1973-10-29 | 1996-11-11     | 2003-11-21    |     74 |    195 | Left   | NA      |          4 | Complete        |  64 |     5 |       7 |     12 |     -3 |   26 |        5 |        0 |        0 |        1 |          7 |          0 |          0 |    60 |            8.333333 |  786 | 12M 16S | Complete                        |   NA |     NA |       NA |            NA |            NA |    NA |              NA |   NA |  NA | Complete                        |            23 |                2 |                  2 |                 4 |                 0 |              14 |                   2 |                   0 |                   0 |                   0 |                    NA |                    NA |                    NA |               20 |                      10.000000 |            374 |         16M 16S | Complete                     |              NA |                NA |                  NA |                       NA |               NA |                         NA |             NA |            NA | Incomplete                   |                     0 |                     0 |                     0 | Incomplete      |
| 18        | 3              | Aaron     | Miller     |   0 | USA            | Defence    | 1971-08-11 | 1994-01-15     | 2008-03-06    |     75 |    210 | Right  | NA      |          7 | Complete        |  56 |     4 |       9 |     13 |     19 |   29 |        4 |        0 |        0 |        0 |          8 |          0 |          1 |    49 |            8.163265 | 1032 | 18M 25S | Complete                        |   NA |     NA |       NA |            NA |            NA |    NA |              NA |   NA |  NA | Complete                        |             0 |               NA |                 NA |                NA |                NA |              NA |                  NA |                  NA |                  NA |                  NA |                    NA |                    NA |                    NA |               NA |                             NA |             NA |              NA | Complete                     |              NA |                NA |                  NA |                       NA |               NA |                         NA |             NA |            NA | Complete                     |                     1 |                     1 |                     0 | Incomplete      |
| 19        | 2              | Bryan     | Muir       |   0 | Canada         | Defence    | 1973-06-08 | 1996-03-08     | 2007-04-07    |     75 |    224 | Left   | NA      |          4 | Unverified      |   8 |     0 |       0 |      0 |      0 |    4 |        0 |        0 |        0 |        0 |          0 |          0 |          0 |     3 |            0.000000 |   66 |  8M 14S | Complete                        |   NA |     NA |       NA |            NA |            NA |    NA |              NA |   NA |  NA | Complete                        |             3 |                0 |                  0 |                 0 |                 0 |               0 |                   0 |                   0 |                   0 |                   0 |                    NA |                    NA |                    NA |                0 |                             NA |             10 |          3M 15S | Complete                     |              NA |                NA |                  NA |                       NA |               NA |                         NA |             NA |            NA | Complete                     |                     1 |                     0 |                     0 | Incomplete      |
| 20        | 39             | Ville     | Nieminen   |   0 | Finland        | Left Wing  | 1977-04-06 | 2000-01-29     | 2007-04-05    |     71 |    200 | Left   | NA      |          1 | Complete        |  50 |    14 |       8 |     22 |      8 |   38 |       12 |        2 |        0 |        3 |          5 |          3 |          0 |    68 |           20.588235 |  622 | 12M 26S | Complete                        |   NA |     NA |       NA |            NA |            NA |    NA |              NA |   NA |  NA | Complete                        |            23 |                4 |                  6 |                10 |                -1 |              20 |                   1 |                   3 |                   0 |                   1 |                    NA |                    NA |                    NA |               39 |                      10.256410 |            326 |         14M 10S | Complete                     |              NA |                NA |                  NA |                       NA |               NA |                         NA |             NA |            NA | Complete                     |                     0 |                     1 |                     0 | Incomplete      |
| 21        | 27             | Scott     | Parker     |   0 | USA            | Right Wing | 1978-01-29 | 1998-11-28     | 2008-03-11    |     77 |    240 | Right  | NA      |         10 | Complete        |  69 |     2 |       3 |      5 |     -2 |  155 |        2 |        0 |        0 |        1 |          3 |          0 |          0 |    35 |            5.714286 |  394 |  5M 42S | Complete                        |   NA |     NA |       NA |            NA |            NA |    NA |              NA |   NA |  NA | Complete                        |             4 |                0 |                  0 |                 0 |                 0 |               2 |                   0 |                   0 |                   0 |                   0 |                    NA |                    NA |                    NA |                0 |                             NA |              9 |          2M 12S | Complete                     |              NA |                NA |                  NA |                       NA |               NA |                         NA |             NA |            NA | Complete                     |                     0 |                     0 |                     0 | Incomplete      |
| 22        | 25             | Shjon     | Podein     |   0 | USA            | Right Wing | 1968-03-05 | 1993-01-09     | 2003-04-22    |     74 |    200 | Left   | NA      |          8 | Complete        |  82 |    15 |      17 |     32 |      7 |   68 |       15 |        0 |        0 |        3 |         17 |          0 |          0 |   137 |           10.948905 | 1180 | 14M 23S | Complete                        |   NA |     NA |       NA |            NA |            NA |    NA |              NA |   NA |  NA | Complete                        |            23 |                2 |                  3 |                 5 |                 3 |              14 |                   2 |                   0 |                   0 |                   1 |                    NA |                    NA |                    NA |               16 |                      12.500000 |            345 |         14M 59S | Complete                     |              NA |                NA |                  NA |                       NA |               NA |                         NA |             NA |            NA | Complete                     |                     1 |                     0 |                     0 | Incomplete      |
| 23        | 4-44           | Nolan     | Pratt      |   0 | Canda          | Defence    | 1975-08-14 | 1996-10-05     | 2008-04-03    |     75 |    207 | Left   | NA      |          4 | Complete        |  46 |     1 |       2 |      3 |      2 |   40 |        1 |        0 |        0 |        1 |          2 |          0 |          0 |    26 |            3.846154 |  452 |  9M 50S | Complete                        |   NA |     NA |       NA |            NA |            NA |    NA |              NA |   NA |  NA | Complete                        |             0 |               NA |                 NA |                NA |                NA |              NA |                  NA |                  NA |                  NA |                  NA |                    NA |                    NA |                    NA |               NA |                             NA |             NA |              NA | Complete                     |              NA |                NA |                  NA |                       NA |               NA |                         NA |             NA |            NA | Complete                     |                     1 |                     1 |                     0 | Incomplete      |
| 24        | 63             | Joel      | Prpic      |   0 | Canada         | Center     | 1974-09-25 | NA             | NA            |     78 |    225 | Left   | NA      |          2 | Incomplete      |   3 |     0 |       0 |      0 |      0 |    2 |        0 |        0 |        0 |        0 |          0 |          0 |          0 |     0 |                  NA |   29 |  9M 47S | Complete                        |   NA |     NA |       NA |            NA |            NA |    NA |              NA |   NA |  NA | Complete                        |             0 |               NA |                 NA |                NA |                NA |              NA |                  NA |                  NA |                  NA |                  NA |                    NA |                    NA |                    NA |               NA |                             NA |             NA |              NA | Complete                     |              NA |                NA |                  NA |                       NA |               NA |                         NA |             NA |            NA | Complete                     |                     1 |                     1 |                     0 | Incomplete      |
| 25        | 14             | Dave      | Reid       |   0 | Canada         | Right Wing | 1964-05-15 | 1983-12-23     | 2001-06-09    |     73 |    217 | Left   | NA      |         17 | Complete        |  73 |     1 |       9 |     10 |      1 |   21 |        1 |        0 |        0 |        0 |          8 |          0 |          1 |    66 |            1.515151 |  721 |  9M 53S | Complete                        |   NA |     NA |       NA |            NA |            NA |    NA |              NA |   NA |  NA | Complete                        |            18 |                0 |                  4 |                 4 |                 2 |               6 |                   0 |                   0 |                   0 |                   0 |                    NA |                    NA |                    NA |                8 |                       0.000000 |            164 |           9M 8S | Complete                     |              NA |                NA |                  NA |                       NA |               NA |                         NA |             NA |            NA | Complete                     |                     0 |                     1 |                     0 | Incomplete      |
| 26        | 28             | Steve     | Reinprecht |   0 | Canada         | Center     | 1976-05-07 | NA             | NA            |     72 |    195 | Left   | NA      |          1 | Incomplete      |  21 |     3 |       4 |      7 |     -1 |    2 |        3 |        0 |        0 |        0 |          3 |          0 |          1 |    28 |           10.714286 |  328 | 15M 38S | Complete                        |   NA |     NA |       NA |            NA |            NA |    NA |              NA |   NA |  NA | Complete                        |            22 |                2 |                  3 |                 5 |                 0 |               2 |                   2 |                   0 |                   0 |                   0 |                    NA |                    NA |                    NA |               14 |                      14.285714 |            267 |          12M 9S | Complete                     |              NA |                NA |                  NA |                       NA |               NA |                         NA |             NA |            NA | Complete                     |                     0 |                     1 |                     0 | Incomplete      |
| 27        | 33             | Patrick   | Roy        |   1 | Canada         | Goal       | 1965-10-05 | 1985-02-23     | 2003-04-22    |     74 |    185 | NA     | Left    |         16 | Complete        |  62 |     0 |       5 |      5 |      0 |   10 |        0 |        0 |        0 |        0 |         NA |         NA |         NA |     0 |                  NA | 3565 | 57M 30S | Complete                        |   40 |     13 |        7 |           132 |          1513 |  1281 |       0.8466623 | 2.22 |   4 | Complete                        |            23 |                0 |                  1 |                 1 |                 0 |               0 |                   0 |                   0 |                   0 |                   0 |                    NA |                    NA |                    NA |                0 |                             NA |           1451 |              NA | Incomplete                   |              16 |                 7 |                  NA |                       41 |              622 |                      0.934 |            1.7 |             4 | Complete                     |                     0 |                     0 |                     0 | Incomplete      |
| 28        | 19             | Joe       | Sakic      |   1 | Canada         | Center     | 1969-07-07 | 1988-10-06     | 2008-11-28    |     71 |    195 | Left   | NA      |         12 | Complete        |  82 |    54 |      64 |    118 |     45 |   30 |       32 |       19 |        3 |       12 |         34 |         27 |          3 |   332 |           16.265060 | 1887 |  23M 1S | Complete                        |   NA |     NA |       NA |            NA |            NA |    NA |              NA |   NA |  NA | Complete                        |            21 |               13 |                 13 |                26 |                 6 |               6 |                   8 |                   5 |                   0 |                   3 |                    NA |                    NA |                    NA |               79 |                      16.455696 |            452 |         21M 33S | Complete                     |              NA |                NA |                  NA |                       NA |               NA |                         NA |             NA |            NA | Complete                     |                     1 |                     1 |                     0 | Incomplete      |
| 29        | 44             | Rob       | Shearer    |   0 | Canada         | Center     | 1976-10-19 | 2000-11-11     | 2000-11-13    |     70 |    190 | Right  | NA      |          0 | Complete        |   2 |     0 |       0 |      0 |     -2 |    0 |        0 |        0 |        0 |        0 |          0 |          0 |          0 |     0 |                  NA |   14 |  6M 45S | Complete                        |   NA |     NA |       NA |            NA |            NA |    NA |              NA |   NA |  NA | Complete                        |             0 |               NA |                 NA |                NA |                NA |              NA |                  NA |                  NA |                  NA |                  NA |                    NA |                    NA |                    NA |               NA |                             NA |             NA |              NA | Complete                     |              NA |                NA |                  NA |                       NA |               NA |                         NA |             NA |            NA | Complete                     |                     0 |                     1 |                     0 | Incomplete      |
| 30        | 41             | Martin    | Skoula     |   0 | Czechoslovakia | Defence    | 1979-10-28 | 1999-10-05     | 2010-04-22    |     75 |    226 | Left   | NA      |         11 | Complete        |  82 |     8 |      17 |     25 |      8 |   38 |        5 |        3 |        0 |        2 |         11 |          6 |          0 |   108 |            7.407407 | 1697 | 20M 41S | Complete                        |   NA |     NA |       NA |            NA |            NA |    NA |              NA |   NA |  NA | Complete                        |            23 |                1 |                  4 |                 5 |                 1 |               8 |                   1 |                   0 |                   0 |                   0 |                    NA |                    NA |                    NA |               14 |                       7.142857 |            276 |         11M 59S | Complete                     |              NA |                NA |                  NA |                       NA |               NA |                         NA |             NA |            NA | Complete                     |                     1 |                     0 |                     0 | Incomplete      |
| 31        | 40             | Alex      | Tanguay    |   0 | Canada         | Left Wing  | 1979-11-21 | 1999-10-05     | 2016-04-19    |     73 |    194 | Left   | NA      |          1 | Complete        |  82 |    27 |      50 |     77 |     35 |   37 |       19 |        7 |        1 |        3 |         39 |         11 |          0 |   135 |           20.000000 | 1464 | 17M 51S | Complete                        |   NA |     NA |       NA |            NA |            NA |    NA |              NA |   NA |  NA | Complete                        |            23 |                6 |                 15 |                21 |                13 |               8 |                   5 |                   1 |                   0 |                   2 |                    NA |                    NA |                    NA |               37 |                      16.216216 |            444 |         19M 18S | Complete                     |              NA |                NA |                  NA |                       NA |               NA |                         NA |             NA |            NA | Complete                     |                     0 |                     0 |                     0 | Incomplete      |
| 32        | 26             | Stephane  | Yelle      |   0 | Canada         | Center     | 1974-05-09 | 1995-10-06     | 2010-04-24    |     74 |    182 | Left   | NA      |          5 | Complete        |  50 |     4 |      10 |     14 |     -3 |   20 |        3 |        0 |        1 |        0 |         10 |          0 |          0 |    54 |            7.407407 |  723 | 14M 28S | Complete                        |   NA |     NA |       NA |            NA |            NA |    NA |              NA |   NA |  NA | Complete                        |            23 |                1 |                  2 |                 3 |                 2 |               8 |                   1 |                   0 |                   0 |                   1 |                    NA |                    NA |                    NA |               23 |                       4.347826 |            319 |         13M 52S | Complete                     |              NA |                NA |                  NA |                       NA |               NA |                         NA |             NA |            NA | Complete                     |                     0 |                     0 |                     0 | Incomplete      |

Now, consider the classes of the columns. Start by looking at a few
columns which look like they are numeric values, record_id,
uniform_number, height, and points.

``` r
cols <- c("record_id", "uniform_number", "height", "points")
head(avsDF[, cols], n = 3)
##   record_id uniform_number height points
## 1         1              1     73      1
## 2         2             46     73      0
## 3         3             45     74      4
sapply(avsDF[, cols], class)
##      record_id uniform_number         height         points 
##    "character"    "character"      "integer"      "numeric"
```

Why are record_id and uniform_number, stored as characters whereas
height and points (sum of goals scored and assists) integer and numeric
values respectively? The answer is in the metadata.

``` r
avs_metadata_DF[avs_metadata_DF$field_name %in% cols, ]
```

| field_name     | form_name              | section_header | field_type | field_label    | select_choices_or_calculations | field_note | text_validation_type_or_show_slider_number | text_validation_min | text_validation_max | identifier | branching_logic | required_field | custom_alignment | question_number | matrix_group_name | matrix_ranking | field_annotation |
|:---------------|:-----------------------|:---------------|:-----------|:---------------|:-------------------------------|:-----------|:-------------------------------------------|:--------------------|:--------------------|:-----------|:----------------|:---------------|:-----------------|:----------------|:------------------|:---------------|:-----------------|
| record_id      | roster                 |                | text       | Record ID      |                                |            |                                            |                     |                     |            |                 |                |                  |                 |                   |                |                  |
| uniform_number | roster                 |                | text       | Uniform Number |                                |            |                                            |                     |                     |            |                 |                |                  |                 |                   |                |                  |
| height         | roster                 |                | text       | Height         |                                | in inches  | integer                                    | 60                  | 84                  |            |                 |                |                  |                 |                   |                |                  |
| points         | regular_season_scoring |                | calc       | Points         | \[goals\]+\[assists\]          |            |                                            |                     |                     |            |                 |                |                  |                 |                   |                |                  |

Notice that for the record_id and uniform_number the field_type is
“text” with no value for “select_choices_or_calculations” and no value
for “text_validation_type_or_show_slider_number”. This is interpreted,
then, as just a text field and should be character vector in the
data.frame. Obviously the user could coerce to integer of numeric is
desired and if appropriate.

For height, note that the field_type is “text” and the
“text_validation_type_or_show_slider_number” is “integer”, hence the
coercion from the raw data to integer when building the data.frame.
Lastly, the points are a calculated field and set to numeric.

REDCapExporter attempts to make reasonable assumptions for the data
types base on the metadata. For example, dates in REDCap can by entered
and validated in Year-Month-Day, Month-Day-Year, and Day-Month-Year
formats. The raw data is all in Year-Month-Day format.

| field_name     | field_type | field_label            | field_note    | text_validation_type_or_show_slider_number |
|:---------------|:-----------|:-----------------------|:--------------|:-------------------------------------------|
| birthdate      | text       | Birthdate              | Format: M-D-Y | date_mdy                                   |
| first_nhl_game | text       | Date of first NHL game |               | date_dmy                                   |
| last_nhl_game  | text       | Date of last NHL game  |               | date_ymd                                   |

The coercion that will be used when calling `format_record` is defined
by an implicit call to `col_type` which uses the metadata, in raw or
formatted form, to determine the coercion.

``` r
identical(col_type(avs_raw_metadata), col_type(avs_metadata_DF))
## [1] TRUE
ct <- col_type(avs_metadata_DF)
```

Each of the elements of `ct` are applied to the column of the data frame
with the same name. Examples: The record_id is to be a character string
by default.

``` r
ct[["record_id"]]
## as.character(record_id)
```

If the user would prefer the record_id to be an integer we can modify
`ct` and apply it explicitly when calling `format_record`.

``` r
ct[["record_id"]] |> str()
##  language as.character(record_id)
ct[["record_id"]] <- expression(as.integer(record_id))
avsDF2 <- format_record(avs_raw_core, col_type = ct)
## Ignoring metadata, using col_type
```

Two notes to make here, first, we can see that the storage mode is
different between `avsDF$record_id` and `avsDF2$record_id`.

``` r
class(avsDF$record_id)
## [1] "character"
class(avsDF2$record_id)
## [1] "integer"
```

Second, there is a message (not a warning), that the metadata that is
part of the `avs_raw_core` object, is not being used to define the
column types.

If you want to suppress that message you can use

``` r
suppressMessages(format_record(avs_raw_core, col_type = ct))
```

or use the records as the object passed to `format_record`

``` r
format_record(avs_record_DF, col_type = ct)
```

By default, variables recorded in REDCap via radio buttons or dropdown
lists are formatted as factors. For example, the position of the player
is a factor.

``` r
class(avsDF$position)
## [1] "factor"
summary(avsDF$position)
##       Goal  Left Wing Right Wing     Center    Defence 
##          2          6          5          8         11
```

If you’d prefer to have all these variables stored as characters instead
of factors you can modify the call to `col_type`

``` r
ct <- col_type(avs_raw_metadata, factors = FALSE)
avsDF2 <- format_record(avs_raw_record, col_type = ct)
class(avsDF2$position)
## [1] "character"
summary(avsDF2$position)
##    Length     Class      Mode 
##        32 character character
table(avsDF2$position)
## 
##     Center    Defence       Goal  Left Wing Right Wing 
##          8         11          2          6          5
```

The default formatting is documented in the manual file The implemented
code is within the S3 method:

``` r
?col_type
```
