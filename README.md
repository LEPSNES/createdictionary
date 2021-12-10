
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
[CRAN](https://CRAN.R-project.org) with (This installation option is
currently unavailable yet):

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
#> # A tibble: 5 x 21
#>   var_name label value_distinct mean  sd    largest_1 largest_2 largest_3
#>   <chr>    <chr> <chr>          <chr> <chr> <chr>     <chr>     <chr>    
#> 1 Sepal_L… <NA>  35             5.84… 0.82… 7.9       7.7       7.6      
#> 2 Sepal_W… <NA>  23             3.05… 0.43… 4.4       4.2       4.1      
#> 3 Petal_L… <NA>  43             3.758 1.76… 6.9       6.7       6.6      
#> 4 Petal_W… <NA>  22             1.19… 0.76… 2.5       2.4       2.3      
#> 5 Species  <NA>  3              <NA>  <NA>  virgin    versic    setosa   
#> # … with 13 more variables: smallest_1 <chr>, smallest_2 <chr>,
#> #   smallest_3 <chr>, top1_value <chr>, top1_freq <chr>, top2_value <chr>,
#> #   top2_freq <chr>, top3_value <chr>, top3_freq <chr>, num_NA <chr>,
#> #   total_row <int>, file_name <chr>, dir_name <chr>

## dic_value_extract_one_dataset uses a data frame as input
dse[1] %>% 
  read_sas() %>% 
  dic_value_extract_one_dataset()
#> # A tibble: 5 x 18
#>   var_name label value_distinct mean  sd    largest_1 largest_2 largest_3
#>   <chr>    <chr> <chr>          <chr> <chr> <chr>     <chr>     <chr>    
#> 1 Sepal_L… <NA>  35             5.84… 0.82… 7.9       7.7       7.6      
#> 2 Sepal_W… <NA>  23             3.05… 0.43… 4.4       4.2       4.1      
#> 3 Petal_L… <NA>  43             3.758 1.76… 6.9       6.7       6.6      
#> 4 Petal_W… <NA>  22             1.19… 0.76… 2.5       2.4       2.3      
#> 5 Species  <NA>  3              <NA>  <NA>  virgin    versic    setosa   
#> # … with 10 more variables: smallest_1 <chr>, smallest_2 <chr>,
#> #   smallest_3 <chr>, top1_value <chr>, top1_freq <chr>, top2_value <chr>,
#> #   top2_freq <chr>, top3_value <chr>, top3_freq <chr>, num_NA <chr>

## dic_value_extract_one_var process a variable each time
dse %>% 
  read_sas() %>% 
  imap_dfr( ~ dic_value_extract_one_var(.x, .y))
#> # A tibble: 5 x 18
#>   var_name label value_distinct mean  sd    largest_1 largest_2 largest_3
#>   <chr>    <chr> <chr>          <chr> <chr> <chr>     <chr>     <chr>    
#> 1 Sepal_L… <NA>  35             5.84… 0.82… 7.9       7.7       7.6      
#> 2 Sepal_W… <NA>  23             3.05… 0.43… 4.4       4.2       4.1      
#> 3 Petal_L… <NA>  43             3.758 1.76… 6.9       6.7       6.6      
#> 4 Petal_W… <NA>  22             1.19… 0.76… 2.5       2.4       2.3      
#> 5 Species  <NA>  3              <NA>  <NA>  virgin    versic    setosa   
#> # … with 10 more variables: smallest_1 <chr>, smallest_2 <chr>,
#> #   smallest_3 <chr>, top1_value <chr>, top1_freq <chr>, top2_value <chr>,
#> #   top2_freq <chr>, top3_value <chr>, top3_freq <chr>, num_NA <chr>
```

``` r
df <- "/LSC/NES/study/CARDIA/core datasets/Y25/DATA"
## on windows, use this
## df <- "T:/LEPS/NES/study/CARDIA/core datasets/Y25/DATA"
dse <- flat2file(df, "*.sas7bdat")
dse[3] %>%
  dic_value_extract_one_dataset_path()
#> # A tibble: 9 x 21
#>   var_name label value_distinct mean  sd    largest_1 largest_2 largest_3
#>   <chr>    <chr> <chr>          <chr> <chr> <chr>     <chr>     <chr>    
#> 1 ID       SUBJ… 3480           2653… 1132… 41681722… 41679622… 41678331…
#> 2 CENTER   YEAR… 4              2.57… 1.12… 4         3         2        
#> 3 HL7CRPS… C-RE… 2              <NA>  <NA>  F         C         <NA>     
#> 4 HL7CRPT… C-RE… 3              <NA>  <NA>  S         N         C        
#> 5 HL6CRPBN C-RE… 828            3.26… 6.26… 199       103       66.4     
#> 6 HL7CRPC… C-RE… 1              1960… 0     1960-01-… <NA>      <NA>     
#> 7 HL7CRPR… C-RE… 1              1960… 0     1960-01-… <NA>      <NA>     
#> 8 HL7CRPA… C-RE… 1              1960… 0     1960-01-… <NA>      <NA>     
#> 9 HL6CRPF  FLAG… 2              2     0     2         <NA>      <NA>     
#> # … with 13 more variables: smallest_1 <chr>, smallest_2 <chr>,
#> #   smallest_3 <chr>, top1_value <chr>, top1_freq <chr>, top2_value <chr>,
#> #   top2_freq <chr>, top3_value <chr>, top3_freq <chr>, num_NA <chr>,
#> #   total_row <int>, file_name <chr>, dir_name <chr>

dse[1:3] %>%
  map_dfr(dic_value_extract_one_dataset_path) %>% 
  slice_head(n=7)
#> # A tibble: 7 x 21
#>   var_name label value_distinct mean  sd    largest_1 largest_2 largest_3
#>   <chr>    <chr> <chr>          <chr> <chr> <chr>     <chr>     <chr>    
#> 1 short_ID <NA>  5114           2678… 1130… 41681     41679     41678    
#> 2 Y15cact… <NA>  218            8.15… 97.2… 4426.505… 2292.617… 615.9132…
#> 3 Y15cact… <NA>  220            8.44… 86.7… 3530.067… 2114.105… 909.8505…
#> 4 Y15CABG  <NA>  2              0     0     0         <NA>      <NA>     
#> 5 Y15pacer <NA>  2              0     0     0         <NA>      <NA>     
#> 6 Y15stent <NA>  3              0.00… 0.02… 1         0         <NA>     
#> 7 Y15valve <NA>  3              0.00… 0.01… 1         0         <NA>     
#> # … with 13 more variables: smallest_1 <chr>, smallest_2 <chr>,
#> #   smallest_3 <chr>, top1_value <chr>, top1_freq <chr>, top2_value <chr>,
#> #   top2_freq <chr>, top3_value <chr>, top3_freq <chr>, num_NA <chr>,
#> #   total_row <int>, file_name <chr>, dir_name <chr>
```

Please check the help document for each function to see how to use them.

``` r
?flat2file
?dic_value_extract_one_dataset_path
?dic_value_extract_one_dataset
?dic_value_extract_one_var
```

future direction.

1.  other dataset types except sas7bdat
    
      - SPSS
      - Stata
      - CSV
      - database table

2.  handle possible file opening errors

3.  handle possible value extraction errors

Hope this tool can be of somewhat help with your research.

***any comments or suggestions are welcome\!***
