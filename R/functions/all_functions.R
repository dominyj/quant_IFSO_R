# R/functions/all_functions.R
# =============================================================================
# Custom Functions for Okun's Law Analysis
# =============================================================================

#' Custom ggplot2 Theme for Project
#'
#' Consistent theme for all visualizations in this project
#'
#' @return A ggplot2 theme object
#' @export
theme_okun <- function() {
  theme_minimal(base_size = 11) +
    theme(
      # Text
      plot.title = element_text(size = 14, face = "bold", hjust = 0),
      plot.subtitle = element_text(size = 11, color = "gray30", hjust = 0),
      plot.caption = element_text(size = 9, color = "gray50", hjust = 0),

      # Axes
      axis.title = element_text(size = 11, face = "bold"),
      axis.text = element_text(size = 10),

      # Legend
      legend.position = "bottom",
      legend.title = element_text(size = 10, face = "bold"),
      legend.text = element_text(size = 10),

      # Panel
      panel.grid.minor = element_blank(),
      panel.grid.major = element_line(color = "gray90"),

      # Facets
      strip.text = element_text(size = 11, face = "bold")
    )
}

#' Ask User to Confirm Action
#'
#' Simple confirmation prompt for destructive operations
#'
#' @param prompt Character string with question to ask user
#' @return Logical TRUE if user confirms, FALSE otherwise
ask_user_confirmation <- function(prompt) {
  response <- readline(prompt = prompt)
  return(tolower(response) == "y")
}

#' Update Data from DBnomics
#'
#' Downloads fresh data from DBnomics API with user confirmation.
#' Creates timestamped backup of existing data before overwriting.
#'
#' @details
#' - Asks user for confirmation before downloading
#' - Creates backup in data/raw_backup/ with timestamp
#' - Runs R/01_import_data.R to download new data
#' - Original data remains in data/raw_original/ (read-only)
#'
#' @return NULL (runs import script as side effect)
#' @export
update_data_from_dbnomics <- function() {

  # Ask user for confirmation
  confirmed <- ask_user_confirmation(
    "Download new data from DBnomics? This will create a backup and update data/raw/ (y/n): "
  )

  if (!confirmed) {
    message("Using existing data in data/raw/")
    return(invisible(NULL))
  }

  # Check if current raw data exists and create backup
  raw_data_file <- here::here("data/raw/macro_data_raw.rds")

  if (file.exists(raw_data_file)) {

    # Create backup directory
    backup_dir <- here::here("data/raw_backup")
    dir.create(backup_dir, showWarnings = FALSE, recursive = TRUE)

    # Create timestamped backup filename
    timestamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
    backup_file <- file.path(backup_dir, paste0("macro_data_raw_", timestamp, ".rds"))

    # Copy current data to backup
    file.copy(from = raw_data_file, to = backup_file)

    message("Backup created: ", basename(backup_file))
  }

  # Download new data
  message("Downloading new data from DBnomics...")
  source(here::here("R/01_import_data.R"))
  message("Data updated successfully")
}
