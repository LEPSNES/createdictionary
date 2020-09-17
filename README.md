
<!-- README.md is generated from README.Rmd. Please edit that file -->

# createdictionary

<!-- badges: start -->

<!-- badges: end -->

``` r
# output: github_document
#   always_allow_html: true
```

This package of createdictionary was developed at the Neuroepidemiology
Section (NES) of Laboratory of Epidemiology & Population Science (LEPS),
NIA. The goal is to build a one-document dictionary from multiple
datasets; the key values are extracted for each variable.

## Installation

You can install the released version of createdictionary from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("createdictionary")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("LEPSNES/createdictionary")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
## get folder path
df <- system.file(package = "haven")
## search all the files under the folder for sas dataset
dse <- flat2file(df, "*.sas7bdat")
## dic_value_extract_one_dataset_path uses file path as input
dse %>%
  dic_value_extract_one_dataset_path()
#> Warning in mean.default(x, na.rm = T): argument is not numeric or logical:
#> returning NA
#>       var_name label value_distinct    max    min             mean top1_value
#> 1 Sepal_Length    NA             35    7.9    4.3 5.84333333333333          5
#> 2  Sepal_Width    NA             23    4.4      2 3.05733333333333          3
#> 3 Petal_Length    NA             43    6.9      1            3.758        1.4
#> 4  Petal_Width    NA             22    2.5    0.1 1.19933333333333        0.2
#> 5      Species    NA              3 virgin setosa             <NA>     setosa
#>   top1_freq top2_value top2_freq top3_value top3_freq     file_name
#> 1        10        5.1         9        6.3         9 iris.sas7bdat
#> 2        26        2.8        14        3.2        13 iris.sas7bdat
#> 3        13        1.5        13        4.5         8 iris.sas7bdat
#> 4        29        1.3        13        1.5        12 iris.sas7bdat
#> 5        50     versic        50     virgin        50 iris.sas7bdat
#>                                                       dir_name
#> 1 /home/liz30/R/x86_64-pc-linux-gnu-library/4.0/haven/examples
#> 2 /home/liz30/R/x86_64-pc-linux-gnu-library/4.0/haven/examples
#> 3 /home/liz30/R/x86_64-pc-linux-gnu-library/4.0/haven/examples
#> 4 /home/liz30/R/x86_64-pc-linux-gnu-library/4.0/haven/examples
#> 5 /home/liz30/R/x86_64-pc-linux-gnu-library/4.0/haven/examples

## dic_value_extract_one_dataset uses a data frame as input
dse[1] %>% 
  read_sas() %>% 
  dic_value_extract_one_dataset()
#> Warning in mean.default(x, na.rm = T): argument is not numeric or logical:
#> returning NA
#>       var_name label value_distinct    max    min             mean top1_value
#> 1 Sepal_Length    NA             35    7.9    4.3 5.84333333333333          5
#> 2  Sepal_Width    NA             23    4.4      2 3.05733333333333          3
#> 3 Petal_Length    NA             43    6.9      1            3.758        1.4
#> 4  Petal_Width    NA             22    2.5    0.1 1.19933333333333        0.2
#> 5      Species    NA              3 virgin setosa             <NA>     setosa
#>   top1_freq top2_value top2_freq top3_value top3_freq
#> 1        10        5.1         9        6.3         9
#> 2        26        2.8        14        3.2        13
#> 3        13        1.5        13        4.5         8
#> 4        29        1.3        13        1.5        12
#> 5        50     versic        50     virgin        50

## dic_value_extract_one_var process a variable each time
dse %>% 
  read_sas() %>% 
  imap_dfr( ~ dic_value_extract_one_var(.x, .y))
#> Warning in mean.default(x, na.rm = T): argument is not numeric or logical:
#> returning NA
#>       var_name label value_distinct    max    min             mean top1_value
#> 1 Sepal_Length    NA             35    7.9    4.3 5.84333333333333          5
#> 2  Sepal_Width    NA             23    4.4      2 3.05733333333333          3
#> 3 Petal_Length    NA             43    6.9      1            3.758        1.4
#> 4  Petal_Width    NA             22    2.5    0.1 1.19933333333333        0.2
#> 5      Species    NA              3 virgin setosa             <NA>     setosa
#>   top1_freq top2_value top2_freq top3_value top3_freq
#> 1        10        5.1         9        6.3         9
#> 2        26        2.8        14        3.2        13
#> 3        13        1.5        13        4.5         8
#> 4        29        1.3        13        1.5        12
#> 5        50     versic        50     virgin        50
```

``` r
df <- "/LSC/NES/study/CARDIA/core datasets/Y25/DATA"
## on windows, use this
## df <- "T:/LEPS/NES/study/CARDIA/core datasets/Y25/DATA"
dse <- flat2file(df, "*.sas7bdat")
dse[3] %>%
  dic_value_extract_one_dataset_path()
#> Warning in mean.default(x, na.rm = T): argument is not numeric or logical:
#> returning NA

