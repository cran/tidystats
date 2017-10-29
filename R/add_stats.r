#' Add statistical output to a tidy stats list
#'
#' \code{add_stats} adds output to a results list. It can take either the output of a statistical test as input or a data frame. See Details for more information on adding data frames.
#'
#' @param output output of a statistical test or a data frame. If a data frame is provided, it must already be in a tidy format.
#' @param results a tidy stats list.
#' @param identifier a character string identifying the model. Automatically created if not provided.
#' @param statistics a vector of statistics to select from the output and add to the tidy stats list.
#' @param type a character string indicating the type of test. One of "hypothesis", "manipulation check", "contrast", "descriptives", or "other". Can be abbreviated.
#' @param confirmatory a boolean to indicate whether the statistical test was confirmatory (TRUE) or exploratory (FALSE). Can be NA.
#' @param notes a character string to add additional information. Some statistical tests produce notes information, which will be overwritten if notes are provided.
#'
#' @details Some statistical functions produce unidentifiable output, which means \code{tidystats} cannot figure out how to tidy the data. To add these results, the output should be manually tidied or tidied using one of \code{tidystats}'s tidy functions. See \code{?tidy_stats} for an overview of available functions.
#'
#' @examples
#' # Create an empty list to store the results in
#' results <- list()
#'
#' # Example: t-test
#' model_t_test <- t.test(extra ~ group, data = sleep)
#' results <- add_stats(model_t_test, results, identifier = "t_test")
#'
#' # Example: correlation
#' x <- c(44.4, 45.9, 41.9, 53.3, 44.7, 44.1, 50.7, 45.2, 60.1)
#' y <- c( 2.6,  3.1,  2.5,  5.0,  3.6,  4.0,  5.2,  2.8,  3.8)
#'
#' model_correlation <- cor.test(x, y)
#'
#' # Add output to the results list, only storing the correlation and p-value
#' results <- add_stats(model_correlation, results, identifier = "correlation",
#'                      statistics = c("r", "p"))
#'
#' # Example: Regression
#' ctl <- c(4.17,5.58,5.18,6.11,4.50,4.61,5.17,4.53,5.33,5.14)
#' trt <- c(4.81,4.17,4.41,3.59,5.87,3.83,6.03,4.89,4.32,4.69)
#' group <- gl(2, 10, 20, labels = c("Ctl","Trt"))
#' weight <- c(ctl, trt)
#'
#' model_lm <- lm(weight ~ group)
#'
#' # Add output to the results list, with notes
#' results <- add_stats(model_lm, results, identifier = "regression", notes = "regression example")
#'
#' # Example: ANOVA
#' model_aov <- aov(yield ~ block + N * P * K, npk)
#'
#' results <- add_stats(model_aov, results, identifier = "ANOVA")
#'
#' # Example: Within-subjects ANOVA
#' model_aov_within <- aov(extra ~ group + Error(ID/group), data = sleep)
#'
#' results <- add_stats(model_aov_within, results, identifier = "ANOVA_within")
#'
#' # Example: Manual chi-squared test of independence
#' library(tibble)
#'
#' x_squared_data <- tibble(
#'   statistic = c("X-squared", "df", "p"),
#'   value = c(5.4885, 6, 0.4828),
#'   method = "Chi-squared test of independence"
#' )
#'
#' results <- add_stats(x_squared_data, results, identifier = "x_squared")
#'
#' @export

add_stats <- function(output, results, identifier = NULL, statistics = NULL, type = NULL,
                      confirmatory = NULL, notes = NULL) UseMethod("add_stats")
