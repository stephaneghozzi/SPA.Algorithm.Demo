# country <- "Argentina"
# disease <- "Avian Influenza"
# objective_feature <- "Can monitor zoonotic disease over time"

compile_specific_scores <- function(
  scores,
  country, disease, objective_feature,
  # country_col_name, disease_col_name, feat_obj_col_name,
  # surveillance_approach_col_name
) {

  cs <- scores$country_score[
    scores$country_score[[country_col_name]] == country,
  ]
  cs[[country_col_name]] <- NULL

  ds <- scores$dis_surv_score[
    scores$dis_surv_score[[disease_col_name]] == disease,
  ]
  ds[[disease_col_name]] <- NULL

  ofs <- scores$feat_obj_surv_score[
    scores$feat_obj_surv_score[[feat_obj_col_name]] == objective_feature,
  ]
  ofs[[feat_obj_col_name]] <- NULL

  specific_scores <- cs |>
    dplyr::full_join(ds, by = surveillance_approach_col_name) |>
    dplyr::full_join(ofs, by = surveillance_approach_col_name)

  return(specific_scores)

}
