# World Happiness — Econometric Analysis
# Group project, ECON 339 Econometrics with R, Cal Poly San Luis Obispo
#
# Models the national Happiness Score (0-10 scale) as a function of six
# structural variables across 467 country-year observations from
# 2020, 2023, and 2024.
#
# Required packages: readxl, lmtest, sandwich, car
# Data: World Happiness Report supplementary file from PLOS ONE article
#       10.1371/journal.pone.0322287 (see data/README.md for setup steps)

options(scipen=999)
library(readxl)

# IMPORTANT: update this path to wherever the data file lives on your machine
setwd("/Users/matiasjohnston/Downloads/Econ 339")

# --- Import + clean -------------------------------------------------------
# Reads the Combined sheet (2020, 2023, and 2024 stacked, with a Year column
# added — see data/README.md). Drops rows with any NA, then drops rows where
# Score exceeds 10 as a sanity check.
myData <- read_excel("pone_0322287_s001.xlsx", sheet = "Combined")
myData <- na.omit(myData)
myData <- myData[myData$Score <= 10,]

# --- Descriptive statistics -----------------------------------------------
# Means of numeric variables (Score + 6 predictors)
colMeans(myData[,c(3:9)])

# Correlation matrix (Appendix Table A2)
cor(myData[,3:9])

# --- Model 1: linear OLS --------------------------------------------------
Model1 <- lm(Score ~ GDP + Social_Support + Life_Expectancy + Freedom + Generosity + Corruption, data = myData)
summary(Model1)

# --- Model 2: log-Y specification ----------------------------------------
Model2 <- lm(log(Score) ~ GDP + Social_Support + Life_Expectancy + Freedom + Generosity + Corruption, data = myData)
summary(Model2)

# Cross-scale R-squared on original scale (smearing correction)
Pred_lnY <- predict(Model2)
se2 <- sigma(Model2)
Pred_Y <- exp(Pred_lnY + se2^2/2)
cor(myData$Score, Pred_Y)^2

# --- Model 3: Model 1 + year dummies (2024 as reference) ------------------
myData$Y2020 <- ifelse(myData$Year == 2020, 1, 0)
myData$Y2023 <- ifelse(myData$Year == 2023, 1, 0)
Model3 <- lm(Score ~ GDP + Social_Support + Life_Expectancy + Freedom + Generosity + Corruption + Y2020 + Y2023, data = myData)
summary(Model3)

# Partial F-test: are the year dummies jointly significant?
anova(Model1, Model3)

# --- Model comparison: Adjusted R-squared and AIC -------------------------
cat("Model 1 - Adj R-squared:", summary(Model1)$adj.r.squared, "\n")
cat("Model 2 - Adj R-squared:", summary(Model2)$adj.r.squared, "\n")
cat("Model 3 - Adj R-squared:", summary(Model3)$adj.r.squared, "\n")
cat("Model 1 AIC:", AIC(Model1), "\n")
cat("Model 2 AIC:", AIC(Model2), "\n")
cat("Model 3 AIC:", AIC(Model3), "\n")

# --- Inference on Model 1 -------------------------------------------------
# 95% confidence intervals for each coefficient
confint(Model1, level = 0.95)

# Single-row prediction at a hypothetical country profile
predict(Model1, data.frame(GDP=1.30, Social_Support=1.45, Life_Expectancy=0.95, Freedom=0.55, Generosity=0.20, Corruption=0.25))

# --- Diagnostics: residual plot (Figure A1) -------------------------------
Residuals <- resid(Model1)
yHat <- predict(Model1)

# Show interactively
plot(yHat, Residuals, xlab="y-hat", ylab="e", col="blue")
abline(h=0, col = "red")

# Also save to figures/residual_plot.png for the report
if (!dir.exists("figures")) dir.create("figures")
png("figures/residual_plot.png", width = 800, height = 500, res = 100)
plot(yHat, Residuals, xlab="y-hat", ylab="e", col="blue",
     main="Figure A1: Residuals vs. fitted values for Model 1")
abline(h=0, col = "red")
dev.off()

# --- Diagnostics: heteroskedasticity --------------------------------------
# Breusch-Pagan test (low p-value -> reject homoskedasticity)
library(lmtest)
bptest(Model1)

# Robust standard errors (White's HC1 estimator)
library(sandwich)
coeftest(Model1, vcov = vcovHC(Model1, type = "HC1"))

# --- Diagnostics: multicollinearity ---------------------------------------
# Variance Inflation Factors (rule of thumb: VIF > 5 is concerning)
library(car)
vif(Model1)
