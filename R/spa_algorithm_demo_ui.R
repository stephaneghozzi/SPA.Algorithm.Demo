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

  bslib::navset_card_underline(

    header = htmltools::hr(),
    footer = htmltools::hr(),

    bslib::nav_panel(
      title = "Scores",
      DT::dataTableOutput("score_table")
    ),

    bslib::nav_panel(
      title = "Data",
      htmltools::p("Raw and processed data.")
    ),

    bslib::nav_panel(
      title = "About",
      htmltools::p("This a demo application illustrating the SPA algorithm.")
    )

  )

)
