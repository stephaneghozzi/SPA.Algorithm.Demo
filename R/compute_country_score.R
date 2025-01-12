compute_country_score <- function(country_context_score,
  context_score_weights) {

  context_weight_col_name <- "Context weight"

  context_score_weights_df <- context_score_weights |>
    tibble::as_tibble() |>
    tidyr::pivot_longer(
      dplyr::everything(),
      names_to = context_col_name,
      values_to = context_weight_col_name
    )

  country_score <- country_context_score |>
    dplyr::left_join(context_score_weights_df, by = context_col_name) |>
    dplyr::group_by(
      dplyr::across(
        dplyr::all_of(c(country_col_name, surveillance_approach_col_name))
      )
    ) |>
    dplyr::filter(!is.na(.data[[context_surv_score_col_name]])) |>
    dplyr::mutate(
      score_country = sum(
        .data[[context_weight_col_name]] * .data[[context_surv_score_col_name]]
      ) / sum(.data[[context_weight_col_name]]),
    ) |>
    dplyr::select(-dplyr::all_of(context_weight_col_name)) |>
    tidyr::pivot_wider(
      names_from = dplyr::all_of(context_col_name),
      values_from = dplyr::all_of(context_surv_score_col_name)
    ) |>
    dplyr::ungroup()

  country_score[[country_score_col_name]] <- country_score$score_country
  country_score$score_country <- NULL
  col_context_Score <- which(
    names(country_score) %in% names(context_score_weights)
  )
  names(country_score)[col_context_Score] <- paste0(
    "Score ",
    names(country_score)[col_context_Score]
  )

  return(country_score)

}
