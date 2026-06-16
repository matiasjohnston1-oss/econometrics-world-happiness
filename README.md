# Econometric Analysis of World Happiness Determinants

Cross-national regression analysis of the structural determinants of national happiness, using World Happiness Report data from 2020, 2023, and 2024.

Group project for ECON 339 (Econometrics with R) at Cal Poly San Luis Obispo. Co-authored with [Teammate 1] and [Teammate 2].

## What this analysis does

Using 467 country-year observations across three years and more than 150 countries each year, this project models the national Happiness Score (0-10 scale) as a function of six structural variables:

- GDP per capita
- Social Support
- Healthy Life Expectancy
- Freedom to Make Life Choices
- Generosity
- Perceptions of Corruption (inversely coded — higher values indicate *less* perceived corruption)

We fit three specifications and compare them:

- **Model 1** — linear OLS with all six predictors.
- **Model 2** — log-Y specification, with smearing correction for cross-scale R² comparison.
- **Model 3** — Model 1 plus year dummies for 2020 and 2023 (2024 as reference).

We test joint significance of the year effects via a partial F-test, compare model fit via Adjusted R² and AIC, and diagnose assumptions via:

- Breusch-Pagan test for heteroskedasticity
- Variance Inflation Factors (VIF) for multicollinearity
- Heteroskedasticity-robust standard errors (White's HC1 estimator)

## Key findings

- The baseline model explains **~78% of the variation** in national happiness scores (Adjusted R² = 0.78).
- **Freedom to Make Life Choices** is the strongest predictor (β = 1.44), followed by Social Support (1.12), Healthy Life Expectancy (1.03), Corruption-inverse (0.89), and GDP per capita (0.82).
- **Generosity is not statistically significant** once heteroskedasticity-robust standard errors are applied (p = 0.131); the 95% CI crosses zero.
- **Year effects are jointly insignificant** (partial F-test p = 0.97). Structural variables — not year-specific shocks — explain national happiness.
- All variance inflation factors are below 5; multicollinearity is not severe enough to undermine interpretation.

See `report.md` for the full managerial report, and `figures/residual_plot.png` for the residual diagnostic.

## How to reproduce

1. Open `analysis.R` in RStudio.
2. Install required packages if needed: `readxl`, `lmtest`, `sandwich`, `car`.
3. Download the data from the source linked in `data/README.md` and follow the setup steps there.
4. Update the `setwd()` line in `analysis.R` to point to your local data folder.
5. Run the script top-to-bottom.

## Files

- `analysis.R` — full R analysis pipeline.
- `report.md` — managerial report (team-written portion).
- `data/README.md` — data source, citation, and setup instructions.
- `figures/residual_plot.png` — Figure A1 from the appendix (residuals vs. fitted values for Model 1).
- `LICENSE` — MIT.

## Data source

World Happiness Report data, compiled and published as a supplementary file alongside PLOS ONE article [10.1371/journal.pone.0322287](https://doi.org/10.1371/journal.pone.0322287). The data is open access under the Creative Commons Attribution license (CC BY). See `data/README.md` for download and setup steps.
