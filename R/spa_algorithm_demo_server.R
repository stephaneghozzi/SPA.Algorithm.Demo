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
    swi <- list(
      input$weight_country,
      input$weight_disease,
      input$weight_feature_objective
    )
    names(swi) <- c(
      country_score_col_name,
      disease_score_col_name,
      feat_obj_score_col_name
    )
    swi
  })

  surv_scores <- shiny::reactive({
    compute_surv_scores(specific_scores(), score_weights_input())
  })


  surv_scores_display <- shiny::reactive({
    surv_scores() |>
      dplyr::select(
        dplyr::all_of(
          c(
            surveillance_approach_col_name,
            score_col_name, combination_score_col_name,
            country_col_name, country_score_col_name,
            natural_disaster_risk_score_col_name,
            epidemic_risk_score_col_name, lab_capacitity_score_col_name,
            surv_capacitity_score_col_name,
            disease_col_name, disease_score_col_name,
            feat_obj_col_name, feat_obj_score_col_name
          )
        )
      ) |>
      dplyr::rename("{country_display_col_name}" := country_col_name) |>
      dplyr::arrange(
        surveillance_approach_col_name,
        dplyr::desc(.data[[score_col_name]])
      ) |>
      dplyr::mutate(
        dplyr::across(dplyr::where(is.numeric), ~ signif(.x, 2))
      ) |>
      dplyr::filter(.data[[score_col_name]] > 0)
  })

  # Optimal approaches
  ranked_approaches_results <- shiny::reactive({
    surv_scores_display() |>
      dplyr::filter(
        .data[[score_col_name]] >= input$display_score_threshold
      ) |>
      dplyr::select({{ surveillance_approach_col_name }}) |>
      unique()
  })

  # Add summary for each displayed approach
  optimal_approaches_table <- shiny::reactive({
    ranked_approaches_results() |>
      dplyr::left_join(
        spa_individual_scores$feat_obj_surv_score,
        by = surveillance_approach_col_name
      ) |>
      dplyr::filter(
        .data[[feat_obj_col_name]] %in% input$features_objectives
      ) |>
      dplyr::group_by(dplyr::pick({{ surveillance_approach_col_name }})) |>
      dplyr::summarise(
        Summary = summarises_approach_adequacy(
          .data[[feat_obj_col_name]],
          .data[[feat_obj_score_col_name]],
          .data[[surveillance_approach_col_name]]
        ),
        .groups = "drop"
      ) |>
      dplyr::select(-Summary)
  })

  # Tables
  headerCallback <- c(
    "function(thead, data, start, end, display){",
    "  $('th', thead).css('border-bottom', '2px solid');",
    "}"
  )

  # Optimal approaches
  output$optimal_approaches_table <- DT::renderDT({
    DT::datatable(
      optimal_approaches_table(),
      rownames = FALSE,
      class = "cell-border stripe",
      options = list(
        pageLength = nrow(surv_scores()),
        dom = "t",
        ordering = FALSE,
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
        c(natural_disaster_risk_score_col_name, epidemic_risk_score_col_name,
          lab_capacitity_score_col_name, surv_capacitity_score_col_name),
        color = "DarkGrey"
      ) |>
      DT::formatStyle(
        surveillance_approach_col_name,
        `border-right` = "solid 1px"
      ) |>
      DT::formatStyle(
        c(country_display_col_name, disease_col_name, feat_obj_col_name),
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
