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
      "diseases",
      label = "Choose diseases",
      choices = "",
      multiple = TRUE
    ),

    shiny::selectInput(
      "features_objectives",
      label = "Choose features / objectives",
      choices = "",
      multiple = TRUE
    )

  ),

  bslib::navset_card_underline(

    bslib::nav_panel(
      title = "Optimal approaches",
      DT::dataTableOutput("optimal_approaches_table")
    ),

    bslib::nav_panel(
      title = "Results",

      shiny::helpText(
        "Enter numerical values for the weights. Only the relative values",
        "matter, e.g., weights of 2, 6, 1 lead the same results as 20, 60, 10."
      ),

      shiny::numericInput(
        "weight_country",
        label = "Context (country) weight",
        value = score_weights$`Score country`,
        min = 0.
      ),
      shiny::numericInput(
        "weight_disease",
        label = "Disease weight",
        value = score_weights$`Score disease`,
        min = 0.
      ),
      shiny::numericInput(
        "weight_feature_objective",
        label = "Feature / objective weight",
        value = score_weights$`Score feature / objective`,
        min = 0.
      ),

      htmltools::hr(),

      DT::dataTableOutput("full_results_table")

    ),

    bslib::nav_panel(
      title = "Data",

      bslib::navset_underline(

        bslib::nav_panel(

          title = "Raw files",

          # quick fix to avoid the download button sticking to the tab title,
          # should rather set padding, but I didn't manage to
          htmltools::HTML("&nbsp;"),

          shiny::downloadButton(
            "original_data_Set",
            label = "Download original data set",
            icon = shiny::icon("download", lib = "glyphicon")
          )

        ),

        bslib::nav_panel(
          title = "Country context",

          bslib::navset_underline(

            bslib::nav_panel(
              title = "Indicators",
              DT::dataTableOutput("country_context_table")
            ),

            bslib::nav_panel(
              title = "Rules",
              DT::dataTableOutput("context_surv_table")
            )

          )

        ),

        bslib::nav_panel(
          title = "Disease matching",
          DT::dataTableOutput("dis_surv_table")
        ),

        bslib::nav_panel(
          title = "Feature / objective matching",
          DT::dataTableOutput("feat_obj_surv_table")
        )
      )

    ),

    bslib::nav_panel(
      title = "About",
      htmltools::p("This a demo application illustrating the SPA algorithm."),
      htmltools::p(
        htmltools::HTML(
          "Code repository:",
          "<a href=https://github.com/stephaneghozzi/SPA.Algorithm.Demo>",
          "https://github.com/stephaneghozzi/SPA.Algorithm.Demo</a>"
        )
      )
    )

  )

)
