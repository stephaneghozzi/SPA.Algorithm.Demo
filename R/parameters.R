# Data features
max_feat_obj_surv <- 3 # maximum score in the matching of features / objectives
  # with surveillance approaches

# Paths to raw data
file_paths <- list(
  context_country =
    "inst/extdata/Contextual Computation V0.3 - Live Version.xlsx",
  context_country_sheet = "Contextual Algorithm Input",
  context_surv =
    "inst/extdata/context-vs-surveillance-approaches.xlsx",
  dis_surv = "inst/extdata/Disease surveillance matching .xlsx",
  feat_obj_surv = "inst/extdata/WSE review_v3 (MATRIX).xlsx"
)

# Column names
feat_obj_col_name <- "System features / Surveillance objectives"
feat_obj_score_col_name <- "Score feature / objective"
disease_col_name <- "Disease"
disease_score_col_name <- "Score disease"
country_col_name <- "COUNTRY"
context_col_name <- "Context type"
context_value_col_name <- "Context value"
context_inclusion_rule_col_name <- "Inclusion rule"
prio_surv_col_name <- "Prioritised surveillance approaches"
surveillance_approach_col_name <- "Surveillance approach"
context_surv_score_col_name <- "Score context"
country_score_col_name <- "Score country"

# Default settings for scores

# The names of `context_score_weights` should be the same as in the
# "context_country" data set
context_score_weights <- list(
  Natural = 1.,
  Epidemic = 1.,
  `Laboratory Capacity D1.1` = 1.,
  `Surveillance Capacity D2.1)` = 1.
)

# Context score when an approach is not prioritised
context_score_not_prioritised <- 0.5

# Overall score weights
score_weights <- list()
score_weights[[country_score_col_name]] <- 1.
score_weights[[disease_score_col_name]] <- 1.
score_weights[[feat_obj_score_col_name]] <- 1.

# Application
show_results_score_threshold <- 0.75
