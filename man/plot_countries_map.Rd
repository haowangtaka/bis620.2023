% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot_countries_map.R
\name{plot_countries_map}
\alias{plot_countries_map}
\title{Plot Studies Frequency by Country on a World Map}
\usage{
plot_countries_map(x)
}
\arguments{
\item{x}{A data frame that must contain a column \code{nct_id} for matching with country names. In this case, x is the studies dataset or subset of studies dataset.}
}
\value{
A ggplot object that includes a world map and, a bar plot of the top N countries based on study count. If the data for top countries is insufficient, a text annotation is displayed instead.
}
\description{
This function takes a dataset and produces a visual representation of the frequency of studies conducted in different countries. It includes both a world map showing study frequency by country and a bar plot of the top countries based on the number of studies.
}
\details{
The function first modifies the country names in a predefined \code{countries} dataset. It then joins this dataset with the input data frame \code{x} on \code{nct_id} and filters out any missing values or 'NA' entries in the country names.

The world map is obtained using \code{map_data("world")}, and the input data is joined with this world map data. The function then checks the number of unique countries and sets the breaks for the color scale accordingly. The final plot is a combination of a world map and a bar plot showing the top N countries (up to 10) based on the count of studies. The world map uses a continuous color scale to represent the study frequency, and the top countries bar plot is displayed alongside the map.
}
