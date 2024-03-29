% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dic_value_extract.R
\name{dic_value_extract_one_var}
\alias{dic_value_extract_one_var}
\title{generate key values for one variable}
\usage{
dic_value_extract_one_var(x, var_name)
}
\arguments{
\item{x, }{the varialbe}

\item{var_name, }{the variable name. They two are designed to match the .x, and .y in imap}
}
\value{
a 1 x n dataframe with one key value per column
}
\description{
generate key values for one variable
}
\examples{
require(haven)
# mtcars.sas7bdat was generated from R mtcars dataset
# get file path
df <- system.file("extdata", "mtcars.sas7bdat", package = "createdictionary")
# read in data
d <- read_sas(df)
# one variable
dic_value_extract_one_var(d$mpg, "mpg")
# process the whole dataset
df \%>\%
read_sas() \%>\%
  imap_dfr( ~ dic_value_extract_one_var(.x, .y))

df <- system.file(package = "haven")
dse <- flat2file(df, "*.sas7bdat")
dse[1] \%>\%
  read_sas() \%>\%
  imap_dfr( ~ dic_value_extract_one_var(.x, .y))


}
\keyword{internal}
