#' Plot a Histogram for a Column with the x Axis Fixed for All Query Keywords. 
#' 
#' This function plot the histogram for a column in the input database with the x axis fixed for all query keywords. 
#'
#' @param x A tibble data. 
#' @param col The column used to plot the histogram.
#' @param x_axis The value that the `x$col` may take.
#' @param title The title for the histogram. (default "")
#' @param na_fill The value to fill NA value. (default "NA")
#' @return A ggplot histogram with itsx axis fixed for all query keywords.
#'
#' @importFrom ggplot2 ggplot aes geom_bar theme_grey scale_x_discrete labs
#' @export
plot_histogram_uniform_x_axis <- function(x, col, x_axis, x_label, titile="", na_fill="NA") {
  x <- add_miss_summary_stat(x, col, x_axis, na_fill)
  p <- ggplot(x, aes(x = plot_col, y = n)) +
    geom_col() +
    theme_bw() +
    scale_x_discrete() +
    xlab(x_label) +
    ylab("Count")
  if (titile == "") {p}
  else {p + ggtitle(titile)}
}