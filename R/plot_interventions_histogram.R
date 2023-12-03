#' Plot Histogram of interventions Types
#'
#' This function takes a dataset and produces two visual representations of interventions types: a histogram. It displays the top 10 interventions types based on their frequency in the dataset.
#'
#' @param x A data frame that must contain a column `nct_id` for matching with a predefined `interventions` dataset, which is assumed to be in the user's environment.
#'
#' @return A histogram. If the input data frame is missing, empty, or lacks intervention types, the function returns a plot with a text annotation indicating the absence of data.
#'
#' @details
#' The function first checks if the input data frame is missing or empty and provides a warning message if so. It then joins the input data frame with the `interventions` dataset on `nct_id` and calculates the count of each intervention type.
#'
#' If no intervention types are found, a warning is issued and a plot with a corresponding message is returned. Otherwise, the function creates a histogram showing the count of the top 10 intervention types.
#'
#'
#' @importFrom ggplot2 ggplot aes geom_col theme ggtitle theme_void annotate xlab ylab element_text
#' @importFrom dplyr left_join filter count arrange
#' @importFrom gridExtra grid.arrange
#' @importFrom utils head
#' @export
plot_interventions_histogram <- function(x) {
  if (missing(x) || nrow(x) == 0) {
    warning("The input data frame is missing or has no rows. No plot will be generated.")
    return(ggplot() +
             theme_void() +
             annotate("text", x = 0.5, y = 0.5, label = "No data to display", size = 6, hjust = 0.5, vjust = 0.5))
  }

  d <- x |>
    left_join(interventions, by = "nct_id", copy = TRUE) |>
    filter(!is.na(intervention_type)) |>
    count(intervention_type)

  if (nrow(d) == 0) {
    warning("No intervention types found in the data frame. No plot will be generated.")
    return(ggplot() +
             theme_void() +
             annotate("text", x = 0.5, y = 0.5, label = "No intervention types found", size = 6, hjust = 0.5, vjust = 0.5))
  }
  # only keep the top 10 for clarity
  d <- d |>
    arrange(desc(n)) |>
    head(n = 10)

  ggplot(d, aes(x = reorder(intervention_type, n), y = n)) + # reordering based on n to show in descending order
    geom_col() +
    theme_bw() +
    ggtitle("Top 10 Interventions Types")+
    xlab("Interventions Type") +
    ylab("Count") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) # Rotate x labels for readability
}
