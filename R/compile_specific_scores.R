compile_specific_scores <- function(
  spa_individual_scores,
  country, disease, objective_feature
  # country_col_name, disease_col_name, feat_obj_col_name,
  # surveillance_approach_col_name
) {

  cs <- spa_individual_scores$country_score[
    spa_individual_scores$country_score[[country_col_name]] == country,
  ]
  cs[[country_col_name]] <- NULL

  ds <- spa_individual_scores$dis_surv_score[
    spa_individual_scores$dis_surv_score[[disease_col_name]] == disease,
  ]
  ds[[disease_col_name]] <- NULL

  ofs <- spa_individual_scores$feat_obj_surv_score[
    spa_individual_scores$feat_obj_surv_score[[feat_obj_col_name]] ==
      objective_feature,
  ]
  ofs[[feat_obj_col_name]] <- NULL

  specific_scores <- cs |>
    dplyr::full_join(ds, by = surveillance_approach_col_name) |>
    dplyr::full_join(ofs, by = surveillance_approach_col_name)

  return(specific_scores)

}
