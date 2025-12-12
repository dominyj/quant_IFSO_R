# 02_tidy_data.R
# =============================================================================
# Clean and Transform Raw Data for Analysis
# =============================================================================
# Input:  data/raw/macro_data_raw.rds
#         data/metadata/countries.rds
#         data/metadata/dbnomics_variables.rds
# Output: data/processed/analysis_data.rds
# =============================================================================

# For true reproducibility, restart R session before running:
# .rs.restartR()

rm(list = ls())

# Packages
library(tidyverse)
library(here)
library(lubridate)

# Load custom functions
source(here("R/functions/all_functions.R"))

# =============================================================================
# Load Data
# =============================================================================

macro_data_raw <- readRDS(here("data/raw/macro_data_raw.rds"))
countries <- readRDS(here("data/metadata/countries.rds"))
variables <- readRDS(here("data/metadata/dbnomics_variables.rds"))

# =============================================================================
# Extract Variable Names from Series Codes
# =============================================================================

# Create lookup table: series_code -> variable_name
# Series codes are the part after provider/dataset (e.g., "DEU.B1_GE.GPSA.Q")
variable_lookup <- expand_grid(
  country_code = countries$country_code,
  variables
) |>
  mutate(
    # Full series_id with provider/dataset
    series_id = str_replace(dbnomics_id, "\\{countrycode\\}", country_code),
    # Extract just the series_code part (after last "/")
    series_code = str_extract(series_id, "[^/]+$")
  ) |>
  select(series_code, variable_name, country_code)

# =============================================================================
# Clean and Reshape Data
# =============================================================================

analysis_data <- macro_data_raw |>
  # Join variable names and country codes using series_code
  left_join(variable_lookup, by = "series_code") |>
  # Select and rename relevant columns
  select(
    country_code,
    date = period,
    variable_name,
    value,
    download_timestamp
  ) |>
  # Convert date to proper date format
  mutate(
    date = ymd(date),
    quarter = quarter(date, with_year = TRUE)
  ) |>
  # Pivot to wide format: one row per country-quarter
  pivot_wider(
    id_cols = c(country_code, date, quarter, download_timestamp),
    names_from = variable_name,
    values_from = value
  ) |>
  # Add country names
  left_join(
    countries |> select(country_code, country_name),
    by = "country_code"
  ) |>
  # Remove rows with missing values in key variables
  filter(
    !is.na(gdp_growth),
    !is.na(unemployment_rate)
  ) |>
  # Sort by country and date
  arrange(country_code, date)

# =============================================================================
# Save Processed Data
# =============================================================================

saveRDS(analysis_data, here("data/processed/analysis_data.rds"))
