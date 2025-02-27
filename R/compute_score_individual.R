compute_score_individual <- function(score_value, weight_value, combin_type) {

  if (combin_type == "multiplicative") {

    score_individual <- compute_score_individual_mult(score_value, weight_value)

  } else if (combin_type == "additive") {

    score_individual <- compute_score_individual_add(score_value, weight_value)

  } else {

    stop("Unknown type of score combination: ", combin_type)

  }

  return(score_individual)

}

compute_score_individual_mult <- function(score_value, weight_value) {

  prod(score_value ^ weight_value) ^ (1 / sum(weight_value))

}

compute_score_individual_add <- function(score_value, weight_value) {

  sum(score_value * weight_value) / sum(weight_value)

}
