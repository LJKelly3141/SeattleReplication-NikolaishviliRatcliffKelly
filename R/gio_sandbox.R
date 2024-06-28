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
  dplyr::select(-c(dates)) #### Change this back to just `-c(dates)`

# Estimate using default priors and MH step
x <- bvar(data_df, 
          lags = 12, 
          n_draw = 5000L, 
          n_burn = 2000L, 
          priors = bv_priors(hyper = "alpha", 
                             mn = bv_mn(alpha = bv_alpha(mode = 0.5, 
                                                         sd = 1, 
                                                         min = 1e-12, 
                                                         max = 10), 
                                        var = 1e6)),
          mh = bv_mh(adjust_acc = TRUE, 
                     acc_lower = 0.2, 
                     acc_upper = 0.4))

# Estimate IRF
irf(x) <- irf(x, horizon = 60, identification = TRUE)

# Plot IRF
plot(irf(x), vars_impulse = c("eonia"))


### 
# AR hyperparameter is 1
# Others 0 
# Crosslags -- 0.5 0.1
# variance = 100
