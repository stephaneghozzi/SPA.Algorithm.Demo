spa_algorithm_demo_server <- function(input, output, session) {

  # Prepare lists of countries, diseases, and surveillance objective / feature,
  # as well as the values displayed when opening the app
  shiny::observe({
    shiny::updateSelectInput(
      session,
      "country",
      choices = sort(
        unique(spa_individual_scores$country_score[[country_col_name]])
      ),
      selected = sample(
        unique(spa_individual_scores$country_score[[country_col_name]]),
        1
      )
    )
  })
  shiny::observe({
    shiny::updateSelectInput(
      session,
      "disease",
      choices = sort(
        unique(spa_individual_scores$dis_surv_score[[disease_col_name]])
      ),
      selected = sample(
        unique(spa_individual_scores$dis_surv_score[[disease_col_name]]),
        1
      )
    )
  })
  shiny::observe({
    shiny::updateSelectInput(
      session,
      "feature_objective",
      choices = sort(
        unique(spa_individual_scores$feat_obj_surv_score[[feat_obj_col_name]])
      ),
      selected = sample(
        unique(spa_individual_scores$feat_obj_surv_score[[feat_obj_col_name]]),
        1
      )
    )
  })

  # Compute scores
  specific_scores <- shiny::reactive({
    compile_specific_scores(spa_individual_scores,
    input$country, input$disease, input$feature_objective)
  })

  surv_scores <- shiny::reactive({
    compute_surv_scores(specific_scores(), score_weights)
  })

  # Display the scores in a table
  output$score_table <- DT::renderDT(
    surv_scores() |>
      dplyr::mutate(
        dplyr::across(dplyr::where(is.numeric), ~ signif(.x, 2))
      ) |>
      dplyr::arrange(
        surveillance_approach_col_name,
        dplyr::desc(`Score surveillance approach 1`)
      ),
    rownames = FALSE,
    options = list(
      pageLength = nrow(surv_scores()),
      dom = "ft"
    )
  )

}
