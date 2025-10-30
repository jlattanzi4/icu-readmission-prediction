# ============================================================================
# CONFUSION MATRIX HEATMAP
# For Slide 17: Test Set Performance
# XGBoost Final Model on Test Set (n=81,794 patients)
# ============================================================================

library(ggplot2)
library(dplyr)
library(scales)

# Test set confusion matrix values from your analysis
# These are the actual predictions from XGBoost on the held-out test set
confusion_data <- data.frame(
  Predicted = c("No Readmit", "No Readmit", "Readmit", "Readmit"),
  Actual = c("No Readmit", "Readmit", "No Readmit", "Readmit"),
  Count = c(36185, 5018, 27336, 11083),
  stringsAsFactors = FALSE
)

# Add labels for what each cell means
confusion_data$Label <- c(
  "True Negative\n(Correct)",
  "False Negative\n(Missed)",
  "False Positive\n(False Alarm)",
  "True Positive\n(Caught)"
)

# Calculate percentages
total_patients <- sum(confusion_data$Count)
confusion_data$Percentage <- (confusion_data$Count / total_patients) * 100

# Determine if prediction was correct (for coloring)
confusion_data$Correct <- c(TRUE, FALSE, FALSE, TRUE)

# Set factor levels to control order
confusion_data$Predicted <- factor(confusion_data$Predicted,
                                   levels = c("No Readmit", "Readmit"))
confusion_data$Actual <- factor(confusion_data$Actual,
                               levels = c("No Readmit", "Readmit"))

# Create professional confusion matrix heatmap
plot <- ggplot(confusion_data, aes(x = Predicted, y = Actual)) +

  # Add colored tiles
  geom_tile(aes(fill = Correct), color = "white", size = 3, alpha = 0.8) +

  # Add count labels (large, bold)
  geom_text(aes(label = format(Count, big.mark = ",")),
            vjust = -1.5,
            size = 8,
            fontface = "bold",
            color = "gray20") +

  # Add percentage labels
  geom_text(aes(label = sprintf("(%.1f%%)", Percentage)),
            vjust = -0.2,
            size = 5,
            color = "gray40") +

  # Add descriptive labels
  geom_text(aes(label = Label),
            vjust = 2,
            size = 4,
            color = "gray30",
            fontface = "italic") +

  # Color scheme: green for correct, red for errors
  scale_fill_manual(values = c("FALSE" = "#E74C3C", "TRUE" = "#27AE60"),
                    guide = "none") +

  # Labels
  labs(
    title = "Confusion Matrix: XGBoost Test Set Performance",
    subtitle = sprintf("n = %s patients | Test Set (2018-2019)",
                      format(total_patients, big.mark = ",")),
    x = "\nPredicted Class",
    y = "Actual Class\n"
  ) +

  # Professional theme
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 18, hjust = 0.5,
                             margin = margin(b = 5)),
    plot.subtitle = element_text(size = 12, hjust = 0.5, color = "gray40",
                                margin = margin(b = 20)),
    axis.title.x = element_text(size = 14, face = "bold", margin = margin(t = 10)),
    axis.title.y = element_text(size = 14, face = "bold", margin = margin(r = 10)),
    axis.text = element_text(size = 13, face = "bold", color = "gray20"),
    panel.grid = element_blank(),
    plot.margin = margin(20, 20, 20, 20)
  ) +

  # Make it square
  coord_equal()

print(plot)

# Save high-resolution version
ggsave(
  filename = "confusion_matrix_heatmap.png",
  plot = plot,
  width = 10,
  height = 10,
  dpi = 300,
  bg = "white"
)

cat("\n✓ Confusion matrix heatmap saved as 'confusion_matrix_heatmap.png'\n")
cat("  Location: ", getwd(), "\n\n")

# ============================================================================
# ALTERNATIVE VERSION: With performance metrics annotated
# ============================================================================

# Calculate key metrics
TP <- 11083
TN <- 36185
FP <- 27336
FN <- 5018

sensitivity <- TP / (TP + FN)
specificity <- TN / (TN + FP)
ppv <- TP / (TP + FP)
npv <- TN / (TN + FN)
accuracy <- (TP + TN) / (TP + TN + FP + FN)

