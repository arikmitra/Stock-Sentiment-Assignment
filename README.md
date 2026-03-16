Crypto Trader Behavior & Sentiment Analysis
This project analyzes the relationship between market sentiment (Fear & Greed Index) and individual trader performance metrics, including PnL, leverage risk, and trade frequency.

1. Prerequisites
To run this analysis, you need to have R installed on your system. Using RStudio is highly recommended for viewing the visualizations and data frames.

Required R Packages
The script utilizes the tidyverse ecosystem. You can install all necessary libraries by running the following command in your R console:

R
install.packages(c("tidyverse", "lubridate", "ggplot2", "dplyr"))
2. Dataset Setup
The script expects two specific CSV files. Ensure these are saved on your local machine:

fear_greed_index.csv: Contains daily market sentiment scores and classifications (e.g., Greed, Fear).

historical_data.csv: Contains trade-level data including Account, Timestamp.IST, Closed.PnL, Size.USD, and Side.

[!IMPORTANT]
Update File Paths: > Before running the script, update lines 7 and 8 to match the directory where you saved your files:

R
fear_greed_df <- read.csv("C:/YOUR_PATH/fear_greed_index.csv")
hist_data_df <- read.csv("C:/YOUR_PATH/historical_data.csv")
3. Analysis Workflow
The analysis is divided into three primary parts:

Part A: Data Cleaning: Loads datasets, checks for dimensions, and identifies missing or duplicate values.

Part B: Feature Engineering:

Converts timestamps to date objects.

Aggregates data to a daily per-account level.

Calculates Win Rate, L/S Ratio, and PnL Volatility.

Segments traders into Frequent vs. Infrequent and High vs. Low Leverage (based on the 75th percentile of trade size and volatility).

Part C: Visualization: Generates four key insights:

PnL distribution across sentiment categories.

Average trade frequency per sentiment type.

Trader Risk Signatures (Size vs. Volatility).

Overall leverage distribution across the user base.

4. How to Run
Open the .R script in RStudio.

Ensure the working directory or file paths are correct.

Select all code (Ctrl+A) and click Run.

View the aggregated data using View(aligned_data) and check the Plots pane for the visualizations.

5. Segmentation Logic
The analysis uses the following logic for trader segmentation:

Frequent Traders: Accounts with trade counts above the median.

High Leverage/Risk: Traders in the top 25% for either Average Trade Size or PnL Volatility.

Winners: Traders with a positive total PnL for the period.
