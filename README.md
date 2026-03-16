# Crypto Trader Behavior & Sentiment Analysis

This project analyzes the relationship between market sentiment (Fear & Greed Index) and individual trader performance metrics, including PnL, leverage risk, and trade frequency.

## 🚀 Prerequisites

To run this analysis, you need R installed. Using RStudio is recommended for viewing the visualizations and data frames.
Required R Packages

Run the following command in your R console to install the necessary libraries:

```rinstall.packages(c("tidyverse", "lubridate", "ggplot2", "dplyr"))```

## 📂 Dataset Setup

The script requires two CSV files. 

*Ensure these are saved on your local machine:

fear_greed_index.csv: Daily market sentiment scores.

historical_data.csv: Individual trade-level data.

**[!IMPORTANT]**
Update File Paths: > Update lines 7 and 8 of the script to match your local directory:

```rfear_greed_df <- read.csv("C:/YOUR_PATH/fear_greed_index.csv")```

```rhist_data_df <- read.csv("C:/YOUR_PATH/historical_data.csv")```

## 🛠️ Analysis Workflow

**Part A: Data Health:**

* Loads datasets and performs a check for missing values or duplicates.

**Part B: Feature Engineering:**

Aligns timestamps across datasets.

* Calculates Win Rate, L/S Ratio, and PnL Volatility.

* Segments traders into Frequent/Infrequent and High/Low Leverage (using the 75th percentile cutoff).

**Part C: Visualization:**

Generates insights on PnL distribution, risk signatures (Size vs. Volatility), and sentiment-based trade frequency.

## 📊 How to Run

* Open the .R script in RStudio.

* Adjust the file paths mentioned in the Dataset Setup.

* Select all code (Ctrl+A) and click Run.

The final processed data can be viewed via View(aligned_data).


## 🔍 Segmentation Logic

Frequent Traders: Accounts with trade counts above the median.

High Leverage/Risk: Traders in the top 25% for either Average Trade Size or PnL Volatility.

Winners: Traders with a positive total PnL for the analyzed period.
