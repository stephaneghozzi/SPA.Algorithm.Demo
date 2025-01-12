load_context_surv <- function(file_path) {

  context_surv <- readxl::read_xlsx(file_path, col_types = "text")

  # Check that the inclusion rules are properly formatted
  is_valid_rule_format <- check_inclusion_rule_format(
    context_surv[[context_inclusion_rule_col_name]]
  )
  if (!is_valid_rule_format) {
    stop(
      paste0(
        "The inclusion rules for prioritising surveillance approaches are not ",
        "properly formatted, see column '", context_inclusion_rule_col_name,
        "' of file '", file_path, "'. The rules should be of the form '> x', ",
        "'>= x', '< x', or '<= x', with 'x' a number, empty spaces are ignored."
      )
    )
  }

  return(context_surv)

}
