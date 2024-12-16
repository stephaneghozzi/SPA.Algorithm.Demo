compute_surv_scores <- function(
  specific_scores,
  score_weights
  # context_score_weights
  # country_score_col_name, disease_score_col_name, feat_obj_score_col_name,
  # surveillance_approach_col_name
) {

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
      `Score surveillance approach 1` = prod(score_value ^ weight_value) / exp(sum(weight_value)),
      `Score surveillance approach 2` = sum(score_value * weight_value) / sum(weight_value),
      .groups = "drop"
    ) |>
    dplyr::left_join(specific_scores, by = surveillance_approach_col_name)

  return(surv_scores)

}
