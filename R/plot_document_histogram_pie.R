#' Plot Histogram and Pie Chart of Document Types
#'
#' This function takes a dataset and produces two visual representations of document types: a histogram and a pie chart. It displays the top 9 document types based on their frequency in the dataset.
#'
#' @param x A data frame that must contain a column `nct_id` for matching with a predefined `documents` dataset, which is assumed to be in the user's environment.
#'
#' @return A combined plot of a histogram and a pie chart. If the input data frame is missing, empty, or lacks document types, the function returns a plot with a text annotation indicating the absence of data.
#'
#' @details
#' The function first checks if the input data frame is missing or empty and provides a warning message if so. It then joins the input data frame with the `documents` dataset on `nct_id` and calculates the count of each document type.
#'
#' If no document types are found, a warning is issued and a plot with a corresponding message is returned. Otherwise, the function creates two plots:
#' 1. A histogram showing the count of the top 9 document types.
#' 2. A pie chart showing the proportions of these top 9 document types.
#'
#' Long document type names are wrapped for better display in the histogram. The final output is an arrangement of both the histogram and the pie chart in a single view.
#'
#' @importFrom ggplot2 ggplot aes geom_col geom_bar theme_minimal theme_void coord_polar scale_fill_brewer labs theme xlab ylab ggtitle element_text
#' @importFrom dplyr left_join filter count
#' @importFrom stringr str_wrap
#' @importFrom gridExtra grid.arrange
#' @importFrom utils head
#' @export
plot_document_histogram_pie <- function(x) {
  if (missing(x) || nrow(x) == 0) {
    warning("The input data frame is missing or has no rows. No plot will be generated.")
    return(ggplot() +
             theme_void() +
             annotate("text", x = 0.5, y = 0.5, label = "No data to display", size = 6, hjust = 0.5, vjust = 0.5))
  }

  # Join the data and calculate counts
  d <- x |>
    left_join(documents, by = "nct_id", copy = TRUE) |>
    filter(!is.na(document_type)) |>
    count(document_type, sort = TRUE)

  if (nrow(d) == 0) {
    warning("No document types found in the data frame. No plot will be generated.")
    return(ggplot() +
             theme_void() +
             annotate("text", x = 0.5, y = 0.5, label = "No document types found", size = 6, hjust = 0.5, vjust = 0.5))
  }

  top_n <- min(nrow(d), 9)
  d <- head(d, top_n)

  # Wrap long names for the histogram
  d$document_type_wrapped <- str_wrap(d$document_type, width = 20)

  # Create the histogram plot with a title
  histogram_plot <- ggplot(d, aes(x = reorder(document_type_wrapped, n), y = n)) +
    geom_col(fill = "steelblue") +
    theme_minimal() +
    xlab("Document Type") +
    ylab("Count") +
    ggtitle("Top 9 Document Types") +  # Add title here
    theme(axis.text.x = element_text(angle = 45, hjust = 1),
          plot.title = element_text(hjust = 0.5)) # Center the title

  # Create the pie chart plot with a title
  pie_chart_plot <- ggplot(d, aes(x = "", y = n, fill = document_type)) +
    geom_bar(width = 1, stat = "identity") +
    coord_polar("y", start = 0) +
    theme_void() +
    theme(legend.position = "bottom") +
    scale_fill_brewer(palette = "Pastel1", direction = -1) +
    ggtitle("Top 9 Document Type Proportions") +  # Add title here
    labs(fill = "Document Type", y = "Count", x = "") +
    theme(legend.text = element_text(size = 8),
          plot.title = element_text(hjust = 0.5)) # Center the title

  # Arrange both plots in a single view
  gridExtra::grid.arrange(histogram_plot, pie_chart_plot, ncol = 2)
}
