## ---- include = FALSE---------------------------------------------------------
library(knitr)

opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

options(digits = 3)

## ----setup, message = FALSE---------------------------------------------------
# Load packages
library(tidystats)
library(dplyr)

# Load data
data <- tidystats::quote_source

## ----descriptives, eval = FALSE-----------------------------------------------
#  descriptives <- data %>%
#    group_by(source) %>%
#    describe_data(response, short = TRUE)
#  descriptives

## ----descriptives-real, echo = FALSE------------------------------------------
data %>%
  group_by(source) %>%
  describe_data(response, short = TRUE) %>%
  kable()

## ----t-test-------------------------------------------------------------------
t_test <- t.test(response ~ source, data = data)
t_test

## ----regression1--------------------------------------------------------------
lm1 <- lm(response ~ source * us_or_international, data = data)
summary(lm1)

## ----regression2--------------------------------------------------------------
lm2 <- lm(response ~ source * age, data = data)
summary(lm2)

## ----tidystats-example--------------------------------------------------------
# Create an empty list to store the analyses in
results <- list()

# Add the analyses
results <- results %>%
  add_stats(t_test, preregistered = TRUE, type = "primary", 
    notes = "A t-test comparing the effect of source on the quote rating.") %>%
  add_stats(lm1, preregistered = FALSE, type = "exploratory", 
    notes = "Interaction effect with being from the U.S. or not.") %>%
  add_stats(lm2)

## ----saving, eval = FALSE-----------------------------------------------------
#  write_stats(results, "lorge-curtiss-1936-replication.json")

