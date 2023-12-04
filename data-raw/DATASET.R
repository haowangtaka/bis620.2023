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

designs = readRDS("designs.rds")
designs = designs |>
  mutate(model = if_else(is.na(intervention_model), observational_model, intervention_model)) |>
  mutate(model_flg = if_else(is.na(intervention_model), if_else(is.na(observational_model), "NA", "Observational Model"), "Intervention Model")) # 0 for na, 1 for observational and 2 for intervention
usethis::use_data(designs, overwrite = TRUE)

