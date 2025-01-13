# country <- "Senegal"
# diseases <- c("Pandemic Influenza", "Avian Influenza", "Buruli Ulcer", "Bacterial Meningitis")
# features_objectives <- c("Can monitor disease  respiratory diseases (inc. droplet, airborne) over time", "Can identify clusters of cases", "Can identify each and every individual cases of a diseases (eradication goal)")
compile_specific_scores <- function(spa_individual_scores, country, diseases,
  features_objectives) {

  # Country
  cs <- spa_individual_scores$country_score[
    spa_individual_scores$country_score[[country_col_name]] == country,
  ]
  cs[[country_col_name]] <- NULL

  # Diseases
  ds <- spa_individual_scores$dis_surv_score[
    spa_individual_scores$dis_surv_score[[disease_col_name]] %in% diseases,
  ] |>
    dplyr::group_by(
      dplyr::across(
        dplyr::all_of(surveillance_approach_col_name)
      )
    ) |>
    dplyr::summarise(
      "{disease_score_col_name}" := mean(
        .data[[disease_score_col_name]],
        na.rm = FALSE
      ),
      .groups = "drop"
    )

  # Features / objectives
  fos <- spa_individual_scores$feat_obj_surv_score[
    spa_individual_scores$feat_obj_surv_score[[feat_obj_col_name]] %in%
      features_objectives,
  ] |>
    dplyr::group_by(
      dplyr::across(
        dplyr::all_of(surveillance_approach_col_name)
      )
    ) |>
    dplyr::summarise(
      "{feat_obj_score_col_name}" := mean(
        .data[[feat_obj_score_col_name]],
        na.rm = FALSE
      ),
      .groups = "drop"
    )

  specific_scores <- cs |>
    dplyr::full_join(ds, by = surveillance_approach_col_name) |>
    dplyr::full_join(fos, by = surveillance_approach_col_name)

  return(specific_scores)

}
