test_that("plot_interventions_histogram works", {
  library(ggplot2)
  data("studies")
  data("interventions")
  vdiffr::expect_doppelganger(
    "plot", plot_interventions_histogram(studies)
  )
})
