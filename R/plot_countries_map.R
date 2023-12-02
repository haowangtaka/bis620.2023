#' Plot Studies Frequency by Country on a World Map
#'
#' This function takes a dataset and produces a visual representation of the frequency of studies conducted in different countries. It includes both a world map showing study frequency by country and a bar plot of the top countries based on the number of studies.
#'
#' @param x A data frame that must contain a column `nct_id` for matching with country names. In this case, x is the studies dataset or subset of studies dataset.
#'
#' @return A ggplot object that includes a world map and, a bar plot of the top N countries based on study count. If the data for top countries is insufficient, a text annotation is displayed instead.
#'
#' @details
#' The function first modifies the country names in a predefined `countries` dataset. It then joins this dataset with the input data frame `x` on `nct_id` and filters out any missing values or 'NA' entries in the country names.
#'
#' The world map is obtained using `map_data("world")`, and the input data is joined with this world map data. The function then checks the number of unique countries and sets the breaks for the color scale accordingly. The final plot is a combination of a world map and a bar plot showing the top N countries (up to 10) based on the count of studies. The world map uses a continuous color scale to represent the study frequency, and the top countries bar plot is displayed alongside the map.
#'
#' @importFrom ggplot2 ggplot aes geom_polygon scale_fill_viridis_c coord_fixed theme_void theme labs map_data
#' @importFrom dplyr mutate left_join filter count
#' @importFrom tidyr pivot_longer
#' @importFrom gridExtra grid.arrange
#' @export
plot_countries_map <- function(x) {

  countries <- countries |>
    mutate(name = ifelse(name == "United States", "USA", name))

  d <- x |>
    left_join(countries, by = "nct_id", copy = TRUE, relationship = "many-to-many") |>
    filter(!is.na(name)) |>
    count(name, sort = TRUE) |>
    filter(name != "NA")  # Ensure that 'NA' entries are removed

  # Get the world map data
  world_map <- map_data("world")

  # Join the data
  map_data <- world_map |>
    left_join(d, by = c("region" = "name"))

  # Check if there's only one country and set breaks accordingly
  if (nrow(d) == 1) {
    breaks <- c(0, d$n, max(d$n) + 1)
  } else {
    breaks <- pretty(range(d$n, na.rm = TRUE))
  }

  # Create the map plot with a continuous scale that includes zero
  map_plot <- ggplot(data = map_data, mapping = aes(x = long, y = lat, group = group, fill = n)) +
    geom_polygon(color = "white", linewidth = 0.1) +
    scale_fill_viridis_c(
      option = "C",
      direction = -1,
      na.value = "grey50",
      name = "Count of Studies",
      limits = range(breaks),
      breaks = breaks
    ) +
    coord_fixed(1.3) +
    theme_void() +
    theme(legend.position = "bottom",
          plot.title = element_text(hjust = 0.5, face = "bold"),
          plot.subtitle = element_text(hjust = 0.5)) +
    labs(title = "Study Frequency by Country",
         subtitle = "The color intensity represents the number of studies conducted in each country")

  # Create a table plot for the top N countries
  top_n <- min(10, nrow(d))
  if (top_n > 0) {
    table_plot <- ggplot(d[1:top_n,], aes(x = reorder(name, n), y = n)) +
      geom_col() +
      coord_flip() +
      theme_minimal() +
      labs(x = NULL, y = "Count", title = paste("Top", top_n, "Countries"))

    # Combine the map and table plots
    combined_plot <- grid.arrange(map_plot, table_plot, ncol = 2, widths = c(2, 1))
  } else {
    combined_plot <- annotate("text", x = 0.5, y = 0.5,
                              label = "No sufficient geographical data for top countries.",
                              size = 6, hjust = 0.5, vjust = 0.5)
  }

  return(combined_plot)
}
