# Load necessary libraries
if (!require('pacman'))
  install.packages('pacman')
pacman::p_load(readxl, ggplot2, scales, lubridate)

# Read the data from the Excel file
hfi <- read_excel("R/mon_fig_hfi.xlsx", sheet = 1)

# Convert the Date column to Date type
hfi[[1]] <- as.Date(hfi[[1]], origin = "1899-12-30")

# Normalize the data
hfidata <- hfi[[2]] / sd(hfi[[2]])
dn <- hfi[[1]]

# Create the data frame for plotting
data <- data.frame(Date = dn, HFI = hfidata)

# Create the base plot
p <- ggplot(data, aes(x = Date, y = HFI)) +
  geom_line(color = "black", size = 0.5) +
  geom_point(shape = 21,
             color = "black",
             fill = "white") +
  geom_point(
    data = data[c(82, 83, 118, 119), ],
    aes(x = Date, y = HFI),
    shape = 21,
    color = "black",
    fill = "blue"
  ) +
  geom_point(
    data = data[c(11, 12, 15, 18, 84, 85, 87, 88, 127, 153, 168), ],
    aes(x = Date, y = HFI),
    shape = 21,
    color = "black",
    fill = rgb(0.75, 0.75, 1)
  )

# Customize the x-axis to show specific years
p <- p + scale_x_date(labels = date_format("%Y"), breaks = as.Date(
  c(
    "2003-01-01",
    "2007-01-01",
    "2011-01-01",
    "2015-01-01",
    "2019-01-01"
  )
))

# Add labels and theme adjustments
p <- p + labs(y = "Change in basis points") +
  theme_minimal()

# Save the plot as a PDF
ggsave(
  "mon_fig_hfi.pdf",
  plot = p,
  device = "pdf",
  width = 15,
  height = 15
)