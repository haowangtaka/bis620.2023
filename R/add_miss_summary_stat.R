#' Add the Missing Columns to the Summary Table
#'
#' This function add the values in `x_axis` that is not in `x$col` to `x$col` with their count equal to zero.
#'
#' @param x A tibble data.
#' @param col The column we want to add additional row to.
#' @param x_axis The value that the `x$col` may take.
#' @param na_fill The value to fill NA value. (default "NA")
#' @return A tibble data after adding the missing columns.
#'
#' @importFrom dplyr mutate group_by select summarize n
#' @importFrom tibble add_row 
#' @export
add_miss_summary_stat <- function(x, col, x_axis, na_fill="NA") {
  x = x |> select(!!sym(col)) |>
    mutate(plot_col = if_else(is.na(!!sym(col)), na_fill, !!sym(col))) |>
    group_by(plot_col) |>
    summarize(n = dplyr::n()) |>
    mutate(plot_col = factor(plot_col, ordered = TRUE, levels = x_axis))
  
  for (c in x_axis) {
    if (!(c %in% x$plot_col)) {
      new_row <- tibble(
        plot_col = factor(c, ordered = TRUE, levels = x_axis),
        n = 0
      )
      x = x |> add_row(new_row)
    }
  }
  return(x)
}