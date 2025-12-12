# main.R
# =============================================================================
# Run Complete Analysis Pipeline
# =============================================================================
# This script runs all analysis steps in sequence.
# Each step can also be run independently (they load their own inputs).
#
# Input:  None (runs all scripts in sequence)
# Output: All analysis outputs (models, tables, figures)
#
# IMPORTANT: Step 01 downloads NEW data and overwrites data/raw/
#            Original data is preserved in data/raw_original/ (read-only)
# =============================================================================

# For true reproducibility, restart R session before running:
# .rs.restartR()

rm(list = ls())

library(here)

# Load custom functions
source(here("R/functions/all_functions.R"))

# =============================================================================
# Step 00: Setup Metadata
# =============================================================================
# Define countries and variables to download from DBnomics

source(here("R/00_setup_metadata.R"))

# =============================================================================
# Step 01: Import Data
# =============================================================================
# WARNING: Downloads NEW data from DBnomics and OVERWRITES data/raw/
# Original data is preserved in data/raw_original/ (read-only backup)
#
# This step is COMMENTED OUT by default to prevent accidental data overwriting.
# To download fresh data: uncomment the line below

# prompt_data_download()

# =============================================================================
# Step 02: Clean Data
# =============================================================================
# Transform raw data into analysis-ready format

source(here("R/02_tidy_data.R"))

# =============================================================================
# Step 03: Run Regression
# =============================================================================
# Estimate Okun's Law (pooled and by country)

source(here("R/03_regression.R"))

# =============================================================================
# Step 04: Create Visualizations
# =============================================================================
# Generate plots and save to output/figures/

source(here("R/04_visualization.R"))
