library(ggplot2)

# User defined settings
customTheme = theme_minimal() +
  # Background and grid lines
  theme(
    panel.background = element_rect(fill = "transparent", colour = NA), # Transparent panel
    plot.background = element_rect(fill = "transparent", colour = NA),  # Transparent plot
    panel.grid.major = element_line(colour = "lightgrey", linewidth = 0.2),  # Remove major grid lines
    panel.grid.minor = element_blank(),  # Remove minor grid lines
    axis.line  = element_line(colour = "black"),  # Add visible axis lines
    # axis.text  = element_text(color = "black"),   # Ensure axis text is visible
    # axis.title = element_text(color = "black")   # Ensure axis titles are visible
    ) +
  # legend
  theme(
    legend.position = "bottom"
    )

# Apply the settings
theme_set(customTheme)