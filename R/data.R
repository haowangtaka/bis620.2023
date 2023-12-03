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


#' A subset of NCT studies
#'
#' A subset of NCT studies data for BIS620
#'
#' @format ## `studies`
#' A data frame with 10000 rows and 70 columns. Please go to the [clinical trials download site](https://aact.ctti-clinicaltrials.org/pipe_files) to get access to the information of this dataset.
"studies"

#' NCT countries
#'
#' NCT countries data for BIS620
#'
#' @format ## `countries`
#' A data frame with 654,096 rows and 4 columns. Please go to the [clinical trials download site](https://aact.ctti-clinicaltrials.org/pipe_files) to get access to the information of this dataset.
#' \describe{
#'   \item{id}{the unique number for each study}
#'   \item{nct_id}{nct id of the study}
#'   \item{name}{country name}
#'   \item{removed}{whether the study is removed}
#' }
"countries"

#' NCT documents
#'
#' NCT documents data for BIS620
#'
#' @format ## `documents`
#' A data frame with 10,449 rows and 6 columns. Please go to the [clinical trials download site](https://aact.ctti-clinicaltrials.org/pipe_files) to get access to the information of this dataset.
#' \describe{
#'   \item{id}{the unique number for each study}
#'   \item{nct_id}{nct id of the study}
#'   \item{document_id}{document id of the study}
#'   \item{document_type}{document type of the study}
#'   \item{url}{url of the study}
#'   \item{comment}{comment of the study}
#' }
"documents"


#' NCT interventions
#'
#' A subset of NCT interventions data for BIS620
#'
#' @format ## `interventions`
#' A data frame with 10000 rows and 2 columns. Please go to the [clinical trials download site](https://aact.ctti-clinicaltrials.org/pipe_files) to get access to the information of this dataset.
"interventions"