# Create version with metrics
plot_v2 <- ggplot(confusion_data, aes(x = Predicted, y = Actual)) +

  geom_tile(aes(fill = Correct), color = "white", size = 3, alpha = 0.8) +

  geom_text(aes(label = format(Count, big.mark = ",")),
            vjust = -1.5,
            size = 8,
            fontface = "bold",
            color = "gray20") +

  geom_text(aes(label = sprintf("(%.1f%%)", Percentage)),
            vjust = -0.2,
            size = 5,
            color = "gray40") +

  geom_text(aes(label = Label),
            vjust = 2,
            size = 4,
            color = "gray30",
            fontface = "italic") +

  scale_fill_manual(values = c("FALSE" = "#E74C3C", "TRUE" = "#27AE60"),
                    guide = "none") +

  labs(
    title = "Confusion Matrix: XGBoost Test Set Performance",
    subtitle = sprintf("n = %s | Sens: %.1f%% | Spec: %.1f%% | PPV: %.1f%% | Accuracy: %.1f%%",
                      format(total_patients, big.mark = ","),
                      sensitivity * 100,
                      specificity * 100,
                      ppv * 100,
                      accuracy * 100),
    x = "\nPredicted Class",
    y = "Actual Class\n"
  ) +

  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 18, hjust = 0.5,
                             margin = margin(b = 5)),
    plot.subtitle = element_text(size = 11, hjust = 0.5, color = "gray40",
                                margin = margin(b = 20)),
    axis.title.x = element_text(size = 14, face = "bold", margin = margin(t = 10)),
    axis.title.y = element_text(size = 14, face = "bold", margin = margin(r = 10)),
    axis.text = element_text(size = 13, face = "bold", color = "gray20"),
    panel.grid = element_blank(),
    plot.margin = margin(20, 20, 20, 20)
  ) +

  coord_equal()

print(plot_v2)

ggsave(
  filename = "confusion_matrix_heatmap_v2.png",
  plot = plot_v2,
  width = 10,
  height = 10,
  dpi = 300,
  bg = "white"
)

cat("\n✓ Alternative version saved as 'confusion_matrix_heatmap_v2.png'\n")
cat("  (Version 2 includes performance metrics in subtitle)\n\n")

# ============================================================================
# SUMMARY STATISTICS
# ============================================================================

cat("═══════════════════════════════════════════════════════════\n")
cat("          CONFUSION MATRIX ANALYSIS SUMMARY\n")
cat("═══════════════════════════════════════════════════════════\n\n")

cat(sprintf("Total Patients:           %s\n", format(total_patients, big.mark = ",")))
cat(sprintf("Actual Readmissions:      %s (%.1f%%)\n",
            format(TP + FN, big.mark = ","),
            ((TP + FN) / total_patients) * 100))
cat(sprintf("Actual No Readmissions:   %s (%.1f%%)\n\n",
            format(TN + FP, big.mark = ","),
            ((TN + FP) / total_patients) * 100))

cat("─────────────────────────────────────────────────────────\n")
cat("PREDICTION BREAKDOWN:\n")
cat("─────────────────────────────────────────────────────────\n")
cat(sprintf("True Positives (Caught):    %s (%.1f%%)\n",
            format(TP, big.mark = ","),
            (TP / total_patients) * 100))
cat(sprintf("True Negatives (Correct):   %s (%.1f%%)\n",
            format(TN, big.mark = ","),
            (TN / total_patients) * 100))
cat(sprintf("False Positives (Alarm):    %s (%.1f%%)\n",
            format(FP, big.mark = ","),
            (FP / total_patients) * 100))
cat(sprintf("False Negatives (Missed):   %s (%.1f%%)\n\n",
            format(FN, big.mark = ","),
            (FN / total_patients) * 100))

cat("─────────────────────────────────────────────────────────\n")
cat("PERFORMANCE METRICS:\n")
cat("─────────────────────────────────────────────────────────\n")
cat(sprintf("Sensitivity (Recall):       %.1f%%  (Catches %.1f%% of readmissions)\n",
            sensitivity * 100, sensitivity * 100))
cat(sprintf("Specificity:                %.1f%%  (Correctly IDs %.1f%% who won't readmit)\n",
            specificity * 100, specificity * 100))
cat(sprintf("Positive Predictive Value:  %.1f%%  (%.1f%% of flagged actually readmit)\n",
            ppv * 100, ppv * 100))
cat(sprintf("Negative Predictive Value:  %.1f%%  (%.1f%% of 'low risk' correct)\n",
            npv * 100, npv * 100))
cat(sprintf("Accuracy:                   %.1f%%  (Overall correct predictions)\n",
            accuracy * 100))
cat("─────────────────────────────────────────────────────────\n\n")

cat("CLINICAL INTERPRETATION:\n")
cat("─────────────────────────────────────────────────────────\n")
cat(sprintf("• For every 10 actual readmissions, model catches %d\n",
            round(sensitivity * 10)))
cat(sprintf("• For every 10 flagged patients, %d actually readmit\n",
            round(ppv * 10)))
cat(sprintf("• Model misses %s readmissions (%.1f%% of total readmissions)\n",
            format(FN, big.mark = ","),
            (FN / (TP + FN)) * 100))
cat(sprintf("• Model creates %s false alarms (%.1f%% of predictions)\n",
            format(FP, big.mark = ","),
            (FP / (TP + FP)) * 100))
cat("─────────────────────────────────────────────────────────\n\n")

cat("READY TO USE!\n")
cat("Insert 'confusion_matrix_heatmap.png' into Slide 17\n\n")
