test_that("plot_document_histogram_pie works", {
  library(ggplot2)
  data("studies")
  data("documents")
  vdiffr::expect_doppelganger(
    "plot-pie-1", plot_document_histogram_pie(studies)
  )
})
