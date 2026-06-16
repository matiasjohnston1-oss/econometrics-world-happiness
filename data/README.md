# Data

The data used in this analysis is the World Happiness Report supplementary file from a PLOS ONE article.

## Source

- **Article:** PLOS ONE, DOI [10.1371/journal.pone.0322287](https://doi.org/10.1371/journal.pone.0322287)
- **Supplementary file:** `pone_0322287_s001.xlsx`

The Excel file contains separate sheets for the years 2020 through 2024.

## Setup

This analysis uses combined data from **2020, 2023, and 2024**. The 2021 and 2022 sheets use a different methodology and column structure (e.g., a "Family" composite rather than "Social Support," "Trust" rather than "Perceptions of Corruption"), so they were excluded to keep the cross-year comparisons consistent.

To reproduce:

1. Download `pone_0322287_s001.xlsx` from the article linked above.
2. In Excel, create a new sheet named `Combined`.
3. Stack the data from the **2020, 2023, and 2024** sheets into the `Combined` sheet with the following column order:

   `Rank | Country | Score | GDP | Social_Support | Life_Expectancy | Freedom | Generosity | Corruption | Year`

4. Fill the `Year` column with the source-sheet year for each row.
5. Save the workbook.

The script `analysis.R` reads `pone_0322287_s001.xlsx`, sheet `Combined`, expecting the column structure above.

## Variables

| Column | Description |
|---|---|
| `Score` | National Happiness Score (0-10 scale, dependent variable) |
| `GDP` | GDP per capita index |
| `Social_Support` | Index for perceived social support |
| `Life_Expectancy` | Healthy life expectancy index |
| `Freedom` | Index for freedom to make life choices |
| `Generosity` | Index for charitable giving |
| `Corruption` | Perceptions of corruption — **note: inversely coded**, so higher values indicate *less* perceived corruption |
| `Year` | Calendar year of the observation (2020, 2023, or 2024) |

## Data license

Per PLOS ONE's open access policy, the supplementary data is published under the Creative Commons Attribution license (CC BY 4.0).
