% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/add_stats.R
\name{add_stats}
\alias{add_stats}
\title{Add statistical output to a tidystats list}
\usage{
add_stats(
  list,
  output,
  identifier = NULL,
  type = NULL,
  preregistered = NULL,
  notes = NULL,
  args = NULL,
  class = NULL
)
}
\arguments{
\item{list}{A tidystats list.}

\item{output}{Output of a statistical test.}

\item{identifier}{A string identifying the model. Automatically created if
not provided.}

\item{type}{A string specifying the type of analysis: primary,
secondary, or exploratory.}

\item{preregistered}{A boolean specifying whether the analysis was
preregistered or not.}

\item{notes}{A string specifying additional information.}

\item{args}{A list of additional arguments to customize which statistics
should be extracted. See 'Details' for a list of supported functions and
their arguments.}

\item{class}{A string to manually specify the class of the object so that
tidystats knows how to extract the statistics. See 'Details' for a list of
classes that are supported.}
}
\description{
\code{\link[=add_stats]{add_stats()}} is used to add the output of a statistical test to a
tidystats list.
}
\details{
Many functions to perform statistical tests (e.g., \code{\link[=t.test]{t.test()}}, \code{\link[=lm]{lm()}}) return
an object containing the statistics. These objects can be stored in variables
and used with \code{\link[=add_stats]{add_stats()}} to extract the statistics and add them to a
list.

The list can be saved to a file using the \code{\link[=write_stats]{write_stats()}} function.

For a list of supported functions, see \code{vignette("supported-functions", package = "tidystats")}.
}
\examples{
# Conduct analyses
sleep_wide <- reshape(
  sleep,
  direction = "wide",
  idvar = "ID",
  timevar = "group",
  sep = "_"
)
sleep_test <- t.test(sleep_wide$extra_1, sleep_wide$extra_2, paired = TRUE)

ctl <- c(4.17, 5.58, 5.18, 6.11, 4.50, 4.61, 5.17, 4.53, 5.33, 5.14)
trt <- c(4.81, 4.17, 4.41, 3.59, 5.87, 3.83, 6.03, 4.89, 4.32, 4.69)
group <- gl(2, 10, 20, labels = c("Ctl", "Trt"))
weight <- c(ctl, trt)
lm_D9 <- lm(weight ~ group)
lm_D9_confint <- confint(lm_D9)

npk_aov <- aov(yield ~ block + N * P * K, npk)

# Create an empty list to store the statistics in
statistics <- list()

# Add statistics to the list
statistics <- statistics |>
  add_stats(sleep_test, type = "primary", preregistered = TRUE) |>
  add_stats(lm_D9) |>
  add_stats(lm_D9_confint, class = "confint") |>
  add_stats(npk_aov, notes = "An ANOVA example")

}
