# Load necessary packages 
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyr,
               dplyr, 
               stats,
               vars, 
               ggplot2,
               readr,
               rio,
               svglite,
               BVAR,
               readxl)

# Load modified `bvar` function
source("R/gio_bvar.R")

# Import data
mon_data <- read_excel("R/mon_data.xlsx")

# Clean column names
names(mon_data) <- c(
  "dates", "eonia", "ip", "hcpi", "cbs", "m1", "eurusd"
)

# Remove "dates" column
data_df <- mon_data |>
  dplyr::select(-dates)

# Estimate using default priors and MH step
x <- bvar(data_df, lags = 12)

# Estimate IRF
irf(x) <- irf(x, horizon = 60, identification = TRUE)

# Plot IRF
plot(irf(x), vars_impulse = c("eonia"))

