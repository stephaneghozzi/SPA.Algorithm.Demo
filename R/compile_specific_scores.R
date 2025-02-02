compile_specific_scores <- function(spa_individual_scores, country, diseases,
  features_objectives) {

  # Country
  cs <- spa_individual_scores$country_score |>
    dplyr::filter(.data[[country_col_name]] == country)

  # Diseases
  ds <- spa_individual_scores$dis_surv_score |>
    dplyr::filter(.data[[disease_col_name]] %in% diseases)

  # Features / objectives
  fos <- spa_individual_scores$feat_obj_surv_score |>
    dplyr::filter(.data[[feat_obj_col_name]] %in% features_objectives)

  specific_scores <- cs |>
    dplyr::full_join(
      ds,
      by = surveillance_approach_col_name,
      relationship = "many-to-many"
    ) |>
    dplyr::full_join(
      fos,
      by = surveillance_approach_col_name,
      relationship = "many-to-many"
    )

  return(specific_scores)

}
