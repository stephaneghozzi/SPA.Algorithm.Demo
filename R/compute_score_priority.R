# The context score is 1 if the approach is prioritised for this context,
# else 0.
compute_score_priority <- function(surv_approaches,
  prioritised_approaches) {

  score_context <- c()
  for (i in 1:length(surv_approaches)) {

    score_context[i] <- as.numeric(
      !is.na(prioritised_approaches[i]) &
      grepl(surv_approaches[i], prioritised_approaches[i])
    )

  }

  return(score_context)

}
