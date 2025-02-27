compute_surv_scores <- function(specific_scores, score_weights) {

  score_weights_df <- score_weights |>
    tibble::as_tibble() |>
    tidyr::pivot_longer(
      dplyr::everything(),
      names_to = "weight_type",
      values_to = "weight_value"
    )

  specific_scores_combined <- specific_scores |>
    tidyr::pivot_longer(
      {{ country_score_col_name }} | {{ disease_score_col_name }} |
        {{feat_obj_score_col_name }},
      names_to = "score_type",
      values_to = "score_value"
    ) |>
    dplyr::left_join(score_weights_df, by = c("score_type" = "weight_type")) |>
    dplyr::group_by(
      dplyr::across(
        dplyr::all_of(
          c(surveillance_approach_col_name, country_col_name, disease_col_name,
            feat_obj_col_name)
        )
      )
    ) |>
    dplyr::summarize(
      "{mult_combination_score_col_name}" := compute_score_individual(
        score_value, weight_value, "multiplicative"
      ),
      "{add_combination_score_col_name}" := compute_score_individual(
        score_value, weight_value, "additive"
      ),
      .groups = "drop"
    )

  surv_scores <- specific_scores_combined |>
    dplyr::group_by(
      dplyr::across(dplyr::all_of(surveillance_approach_col_name))
    ) |>
    dplyr::summarize(
      "{mult_score_col_name}" := mean(.data[[mult_combination_score_col_name]]),
      "{add_score_col_name}" := mean(.data[[add_combination_score_col_name]]),
      .groups = "drop"
    ) |>
    dplyr::mutate(
      "{mult_rank_col_name}" := rank(
        -.data[[mult_score_col_name]],
        ties.method = "min"
      ),
      "{add_rank_col_name}" := rank(
        -.data[[add_score_col_name]],
        ties.method = "min")
    ) |>
    dplyr::right_join(specific_scores_combined) |>
    dplyr::right_join(specific_scores)

  return(surv_scores)

}
