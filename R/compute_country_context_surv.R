compute_country_context_surv <- function(country_context_rel, context_surv,
  country_col_name, context_col_name, surveillance_approach_col_name,
  context_surv_score_col_name) {

  context_value_col_name <- "Context value"
  context_surv_col_name <- "context_surv"

  country_context_surv <- country_context_rel |>
    tidyr::pivot_longer(
      !dplyr::matches(country_col_name),
      names_to = context_col_name,
      values_to = context_value_col_name
    ) |>
    dplyr::left_join(context_surv, by = context_col_name) |>
    tidyr::pivot_longer(
      !dplyr::matches(c(country_col_name, country_col_name, context_col_name,
        context_value_col_name)),
      names_to = surveillance_approach_col_name,
      values_to = context_surv_col_name
    ) |>
    dplyr::mutate(
      context_surv_score = dplyr::case_when(
        context_surv == "+" ~ .data[[context_value_col_name]],
        context_surv == "-" ~ 1 - .data[[context_value_col_name]],
        context_surv == "0" ~ 0.5,
        TRUE ~ as.numeric(NA)
      )
    )

  country_context_surv[[context_surv_score_col_name]] <-
    country_context_surv$context_surv_score

  country_context_surv <- country_context_surv |>
    dplyr::select(
      -dplyr::all_of(c("context_surv_score", context_value_col_name,
        context_surv_col_name))
    )

  return(country_context_surv)

}
