

#' extract information from one single dataset provided as file path
#'
#' This function can now handle the read_sas error by employing the purrr::safely
#' strategy, which would lead to one row output of all NA's except filename and
#' dirname. Moreover, the total row number of each dataset is also provided as
#' total_row.
#'
#' @param dataset_path the full path to the dataset from which key values
#'   will be extracted
#'
#' @return a dataframe including the values extracted from each variable in the dataset
#' @export
#'
#' @examples
#'
#' # mtcars.sas7bdat was generated from R mtcars dataset
#' df <- system.file("extdata", "mtcars.sas7bdat", package = "createdictionary")
#' df %>%
#'   dic_value_extract_one_dataset_path()
#' # should work if there exist sas7bdat datasets in R path.
#' # The package "haven" have such datasets.
#' df <- system.file(package = "haven")
#' dse <- flat2file(df, "*.sas7bdat")
#' dse[1] %>%
#'   dic_value_extract_one_dataset_path()
#'
#' # need access to the specified folder and have sas7bdat datasets there
#' df <- "/LSC/NES/study/CARDIA/core datasets/Y25/DATA"
#' dse <- flat2file(df, "*.sas7bdat")
#' dse[3] %>%
#'   dic_value_extract_one_dataset_path()
#'
#' value_extracted <-  dse %>%
#'   map_dfr(dic_value_extract_one_dataset_path)
#'

#'
dic_value_extract_one_dataset_path <- function(dataset_path) {

  # read in data
  # d <- haven::read_sas(dataset_path)
  d <- safe_read_sas(dataset_path)$result
  # extract the values
  if (!is.null(d)) {
    value_extracted <-
      purrr::imap_dfr(d, ~ dic_value_extract_one_var_safely(.x, .y)$result)
    value_extracted$total_row <- nrow(d)
  } else {
    value_extracted <-
      data.frame(
        var_name = NA,
        label = NA,
        value_distinct = NA,
        max = NA,
        min = NA,
        mean = NA,
        top1_value = NA,
        top1_freq = NA,
        top2_value = NA,
        top2_freq = NA,
        top3_value = NA,
        top3_freq = NA,
        total_row = NA
      )
  }

  #
  #   # add total row number of the dataset
  #     ifelse (!is.null(d),
  #             nrow(d),
  #             NA)

  # add file name and dir name
  value_extracted$file_name <- basename(dataset_path)
  value_extracted$dir_name <- dirname(dataset_path)
  return(value_extracted)
}


#' extract information from one single dataset provided as data frame
#'
#' @param .data the dataframe from which key values
#'   will be extracted
#'
#' @return a dataframe including the values extracted from each variable in the dataset
#' @export
#'
#' @examples
#'
#' require(haven)
#' # mtcars.sas7bdat was generated from R mtcars dataset
#' df <- system.file("extdata", "mtcars.sas7bdat", package = "createdictionary")
#' df %>%
#' read_sas() %>%
#'   dic_value_extract_one_dataset()
#' # should work if there exist sas7bdat datasets in R path.
#' # The package "haven" have such datasets.
#'
#' df <- system.file(package = "haven")
#' dse <- flat2file(df, "*.sas7bdat")
#' dse[1] %>%
#'  read_sas() %>%
#'  dic_value_extract_one_dataset()
#'
#' # need access to the specified folder and have sas7bdat datasets there
#' df <- "/LSC/NES/study/CARDIA/core datasets/Y25/DATA"
#' dse <- flat2file(df, "*.sas7bdat")
#' d <- dse[3] %>% read_sas()
#' d %>% dic_value_extract_one_dataset()
#'
#'
dic_value_extract_one_dataset <- function(.data) {
  .data %>%
    # purrr::imap_dfr(~ dic_value_extract_one_var(.x, .y))
    purrr::imap_dfr(~ dic_value_extract_one_var_safely(.x, .y)$result)

}



