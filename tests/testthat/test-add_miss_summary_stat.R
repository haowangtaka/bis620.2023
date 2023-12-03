test_that("add_miss_summary_stat() works", {
  data("studies")
  expect_snapshot(add_miss_summary_stat(studies, "phase", get_distinct(studies, "phase"), "NA"))
})
