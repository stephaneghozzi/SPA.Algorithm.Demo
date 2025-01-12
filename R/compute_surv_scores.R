compute_surv_scores <- function(specific_scores, score_weights,
  context_score_not_prioritised) {

  score_weights_df <- score_weights |>
    tibble::as_tibble() |>
    tidyr::pivot_longer(
      dplyr::everything(),
      names_to = "weight_type",
      values_to = "weight_value"
    )

  surv_scores <- specific_scores |>
    dplyr::select(
      dplyr::all_of(c(surveillance_approach_col_name, country_score_col_name,
        disease_score_col_name, feat_obj_score_col_name))
    ) |>
    tidyr::pivot_longer(
      dplyr::all_of(c(country_score_col_name, disease_score_col_name,
        feat_obj_score_col_name)),
      names_to = "score_type",
      values_to = "score_value"
    ) |>
    dplyr::left_join(score_weights_df, by = c("score_type" = "weight_type")) |>
    dplyr::group_by(
      dplyr::across(
        dplyr::all_of(surveillance_approach_col_name)
      )
    ) |>
    dplyr::summarize(
      `Score surveillance approach 1` = prod(score_value ^ weight_value) ^
        (1 / sum(weight_value)),
      `Score surveillance approach 2` = sum(score_value * weight_value) /
        sum(weight_value),
      .groups = "drop"
    ) |>
    dplyr::mutate(
      `Rank 1` = rank(-`Score surveillance approach 1`, ties.method = "min"),
      `Rank 2` = rank(-`Score surveillance approach 2`, ties.method = "min"),
    ) |>
    dplyr::relocate(
      dplyr::all_of(
        c(surveillance_approach_col_name, "Rank 1",
          "Score surveillance approach 1", "Rank 2",
          "Score surveillance approach 2")
      )
    ) |>
    dplyr::left_join(specific_scores, by = surveillance_approach_col_name)

  return(surv_scores)

}
