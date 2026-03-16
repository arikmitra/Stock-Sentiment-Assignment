## Part-A

#1

#loading the datasets
fear_greed_df <- read.csv("D:/intern/fear_greed_index.csv")
hist_data_df <- read.csv("D:/intern/historical_data.csv")

#documenting rows and columns
cat("FGI Dimensions:", dim(fear_greed_df), "\n")
cat("Hist Dimensions:", dim(hist_data_df), "\n")

#missing values
cat("FGI Missing:", sum(is.na(fear_greed_df)), "\n")
cat("Hist Missing:", sum(is.na(hist_data_df)), "\n")

# duplicated entries
cat("FGI Duplicate:", sum(duplicated(fear_greed_df)), "\n")
cat("Hist Duplicate:", sum(duplicated(hist_data_df)), "\n")

## There are no missing values and duplicate entries in the data


#2

# Loading all necessary libraries for calculations etc

library(tidyverse)
library(lubridate)
library(ggplot2)
library(dplyr)

#Converting the time stamps

hist_data_df$date <- as.Date(hist_data_df$Timestamp.IST, format = "%d-%m-%Y")
fear_greed_df$date <- as.Date(fear_greed_df$date)

#3 and Part-B

# Arranging data to daily level per account and
# calculating daily PnL per trader, ls ratio, win rate, average trade size,
# number of trades/day

# Segments also added: Frequent vs Infrequent traders, winners vs losers, 
# high vs low leverage

daily_metrics <- hist_data_df %>%
  group_by(date, Account) %>%
  summarize(
    total_pnl_per_trader = sum(Closed.PnL, na.rm = TRUE), #used for trader segmenting
    pnl_volatility = sd(Closed.PnL, na.rm = TRUE), # needed for leverage
    pnl_volatility = ifelse(is.na(pnl_volatility),0,pnl_volatility),
    num_trades = n(),
    total_trades = sum(num_trades), # needed for account segmenting
    avg_trade_size = mean(Size.USD, na.rm = TRUE),
    win_rate = sum(Closed.PnL > 0) / sum(Closed.PnL != 0),
    long_count = sum(Side == "BUY"),
    short_count = sum(Side == "SELL"),
    long_short_ratio = long_count / (long_count + short_count), # ls ratio
    .groups = "drop"
  ) %>%
  mutate(
    win_rate = ifelse(is.nan(win_rate), 0, win_rate), # win rate handling of NaNs
    segment = ifelse(total_trades >= median(total_trades), "Frequent", "Infrequent"), #frequent vs infrequent traders
    segment_pnl = ifelse(total_pnl_per_trader > 0, "Winner", "Loser"), #consistent winners vs inconsistent traders
    )

size_cutoff <- quantile(daily_metrics$avg_trade_size, 0.75, na.rm = TRUE)
vol_cutoff <- quantile(daily_metrics$pnl_volatility, 0.75, na.rm = TRUE)# Setting cutoffs for High and Low leverage

leverage_metrics <- daily_metrics %>%
mutate(leverage_segment = ifelse(avg_trade_size > size_cutoff | pnl_volatility > vol_cutoff, 
                          "High Leverage/Risk", 
                          "Low Leverage/Risk") #high vs low leverage
)

#merging the data by date
aligned_data <- inner_join(leverage_metrics, fear_greed_df, by = "date")

View(aligned_data)

## Part-C

# Leverage distribution

leverage_dist <- leverage_metrics %>%
  group_by(leverage_segment) %>%
  summarise(
    count = n(),
    percentage = n() / nrow(leverage_metrics) * 100
  )


## Visualizations

# Insight 1: PnL by Sentiment Category

ggplot(aligned_data, aes(x = classification, y = total_pnl_per_trader, fill = classification)) +
  geom_boxplot(outlier.alpha = 0.1) +
  coord_cartesian(ylim = c(-5000, 15000)) +
  theme_minimal() +
  labs(title = "Daily PnL Distribution vs. Market Sentiment", y = "PnL (USD)")


# Insight 2: Trade Frequency

ggplot(aligned_data, aes(x = classification, y = total_trades, fill = classification)) +
  geom_bar(stat = "summary", fun = "mean") +
  theme_minimal() +
  labs(title = "Avg. Trade Frequency per Sentiment Type", y = "Trades per Day")


# Insight 3: Size vs Volatility

ggplot(leverage_metrics, aes(x = avg_trade_size, y = pnl_volatility, color = leverage_segment)) +
  geom_point(alpha = 0.6) +
  scale_x_log10() + # Log scale for better visibility of whale traders
  scale_y_log10() +
  labs(title = "Trader Risk Signature: Size vs. Volatility",
       subtitle = "High Leverage traders cluster in the top-right (High Size, High Risk)",
       x = "Average Trade Size (USD - Log Scale)",
       y = "PnL Volatility (Std Dev - Log Scale)") +
  scale_color_manual(values = c("High Leverage/Risk" = "red", "Low Leverage/Risk" = "blue"))



# Insight 4: Leverage Distribution

ggplot(leverage_dist, aes(x = leverage_segment, y = percentage, fill = leverage_segment)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = paste0(round(percentage, 1), "%")), vjust = -0.5) +
  theme_minimal() +
  labs(title = "Trader Leverage Distribution",
       subtitle = "High Leverage defined as Top 25% in Size or PnL Volatility",
       x = "Segment",
       y = "Percentage of Traders (%)") +
  scale_color_manual(values = c("High Leverage" = "maroon", "Low Leverage" = "lightblue"))

#--------------------------------------------------------------------------------------------

