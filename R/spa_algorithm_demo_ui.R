spa_algorithm_demo_ui <- bslib::page_sidebar(

  title = "SPA Algorithm Demo",

  sidebar = bslib::sidebar(

    shiny::helpText(
      "Select by clicking the dropdown menu or typing keywords to filter the",
      "list."
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
    )

  ),

  DT::dataTableOutput("score_table")

)
