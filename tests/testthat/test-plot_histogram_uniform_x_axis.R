test_that("plot_histogram_uniform_x_axis() works", {
  library(ggplot2)
  data("studies")
  vdiffr::expect_doppelganger(
    "plot-histogram-1", plot_histogram_uniform_x_axis(studies, "phase", get_distinct(studies, "phase"), "Phase")
  )  
})
