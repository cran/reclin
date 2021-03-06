
#' Score pairs by summing the similarity vectors
#' 
#' @param pairs a \code{pairs} object, such as generated by 
#'   \code{\link{pair_blocking}}
#' @param var a character vector of length 1 with the name of the variable that
#'   will be created. 
#' @param by a character vector with the column names from \code{pairs} that
#'   should be summed. When missing the \code{by} attribute from \code{pairs}
#'   is used. 
#' @param add add the variable to the \code{pairs} object and return the 
#'   \code{pairs} object. Otherwise, return a vector with the scores.
#' @param na_value the value to use for missing values
#' @param ... passed on to other methods.
#'   
#' @details 
#' The scores are calculated by summing the columns given by \code{by}. Missing
#' values are counted as zeros.
#' 
#' @return 
#' When \code{add = TRUE} the original \code{pairs} object is returned with the 
#' column given by \code{var} added to it. Otherwise a vector with scores is 
#' returned.
#'  
#' @examples 
#' data("linkexample1", "linkexample2")
#' pairs <- pair_blocking(linkexample1, linkexample2, "postcode")
#' pairs <- compare_pairs(pairs, c("lastname", "firstname", "address", "sex"))
#' pairs <- score_simsum(pairs)
#'  
#' \dontshow{gc()}
#'
#' @export
score_simsum <- function(pairs, var = "simsum", by, add = TRUE,
    na_value = 0, ...) {
  if (!methods::is(pairs, "pairs")) stop("pairs should be an object of type 'pairs'.")
  UseMethod("score_simsum")
}

#' @export
score_simsum.ldat <- function(pairs, var = "simsum", by, add = TRUE,
    na_value = 0, ...) {
  if (missing(by)) by <- attr(pairs, "by")
  if (is.null(by)) 
    stop("Argument 'by' is missing and not in attributes of 'pairs'.")
  simsum <- lvec(nrow(pairs), "numeric")
  for (v in by) {
    val <- 1*pairs[[v]]
    val[is.na(val)] <- na_value
    simsum <- simsum + val
  }
  if (add) { 
    pairs[[var]] <- simsum
    attr(pairs, "score") <- var
    pairs
  } else simsum
}

#' @export
score_simsum.data.frame <- function(pairs, var = "simsum", by, add = TRUE, 
    na_value = 0, ...) {
  if (missing(by)) by <- attr(pairs, "by")
  if (is.null(by)) 
    stop("Argument 'by' is missing and not in attributes of 'pairs'.")
  simsum <- numeric(nrow(pairs))
  for (v in by) {
    val <- 1*pairs[[v]]
    val[is.na(val)] <- na_value
    simsum <- simsum + val
  }
  if (add) { 
    pairs[[var]] <- simsum
    attr(pairs, "score") <- var
    pairs
  } else simsum
}

