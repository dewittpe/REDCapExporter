# Format Record

Use REDCap project metadata to build a well formatted `data.frame` for
the record.

## Usage

``` r
format_record(x, metadata = NULL, col_type = NULL, ...)
```

## Arguments

- x:

  a `rcer_rccore`, `rcer_raw_record`, or `rcer_record` object.

- metadata:

  a `rcer_metadata` or `rcer_raw_metadata` object. Will be ignored if
  `col_type` is defined.

- col_type:

  a `rcer_col_type` object.

- ...:

  other arguments passed to
  [`col_type`](http://www.peteredewitt.com/REDCapExporter/reference/col_type.md)

## Value

A `data.frame`

## See also

[`export_core`](http://www.peteredewitt.com/REDCapExporter/reference/export_core.md),
[`export_content`](http://www.peteredewitt.com/REDCapExporter/reference/export_content.md),
[`vignette("formatting", package = "REDCapExporter")`](http://www.peteredewitt.com/REDCapExporter/articles/formatting.md)

## Examples

``` r
data("avs_raw_metadata")
data("avs_raw_record")

# Formatting the record can be called in different ways and the same result
# will be generated
identical(
  format_record(avs_raw_record, avs_raw_metadata),
  format_record(avs_raw_core)
)
#> [1] TRUE

avs <- format_record(avs_raw_record, avs_raw_metadata)
avs
#>    record_id uniform_number firstname   lastname hof    nationality   position
#> 1          1              1     David  Aebischer   0          Swiss       Goal
#> 2          2             46      Yuri    Babenko   0           USSR     Center
#> 3          3             45      Rick      Berry   0         Canada    Defence
#> 4          4              4       Rob      Blake   1         Canada    Defence
#> 5          5             77       Ray    Bourque   1         Canada    Defence
#> 6          6              7      Greg   de Vries   0         Canada    Defence
#> 7          7             18      Adam  Deadmarsh   0         Canada Right Wing
#> 8          8             11     Chris    Dingman   0         Canada  Left Wing
#> 9          9             37     Chris      Drury   0            USA  Left Wing
#> 10        10             52      Adam      Foote   0         Canada    Defence
#> 11        11             21     Peter   Forsberg   1        Sweeden     Center
#> 12        12              5    Alexei    Gusarov   0           USSR    Defence
#> 13        13             23     Milan     Hejduk   0 Czechoslovakia Right Wing
#> 14        14             13       Dan     Hinote   0            USA     Center
#> 15        15             24       Jon      Klemm   0         Canada    Defence
#> 16        16              9      Brad     Larsen   0         Canada  Left Wing
#> 17        17             29      Eric    Messier   0         Canada  Left Wing
#> 18        18              3     Aaron     Miller   0            USA    Defence
#> 19        19              2     Bryan       Muir   0         Canada    Defence
#> 20        20             39     Ville   Nieminen   0        Finland  Left Wing
#> 21        21             27     Scott     Parker   0            USA Right Wing
#> 22        22             25     Shjon     Podein   0            USA Right Wing
#> 23        23           4-44     Nolan      Pratt   0          Canda    Defence
#> 24        24             63      Joel      Prpic   0         Canada     Center
#> 25        25             14      Dave       Reid   0         Canada Right Wing
#> 26        26             28     Steve Reinprecht   0         Canada     Center
#> 27        27             33   Patrick        Roy   1         Canada       Goal
#> 28        28             19       Joe      Sakic   1         Canada     Center
#> 29        29             44       Rob    Shearer   0         Canada     Center
#> 30        30             41    Martin     Skoula   0 Czechoslovakia    Defence
#> 31        31             40      Alex    Tanguay   0         Canada  Left Wing
#> 32        32             26  Stephane      Yelle   0         Canada     Center
#>     birthdate first_nhl_game last_nhl_game height weight shoots catches
#> 1  1978-02-07     2001-04-07    2007-10-10     73    185   <NA>    Left
#> 2  1978-01-02     2000-11-22    2000-11-29     73    200   Left    <NA>
#> 3  1978-11-04     2001-01-07    2004-04-04     74    210   Left    <NA>
#> 4  1969-12-10     1990-03-27    2010-05-23     76    220  Right    <NA>
#> 5  1960-12-28     1979-10-11    2001-06-09     71    219   Left    <NA>
#> 6  1973-01-04     1996-01-17    2009-04-10     74    205   Left    <NA>
#> 7  1975-05-10     1995-01-21    2002-12-15     72    205  Right    <NA>
#> 8  1976-07-06     1997-10-01    2006-04-25     76    235   Left    <NA>
#> 9  1976-08-20     1998-10-10    2011-04-23     70    191  Right    <NA>
#> 10 1971-07-10     1991-10-19    2011-04-10     74    220  Right    <NA>
#> 11 1973-07-20     1995-01-11    2011-02-12     72    205   Left    <NA>
#> 12 1964-07-08     1990-12-15    2001-05-21     75    185   Left    <NA>
#> 13 1976-02-14     1998-10-10    2013-04-27     72    190  Right    <NA>
#> 14 1977-01-30     1999-10-05    2009-04-21     72    187  Right    <NA>
#> 15 1970-01-08     1992-02-23    2008-04-03     74    205  Right    <NA>
#> 16 1977-06-28           <NA>          <NA>     72    210   Left    <NA>
#> 17 1973-10-29     1996-11-11    2003-11-21     74    195   Left    <NA>
#> 18 1971-08-11     1994-01-15    2008-03-06     75    210  Right    <NA>
#> 19 1973-06-08     1996-03-08    2007-04-07     75    224   Left    <NA>
#> 20 1977-04-06     2000-01-29    2007-04-05     71    200   Left    <NA>
#> 21 1978-01-29     1998-11-28    2008-03-11     77    240  Right    <NA>
#> 22 1968-03-05     1993-01-09    2003-04-22     74    200   Left    <NA>
#> 23 1975-08-14     1996-10-05    2008-04-03     75    207   Left    <NA>
#> 24 1974-09-25           <NA>          <NA>     78    225   Left    <NA>
#> 25 1964-05-15     1983-12-23    2001-06-09     73    217   Left    <NA>
#> 26 1976-05-07           <NA>          <NA>     72    195   Left    <NA>
#> 27 1965-10-05     1985-02-23    2003-04-22     74    185   <NA>    Left
#> 28 1969-07-07     1988-10-06    2008-11-28     71    195   Left    <NA>
#> 29 1976-10-19     2000-11-11    2000-11-13     70    190  Right    <NA>
#> 30 1979-10-28     1999-10-05    2010-04-22     75    226   Left    <NA>
#> 31 1979-11-21     1999-10-05    2016-04-19     73    194   Left    <NA>
#> 32 1974-05-09     1995-10-06    2010-04-24     74    182   Left    <NA>
#>    experience roster_complete gp goals assists points plusmn pimi goals_ev
#> 1           0        Complete 26     0       1      1      0    0        0
#> 2           0        Complete  3     0       0      0      0    0        0
#> 3           0        Complete 19     0       4      4      5   38        0
#> 4          11        Complete 13     2       8     10     11    8        1
#> 5          21        Complete 80     7      52     59     25   48        3
#> 6           5        Complete 79     5      12     17     23   51        5
#> 7           6        Complete 39    13      13     26     -2   59        6
#> 8           3        Complete 41     1       1      2     -3  108        1
#> 9           2        Complete 71    24      41     65      6   47       13
#> 10          9        Complete 35     3      12     15      6   42        1
#> 11          6        Complete 73    27      62     89     23   54       12
#> 12         10        Complete  9     0       1      1      2    6        0
#> 13          2        Complete 80    41      38     79     32   36       28
#> 14          1        Complete 76     5      10     15      1   51        4
#> 15          8        Complete 78     4      11     15     22   54        2
#> 16          1      Incomplete  9     0       0      0      1    0        0
#> 17          4        Complete 64     5       7     12     -3   26        5
#> 18          7        Complete 56     4       9     13     19   29        4
#> 19          4      Unverified  8     0       0      0      0    4        0
#> 20          1        Complete 50    14       8     22      8   38       12
#> 21         10        Complete 69     2       3      5     -2  155        2
#> 22          8        Complete 82    15      17     32      7   68       15
#> 23          4        Complete 46     1       2      3      2   40        1
#> 24          2      Incomplete  3     0       0      0      0    2        0
#> 25         17        Complete 73     1       9     10      1   21        1
#> 26          1      Incomplete 21     3       4      7     -1    2        3
#> 27         16        Complete 62     0       5      5      0   10        0
#> 28         12        Complete 82    54      64    118     45   30       32
#> 29          0        Complete  2     0       0      0     -2    0        0
#> 30         11        Complete 82     8      17     25      8   38        5
#> 31          1        Complete 82    27      50     77     35   37       19
#> 32          5        Complete 50     4      10     14     -3   20        3
#>    goals_pp goals_sh goals_gw assists_ev assists_pp assists_sh shots
#> 1         0        0        0         NA         NA         NA     0
#> 2         0        0        0          0          0          0     2
#> 3         0        0        0          4          0          0    10
#> 4         1        0        1          6          2          0    44
#> 5         2        2        0         21         31          0   216
#> 6         0        0        0         11          0          1    76
#> 7         7        0        2          7          6          0    86
#> 8         0        0        0          1          0          0    33
#> 9        11        0        5         22         18          0   204
#> 10        1        1        1          7          5          0    59
#> 11       12        2        5         34         24          4   178
#> 12        0        0        0          1          0          0     4
#> 13       12        1        9         21         15          2   213
#> 14        1        0        1          8          2          0    69
#> 15        2        0        2          6          3          2    97
#> 16        0        0        0          0          0          0     3
#> 17        0        0        1          7          0          0    60
#> 18        0        0        0          8          0          1    49
#> 19        0        0        0          0          0          0     3
#> 20        2        0        3          5          3          0    68
#> 21        0        0        1          3          0          0    35
#> 22        0        0        3         17          0          0   137
#> 23        0        0        1          2          0          0    26
#> 24        0        0        0          0          0          0     0
#> 25        0        0        0          8          0          1    66
#> 26        0        0        0          3          0          1    28
#> 27        0        0        0         NA         NA         NA     0
#> 28       19        3       12         34         27          3   332
#> 29        0        0        0          0          0          0     0
#> 30        3        0        2         11          6          0   108
#> 31        7        1        3         39         11          0   135
#> 32        0        1        0         10          0          0    54
#>    shooting_percentage  toi    atoi regular_season_scoring_complete wins losses
#> 1             0.000000 1393 53M 34S                        Complete   12      7
#> 2             0.000000   32 10M 34S                        Complete   NA     NA
#> 3             0.000000  231  12M 8S                        Complete   NA     NA
#> 4             4.545455  339  26M 3S                        Complete   NA     NA
#> 5             3.240741 2088  26M 6S                        Complete   NA     NA
#> 6             6.578947 1351  17M 6S                        Complete   NA     NA
#> 7            15.116279  687 17M 38S                        Complete   NA     NA
#> 8             3.030303  264  6M 26S                        Complete   NA     NA
#> 9            11.764706 1281  18M 3S                        Complete   NA     NA
#> 10            5.084746  888 25M 22S                        Complete   NA     NA
#> 11           15.168539 1518 20M 48S                        Complete   NA     NA
#> 12            0.000000  135 14M 59S                        Complete   NA     NA
#> 13           19.248826 1589 19M 52S                        Complete   NA     NA
#> 14            7.246377  787 10M 21S                        Complete   NA     NA
#> 15            4.123711 1554 19M 56S                        Complete   NA     NA
#> 16            0.000000   84  9M 17S                        Complete   NA     NA
#> 17            8.333333  786 12M 16S                        Complete   NA     NA
#> 18            8.163265 1032 18M 25S                        Complete   NA     NA
#> 19            0.000000   66  8M 14S                        Complete   NA     NA
#> 20           20.588235  622 12M 26S                        Complete   NA     NA
#> 21            5.714286  394  5M 42S                        Complete   NA     NA
#> 22           10.948905 1180 14M 23S                        Complete   NA     NA
#> 23            3.846154  452  9M 50S                        Complete   NA     NA
#> 24                  NA   29  9M 47S                        Complete   NA     NA
#> 25            1.515152  721  9M 53S                        Complete   NA     NA
#> 26           10.714286  328 15M 38S                        Complete   NA     NA
#> 27                  NA 3565 57M 30S                        Complete   40     13
#> 28           16.265060 1887  23M 1S                        Complete   NA     NA
#> 29                  NA   14  6M 45S                        Complete   NA     NA
#> 30            7.407407 1697 20M 41S                        Complete   NA     NA
#> 31           20.000000 1464 17M 51S                        Complete   NA     NA
#> 32            7.407407  723 14M 28S                        Complete   NA     NA
#>    ties_otl goals_against shots_against saves save_percentage  gaa so
#> 1         3            52           538   486       0.9033457 2.24  3
#> 2        NA            NA            NA    NA              NA   NA NA
#> 3        NA            NA            NA    NA              NA   NA NA
#> 4        NA            NA            NA    NA              NA   NA NA
#> 5        NA            NA            NA    NA              NA   NA NA
#> 6        NA            NA            NA    NA              NA   NA NA
#> 7        NA            NA            NA    NA              NA   NA NA
#> 8        NA            NA            NA    NA              NA   NA NA
#> 9        NA            NA            NA    NA              NA   NA NA
#> 10       NA            NA            NA    NA              NA   NA NA
#> 11       NA            NA            NA    NA              NA   NA NA
#> 12       NA            NA            NA    NA              NA   NA NA
#> 13       NA            NA            NA    NA              NA   NA NA
#> 14       NA            NA            NA    NA              NA   NA NA
#> 15       NA            NA            NA    NA              NA   NA NA
#> 16       NA            NA            NA    NA              NA   NA NA
#> 17       NA            NA            NA    NA              NA   NA NA
#> 18       NA            NA            NA    NA              NA   NA NA
#> 19       NA            NA            NA    NA              NA   NA NA
#> 20       NA            NA            NA    NA              NA   NA NA
#> 21       NA            NA            NA    NA              NA   NA NA
#> 22       NA            NA            NA    NA              NA   NA NA
#> 23       NA            NA            NA    NA              NA   NA NA
#> 24       NA            NA            NA    NA              NA   NA NA
#> 25       NA            NA            NA    NA              NA   NA NA
#> 26       NA            NA            NA    NA              NA   NA NA
#> 27        7           132          1513  1281       0.8466623 2.22  4
#> 28       NA            NA            NA    NA              NA   NA NA
#> 29       NA            NA            NA    NA              NA   NA NA
#> 30       NA            NA            NA    NA              NA   NA NA
#> 31       NA            NA            NA    NA              NA   NA NA
#> 32       NA            NA            NA    NA              NA   NA NA
#>    regular_season_goalies_complete gp_postseason goals_postseason
#> 1                         Complete             1                0
#> 2                         Complete             0               NA
#> 3                         Complete             0               NA
#> 4                         Complete            23                6
#> 5                         Complete            21                4
#> 6                         Complete            23                0
#> 7                         Complete             0               NA
#> 8                         Complete            16                0
#> 9                         Complete            23               11
#> 10                        Complete            23                3
#> 11                        Complete            11                4
#> 12                        Complete             0               NA
#> 13                        Complete            23                7
#> 14                        Complete            23                2
#> 15                        Complete            22                1
#> 16                        Complete             0               NA
#> 17                        Complete            23                2
#> 18                        Complete             0               NA
#> 19                        Complete             3                0
#> 20                        Complete            23                4
#> 21                        Complete             4                0
#> 22                        Complete            23                2
#> 23                        Complete             0               NA
#> 24                        Complete             0               NA
#> 25                        Complete            18                0
#> 26                        Complete            22                2
#> 27                        Complete            23                0
#> 28                        Complete            21               13
#> 29                        Complete             0               NA
#> 30                        Complete            23                1
#> 31                        Complete            23                6
#> 32                        Complete            23                1
#>    assists_postseason points_postseason plusmn_postseason pimi_postseason
#> 1                   0                 0                 0               0
#> 2                  NA                NA                NA              NA
#> 3                  NA                NA                NA              NA
#> 4                  13                19                 6              16
#> 5                   6                10                 9              12
#> 6                   1                 1                 5              20
#> 7                  NA                NA                NA              NA
#> 8                   4                 4                 3              14
#> 9                   5                16                 5               4
#> 10                  4                 7                 5              47
#> 11                 10                14                 5               6
#> 12                 NA                NA                NA              NA
#> 13                 16                23                 8               6
#> 14                  4                 6                 4              21
#> 15                  2                 3                 7              16
#> 16                 NA                NA                NA              NA
#> 17                  2                 4                 0              14
#> 18                 NA                NA                NA              NA
#> 19                  0                 0                 0               0
#> 20                  6                10                -1              20
#> 21                  0                 0                 0               2
#> 22                  3                 5                 3              14
#> 23                 NA                NA                NA              NA
#> 24                 NA                NA                NA              NA
#> 25                  4                 4                 2               6
#> 26                  3                 5                 0               2
#> 27                  1                 1                 0               0
#> 28                 13                26                 6               6
#> 29                 NA                NA                NA              NA
#> 30                  4                 5                 1               8
#> 31                 15                21                13               8
#> 32                  2                 3                 2               8
#>    goals_ev_postseason goals_pp_postseason goals_sh_postseason
#> 1                    0                   0                   0
#> 2                   NA                  NA                  NA
#> 3                   NA                  NA                  NA
#> 4                    3                   3                   0
#> 5                    1                   3                   0
#> 6                    0                   0                   0
#> 7                   NA                  NA                  NA
#> 8                    0                   0                   0
#> 9                    9                   2                   0
#> 10                   2                   1                   0
#> 11                   3                   1                   0
#> 12                  NA                  NA                  NA
#> 13                   3                   4                   0
#> 14                   2                   0                   0
#> 15                   1                   0                   0
#> 16                  NA                  NA                  NA
#> 17                   2                   0                   0
#> 18                  NA                  NA                  NA
#> 19                   0                   0                   0
#> 20                   1                   3                   0
#> 21                   0                   0                   0
#> 22                   2                   0                   0
#> 23                  NA                  NA                  NA
#> 24                  NA                  NA                  NA
#> 25                   0                   0                   0
#> 26                   2                   0                   0
#> 27                   0                   0                   0
#> 28                   8                   5                   0
#> 29                  NA                  NA                  NA
#> 30                   1                   0                   0
#> 31                   5                   1                   0
#> 32                   1                   0                   0
#>    goals_gw_postseason assists_ev_postseason assists_pp_postseason
#> 1                    0                    NA                    NA
#> 2                   NA                    NA                    NA
#> 3                   NA                    NA                    NA
#> 4                    0                    NA                    NA
#> 5                    1                    NA                    NA
#> 6                    0                    NA                    NA
#> 7                   NA                    NA                    NA
#> 8                    0                    NA                    NA
#> 9                    2                    NA                    NA
#> 10                   1                    NA                    NA
#> 11                   2                    NA                    NA
#> 12                  NA                    NA                    NA
#> 13                   1                    NA                    NA
#> 14                   0                    NA                    NA
#> 15                   1                    NA                    NA
#> 16                  NA                    NA                    NA
#> 17                   0                    NA                    NA
#> 18                  NA                    NA                    NA
#> 19                   0                    NA                    NA
#> 20                   1                    NA                    NA
#> 21                   0                    NA                    NA
#> 22                   1                    NA                    NA
#> 23                  NA                    NA                    NA
#> 24                  NA                    NA                    NA
#> 25                   0                    NA                    NA
#> 26                   0                    NA                    NA
#> 27                   0                    NA                    NA
#> 28                   3                    NA                    NA
#> 29                  NA                    NA                    NA
#> 30                   0                    NA                    NA
#> 31                   2                    NA                    NA
#> 32                   1                    NA                    NA
#>    assists_sh_postseason shots_postseason shooting_percentage_postseason
#> 1                     NA                0                             NA
#> 2                     NA               NA                             NA
#> 3                     NA               NA                             NA
#> 4                     NA               83                       7.228916
#> 5                     NA               49                       8.163265
#> 6                     NA               20                       0.000000
#> 7                     NA               NA                             NA
#> 8                     NA                8                       0.000000
#> 9                     NA               62                      17.741935
#> 10                    NA               28                      10.714286
#> 11                    NA               23                      17.391304
#> 12                    NA               NA                             NA
#> 13                    NA               51                      13.725490
#> 14                    NA               16                      12.500000
#> 15                    NA               14                       7.142857
#> 16                    NA               NA                             NA
#> 17                    NA               20                      10.000000
#> 18                    NA               NA                             NA
#> 19                    NA                0                             NA
#> 20                    NA               39                      10.256410
#> 21                    NA                0                             NA
#> 22                    NA               16                      12.500000
#> 23                    NA               NA                             NA
#> 24                    NA               NA                             NA
#> 25                    NA                8                       0.000000
#> 26                    NA               14                      14.285714
#> 27                    NA                0                             NA
#> 28                    NA               79                      16.455696
#> 29                    NA               NA                             NA
#> 30                    NA               14                       7.142857
#> 31                    NA               37                      16.216216
#> 32                    NA               23                       4.347826
#>    toi_postseason atoi_postseason post_season_scoring_complete wins_postseason
#> 1               1             32S                     Complete               0
#> 2              NA            <NA>                     Complete              NA
#> 3              NA            <NA>                     Complete              NA
#> 4             677         29M 26S                     Complete              NA
#> 5             599         28M 32S                     Complete              NA
#> 6             328         14M 17S                     Complete              NA
#> 7              NA            <NA>                     Complete              NA
#> 8             101          6M 18S                     Complete              NA
#> 9             439          19M 6S                     Complete              NA
#> 10            652         28M 22S                     Complete              NA
#> 11            241         21M 55S                     Complete              NA
#> 12             NA            <NA>                     Complete              NA
#> 13            496         21M 33S                     Complete              NA
#> 14            192          8M 22S                     Complete              NA
#> 15            357         16M 15S                     Complete              NA
#> 16             NA            <NA>                     Complete              NA
#> 17            374         16M 16S                     Complete              NA
#> 18             NA            <NA>                     Complete              NA
#> 19             10          3M 15S                     Complete              NA
#> 20            326         14M 10S                     Complete              NA
#> 21              9          2M 12S                     Complete              NA
#> 22            345         14M 59S                     Complete              NA
#> 23             NA            <NA>                     Complete              NA
#> 24             NA            <NA>                     Complete              NA
#> 25            164           9M 8S                     Complete              NA
#> 26            267          12M 9S                     Complete              NA
#> 27           1451            <NA>                   Incomplete              16
#> 28            452         21M 33S                     Complete              NA
#> 29             NA            <NA>                     Complete              NA
#> 30            276         11M 59S                     Complete              NA
#> 31            444         19M 18S                     Complete              NA
#> 32            319         13M 52S                     Complete              NA
#>    losses_postseason ties_otl_postseason goals_allowed_postseason
#> 1                  0                  NA                        0
#> 2                 NA                  NA                       NA
#> 3                 NA                  NA                       NA
#> 4                 NA                  NA                       NA
#> 5                 NA                  NA                       NA
#> 6                 NA                  NA                       NA
#> 7                 NA                  NA                       NA
#> 8                 NA                  NA                       NA
#> 9                 NA                  NA                       NA
#> 10                NA                  NA                       NA
#> 11                NA                  NA                       NA
#> 12                NA                  NA                       NA
#> 13                NA                  NA                       NA
#> 14                NA                  NA                       NA
#> 15                NA                  NA                       NA
#> 16                NA                  NA                       NA
#> 17                NA                  NA                       NA
#> 18                NA                  NA                       NA
#> 19                NA                  NA                       NA
#> 20                NA                  NA                       NA
#> 21                NA                  NA                       NA
#> 22                NA                  NA                       NA
#> 23                NA                  NA                       NA
#> 24                NA                  NA                       NA
#> 25                NA                  NA                       NA
#> 26                NA                  NA                       NA
#> 27                 7                  NA                       41
#> 28                NA                  NA                       NA
#> 29                NA                  NA                       NA
#> 30                NA                  NA                       NA
#> 31                NA                  NA                       NA
#> 32                NA                  NA                       NA
#>    saves_postseason save_percentage_postseason gaa_postseason so_postseason
#> 1                 0                      0.000            0.0             0
#> 2                NA                         NA             NA            NA
#> 3                NA                         NA             NA            NA
#> 4                NA                         NA             NA            NA
#> 5                NA                         NA             NA            NA
#> 6                NA                         NA             NA            NA
#> 7                NA                         NA             NA            NA
#> 8                NA                         NA             NA            NA
#> 9                NA                         NA             NA            NA
#> 10               NA                         NA             NA            NA
#> 11               NA                         NA             NA            NA
#> 12               NA                         NA             NA            NA
#> 13               NA                         NA             NA            NA
#> 14               NA                         NA             NA            NA
#> 15               NA                         NA             NA            NA
#> 16               NA                         NA             NA            NA
#> 17               NA                         NA             NA            NA
#> 18               NA                         NA             NA            NA
#> 19               NA                         NA             NA            NA
#> 20               NA                         NA             NA            NA
#> 21               NA                         NA             NA            NA
#> 22               NA                         NA             NA            NA
#> 23               NA                         NA             NA            NA
#> 24               NA                         NA             NA            NA
#> 25               NA                         NA             NA            NA
#> 26               NA                         NA             NA            NA
#> 27              622                      0.934            1.7             4
#> 28               NA                         NA             NA            NA
#> 29               NA                         NA             NA            NA
#> 30               NA                         NA             NA            NA
#> 31               NA                         NA             NA            NA
#> 32               NA                         NA             NA            NA
#>    post_season_goalies_complete eg_checkbox___cb01 eg_checkbox___cb02
#> 1                      Complete                  1                  0
#> 2                      Complete                  0                  1
#> 3                      Complete                  0                  0
#> 4                      Complete                  0                  0
#> 5                      Complete                  0                  1
#> 6                      Complete                  1                  0
#> 7                      Complete                  1                  1
#> 8                      Complete                  1                  1
#> 9                      Complete                  0                  0
#> 10                     Complete                  1                  1
#> 11                     Complete                  0                  0
#> 12                     Complete                  1                  0
#> 13                     Complete                  0                  0
#> 14                     Complete                  0                  1
#> 15                     Complete                  1                  1
#> 16                     Complete                  0                  0
#> 17                   Incomplete                  0                  0
#> 18                     Complete                  1                  1
#> 19                     Complete                  1                  0
#> 20                     Complete                  0                  1
#> 21                     Complete                  0                  0
#> 22                     Complete                  1                  0
#> 23                     Complete                  1                  1
#> 24                     Complete                  1                  1
#> 25                     Complete                  0                  1
#> 26                     Complete                  0                  1
#> 27                     Complete                  0                  0
#> 28                     Complete                  1                  1
#> 29                     Complete                  0                  1
#> 30                     Complete                  1                  0
#> 31                     Complete                  0                  0
#> 32                     Complete                  0                  0
#>    eg_checkbox___cb03 extras_complete
#> 1                   0      Incomplete
#> 2                   0      Incomplete
#> 3                   0      Incomplete
#> 4                   0      Incomplete
#> 5                   0      Incomplete
#> 6                   0      Incomplete
#> 7                   0      Incomplete
#> 8                   0      Incomplete
#> 9                   0      Incomplete
#> 10                  0      Incomplete
#> 11                  0      Incomplete
#> 12                  0      Incomplete
#> 13                  0      Incomplete
#> 14                  0      Incomplete
#> 15                  0      Incomplete
#> 16                  0      Incomplete
#> 17                  0      Incomplete
#> 18                  0      Incomplete
#> 19                  0      Incomplete
#> 20                  0      Incomplete
#> 21                  0      Incomplete
#> 22                  0      Incomplete
#> 23                  0      Incomplete
#> 24                  0      Incomplete
#> 25                  0      Incomplete
#> 26                  0      Incomplete
#> 27                  0      Incomplete
#> 28                  0      Incomplete
#> 29                  0      Incomplete
#> 30                  0      Incomplete
#> 31                  0      Incomplete
#> 32                  0      Incomplete
```
