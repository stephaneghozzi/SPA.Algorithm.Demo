compute_country_score <- function(country_context_surv,
  context_score_weights) {

  context_weight_col_name <- "Context weight"

  context_score_weights_df <- context_score_weights |>
    tibble::as_tibble() |>
    tidyr::pivot_longer(
      dplyr::everything(),
      names_to = context_col_name,
      values_to = context_weight_col_name
    )

  country_score <- country_context_surv |>
    dplyr::left_join(context_score_weights_df, by = context_col_name) |>
    dplyr::group_by(
      dplyr::across(
        dplyr::all_of(c(country_col_name, surveillance_approach_col_name))
      )
    ) |>
    dplyr::filter(!is.na(.data[[context_surv_score_col_name]])) |>
    dplyr::mutate(
      "{country_score_col_name}" := sum(
        .data[[context_weight_col_name]] * .data[[context_surv_score_col_name]]
      ) / sum(.data[[context_weight_col_name]]),
    ) |>
    dplyr::select(-dplyr::all_of(context_weight_col_name)) |>
    tidyr::pivot_wider(
      names_from = dplyr::all_of(context_col_name),
      values_from = dplyr::all_of(context_surv_score_col_name)
    ) |>
    dplyr::ungroup()

  # Rename context score columns
  for (i in 1:length(names(country_score))) {
    ncs <- names(country_score)[i]
    if (ncs == natural_disaster_risk_col_name) {
      names(country_score)[i] <- natural_disaster_risk_score_col_name
    } else if (ncs == epidemic_risk_col_name) {
      names(country_score)[i] <- epidemic_risk_score_col_name
    } else if (ncs == lab_capacitity_col_name) {
      names(country_score)[i] <- lab_capacitity_score_col_name
    } else if (ncs == surv_capacitity_col_name) {
      names(country_score)[i] <- surv_capacitity_score_col_name
    }
  }

  return(country_score)

}
