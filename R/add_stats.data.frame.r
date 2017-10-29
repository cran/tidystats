#' add_stats data frame function
#'
#' \code{add_stats.data.frame} is a function to add a tidy data frame of results to a tidy stats list. tidystats does not support all possible statistical tests, so it may not be able to produce tidy output of a statistical model. The best solution for now is to tidy the output of a statistical test yourself, creating a tidy data frame, and then use \code{add_stats}, which will call this function, to add it to the tidy stats list.
#'
#' @param output A data frame that contains statistical output in a tidy format.
#' @param results A tidy stats list.
#' @param identifier A character string identifying the model. Automatically created if not provided.
#' @param statistics A vector of statistics to select from the output and add to the tidy stats list.
#' @param type A character string indicating the type of test. One of "hypothesis", "manipulation check", "contrast", "descriptives", or "other". Can be abbreviated.
#' @param confirmatory A boolean to indicate whether the statistical test was confirmatory (TRUE) or exploratory (FALSE). Can be NA.
#' @param notes A character string to add additional information. Some statistical tests produce notes information, which will be overwritten if notes are provided.
#'
#' @import dplyr
#'
#' @examples
#'
#' # Create an empty list to store the results in
#' results <- list()
#'
#' # Example: Manual chi-squared test of independence
#' x_squared_data <- data.frame(
#'   statistic = c("X-squared", "df", "p"),
#'   value = c(5.4885, 6, 0.4828),
#'   method = "Chi-squared test of independence"
#'   )
#'
#' # Add results to results
#' results <- add_stats(x_squared_data, results, identifier = "M1")
#'
#' @export
add_stats.data.frame <- function(output, results, identifier = NULL, statistics = NULL, type = NULL,
                                 confirmatory = NULL, notes = NULL) {

  # Create an identifier if it is not specified, else check whether it already exists
  if (is.null(identifier)) {
    identifier <- paste0("M", formatC(length(results)+1, width = "1", format = "d"))
  } else {
    if (!is.null(names(results))) {
      if (identifier %in% names(results)) {
        stop("Identifier already exists.")
      }
    }
  }

  # Throw a warning if non-standard columns are found in the data
  if (sum(!names(output) %in% c("statistic", "value", "method", "group", "term")) > 0) {
    warning(paste("Non-standard columns found."))
  }

  # Create the new element
  new_element <- output

  # Filter out statistics
  if (!is.null(statistics)) {
    new_element <- dplyr::filter(new_element, statistic %in% statistics)
  }

  # Add the type
  if (!is.null(type)) {
    type <- match.arg(type, choices = c("hypothesis", "manipulation check", "contrast",
                                        "descriptives", "other"))

    new_element$type <- dplyr::case_when(
      substr(type, 1, 1) == "h" ~ "hypothesis",
      substr(type, 1, 1) == "m" ~ "manipulation check",
      substr(type, 1, 1) == "c" ~ "contrast",
      substr(type, 1, 1) == "d" ~ "descriptives",
      TRUE ~ NA_character_
    )
  }

  # Add information whether the analysis was confirmatory or not
  if (!is.null(confirmatory)) {
    new_element$confirmatory <- dplyr::case_when(
      confirmatory == TRUE ~ TRUE,
      confirmatory == FALSE ~ FALSE,
      TRUE ~ NA
    )
  }

  # Add notes
  if (!is.null(notes)) {
    new_element$notes <- notes
  }

  # Add the new element to the list
  results[[identifier]] <- new_element

  # Return the new results list
  return(results)
}