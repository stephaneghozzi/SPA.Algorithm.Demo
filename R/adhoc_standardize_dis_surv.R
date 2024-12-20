# Align surveillance-approach names in the "disease matching" table with those
# in the "features / objectives" table.
adhoc_standardize_dis_surv <- function(dis_surv, surv_names, disease_col_name) {

  # Ad-hoc corrections
  correct_cbs <- which(names(dis_surv) == "Community-based Surveillance")
  names(dis_surv)[correct_cbs] <- "Community based surveillance"

  correct_dsnd <- which(names(dis_surv) == "Disaster Surveillance")
  names(dis_surv)[correct_dsnd] <- "Disaster surveillance (e.g natural disaster)"

  correct_hadccm <- which(
    names(dis_surv) == "Hospital Administrative Data & Clinical Code Monitoring"
  )
  names(dis_surv)[correct_hadccm] <-
    "Hospital administrative data and clinical code monitoring (including emergency department)"

  correct_lbsn <- which(
    names(dis_surv) == "Laboratory-based Surveillance Network"
  )
  names(dis_surv)[correct_lbsn] <- "Laboratory- based surveillance network"

  correct_pvae <- which(
    names(dis_surv) == "Pharmacovigilance"
  )
  names(dis_surv)[correct_pvae] <- "Pharmacovigilance (Adverse events)"

  # When two columns refer to the same approach, then there is a match whenever
  # one of those matches the disease
  correct_esis <- which(
    names(dis_surv) == "Environmental Surveillance (including Wastewater)"
  )
  names(dis_surv)[correct_esis] <-
    "Environmental surveillance (includ. wastewater)"
  dis_surv <- dis_surv |>
    dplyr::mutate(
      `Environmental surveillance (includ. wastewater)` = max(
        `Environmental surveillance (includ. wastewater)`,
        `Environmental Surveillance`
      )
    ) |>
    dplyr::select(-`Environmental Surveillance`)

  # Match letter cases
  names(dis_surv) <- sapply(
    names(dis_surv),
    \(x) ifelse(
      tolower(x) %in% tolower(surv_names),
      surv_names[which(tolower(surv_names) == tolower(x))],
      x
    )
  )

  # Add missing approaches, fill with 0's
  missing_surv <- surv_names[!surv_names %in% names(dis_surv)]
  if (length(missing_surv) > 0) {
    warning(
      paste0(
        "Adding the following surveillance approaches to disease matching ",
        "table, but filling with 0's, i.e., they don't match any disease:\n",
        paste(paste0("- ", missing_surv), collapse = ",\n"),
        "."
      )
    )
    dis_surv[,missing_surv] <- 0L
  }

  # Flag if there are surveillance approaches not listed in the reference list
  # (derived from matrix of features / objective vs approaches)
  extra_surv <- names(dis_surv)[
    (names(dis_surv) != disease_col_name) & (!names(dis_surv) %in% surv_names)
  ]
  if (length(extra_surv) > 0) {
    warning(
      paste0(
        "The following surveillance approaches were found in the ",
        "disease-matching table but not in the matrix of features / objective ",
        "vs approaches, they'll be ignored in subsequent analyses:\n",
        paste(paste0("- ", extra_surv), collapse = ",\n"),
        "."
      )
    )
  }

  return(dis_surv)

}
