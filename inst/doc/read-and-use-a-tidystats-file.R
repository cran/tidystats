## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----example1_eval, eval = FALSE, message = FALSE-----------------------------
#  # Load packages
#  library(tidystats)
#  library(dplyr)
#  
#  # Read in a tidystats-produced .json file
#  results <- read_stats("results.json")
#  
#  # Convert the list to a data frame
#  results_df <- tidy_stats_to_data_frame(results)
#  
#  # Select the p-values
#  p_values <- filter(results_df, statistic == "p")

## ----example1_no_eval, message = FALSE, echo = FALSE--------------------------
library(tidystats)
library(dplyr)
library(knitr)

results <-read_stats(system.file("results.json", package = "tidystats"))
results_df <- tidy_stats_to_data_frame(results)

p_values <- filter(results_df, statistic == "p")

options(knitr.kable.NA = '')

p_values %>%
  select(-extra) %>%
  kable(format = "markdown")

## ----example2_no_eval, eval = FALSE-------------------------------------------
#  sig_p_values <- filter(results_df, statistic == "p" & value < .05)

## ----example2_eval, echo = FALSE----------------------------------------------
sig_p_values <- filter(results_df, statistic == "p" & value < .05)

sig_p_values %>%
  select(-extra) %>%
  kable(format = "markdown")

