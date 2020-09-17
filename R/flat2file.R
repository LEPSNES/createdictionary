
#' Concatenate all the files inside or outside directories
#'
#' @param df character vector or list of files or directories in full path
#' @param in_pattern file selection pattern
#' @param ex_pattern file exclusion pattern
#'
#' @return character vector including full path only for files
#' @export
#'
#' @examples
#' df <- c("/opt/R/4.0.2/lib/R/library/base/Meta/Rd.rds", system.file())
#' df <- c("/opt/R/4.0.2/lib/R/library/base/Meta/Rd.rds", system.file(package = "readr"), system.file(package = "dplyr"))
#' flat2file(df, "*.rds")
#' df <- "/LSC/NES/study/CARDIA/core datasets/Y25/DATA"
#' flat2file(df, "*.sas7bdat")
#' flat2file(df, in_pattern = "*.sas7bdat", ex_pattern = "h3chem.sas7bdat")
#'
flat2file <- function(df, in_pattern, ex_pattern = NULL) {
  # separete the paths in df into file path or dir path
  dir <- df[fs::is_dir(df)]
  file <- df[fs::is_file(df)]
  # replace dir with the files under it
  if (is.null(ex_pattern)) {
    c(file,
      map(dir, ~ fs::dir_ls(
        .x, recurse = T, glob = in_pattern
      )) %>%
        flatten_chr())
  } else{
    c(
      file,
      map(dir, ~ fs::dir_ls(
        .x, recurse = T, glob = in_pattern
      )) %>%
        flatten_chr() %>%
        str_subset(ex_pattern, negate = TRUE)
    )
  }

}

