# ============================================================================
# DATA COMPLETENESS HORIZONTAL BAR CHART
# For Slide 10: Data Quality & Completeness
# ============================================================================

library(ggplot2)
library(dplyr)

# Create data frame with completeness percentages
completeness_data <- data.frame(
  Category = c(
    "Admission Data",
    "Demographics",
    "Lab Results",
    "Medications",
    "Diagnoses",
    "Procedures"
  ),
  Completeness = c(100, 99, 96, 92, 85, 73),
  stringsAsFactors = FALSE
)

# Reorder categories by completeness (highest to lowest)
completeness_data <- completeness_data %>%
  mutate(Category = factor(Category, levels = Category[order(Completeness, decreasing = TRUE)]))

# Create professional horizontal bar chart
plot <- ggplot(completeness_data, aes(x = Category, y = Completeness)) +
  # Add bars with gradient color based on completeness
  geom_col(aes(fill = Completeness), width = 0.7, alpha = 0.9) +

  # Add percentage labels on the bars
  geom_text(aes(label = paste0(Completeness, "%")),
            hjust = -0.2,
            size = 5,
            fontface = "bold",
            color = "gray20") +

  # Flip coordinates to make horizontal
  coord_flip() +

  # Color gradient from red (low) to green (high)
  scale_fill_gradient(low = "#E74C3C", high = "#27AE60", guide = "none") +

  # Set y-axis limits to accommodate labels
  scale_y_continuous(limits = c(0, 110), breaks = seq(0, 100, 20)) +

  # Labels and title
  labs(
    title = "Data Completeness by Feature Category",
    subtitle = "Real-World EHR Data Quality (MIMIC-IV)",
    x = NULL,
    y = "Completeness (%)"
  ) +

  # Professional theme
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 18, hjust = 0.5, margin = margin(b = 5)),
    plot.subtitle = element_text(size = 12, hjust = 0.5, color = "gray40", margin = margin(b = 15)),
    axis.text.y = element_text(size = 13, face = "bold", color = "gray20"),
    axis.text.x = element_text(size = 11, color = "gray40"),
    axis.title.x = element_text(size = 12, face = "bold", margin = margin(t = 10)),
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_line(color = "gray80", size = 0.3),
    plot.margin = margin(20, 20, 20, 20)
  )

# Display the plot
print(plot)

# Save as high-resolution PNG for presentation
ggsave(
  filename = "data_completeness_chart.png",
  plot = plot,
  width = 10,
  height = 6,
  dpi = 300,
  bg = "white"
)

cat("\n✓ Chart saved as 'data_completeness_chart.png'\n")
cat("  Location: ", getwd(), "\n\n")

# ============================================================================
# ALTERNATIVE VERSION: With color-coded zones
# ============================================================================

# Create version 2 with color zones
plot_v2 <- ggplot(completeness_data, aes(x = Category, y = Completeness)) +

  # Add colored bars based on quality zones
  geom_col(aes(fill = cut(Completeness,
                           breaks = c(0, 70, 85, 95, 100),
                           labels = c("Poor", "Fair", "Good", "Excellent"))),
           width = 0.7, alpha = 0.85) +

  # Add percentage labels
  geom_text(aes(label = paste0(Completeness, "%")),
            hjust = -0.2,
            size = 5,
            fontface = "bold",
            color = "gray20") +

  coord_flip() +

  # Manual colors for quality zones
  scale_fill_manual(
    values = c("Poor" = "#E74C3C",
               "Fair" = "#F39C12",
               "Good" = "#3498DB",
               "Excellent" = "#27AE60"),
    name = "Data Quality",
    drop = FALSE
  ) +

  scale_y_continuous(limits = c(0, 110), breaks = seq(0, 100, 20)) +

  labs(
    title = "Data Completeness by Feature Category",
    subtitle = "Quality Assessment: MIMIC-IV Dataset",
    x = NULL,
    y = "Completeness (%)"
  ) +

  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 18, hjust = 0.5, margin = margin(b = 5)),
    plot.subtitle = element_text(size = 12, hjust = 0.5, color = "gray40", margin = margin(b = 15)),
    axis.text.y = element_text(size = 13, face = "bold", color = "gray20"),
    axis.text.x = element_text(size = 11, color = "gray40"),
    axis.title.x = element_text(size = 12, face = "bold", margin = margin(t = 10)),
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_line(color = "gray80", size = 0.3),
    legend.position = "bottom",
    legend.title = element_text(face = "bold", size = 11),
    legend.text = element_text(size = 10),
    plot.margin = margin(20, 20, 20, 20)
  )

print(plot_v2)

# Save alternative version
ggsave(
  filename = "data_completeness_chart_v2.png",
  plot = plot_v2,
  width = 10,
  height = 6,
  dpi = 300,
  bg = "white"
)

cat("\n✓ Alternative version saved as 'data_completeness_chart_v2.png'\n")
cat("  (Version 2 includes color-coded quality zones)\n\n")

# ============================================================================
# SUMMARY STATISTICS
# ============================================================================

cat("DATA COMPLETENESS SUMMARY:\n")
cat("─────────────────────────────────────────\n")
cat(sprintf("Average completeness: %.1f%%\n", mean(completeness_data$Completeness)))
cat(sprintf("Median completeness:  %.1f%%\n", median(completeness_data$Completeness)))
cat(sprintf("Range: %.0f%% - %.0f%%\n", min(completeness_data$Completeness), max(completeness_data$Completeness)))
cat("\nCategories ≥95%% (Excellent): ", sum(completeness_data$Completeness >= 95), "\n")
cat("Categories 85-94%% (Good):    ", sum(completeness_data$Completeness >= 85 & completeness_data$Completeness < 95), "\n")
cat("Categories <85%% (Fair):      ", sum(completeness_data$Completeness < 85), "\n")
cat("─────────────────────────────────────────\n\n")

# ============================================================================
# QUICK REFERENCE TABLE
# ============================================================================

cat("\nQUICK REFERENCE TABLE FOR SLIDE:\n")
cat("═══════════════════════════════════════════\n")
for(i in 1:nrow(completeness_data)) {
  cat(sprintf("%-20s %3d%%\n",
              completeness_data$Category[i],
              completeness_data$Completeness[i]))
}
cat("═══════════════════════════════════════════\n\n")

cat("READY TO USE!\n")
cat("Insert 'data_completeness_chart.png' into Slide 10\n\n")
