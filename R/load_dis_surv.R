load_dis_surv <- function(file_path) {

  # Load raw matrix of disease vs surveillance approach
  dis_surv <- readxl::read_xlsx(file_path)

  # Extract individual surveillance approaches
  surv_approaches <- paste(
    dis_surv$`Relevant Surveillance Systems`,
    collapse = ", "
  ) |>
    stringr::str_split_1(", ") |>
    unique()

  dis_surv[, surv_approaches] <- as.integer(NA)

  for (i in 1:nrow(dis_surv)) {

    dis_surv[i, surv_approaches] <- as.list(
      sapply(
        surv_approaches,
        \(x) as.integer(grepl(x, dis_surv[i, "Relevant Surveillance Systems"]))
      )
    )
  }

  dis_surv$`Relevant Surveillance Systems` <- NULL

  return(dis_surv)

}

