## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----read-example, eval = FALSE, message = FALSE------------------------------
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

## ----read-example-table, message = FALSE, echo = FALSE------------------------
library(tidystats)
library(dplyr)
library(knitr)

results <- read_stats("../inst/results.json")
results_df <- tidy_stats_to_data_frame(results)

p_values <- filter(results_df, statistic == "p")

options(knitr.kable.NA = '')

p_values %>%
  select(-extra) %>%
  kable(format = "markdown")

