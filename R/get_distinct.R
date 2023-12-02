#' Get a Vector of Distinct Value of a Column in Tibble
#'
#' This function returns a vector of the distinct value of a column in a tibble. It also change the NA to a input value specified by users.
#'
#' @param d A tibble data.
#' @param column A column name. It should be in the columns of `d`. 
#' @param na_fill the value to fill NA value. (default "NA")
#' @return A vector of distinct value of the column in the tibble.
#'
#' @importFrom dplyr mutate distinct select if_else
#' @importFrom tibble as_tibble
#' @importFrom rlang sym
#' @export
get_distinct <- function(d, column, na_fill="NA") {
  distinct_values = d |> select(!!sym(column)) |> mutate(count_col = dplyr::if_else(is.na(!!sym(column)), na_fill, !!sym(column))) |> distinct(count_col) |> as_tibble() |> as.vector()
  distinct_values = unlist(distinct_values)
  return(distinct_values)
}