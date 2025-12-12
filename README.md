# R Best Practice Example Project

This project demonstrates best practices for reproducible research in R using a simple economic analysis as an example.

## Project Structure
```
.
├── R/
│   ├── 00_setup_metadata.R      # Define countries and variables
│   ├── 01_import_data.R         # Download data from DBnomics
│   ├── 02_tidy_data.R           # Clean and transform data
│   ├── 03_regression.R          # Run regression analysis
│   ├── 04_visualization.R       # Create plots
│   └── functions/
│       └── all_functions.R      # Custom functions (with roxygen2)
├── data/
│   ├── metadata/                # Project metadata (CSV + RDS)
│   ├── raw/                     # Raw data from API
│   ├── raw_original/            # Original data backup
│   ├── raw_backup/              # Timestamped backups
│   └── processed/               # Analysis-ready data
├── output/
│   ├── models/                  # Regression results
│   ├── tables/                  # Output tables
│   └── figures/                 # Plots
├── main.R                       # Run complete pipeline
├── renv.lock                    # Package dependencies
├── quant_IFSO.Rproj
└── README.md
```

## Setup

1. **Open R Project**: `quant_IFSO.Rproj`
2. **Restore packages**: `renv::restore()`
3. **Run analysis**: `source("main.R")`

## Running the Analysis

### Complete Pipeline
```r
source("main.R")
```

**Note:** Data download (Step 01) is commented out by default. Uncomment to download fresh data.

### Individual Scripts

Each script runs independently:
```r
source(here::here("R/02_tidy_data.R"))
```

## Data Management

### Backup System

- **`data/raw/`** - Current raw data
- **`data/raw_original/`** - Original raw data used for analysis
- **`data/raw_backup/`** - Timestamped backups (created automatically on update)

### Update Data

In `main.R`, uncomment:
```r
update_data_from_dbnomics()
```

The function will prompt for confirmation and create a backup before downloading.

## Best Practices Demonstrated

This project shows:

- **Git version control** - Track changes, collaborate
- **`{renv}`** - Reproducible package management
- **`{here}`** - Portable file paths
- **Clear structure** - Logical folders and numbered scripts
- **Independent scripts** - Each loads its own inputs
- **Custom functions** - Reusable code with roxygen2 documentation
- **Self-documenting code** - Clear variable names, minimal comments
- **Automated backups** - Data versioning with timestamps

## Reproducibility

For full reproducibility:
1. Open via `.Rproj` file
2. Run `renv::restore()`
3. Restart R before running scripts (`.rs.restartR()`)
