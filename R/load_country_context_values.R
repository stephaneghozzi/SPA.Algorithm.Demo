load_country_context_values <- function(file_path, sheet_name,
  country_col_name) {

  country_context <- readxl::read_xlsx(file_path, sheet_name)

  # Remove empty columns
  remove_col_num <- which(
    sapply(names(country_context), \(x) all(is.na(country_context[,x])))
  )
  country_context[,remove_col_num] <- NULL

  # The second row in the Excel (first row in the imported table) indicates the
  # values that each context column can take. We don't need the one for country
  # names.
  context_extreme_values <- country_context[1,] |>
    tidyr::pivot_longer(
      tidyr::everything(),
      names_to = "feature",
      values_to = "extreme_values"
    ) |>
    dplyr::filter(feature != country_col_name) |>
    dplyr::mutate(
      min_value = as.integer(
        gsub("\\(", "", stringr::str_split_i(extreme_values, "-", 1))
      ),
      max_value = as.integer(
        gsub("\\)", "", stringr::str_split_i(extreme_values, "-", 2))
      ),
    ) |>
    dplyr::select(-extreme_values)

  # Remove from the raw data the row indicating the extreme values
  country_context <- country_context[2:nrow(country_context),] |>
    dplyr::mutate(dplyr::across(!dplyr::contains(country_col_name), as.numeric))

  country_context_values  <- list(
    context_extreme_values = context_extreme_values,
    country_context = country_context
  )
  return(country_context_values)

}
