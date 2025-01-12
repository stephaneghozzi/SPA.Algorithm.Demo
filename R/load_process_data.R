load_process_data <- function() {

  # Get all surveillance approaches
  feat_obj_surv <- load_feat_obj_surv(
    file_paths$feat_obj_surv,
    feat_obj_col_name
  )
  surv_names <- names(feat_obj_surv)[names(feat_obj_surv) != feat_obj_col_name]

  # Country contexts
  country_context_values <- load_country_context_values(
    file_paths$context_country,
    file_paths$context_country_sheet,
    country_col_name
  )
  context_extreme_values <- country_context_values$context_extreme_values
  country_context <- country_context_values$country_context

  # Contexts vs surveillance approaches
  context_surv <- load_context_surv(file_paths$context_surv)

  # Compute country contexts vs surveillance approach
  country_context_surv <- compute_country_context_surv(country_context,
    context_surv, surv_names)

  # Compute final country score based on contexts
  country_score <- compute_country_score(country_context_surv,
    context_score_weights)

  # Features and objectives vs surveillance approaches
  feat_obj_surv_score <- feat_obj_surv |>
    dplyr::mutate(
      dplyr::across(
        !dplyr::matches(feat_obj_col_name),
        ~ .x / max_feat_obj_surv
      )
    ) |>
    tidyr::pivot_longer(
      !dplyr::matches(feat_obj_col_name),
      names_to = surveillance_approach_col_name,
      values_to = feat_obj_score_col_name
    )

  # Diseases vs surveillance approaches
  dis_surv <- load_dis_surv(file_paths$dis_surv) |>
    adhoc_standardize_dis_surv(surv_names, disease_col_name)
  dis_surv_score <- dis_surv |>
    tidyr::pivot_longer(
      dplyr::all_of(names(dis_surv)[names(dis_surv) != disease_col_name]),
      names_to = surveillance_approach_col_name,
      values_to = disease_score_col_name
    )

  spa_individual_scores <- list(
    country_score = country_score,
    dis_surv_score = dis_surv_score,
    feat_obj_surv_score = feat_obj_surv_score
  )

  return(spa_individual_scores)

}

