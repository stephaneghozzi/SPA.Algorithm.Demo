# Data features
max_feat_obj_surv <- 3

# Paths to raw data
file_paths <- list(
  context_country = "data/Contextual Computation V0.3 - Live Version.xlsx",
  context_country_sheet = "Contextual Algorithm Input",
  context_surv =
    "data/PLACEHOLDER-country-features-vs-surveillance-approaches.xlsx",
  dis_surv = "data/Disease surveillance matching .xlsx",
  feat_obj_surv = "data/WSE review_v3 (MATRIX).xlsx"
)

# Column names
feat_obj_col_name <- "System features / Surveillance objectives"
feat_obj_score_col_name <- "Score feature / objective"
disease_col_name <- "Disease"
disease_score_col_name <- "Score disease"
country_col_name <- "COUNTRY"
context_col_name <- "Context type"
surveillance_approach_col_name <- "Surveillance approach"
context_surv_score_col_name <- "Score context"
country_score_col_name <- "Score country"

# Default score weights
# The names of `context_score_weights` should be the same as in the
# "context_country" data set
context_score_weights <- list(
  Natural = 1.,
  Epidemic = 1.,
  `Laboratory Capacity D1.1` = 1.,
  `Surveillance Capacity D2.1)` = 1.
)

# The names of `score_weights` should be the same as those defined above
score_weights <- list(
  `Score country` = 1.,
  `Score disease` = 1.,
  `Score feature / objective` = 1.
)
