test_that("get_distinct() works", {
  data("designs")
  expect_snapshot(get_distinct(designs, "allocation", "N/A"))
})
