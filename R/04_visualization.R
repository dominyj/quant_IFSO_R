# 04_visualization.R
# =============================================================================
# Create Visualizations for Okun's Law
# =============================================================================
# Input:  data/processed/analysis_data.rds
#         output/models/okun_models_by_country.rds
# Output: output/figures/okun_scatter_pooled.png
#         output/figures/okun_scatter_by_country.png
#         output/figures/okun_coefficients.png
# =============================================================================

# For true reproducibility, restart R session before running:
# .rs.restartR()

rm(list = ls())

# Packages
library(tidyverse)
library(here)

# Load custom functions
source(here("R/functions/all_functions.R"))

# =============================================================================
# Load Data
# =============================================================================

analysis_data <- readRDS(here("data/processed/analysis_data.rds"))
okun_models <- readRDS(here("output/models/okun_models_by_country.rds"))

# =============================================================================
# Pooled Scatter Plot
# =============================================================================

plot_pooled <- ggplot(analysis_data, aes(x = gdp_growth, y = unemployment_rate)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", se = TRUE, color = "red") +
  labs(
    title = "Okun's Law: Pooled Data",
    x = "GDP Growth Rate (%)",
    y = "Unemployment Rate (%)",
    caption = "Data: OECD via DBnomics"
  ) +
  theme_okun()

ggsave(
  here("output/fig/exploratory/okun_scatter_pooled.pdf"),
  plot_pooled,
  width = 8,
  height = 6
)

# =============================================================================
# Scatter Plot by Country
# =============================================================================

plot_by_country <- ggplot(analysis_data, aes(x = gdp_growth, y = unemployment_rate, color = country_name)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE) +
  facet_wrap(~country_name, scales = "free") +
  labs(
    title = "Okun's Law by Country",
    x = "GDP Growth Rate (%)",
    y = "Unemployment Rate (%)",
    caption = "Data: OECD via DBnomics"
  ) +
  theme_okun() +
  theme(legend.position = "none")

ggsave(
  here("output/fig/exploratory/okun_scatter_by_country.pdf"),
  plot_by_country,
  width = 12,
  height = 8
)

# =============================================================================
# Coefficient Comparison
# =============================================================================

okun_coefficients_plot <- okun_models |>
  select(country_name, tidy_model) |>
  unnest(tidy_model) |>
  filter(term == "gdp_growth") |>
  ggplot(aes(x = reorder(country_name, estimate), y = estimate)) +
  geom_point(size = 12, shape = "*", color = "red") +
  geom_errorbar(
    aes(ymin = estimate - 1.96 * std.error, ymax = estimate + 1.96 * std.error),
    width = 0.2
  ) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray") +
  coord_flip() +
  labs(
    title = "Okun's Law Coefficients by Country",
    subtitle = "Effect of 1pp GDP growth on unemployment rate",
    x = NULL,
    y = "Coefficient (with 95% CI)",
    caption = "Data: OECD via DBnomics"
  ) +
  theme_okun()

ggsave(
  here("output/fig/exploratory/okun_coefficients.pdf"),
  okun_coefficients_plot,
  width = 8,
  height = 6
)
