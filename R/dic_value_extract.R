

#' extract information from one single dataset provided as file path
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
  d <- haven::read_sas(dataset_path)
  # extract the values
  value_extracted <-
    d %>%
    # purrr::imap_dfr(~ dic_value_extract_one_var(.x, .y))
    purrr::imap_dfr(~ dic_value_extract_one_var_safely(.x, .y)$result)
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
dic_value_extract_one_var <- function(x, var_name) {
  # label = get_label(x)
  label = ifelse(is.null(sjlabelled::get_label(x)), NA, sjlabelled::get_label(x))
  value_distinct = as.character(dplyr::n_distinct(x))
  max = as.character(max(x, na.rm = T))
  min = as.character(min(x, na.rm = T))
  mean = as.character(mean(x, na.rm = T))
  if (length(table(x)) > 0) {
    top1_value = names(sort(table(x), decreasing = T)[1])
    top1_freq = as.character(sort(table(x), decreasing = T)[1])
    top2_value = names(sort(table(x), decreasing = T)[2])
    top2_freq = as.character(sort(table(x), decreasing = T)[2])
    top3_value = names(sort(table(x), decreasing = T)[3])
    top3_freq = as.character(sort(table(x), decreasing = T)[3])
  } else {
    top1_value = NA
    top1_freq = NA
    top2_value = NA
    top2_freq = NA
    top3_value = NA
    top3_freq = NA
  }
  data.frame(
    var_name,
    label,
    value_distinct,
    max,
    min,
    mean,
    top1_value,
    top1_freq,
    top2_value,
    top2_freq,
    top3_value,
    top3_freq
  )
}


# the safe version of extract values from one variable
# require(haven)
# # mtcars.sas7bdat was generated from R mtcars dataset
# # get file path
# df <- system.file("extdata", "mtcars.sas7bdat", package = "createdictionary")
# # read in data
# d <- read_sas(df)
# # one variable
# dic_value_extract_one_var_safetly(d$mpg, "mpg")
# dic_value_extract_one_var_safetly(d$mpg, "mpg")$result

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

# dic_value_extract_one_var_safely <- safely(dic_value_extract_one_var,
#                                            otherwise =   NA)


