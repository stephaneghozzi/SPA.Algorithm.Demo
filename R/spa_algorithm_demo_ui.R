#' UI of the SPA Algorithm Demo web application
#'
#' @export
spa_algorithm_demo_ui <- bslib::page_sidebar(

  title = "SPA Algorithm Demo",

  sidebar = bslib::sidebar(

    width = "400px",
    open = "always",

    shiny::helpText(
      "Select by clicking the dropdown menu or typing keywords to filter the",
      "list. A random set is selected when loading the page."
    ),

    shiny::selectInput(
      "country",
      label = "Choose a country",
      choices = ""
    ),

    shiny::selectInput(
      "disease",
      label = "Choose a disease",
      choices = ""
    ),

    shiny::selectInput(
      "feature_objective",
      label = "Choose a feature / objective",
      choices = ""
    ),

    htmltools::hr(),

    shiny::helpText(
      "Enter numerical values for the weights. Only the relative values",
      "matter, e.g., weights of 2, 6, 1 lead the same results as 20, 60, 10."
    ),

    shiny::numericInput(
      "weight_country",
      label = "Context (country) weight",
      value = score_weights$`Score country`
    ),
    shiny::numericInput(
      "weight_disease",
      label = "Disease weight",
      value = score_weights$`Score disease`
    ),
    shiny::numericInput(
      "weight_feature_objective",
      label = "Feature / objective weight",
      value = score_weights$`Score feature / objective`
    )

  ),

  bslib::navset_card_underline(

    header = htmltools::hr(),
    footer = htmltools::hr(),

    bslib::nav_panel(
      title = "Scores",
      DT::dataTableOutput("score_table")
    ),

    bslib::nav_panel(
      title = "Data",
      shiny::downloadButton(
        "original_data_Set",
        label = "Download original data set",
        icon = shiny::icon("download", lib = "glyphicon")
      )
    ),

    bslib::nav_panel(
      title = "About",
      htmltools::p("This a demo application illustrating the SPA algorithm.")
    )

  )

)
