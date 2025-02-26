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
  feat_obj_surv = "inst/extdata/WSE review_v3 (MATRIX).xlsx",
  about = "inst/about.md"
)

# Column names
feat_obj_col_name <- "System features / Surveillance objectives"
feat_obj_score_col_name <- "Objective Score"
disease_col_name <- "Disease"
disease_score_col_name <- "Disease Score"
country_col_name <- "COUNTRY"
context_col_name <- "Context type"
context_value_col_name <- "Context value"
context_inclusion_rule_col_name <- "Inclusion rule"
prio_surv_col_name <- "Prioritised surveillance approaches"
surveillance_approach_col_name <- "Surveillance approach"
natural_disaster_risk_col_name <- "Natural"
epidemic_risk_col_name <- "Epidemic"
lab_capacitity_col_name <- "Laboratory Capacity D1.1"
surv_capacitity_col_name <- "Surveillance Capacity D2.1)"

context_surv_score_col_name <- "Score context"
country_score_col_name <- "Country Score"
combination_score_col_name <- "CDO Score" # "Country Disease Objective"
natural_disaster_risk_score_col_name <- "Disaster Score"
epidemic_risk_score_col_name <- "Epidemic Score"
lab_capacitity_score_col_name <- "Lab Score"
surv_capacitity_score_col_name <- "Surveillance Score"

rank_col_name <- "Rank"
final_score_col_name <- "Score"

# Default settings for scores

# Weights when combining individual context indicators
context_score_weights <- list()
context_score_weights[[natural_disaster_risk_col_name]] <- 1.
context_score_weights[[epidemic_risk_col_name]] <- 1.
context_score_weights[[lab_capacitity_col_name]] <- 1.
context_score_weights[[surv_capacitity_col_name]] <- 1.

# Context score when an approach is not prioritised
context_score_not_prioritised <- 0.5

# Overall score weights
score_weights <- list()
score_weights[[country_score_col_name]] <- 1.
score_weights[[disease_score_col_name]] <- 1.
score_weights[[feat_obj_score_col_name]] <- 1.

# Application
display_score_threshold_default <- 0.75
