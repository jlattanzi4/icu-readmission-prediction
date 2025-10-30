# ============================================================================
# ROI COMPARISON BAR CHART
# For Slide 20: Business Impact - Return on Investment
# Comparing Net Benefit by Hospital Size
# ============================================================================

library(ggplot2)
library(scales)

# ROI data from Capstone_Analysis_FINAL.html
roi_data <- data.frame(
  hospital_type = c("Small Community\n(5,000 discharges)",
                    "Medium Regional\n(15,000 discharges)",
                    "Large Academic\n(30,000 discharges)"),
  annual_discharges = c(5000, 15000, 30000),
  readmissions_prevented = c(150, 450, 900),
  cost_savings = c(3900000, 11700000, 23400000),
  intervention_cost = c(1150000, 3150000, 6150000),
  net_benefit = c(2750000, 8550000, 17250000),
  roi_percent = c(239.1, 271.4, 280.5),
  stringsAsFactors = FALSE
)

# Set factor levels to control order
roi_data$hospital_type <- factor(roi_data$hospital_type,
                                  levels = roi_data$hospital_type)

# Create professional bar chart
plot <- ggplot(roi_data, aes(x = hospital_type, y = net_benefit, fill = hospital_type)) +

  # Add bars
  geom_bar(stat = "identity", width = 0.7, alpha = 0.9) +

  # Add value labels on bars
  geom_text(aes(label = paste0("$", format(net_benefit / 1000000, nsmall = 2), "M\n",
                               roi_percent, "% ROI")),
            vjust = -0.5,
            size = 5,
            fontface = "bold",
            color = "gray20") +

  # Color scheme
  scale_fill_manual(values = c("Small Community\n(5,000 discharges)" = "#3498db",
                               "Medium Regional\n(15,000 discharges)" = "#2ecc71",
                               "Large Academic\n(30,000 discharges)" = "#e74c3c")) +

  # Format y-axis as dollars in millions
  scale_y_continuous(labels = dollar_format(scale = 1e-6, suffix = "M"),
                     limits = c(0, max(roi_data$net_benefit) * 1.15),
                     expand = c(0, 0)) +

  # Labels
  labs(
    title = "Annual Net Benefit by Hospital Size",
    subtitle = "Using Test Set PPV (29.8%) and 25% Intervention Effectiveness",
    x = "\nHospital Type",
    y = "Net Annual Benefit\n",
    caption = "Assumes $26,000 average readmission cost and $500 intervention cost per patient"
  ) +

  # Professional theme
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 18, hjust = 0.5,
                             margin = margin(b = 5)),
    plot.subtitle = element_text(size = 12, hjust = 0.5, color = "gray40",
                                margin = margin(b = 20)),
    plot.caption = element_text(size = 10, color = "gray50", hjust = 0.5,
                               margin = margin(t = 15)),
    axis.title.x = element_text(size = 14, face = "bold", margin = margin(t = 10)),
    axis.title.y = element_text(size = 14, face = "bold", margin = margin(r = 10)),
    axis.text.x = element_text(size = 12, face = "bold", color = "gray20"),
    axis.text.y = element_text(size = 11, color = "gray30"),
    legend.position = "none",
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    plot.margin = margin(20, 20, 20, 20)
  )

print(plot)

# Save high-resolution version
ggsave(
  filename = "roi_comparison_chart.png",
  plot = plot,
  width = 12,
  height = 8,
  dpi = 300,
  bg = "white"
)

cat("\n✓ ROI comparison chart saved as 'roi_comparison_chart.png'\n")
cat("  Location: ", getwd(), "\n\n")

# ============================================================================
# ALTERNATIVE VERSION: Stacked bar showing costs vs savings
# ============================================================================

# Reshape data for stacked format
roi_stacked <- data.frame(
  hospital_type = rep(roi_data$hospital_type, 2),
  category = rep(c("Intervention Cost", "Net Benefit"), each = 3),
  amount = c(roi_data$intervention_cost, roi_data$net_benefit),
  stringsAsFactors = FALSE
)

roi_stacked$hospital_type <- factor(roi_stacked$hospital_type,
                                     levels = unique(roi_data$hospital_type))
