% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tidy_stats_to_data_frame.R
\name{tidy_stats_to_data_frame}
\alias{tidy_stats_to_data_frame}
\title{Convert a tidystats list to a data frame}
\usage{
tidy_stats_to_data_frame(x)
}
\arguments{
\item{x}{A tidystats list.}
}
\description{
\code{tidy_stats_to_data_frame} converts a tidystats list to a data frame, 
which can then be used to extract specific statistics using standard
subsetting functions (e.g., \code{dplyr::filter}).
}
\examples{
# Load dplyr for access to the piping operator
library(dplyr)
  
# t-test:
sleep_test <- t.test(extra ~ group, data = sleep, paired = TRUE)

# lm:
ctl <- c(4.17, 5.58, 5.18, 6.11, 4.50, 4.61, 5.17, 4.53, 5.33, 5.14)
trt <- c(4.81, 4.17, 4.41, 3.59, 5.87, 3.83, 6.03, 4.89, 4.32, 4.69)
group <- gl(2, 10, 20, labels = c("Ctl", "Trt"))
weight <- c(ctl, trt)
lm_D9 <- lm(weight ~ group)

# ANOVA:
npk_aov <- aov(yield ~ block + N*P*K, npk)

#' # Create an empty list
results <- list()

# Add output to the results list
results <- results \%>\%
  add_stats(sleep_test) \%>\%
  add_stats(lm_D9, type = "primary", preregistered = TRUE) \%>\%
  add_stats(npk_aov, notes = "An ANOVA example")
  
# Convert the list to a data frame
results_df <- tidy_stats_to_data_frame(results)

# Select all the p-values
filter(results_df, statistic == "p")

}
