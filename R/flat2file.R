
#' Concatenate all the files inside or outside directories
#'
#' @param df character vector or list of files or directories in full path
#' @param pattern file selection pattern
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
#'
#'
flat2file <- function(df, pattern) {
  # separete the paths in df into file path or dir path
  dir <- df[fs::is_dir(df)]
  file <- df[fs::is_file(df)]
  # replace dir with the files under it
  c(file,
    map(dir, ~ fs::dir_ls(.x, recurse = T, glob=pattern)) %>% flatten_chr()
    )

}

