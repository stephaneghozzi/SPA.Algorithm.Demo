compute_country_context_surv <- function(country_context, context_surv,
  surv_names) {

  # Combinations of surveillance approaches, countries, and contexts
  all_surv_approaches <- tibble::as_tibble(surv_names)
  names(all_surv_approaches) <- surveillance_approach_col_name

  country_context_values <- country_context |>
    tidyr::pivot_longer(
      !dplyr::matches(country_col_name),
      names_to = context_col_name,
      values_to = context_value_col_name
    )

  # List for each country the contexts and corresponding prioritised approaches,
  # if any
  contry_context_prio <- country_context_values |>
    dplyr::left_join(
      context_surv,
      by = context_col_name,
      relationship = "many-to-many"
    ) |>
    dplyr::mutate(
      include = inclusion_rule_is_met(
        .data[[context_value_col_name]],
        .data[[context_inclusion_rule_col_name]]
      )
    ) |>
    dplyr::filter(include) |>
    dplyr::group_by( # in case a context value meets multiple inclusion rules
      dplyr::across(
        dplyr::all_of(
          c(country_col_name, context_col_name)
        )
      )
    ) |>
    dplyr::summarise(
      "{prio_surv_col_name}" := paste0(
        .data[[prio_surv_col_name]],
        collapse = ", "
      ),
      .groups = "drop"
    )

  # For each country, context, and surveillance approach, see whether the
  # surveillance approach is prioritised and compute the context score
  # accordingly
  country_context_surv <- country_context_values |>
    dplyr::cross_join(all_surv_approaches) |>
    dplyr::left_join(
      contry_context_prio,
      by = c(country_col_name, context_col_name)
    ) |>
    dplyr::mutate(
      "{context_surv_score_col_name}" := compute_score_priority(
        .data[[surveillance_approach_col_name]],
        .data[[prio_surv_col_name]],
        context_score_not_prioritised
      )
    )

  # Keep only relevant columns
  country_context_surv <- country_context_surv |>
    dplyr::select(
      dplyr::all_of(
        c(country_col_name, context_col_name, surveillance_approach_col_name,
          context_surv_score_col_name)
      )
    )

  return(country_context_surv)

}
