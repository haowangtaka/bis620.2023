#' Accelerometry Data Resampled from UK Biobank
#'
#' Toy accelerometry data for BIS620
#'
#' @format ## `accel`
#' A data frame with 1,080,000 rows and 4 columns:
#' \describe{
#'   \item{time}{the time of the measurement}
#'   \item{X, Y, Z}{Accelerometry measurement (in milligravities).}
#' }
"accel"


#' NCT studies
#'
#' NCT studies data for BIS620
#'
#' @format ## `studies`
#' A data frame with 471,252 rows and 70 columns. Please go to the [clinical trials download site](https://aact.ctti-clinicaltrials.org/pipe_files) to get access to the information of this dataset.
"studies"

#' NCT countries
#'
#' NCT countries data for BIS620
#'
#' @format ## `countries`
#' A data frame with 654,096 rows and 4 columns. Please go to the [clinical trials download site](https://aact.ctti-clinicaltrials.org/pipe_files) to get access to the information of this dataset.
#' \describe{
#'   \item{id}{the unique number for each study}
#'   \item{nct_id}{nct_id of the study}
#'   \item{name}{country name}
#'   \item{removed}{whether the study is removed}
#' }
"countries"
