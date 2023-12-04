#' Start Shiny App for Clinical Trial Data
#'
#' This function can start our clinical data visualization app.
#'
#' @returns No return.
#' 
#' @import shiny
#' @importFrom tidyquery query
#' @importFrom stats na.omit
#' @importFrom utils data
#' @export
clinical_shinyapp <- function() {
  # Set the maximum number of studies to be fetched for display
  max_num_studies <- 1000
  options(warn = -1)
  # Load data
  data("studies")
  data("sponsors")
  data("conditions")
  data("countries")
  data("interventions")
  data("documents")
  data("designs")
  
  # Some Local functions
  query_kwds <- function(d, kwds, column, ignore_case = TRUE, match_all = FALSE) {
    kwds = kwds[kwds != ""]
    kwds = paste0("%", kwds, "%") |>
      gsub("'", "''", x = _)
    if (ignore_case) {
      like <- " ilike "
    } else{
      like <- " like "
    }
    q = paste(
      paste0(column, like, "'", kwds, "'"),
      collapse = ifelse(match_all, " AND ", " OR ")
    )
    q = paste(
      "select * where",
      q
    )
    d |> query(q) 
  }
  
  plot_conditions_histogram <- function(x) {
    d <- x |>
      left_join(conditions, by = "nct_id", copy = TRUE) |>
      count(name) 
    # only keep the top 10 for clarity
    d <- d |>
      arrange(desc(n)) |>
      head(n = 10)
    
    ggplot(d, aes(x = reorder(name, n), y = n)) + # reordering based on n to show in descending order
      geom_col() +
      theme_bw() +
      xlab("Conditions") +
      ylab("Count") +
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) # Rotate x labels for readability
  }

  get_concurrent_trials = function(d) {
    # Get all of the unique dates.
    all_dates = d |> 
      pivot_longer(cols = everything()) |>
      select(-name) |>
      distinct() |> 
      arrange(value) |>
      na.omit() |> 
      rename(date = value)
    
    within_date = function(date, starts, ends) {
      date >= starts & date <= ends
    }
    
    # Get the number of concurrent trials at each of the unique dates.
    all_dates$count = 
      map_dbl(
        all_dates$date, 
        ~ .x |> 
          within_date(d$start_date, d$completion_date) |>
          sum(na.rm = TRUE)
      )
    return(all_dates)
  }
  
  
  get_distinct <- function(d, column, na_fill="NA") {
    distinct_values = d |> select(!!sym(column)) |> mutate(count_col = if_else(is.na(!!sym(column)), na_fill, !!sym(column))) |> distinct(count_col) |> as_tibble() |> as.vector()
    distinct_values = unlist(distinct_values)
    return(distinct_values)
  }
  
  plot_phase_histogram_uniform_x_axis = function(x, x_axis) {
    x$phase[is.na(x$phase)] = "NA"
    x = x |>
      select(phase) |>
      collect() |>
      mutate(phase = if_else(is.na(phase), "NA", phase)) |>
      group_by(phase) |>
      summarize(n = n()) |>
      collect() |>
      mutate(phase = factor(phase, ordered = TRUE, levels = x_axis))
    
    for (c in x_axis) {
      if (!(c %in% x$phase)) {
        new_row <- tibble(
          phase = factor(c, ordered = TRUE, levels = x_axis),
          n = 0
        )
        x = x |> add_row(new_row)
      }
    }
    
    ggplot(x, aes(x = phase, y = n)) +
      geom_col() +
      theme_bw() +
      scale_x_discrete() +
      xlab("Phase") +
      ylab("Count")
  }
  
  # Define UI for application that queries clinical trials and displays various histograms
  ui <- fluidPage(
    titlePanel("Understand Their Clinical Study!"),  # Application title
    
    # Sidebar with inputs to filter the displayed data
    sidebarLayout(
      sidebarPanel(
        textInput("brief_title_kw", "Brief title keywords"),
        sliderInput("universal_year_range", "Studies Initial Year Range:", 
                    min = 1990, max = as.numeric(format(Sys.Date(), "%Y")), 
                    value = c(1990, as.numeric(format(Sys.Date(), "%Y"))), sep = ""),
        selectInput("study_type", "Choose a Study Type:",
                    choices = c("Interventional", "Observational", 
                                "Observational [Patient Registry]", 
                                "Expanded Access", "NA"),
                    multiple = TRUE,
                    selected = c("Interventional", "Observational", 
                                 "Observational [Patient Registry]", 
                                 "Expanded Access", "NA")),
        selectInput("agency_class", "Sponsor Type", 
                    choices = list("Ambiguous" = "AMBIG", 
                                   "Federal" = "FED", 
                                   "Individual" = "INDIV",
                                   "Industry" = "INDUSTRY",
                                   "Network" = "NETWORK",
                                   "National Institutes of Health" = "NIH",
                                   "Other" = "OTHER",
                                   "Other Government" = "OTHER_GOV",
                                   "Unknown" = "UNKNOWN"),
                    multiple = TRUE,
                    selected = list("Ambiguous" = "AMBIG", 
                                    "Federal" = "FED", 
                                    "Individual" = "INDIV",
                                    "Industry" = "INDUSTRY",
                                    "Network" = "NETWORK",
                                    "National Institutes of Health" = "NIH",
                                    "Other" = "OTHER",
                                    "Other Government" = "OTHER_GOV",
                                    "Unknown" = "UNKNOWN")),
        tags$img(src = "https://pbs.twimg.com/media/FIncLZMVkAA4NqW?format=png&name=small", width = "250px", height = "250px")
      ),
      
      # Main panel to display the plots and tables
      mainPanel(
        tabsetPanel(
          type = "tabs",
          tabPanel("Phase", plotOutput("phase_plot")),
          tabPanel("Concurrent", plotOutput("concurrent_plot")),
          tabPanel("Conditions", plotOutput("conditions_plot")),
          tabPanel("Countries", plotOutput("countries_plot")),
          tabPanel("Interventions", plotOutput("interventions_plot")),
          tabPanel("Documents", plotOutput("document_plot")),
          tabPanel("Designs", tabsetPanel(
            tabPanel("Allocation", plotOutput("allocation_plot")), 
            tabPanel("Model", plotOutput("model_plot")),
            tabPanel("Primary Purpose", plotOutput("primary_purpose_plot")),
            tabPanel("Time Perspective", plotOutput("time_perspective_plot")),
            tabPanel("Masking", plotOutput("masking_plot")))
          )
        ),
        dataTableOutput("trial_table")
      )
    )
  )
  
  # Define server logic to respond to user inputs and render plots and data tables
  server <- function(input, output) {
    phase_axis = get_distinct(studies, "phase")
    allocation_axis = get_distinct(designs, "allocation", "N/A")
    model_axis = get_distinct(designs, "model_flg")
    primary_purpose_axis = get_distinct(designs, "primary_purpose")
    time_perspective_axis = get_distinct(designs, "time_perspective")
    masking_axis = get_distinct(designs, "masking")
    # Reactive function to get filtered studies based on user input
    get_studies <- reactive({
      # Filter by brief title keywords if provided
      if (input$brief_title_kw != "") {
        si <- input$brief_title_kw |>
          strsplit(",") |>
          unlist() |>
          trimws()
        ret <- query_kwds(studies, si, "brief_title", match_all = TRUE)
      } else {
        ret <- studies
      }
      

      ret = ret |>
        left_join(sponsors %>% select(nct_id, agency_class), by = 'nct_id') |>
        left_join(designs %>% select(nct_id, allocation, model_flg, primary_purpose, time_perspective, masking), by = 'nct_id')
      
      # Collect the dataset
      ret <- ret |>
        collect()
      
      # Filter by study initial year range
      ret <- subset(ret, as.numeric(format(study_first_submitted_date, "%Y")) >= input$universal_year_range[1] & 
                      as.numeric(format(study_first_submitted_date, "%Y")) <= input$universal_year_range[2])
      
      ret <- ret |> mutate(study_type = if_else(is.na(study_type), "NA", study_type)) |>
        filter(study_type %in% input$study_type)
      
      ret <- ret |> 
        filter(agency_class %in% !!input$agency_class)
      
      # Limit the number of studies displayed
      ret <- ret |>
        head(max_num_studies) |>
        collect()
      
      ret
    })
    
    # Render plot for study phases
    output$phase_plot = renderPlot({
      get_studies() |>
        plot_phase_histogram_uniform_x_axis(phase_axis)
    })
    
    # Render plot for concurrent clinical trials over time
    output$concurrent_plot <- renderPlot({
      get_studies() |>
        select(start_date, completion_date) |>
        get_concurrent_trials() |>
        ggplot(aes(x = date, y = count)) +
        geom_line() +
        xlab("Date") +
        ylab("Count") +
        theme_bw()
    })
    
    # Render plot for the most frequent medical conditions
    output$conditions_plot <- renderPlot({
      get_studies() |>
        plot_conditions_histogram()
    })
    
    # Render plot for the most frequent study countries
    output$countries_plot <- renderPlot({
      get_studies() |>
        plot_countries_map()
    })
    
    # Render plot for the most reported intervention
    output$interventions_plot <- renderPlot({
      get_studies() |>
        plot_interventions_histogram()
    })
    
    # Render plot for the most related document types
    output$document_plot <- renderPlot({
      get_studies() |>
        plot_document_histogram_pie()
    })
    
    output$allocation_plot = renderPlot({
      get_studies() |>
        plot_histogram_uniform_x_axis("allocation", allocation_axis, "Allocation", na_fill = "N/A")
    })
    output$model_plot = renderPlot({
      get_studies() |>
        plot_histogram_uniform_x_axis("model_flg", model_axis, "Model")
    })
    output$primary_purpose_plot = renderPlot({
      get_studies() |>
        plot_histogram_uniform_x_axis("primary_purpose", primary_purpose_axis, "Primary Purpose") +
        coord_flip()
    }) 
    output$time_perspective_plot = renderPlot({
      get_studies() |>
        plot_histogram_uniform_x_axis("time_perspective", time_perspective_axis, "Time Perspective")
    }) 
    output$masking_plot = renderPlot({
      get_studies() |>
        plot_histogram_uniform_x_axis("masking", masking_axis, "Masking")
    }) 
    
    # Render data table for the filtered clinical trials
    output$trial_table <- renderDataTable({
      get_studies() |>
        select(nct_id, brief_title, start_date, completion_date) |>
        rename(`NCT ID` = nct_id, `Brief Title` = brief_title,
               `Start Date` = start_date, `Completion Date` = completion_date)
    })
  }
  
  # Run the Shiny application
  shinyApp(ui = ui, server = server)
  
}
