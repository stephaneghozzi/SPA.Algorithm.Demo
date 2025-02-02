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
      "diseases",
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
      "features_objectives",
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
    compile_specific_scores(
      spa_individual_scores, input$country, input$diseases,
      input$features_objectives
    )
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
      dplyr::relocate(
        dplyr::all_of(
          c(surveillance_approach_col_name, "Rank", "Score", "Score individual",
            country_col_name, country_score_col_name,
            paste0("Score ", names(context_score_weights)), disease_col_name,
            disease_score_col_name, feat_obj_col_name, feat_obj_score_col_name)
        )
      ) |>
      dplyr::rename(dplyr::all_of(c(Country = country_col_name))) |>
      dplyr::arrange(surveillance_approach_col_name, dplyr::desc(Score)) |>
      dplyr::mutate(
        dplyr::across(dplyr::where(is.numeric), ~ signif(.x, 2))
      ) |>
      dplyr::filter(Score > 0)
  })

  ranked_approaches_results <- shiny::reactive({
    surv_scores_display() |>
      dplyr::select(
        dplyr::all_of(
          c(surveillance_approach_col_name, "Rank", "Score")
        )
      ) |>
      unique() |>
      dplyr::filter(Score >= show_results_score_threshold)
  })

  # Tables
  headerCallback <- c(
    "function(thead, data, start, end, display){",
    "  $('th', thead).css('border-bottom', '2px solid');",
    "}"
  )

  output$optimal_approaches_table <- DT::renderDT({
    DT::datatable(
      ranked_approaches_results(),
      rownames = FALSE,
      class = "cell-border stripe",
      options = list(
        pageLength = nrow(surv_scores()),
        dom = "ft",
        headerCallback = htmlwidgets::JS(headerCallback),
        language = list(
            zeroRecords = paste0('No approach met the optimal threshold. ',
            'However you can see the "Results" tab for details.')
        )
      )
    )
  })

  output$full_results_table <- DT::renderDT({

    DT::datatable(
      surv_scores_display(),
      rownames = FALSE,
      class = "cell-border stripe",
      options = list(
        pageLength = nrow(surv_scores()),
        dom = "ft",
        headerCallback = htmlwidgets::JS(headerCallback)
      )
    ) |>
      DT::formatStyle(
        paste0("Score ", names(context_score_weights)),
        color = "DarkGrey"
      ) |>
      DT::formatStyle(
        c("Score"),
        `border-right` = "solid 2px"
      ) |>
      DT::formatStyle(
        c("Country", disease_col_name, feat_obj_col_name),
        `border-left` = "solid 2px"
      ) |>
      DT::formatStyle(
        country_score_col_name,
        `border-right` = "solid 1px"
      )

  })

  output$country_context_table <- DT::renderDT({
    DT::datatable(
      spa_individual_scores$country_context,
      rownames = FALSE,
      class = "cell-border stripe",
      options = list(
        pageLength = nrow(spa_individual_scores$country_context),
        dom = "ft",
        headerCallback = htmlwidgets::JS(headerCallback)
      )
    )
  })

  output$context_surv_table <- DT::renderDT({
    DT::datatable(
      spa_individual_scores$context_surv,
      rownames = FALSE,
      class = "cell-border stripe",
      options = list(
        pageLength = nrow(spa_individual_scores$context_surv),
        dom = "ft",
        headerCallback = htmlwidgets::JS(headerCallback)
      )
    )
  })

  output$dis_surv_table <- DT::renderDT({
    DT::datatable(
      spa_individual_scores$dis_surv,
      rownames = FALSE,
      class = "cell-border stripe",
      options = list(
        pageLength = nrow(spa_individual_scores$dis_surv),
        dom = "ft",
        headerCallback = htmlwidgets::JS(headerCallback)
      )
    )
  })

  output$feat_obj_surv_table <- DT::renderDT({
    DT::datatable(
      spa_individual_scores$feat_obj_surv,
      rownames = FALSE,
      class = "cell-border stripe",
      options = list(
        pageLength = nrow(spa_individual_scores$feat_obj_surv),
        dom = "ft",
        headerCallback = htmlwidgets::JS(headerCallback)
      )
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
        mode = "cherry-pick"
      )
    },

    contentType = "application/zip"
  )

}