#> Warning in mean.default(x, na.rm = T): argument is not numeric or logical:
#> returning NA
#>    var_name                                         label value_distinct
#> 1        ID                             SUBJECT ID NUMBER           3480
#> 2    CENTER                       YEAR 0 EXAMINING CENTER              4
#> 3 HL7CRPSTA               C-REACTIVE PROTEIN ASSAY STATUS              2
#> 4 HL7CRPTYP                 C-REACTIVE PROTEIN ASSAY TYPE              3
#> 5  HL6CRPBN C-REACTIVE PROTEIN (uG/ML) - HIGH SENSITIVITY            828
#> 6 HL7CRPCDT               C-REACTIVE PROTEIN COLLECT DATE              1
#> 7 HL7CRPRDT              C-REACTIVE PROTEIN RECEIVED DATE              1
#> 8 HL7CRPADT                 C-REACTIVE PROTEIN ASSAY DATE              1
#> 9   HL6CRPF              FLAG C-REACTIVE PROTEIN (2: QNS)              2
#>            max          min             mean   top1_value top1_freq
#> 1 416817227898 100023004268 265330540437.525 100023004268         1
#> 2            4            1 2.57701149425287            4       954
#> 3            F            C             <NA>            F      3475
#> 4            S            C             <NA>            N      3473
#> 5          199          0.1 3.26675496688742         0.19        26
#> 6   1960-01-01   1960-01-01       1960-01-01   1960-01-01      3480
#> 7   1960-01-01   1960-01-01       1960-01-01   1960-01-01      3480
#> 8   1960-01-01   1960-01-01       1960-01-01   1960-01-01      3480
#> 9            2            2                2            2         7
#>     top2_value top2_freq   top3_value top3_freq      file_name
#> 1 100033323702         1 100056526386         1 h3crp.sas7bdat
#> 2            3       919            1       819 h3crp.sas7bdat
#> 3            C         5         <NA>      <NA> h3crp.sas7bdat
#> 4            S         5            C         2 h3crp.sas7bdat
#> 5         0.26        25         0.39        25 h3crp.sas7bdat
#> 6         <NA>      <NA>         <NA>      <NA> h3crp.sas7bdat
#> 7         <NA>      <NA>         <NA>      <NA> h3crp.sas7bdat
#> 8         <NA>      <NA>         <NA>      <NA> h3crp.sas7bdat
#> 9         <NA>      <NA>         <NA>      <NA> h3crp.sas7bdat
#>                                       dir_name
#> 1 /LSC/NES/study/CARDIA/core datasets/Y25/DATA
#> 2 /LSC/NES/study/CARDIA/core datasets/Y25/DATA
#> 3 /LSC/NES/study/CARDIA/core datasets/Y25/DATA
#> 4 /LSC/NES/study/CARDIA/core datasets/Y25/DATA
#> 5 /LSC/NES/study/CARDIA/core datasets/Y25/DATA
#> 6 /LSC/NES/study/CARDIA/core datasets/Y25/DATA
#> 7 /LSC/NES/study/CARDIA/core datasets/Y25/DATA
#> 8 /LSC/NES/study/CARDIA/core datasets/Y25/DATA
#> 9 /LSC/NES/study/CARDIA/core datasets/Y25/DATA

dse[1:3] %>%
  map_dfr(dic_value_extract_one_dataset_path) %>% 
  slice_head(n=7)
#> Warning in mean.default(x, na.rm = T): argument is not numeric or logical:
#> returning NA

#> Warning in mean.default(x, na.rm = T): argument is not numeric or logical:
#> returning NA
#> Warning in max(x, na.rm = T): no non-missing arguments to max; returning -Inf
#> Warning in min(x, na.rm = T): no non-missing arguments to min; returning Inf
#> Warning in mean.default(x, na.rm = T): argument is not numeric or logical:
#> returning NA

#> Warning in mean.default(x, na.rm = T): argument is not numeric or logical:
#> returning NA
#>     var_name label value_distinct         max   min                 mean
#> 1   short_ID  <NA>           5114       41681 10001     26785.9657802112
#> 2 Y15cactot1  <NA>            218 4426.505493     0     8.15285217555995
#> 3 Y15cactot2  <NA>            220 3530.067261     0     8.44491058751245
#> 4    Y15CABG  <NA>              2           0     0                    0
#> 5   Y15pacer  <NA>              2           0     0                    0
#> 6   Y15stent  <NA>              3           1     0 0.000657246138678935
#> 7   Y15valve  <NA>              3           1     0 0.000328623069339468
#>   top1_value top1_freq top2_value top2_freq top3_value top3_freq
#> 1      10001         1      10002         1      10003         1
#> 2          0      2758    4.67309         6   6.542326         6
#> 3          0      2740   5.607708         8    4.67309         6
#> 4          0      3043       <NA>      <NA>       <NA>      <NA>
#> 5          0      3043       <NA>      <NA>       <NA>      <NA>
#> 6          0      3041          1         2       <NA>      <NA>
#> 7          0      3042          1         1       <NA>      <NA>
#>                      file_name                                     dir_name
#> 1 fghctr01_dec07_2012.sas7bdat /LSC/NES/study/CARDIA/core datasets/Y25/DATA
#> 2 fghctr01_dec07_2012.sas7bdat /LSC/NES/study/CARDIA/core datasets/Y25/DATA
#> 3 fghctr01_dec07_2012.sas7bdat /LSC/NES/study/CARDIA/core datasets/Y25/DATA
#> 4 fghctr01_dec07_2012.sas7bdat /LSC/NES/study/CARDIA/core datasets/Y25/DATA
#> 5 fghctr01_dec07_2012.sas7bdat /LSC/NES/study/CARDIA/core datasets/Y25/DATA
#> 6 fghctr01_dec07_2012.sas7bdat /LSC/NES/study/CARDIA/core datasets/Y25/DATA
#> 7 fghctr01_dec07_2012.sas7bdat /LSC/NES/study/CARDIA/core datasets/Y25/DATA
```

Please check the help document for each function to see how to use them.

``` r
?flat2file
?dic_value_extract_one_dataset_path
?dic_value_extract_one_dataset
?dic_value_extract_one_var
```
