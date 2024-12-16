load_context_surv <- function(file_path) {

  context_surv <- readxl::read_xlsx(file_path, col_types = "text")

  return(context_surv)

}
