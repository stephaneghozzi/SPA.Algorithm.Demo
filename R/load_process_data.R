load_process_data <- function(
  # file_paths,
  # surveillance_approach_col_name,
  # country_col_name, context_col_name, context_surv_score_col_name,
  # country_score_col_name,
  # disease_col_name, disease_score_col_name,
  # feat_obj_col_name,
  # context_score_weights
) {


  # Country contexts
  country_context_values <- load_country_context_values(
    file_paths$context_country,
    file_paths$context_country_sheet,
    country_col_name
  )
  context_extreme_values <- country_context_values$context_extreme_values
  country_context <- country_context_values$country_context
  country_context_rel <- country_context

  # Scale country contexts to [0,1]
  for (
    cf in names(country_context)[names(country_context) != country_col_name]
  ) {
    min_cf <- context_extreme_values$min_value[
      context_extreme_values$feature == cf
    ]
    max_cf <- context_extreme_values$max_value[
      context_extreme_values$feature == cf
    ]
    country_context_rel[,cf] <- (country_context[,cf] - min_cf) /
      (max_cf - min_cf)
  }

  # Contexts vs surveillance approaches
  context_surv <- load_context_surv(file_paths$context_surv)

  # Compute country contexts vs surveillance approach
  country_context_score <- compute_country_context_surv(country_context_rel,
    context_surv, country_col_name, context_col_name,
    surveillance_approach_col_name, context_surv_score_col_name)

  # Compute final country score based on contexts
  country_score <- compute_country_score(country_context_score,
    context_score_weights, context_surv_score_col_name,
    context_col_name, country_col_name, surveillance_approach_col_name,
    country_score_col_name)

  # Features and objectives vs surveillance approaches
  feat_obj_surv <- load_feat_obj_surv(
    file_paths$feat_obj_surv,
    feat_obj_col_name
  )
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
  surv_names <- names(feat_obj_surv)[names(feat_obj_surv) != feat_obj_col_name]
  dis_surv <- load_dis_surv(file_paths$dis_surv) |>
    adhoc_standardize_dis_surv(surv_names, disease_col_name)
  dis_surv_score <- dis_surv |>
    tidyr::pivot_longer(
      dplyr::all_of(names(dis_surv)[names(dis_surv) != disease_col_name]),
      names_to = surveillance_approach_col_name,
      values_to = disease_score_col_name
    )

  scores <- list(
    country_score = country_score,
    dis_surv_score = dis_surv_score,
    feat_obj_surv_score = feat_obj_surv_score
  )

  return(scores)

}
