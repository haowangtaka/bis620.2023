test_that("plot_countries_map() works", {
  library(ggplot2)
  data("studies")
  data("countries")
  vdiffr::expect_doppelganger(
    "plot-map-1", plot_countries_map(studies)
  )
})