#' generate key values for one variable
#'
#' @param x, the varialbe
#'
#'
#' @param var_name,  the variable name. They two are designed to match the .x, and .y in imap
#'
#' @return a 1 x n dataframe with one key value per column
#' @export
#'
#' @keywords internal
#'
#' @examples
#' require(haven)
#' # mtcars.sas7bdat was generated from R mtcars dataset
#' # get file path
#' df <- system.file("extdata", "mtcars.sas7bdat", package = "createdictionary")
#' # read in data
#' d <- read_sas(df)
#' # one variable
#' dic_value_extract_one_var(d$mpg, "mpg")
#' # process the whole dataset
#' df %>%
#' read_sas() %>%
#'   imap_dfr( ~ dic_value_extract_one_var(.x, .y))
#'
#' df <- system.file(package = "haven")
#' dse <- flat2file(df, "*.sas7bdat")
#' dse[1] %>%
#'   read_sas() %>%
#'   imap_dfr( ~ dic_value_extract_one_var(.x, .y))
#'
#'
#'
# Comment out the function Feb 24, 2021
# dic_value_extract_one_var <- function(x, var_name) {
#   # label = get_label(x)
#   label = ifelse(is.null(sjlabelled::get_label(x)), NA, sjlabelled::get_label(x))
#   value_distinct = as.character(dplyr::n_distinct(x))
#   max = as.character(max(x, na.rm = T))
#   min = as.character(min(x, na.rm = T))
#   mean = as.character(mean(x, na.rm = T))
#   if (length(table(x)) > 0) {
#     top1_value = names(sort(table(x), decreasing = T)[1])
#     top1_freq = as.character(sort(table(x), decreasing = T)[1])
#     top2_value = names(sort(table(x), decreasing = T)[2])
#     top2_freq = as.character(sort(table(x), decreasing = T)[2])
#     top3_value = names(sort(table(x), decreasing = T)[3])
#     top3_freq = as.character(sort(table(x), decreasing = T)[3])
#   } else {
#     top1_value = NA
#     top1_freq = NA
#     top2_value = NA
#     top2_freq = NA
#     top3_value = NA
#     top3_freq = NA
#   }
#   data.frame(
#     var_name,
#     label,
#     value_distinct,
#     max,
#     min,
#     mean,
#     top1_value,
#     top1_freq,
#     top2_value,
#     top2_freq,
#     top3_value,
#     top3_freq
#   )
# }


dic_value_extract_one_var <- function(x, var_name) {
  # sort decreasingly by frequency
  frq <- sort(table(x), decreasing = T)
  x_sorted <- sort(x, decreasing = TRUE)
  # make the tibble, one row
  tibble(
    var_name,
    label = ifelse(
      is.null(sjlabelled::get_label(x)),
      NA,
      sjlabelled::get_label(x)
    ),
    # value_distinct = as.character(dplyr::n_distinct(x)),
    value_distinct = dplyr::n_distinct(x),
    # max = as.character(max(x, na.rm = T)),
    # min = as.character(min(x, na.rm = T)),
    # mean = as.character(mean(x, na.rm = T)),
    mean = mean(x, na.rm = T),
    sd = sd(x, na.rm = T),
    largest_1 = x_sorted[1],
    largest_2 = x_sorted[2],
    largest_3 = x_sorted[3],
    smallest_1 = rev(x_sorted)[1],
    smallest_2 = rev(x_sorted)[2],
    smallest_3 = rev(x_sorted)[3],
    largest_300 = x_sorted[300],
    top1_value = ifelse(length(frq) == 0, NA, names(frq[1])),
    top1_freq = ifelse(length(frq) == 0, NA, frq[1]),
    top2_value = ifelse(length(frq) == 0, NA, names(frq[2])),
    top2_freq = ifelse(length(frq) == 0, NA, frq[2]),
    top3_value = ifelse(length(frq) == 0, NA, names(frq[3])),
    top3_freq = ifelse(length(frq) == 0, NA, frq[3]),
  ) %>% mutate(across(everything(), as.character))
}



#' the safe version of extract values from one variable
#' require(haven)
#' # mtcars.sas7bdat was generated from R mtcars dataset
#' # get file path
#' df <- system.file("extdata", "mtcars.sas7bdat", package = "createdictionary")
#' # read in data
#' d <- read_sas(df)
#' # one variable
#' dic_value_extract_one_var_safetly(d$mpg, "mpg")
#' dic_value_extract_one_var_safetly(d$mpg, "mpg")$result

dic_value_extract_one_var_safely <- safely(
    dic_value_extract_one_var,
    otherwise =   data.frame(
      var_name = NA,
      label = NA,
      value_distinct = NA,
      max = NA,
      min = NA,
      mean = NA,
      top1_value = NA,
      top1_freq = NA,
      top2_value = NA,
      top2_freq = NA,
      top3_value = NA,
      top3_freq = NA
    )
  )


#' # the safe version of read_sas

safe_read_sas <- purrr::safely(haven::read_sas, , otherwise = NULL)


