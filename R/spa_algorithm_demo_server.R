#' Server of the SPA Algorithm Demo web application
#'
#' @export
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

  score_weights_input <- shiny::reactive({
    list(
      `Score country` = input$weight_country,
      `Score disease` = input$weight_disease,
      `Score feature / objective` = input$weight_feature_objective
    )
  })

  surv_scores <- shiny::reactive({
    compute_surv_scores(specific_scores(), score_weights_input())
  })

  surv_scores_display <- shiny::reactive({
    surv_scores() |>
      dplyr::mutate(
        dplyr::across(dplyr::where(is.numeric), ~ signif(.x, 2))
      ) |>
      dplyr::arrange(
        surveillance_approach_col_name,
        dplyr::desc(`Score surveillance approach 1`)
      )
  })

  # Display the scores in a table
  output$score_table <- DT::renderDT({

    DT::datatable(
      surv_scores_display(),
      rownames = FALSE,
      options = list(
        pageLength = nrow(surv_scores()),
        dom = "ft"
      )
    ) |>
      DT::formatStyle(
        c(surveillance_approach_col_name, "Rank 1", "Rank 2"),
        fontWeight = "bold"
      ) |>
      DT::formatStyle(
        names(surv_scores())[
          !names(surv_scores()) %in% c(surveillance_approach_col_name,
            "Score surveillance approach 1", "Score surveillance approach 2",
            "Rank 1", "Rank 2")
        ],
        color = "DarkGrey"
      )
  })

  # Get original data sets for download
  output$original_data_Set <- downloadHandler(

    filename <- "spa_original_data_set.zip",

    content <- function(file) {
      zip::zip(
        file,
        files = dir(
          system.file("extdata", package = "SPA.Algorithm.Demo"),
          full.names = TRUE
        ),
        # include_directories = FALSE,
        mode = "cherry-pick"
      )
    },

    contentType = "application/zip"
  )

}
