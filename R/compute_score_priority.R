# The context score is 1 if the approach is prioritised for this context,
# else 0.
compute_score_priority <- function(surv_approaches,
  prioritised_approaches, score_no_prio) {

  score_context <- c()
  for (i in 1:length(surv_approaches)) {

    is_prioritised <- !is.na(prioritised_approaches[i]) &
      grepl(surv_approaches[i], prioritised_approaches[i])

    score_context[i] <- ifelse(
      is_prioritised,
      1,
      score_no_prio
    )

  }

  return(score_context)

}
