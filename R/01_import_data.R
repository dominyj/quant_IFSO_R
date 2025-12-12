# 01_import_data.R
# =============================================================================
# Download Data from DBnomics API
# =============================================================================
# Input:  data/metadata/countries.rds
#         data/metadata/dbnomics_variables.rds
# Output: data/raw/macro_data_raw.rds
# =============================================================================

# For true reproducibility, restart R session before running:
# .rs.restartR()

rm(list = ls())

# Packages
library(tidyverse)
library(here)
library(rdbnomics)

# Load custom functions
source(here("R/functions/all_functions.R"))

# =============================================================================
# Load Metadata
# =============================================================================

countries <- readRDS(here("data/metadata/countries.rds"))
variables <- readRDS(here("data/metadata/dbnomics_variables.rds"))

# =============================================================================
# Build Series IDs
# =============================================================================

# Create all combinations of countries and variables
series_grid <- expand_grid(
  country_code = countries$country_code,
  variables
) |>
  mutate(
    # Replace placeholder with actual country code
    series_id = str_replace(dbnomics_id, "\\{countrycode\\}", country_code)
  )

# =============================================================================
# Download All Data
# =============================================================================

macro_data_raw <- rdb(ids = series_grid$series_id) |>
  mutate(download_timestamp = Sys.time())

# =============================================================================
# Save Raw Data
# =============================================================================

saveRDS(macro_data_raw, here("data/raw/macro_data_raw.rds"))
