summarises_approach_adequacy <- function(objectives, objective_scores, surv_approach) {

  obj_best <- objectives[which(objective_scores == 1)]
  obj_ok <- objectives[which(objective_scores > 0 & objective_scores < 1)]
  obj_bad <- objectives[which(objective_scores == 0)]

  summary_best <- paste(obj_best, collapse = '", "')
  summary_ok <- paste(obj_ok, collapse = '", "')
  summary_bad <- paste(obj_bad, collapse = '", "')

  summary <- paste0(
    ifelse(
      nchar(summary_best) > 0,
      paste0('is best for "', summary_best, '"'),
      ""
    ),
    ifelse(
      nchar(summary_best) > 0 & nchar(summary_ok) > 0,
      "; ",
      ""
    ),
    ifelse(
      nchar(summary_ok) > 0,
      paste0('can also be used for "', summary_ok, '"'),
      ""
    ),
    ifelse(
      (nchar(summary_best) > 0 | nchar(summary_ok) > 0)
      & nchar(summary_bad) > 0,
      "; ",
      ""
    ),
    ifelse(
      nchar(summary_bad) > 0,
      paste0('is not very suitable for "', summary_bad, '"'),
      ""
    )
  )

  return(summary)

}
