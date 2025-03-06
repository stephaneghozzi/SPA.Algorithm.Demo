compute_score_individual <- function(score_value, weight_value) {

  prod(score_value ^ weight_value) ^ (1 / sum(weight_value))

}