roi_stacked$category <- factor(roi_stacked$category,
                               levels = c("Net Benefit", "Intervention Cost"))

plot_v2 <- ggplot(roi_stacked, aes(x = hospital_type, y = amount, fill = category)) +

  geom_bar(stat = "identity", width = 0.7, alpha = 0.9) +

  # Add total savings labels
  geom_text(data = roi_data,
            aes(x = hospital_type, y = cost_savings, label = paste0("$", format(cost_savings / 1000000, nsmall = 1), "M savings"),
                fill = NULL),
            vjust = -0.5,
            size = 4.5,
            fontface = "bold",
            color = "gray20") +

  scale_fill_manual(values = c("Intervention Cost" = "#e67e22",
                               "Net Benefit" = "#27ae60"),
                    name = "") +

  scale_y_continuous(labels = dollar_format(scale = 1e-6, suffix = "M"),
                     limits = c(0, max(roi_data$cost_savings) * 1.15),
                     expand = c(0, 0)) +

  labs(
    title = "Cost-Benefit Analysis by Hospital Size",
    subtitle = "Intervention Costs vs. Net Benefit (Total Height = Gross Savings)",
    x = "\nHospital Type",
    y = "Annual Amount ($)\n",
    caption = "Green = money kept after intervention costs | Orange = investment required"
  ) +

  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 18, hjust = 0.5,
                             margin = margin(b = 5)),
    plot.subtitle = element_text(size = 12, hjust = 0.5, color = "gray40",
                                margin = margin(b = 20)),
    plot.caption = element_text(size = 10, color = "gray50", hjust = 0.5,
                               margin = margin(t = 15)),
    axis.title.x = element_text(size = 14, face = "bold", margin = margin(t = 10)),
    axis.title.y = element_text(size = 14, face = "bold", margin = margin(r = 10)),
    axis.text.x = element_text(size = 12, face = "bold", color = "gray20"),
    axis.text.y = element_text(size = 11, color = "gray30"),
    legend.position = "top",
    legend.text = element_text(size = 12),
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    plot.margin = margin(20, 20, 20, 20)
  )

print(plot_v2)

ggsave(
  filename = "roi_comparison_stacked.png",
  plot = plot_v2,
  width = 12,
  height = 8,
  dpi = 300,
  bg = "white"
)

cat("\n✓ Alternative stacked version saved as 'roi_comparison_stacked.png'\n")
cat("  (Shows intervention cost vs net benefit)\n\n")

# ============================================================================
# SUMMARY STATISTICS
# ============================================================================

cat("═══════════════════════════════════════════════════════════\n")
cat("          ROI COMPARISON SUMMARY\n")
cat("═══════════════════════════════════════════════════════════\n\n")

for(i in 1:nrow(roi_data)) {
  cat(sprintf("%s:\n", gsub("\n", " ", roi_data$hospital_type[i])))
  cat(sprintf("  Annual Discharges:       %s\n", format(roi_data$annual_discharges[i], big.mark = ",")))
  cat(sprintf("  Readmissions Prevented:  %s\n", format(roi_data$readmissions_prevented[i], big.mark = ",")))
  cat(sprintf("  Intervention Cost:       $%s\n", format(roi_data$intervention_cost[i], big.mark = ",")))
  cat(sprintf("  Gross Savings:           $%s\n", format(roi_data$cost_savings[i], big.mark = ",")))
  cat(sprintf("  Net Benefit:             $%s\n", format(roi_data$net_benefit[i], big.mark = ",")))
  cat(sprintf("  ROI:                     %.1f%%\n\n", roi_data$roi_percent[i]))
}

cat("KEY INSIGHT:\n")
cat("ROI increases with hospital size (239% → 271% → 281%)\n")
cat("Larger hospitals achieve better economies of scale\n")
cat("All hospital sizes show substantial positive returns\n\n")

cat("READY TO USE!\n")
cat("Insert 'roi_comparison_chart.png' into Slide 20\n")
cat("Or use 'roi_comparison_stacked.png' for cost breakdown view\n\n")
