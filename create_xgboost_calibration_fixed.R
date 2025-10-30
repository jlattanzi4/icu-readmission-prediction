# ============================================================================
# FIXED XGBOOST CALIBRATION CURVE
# For Slide 22 (formerly 23): Model Calibration
# CORRECTED to show full Y-axis range (was limited to 0-0.6)
# ============================================================================
#
# INSTRUCTIONS:
# 1. Run your main analysis (Capstone_Analysis_FINAL.Rmd) first to generate xgb_calib
# 2. Then source this script to create the fixed calibration plot
# 3. Use the output file xgboost_calibration_FIXED.png for your presentation
#
# ============================================================================

library(ggplot2)

cat("Creating fixed XGBoost calibration plot...\n")

# Check if xgb_calib exists
if (!exists("xgb_calib")) {
  stop("ERROR: xgb_calib not found!\n",
       "Please run Capstone_Analysis_FINAL.Rmd first to generate the calibration data.")
}

# Get the maximum values to set proper axis limits
max_pred <- max(xgb_calib$calib_df$predicted_rate, na.rm = TRUE)
max_obs <- max(xgb_calib$calib_df$observed_rate, na.rm = TRUE)
max_upper <- max(xgb_calib$calib_df$upper_ci, na.rm = TRUE)

# Use the maximum of all values to ensure everything is visible
axis_max <- max(c(max_pred, max_obs, max_upper))

cat(sprintf("Data range: Predicted up to %.3f, Observed up to %.3f\n", max_pred, max_obs))
cat(sprintf("Setting axis limits to 0 - %.2f (with padding)\n", axis_max + 0.05))

# Create the fixed reliability diagram
# KEY FIX: Changed xlim and ylim from c(0, 0.6) to show FULL data range
calibration_plot <- ggplot(xgb_calib$calib_df,
                           aes(x = predicted_rate,
                               y = observed_rate)) +

  # Perfect calibration diagonal line (red dashed)
  geom_abline(intercept = 0, slope = 1,
              linetype = 'dashed', color = 'red', size = 1.2) +

  # Calibration error segments (gray vertical lines)
  geom_segment(aes(x = predicted_rate, xend = predicted_rate,
                   y = predicted_rate, yend = observed_rate),
               color = 'gray60', alpha = 0.5) +

  # 95% confidence interval ribbon
  geom_ribbon(aes(ymin = lower_ci, ymax = upper_ci),
              alpha = 0.3, fill = 'purple') +

  # Calibration curve line
  geom_line(color = 'purple', size = 1.5) +

  # Points sized by number of patients in each bin
  geom_point(aes(size = n), color = 'purple', alpha = 0.8) +

  # CRITICAL FIX: Show FULL range instead of limiting to 0.6
  # Old: coord_fixed(ratio = 1, xlim = c(0, 0.6), ylim = c(0, 0.6))
  # New: Use actual data range
  coord_fixed(ratio = 1,
              xlim = c(0, axis_max + 0.05),
              ylim = c(0, axis_max + 0.05)) +

  # Point size scale
  scale_size_continuous(range = c(3, 10), name = 'Patients\nin Bin') +

  # "Perfect Calibration" annotation
  annotate('text', x = 0.45, y = 0.05,
           label = 'Perfect Calibration',
           color = 'red', angle = 45, size = 4) +

  # Labels
  labs(title = 'XGBoost Reliability Diagram',
       subtitle = 'Assessing Prediction Accuracy Across Risk Levels',
       x = 'Predicted Readmission Probability',
       y = 'Observed Readmission Rate',
       caption = 'Gray lines show calibration error | Shaded area = 95% CI') +

  # Theme
  theme_minimal(base_size = 14) +
  theme(plot.title = element_text(hjust = 0.5, face = 'bold', size = 16),
        plot.subtitle = element_text(hjust = 0.5, size = 12),
        legend.position = 'right',
        plot.caption = element_text(hjust = 0, size = 10, color = 'gray40'),
        panel.grid.minor = element_blank())

print(calibration_plot)

# Save high-resolution version
ggsave(
  filename = "xgboost_calibration_FIXED.png",
  plot = calibration_plot,
  width = 10,
  height = 7,
  dpi = 300,
  bg = "white"
)

cat("\n✓ SUCCESS! Fixed XGBoost calibration plot saved as 'xgboost_calibration_FIXED.png'\n\n")

cat("WHAT WAS FIXED:\n")
cat("===============\n")
cat(sprintf("• Original plot: Limited to 0-0.6 range (cut off at y=0.6)\n"))
cat(sprintf("• Fixed plot: Shows full range 0-%.2f (displays all calibration data)\n", axis_max + 0.05))
cat("• Now you can see model calibration across ALL risk levels\n")
cat("• High-risk patients (>60% predicted probability) are now visible\n\n")

cat("This plot is ready for Slide 22 (Model Calibration)!\n")
