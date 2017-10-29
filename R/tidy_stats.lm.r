#' Create a tidy stats data frame from an lm object
#'
#' \code{tidy_stats.lm} takes an lm object and converts the object to a tidy stats data frame.
#'
#' @param model Output of \code{lm()}.
#'
#' @examples
#' # Conduct a regression
#' ctl <- c(4.17,5.58,5.18,6.11,4.50,4.61,5.17,4.53,5.33,5.14)
#' trt <- c(4.81,4.17,4.41,3.59,5.87,3.83,6.03,4.89,4.32,4.69)
#' group <- gl(2, 10, 20, labels = c("Ctl","Trt"))
#' weight <- c(ctl, trt)
#'
#' model_lm <- lm(weight ~ group)
#' tidy_stats(model_lm)
#'
#' @import dplyr
#' @import tidyr
#' @importFrom magrittr %>%
#'
#' @export

tidy_stats.lm <- function(model) {

  # Get summary statistics
  summary <- summary(model)

  # Extract statistics
  # Not included: Descriptives of residuals, residual standard error, residual degrees of freedom
  output <- tibble::as_data_frame(summary$coefficients) %>%
    dplyr::rename(
      b = Estimate,
      SE = `Std. Error`,
      t = `t value`,
      p = `Pr(>|t|)`
    ) %>%
    dplyr::mutate(
      df = summary$df[2],
      term = names(model$coefficients),
      term_nr = 1:n()) %>%
    tidyr::gather("statistic", "value", -term, -term_nr) %>%
    dplyr::arrange(term_nr)

  output <- dplyr::bind_rows(output,
    tibble::data_frame(
      term = "(Model)",
      term_nr = max(output$term_nr) + 1,
        statistic = c("R squared", "adjusted R squared", "F", "numerator df", "denominator df"),
      value = c(summary$r.squared, summary$adj.r.squared, summary$fstatistic[1],
                summary$fstatistic[2], summary$fstatistic[3])
    )
  )


  # Calculate model fit p value ourselves
  p <- pf(summary$fstatistic[1], summary$fstatistic[2], summary$fstatistic[3], lower.tail = FALSE)

  output <- dplyr::bind_rows(output, data_frame(term = "(Model)", term_nr = max(output$term_nr),
                                         statistic = "p", value = p))

  # Add method
  output$method <- "Linear regression"

  # Reorder columns
  output <- dplyr::select(output, term_nr, everything())

  return(output)
}