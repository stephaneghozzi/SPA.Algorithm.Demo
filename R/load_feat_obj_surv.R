load_feat_obj_surv <- function(file_path, feat_obj_col_name) {

  # Load raw matrix of objective vs surveillance approach
  feat_obj_surv <- readxl::read_xlsx(file_path, skip = 1)

  # Clean featrue / objective column name
  feat_obj_col_select <- "features"
  feat_obj_col_num <- which(grepl(feat_obj_col_select, names(feat_obj_surv)))
  names(feat_obj_surv)[feat_obj_col_num] <- feat_obj_col_name

  # Remove the first column, which indicates groups of objectives, and removes
  # the rows with corresponding missing values
  feat_obj_surv[,1] <- NULL
  feat_obj_surv <- feat_obj_surv[!is.na(feat_obj_surv[,feat_obj_col_name]),]

  # Set to integers all columns other than the one listing features and
  # objectives
  feat_obj_surv <- feat_obj_surv |>
    dplyr::mutate(
      dplyr::across(
        !dplyr::matches(feat_obj_col_name),
        as.integer
      )
    )

  return(feat_obj_surv)

}
