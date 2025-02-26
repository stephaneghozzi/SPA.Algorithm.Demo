inclusion_rule_is_met <- function(values, rules) {

  ref_values <- as.numeric(gsub(">|<|=| ", "", rules))

  include <- c()
  for (i in 1:length(values)) {

    rule_first_char <- substr(rules[i], 1, 1)
    rule_first_two_char <- substr(rules[i], 1, 2)

    if (is.na(values[i])) {

      include[i] <- FALSE

    } else {

      if (rule_first_two_char %in% c(">=", "<=")) {

        comparator <- rule_first_two_char

      } else if (rule_first_char %in% c(">", "<")) {

        comparator <- rule_first_char

      } else {

        stop(
          "An inclusion rule for surveillance approach is not well ",
          "formatted: '", rules[i], "'."
        )

      }

      include[i] <- do.call(comparator, list(values[i], ref_values[i]))

    }

  }

  return(include)

}
