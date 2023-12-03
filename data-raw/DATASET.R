## code to prepare `DATASET` dataset goes here

accel = readRDS("accel.rds")
usethis::use_data(accel, overwrite = TRUE)

studies = readRDS("studies.rds")
usethis::use_data(studies, overwrite = TRUE)

countries = readRDS("countries.rds")
usethis::use_data(countries, overwrite = TRUE)

documents = readRDS("documents.rds")
usethis::use_data(documents, overwrite = TRUE)

interventions= readRDS("interventions.rds")
usethis::use_data(interventions, overwrite = TRUE)
