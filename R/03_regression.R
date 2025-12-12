# 03_regression.R
# =============================================================================
# Estimate Okun's Law Relationship
# =============================================================================
# Input:  data/processed/analysis_data.rds
# Output: output/models/okun_model_pooled.rds
#         output/models/okun_models_by_country.rds
#         output/tables/okun_coefficients.csv
# =============================================================================

# For true reproducibility, restart R session before running:
# .rs.restartR()

rm(list = ls())

# Packages
library(tidyverse)
library(here)
library(broom)

# Load custom functions
source(here("R/functions/all_functions.R"))

# =============================================================================
# Load Data
# =============================================================================

analysis_data <- readRDS(here("data/processed/analysis_data.rds"))

# =============================================================================
# Pooled Model (All Countries)
# =============================================================================

okun_model_pooled <- lm(
  unemployment_rate ~ gdp_growth,
  data = analysis_data
)

# =============================================================================
# Country-Specific Models
# =============================================================================

okun_models_by_country <- analysis_data |>
  group_by(country_code, country_name) |>
  nest() |>
  mutate(
    model = map(data, ~ lm(unemployment_rate ~ gdp_growth, data = .x)),
    tidy_model = map(model, tidy),
    glance_model = map(model, glance)
  )

# =============================================================================
# Extract Coefficients
# =============================================================================

okun_coefficients <- okun_models_by_country |>
  select(country_code, country_name, tidy_model) |>
  unnest(tidy_model) |>
  filter(term == "gdp_growth") |>
  select(
    country_code,
    country_name,
    coefficient = estimate,
    std_error = std.error,
    p_value = p.value
  )

# =============================================================================
# Save Results
# =============================================================================

saveRDS(okun_model_pooled, here("output/models/okun_model_pooled.rds"))
saveRDS(okun_models_by_country, here("output/models/okun_models_by_country.rds"))
write_csv(okun_coefficients, here("output/tables/okun_coefficients.csv"))
