# "The inclusion rules for prioritising surveillance approaches should be of
# the form "> x", ">= x", "< x", or "<= x", with "x" a number and empty spaces
# ignored.
check_inclusion_rule_format <- function(rules) {

  rules <- gsub(" ", "", rules)

  is_valid_rule_format <- all(
    (nchar(rules) > 1) &
    grepl(">|<", substr(rules, 1, 1)) &
    grepl("=|\\.|[0-9]", substr(rules, 2, 2))
  ) &
    all(
      !is.na(
        as.numeric(
          substr(rules, 3, nchar(rules))[substr(rules, 3, nchar(rules)) > 0]
        )
      )
    )

  return(is_valid_rule_format)

}
