#' @title Calculate Coefficient of Variation
#' 
#' @description Computes the coefficient of variation (CV), by dividing the standard deviation (SD) by the arithmetic mean of a set of numbers. If `na_rm` is `TRUE` then missing values are removed before calculation is completed. This function was built by the following authors: Nicholas Lyon
#' 
#' @param x (numeric) vector of numbers for which to calculate CV
#' @param na_rm (logical) whether to remove missing values from both average and SD calculation
#' 
#' @return (numeric) coefficient of variation
#' 
#' @export
#' 
#' @examples
#' # Convert from Fahrenheit to Celsius
#' cv(x = c(4, 5, 6, 4, 5, 5), na_rm = TRUE)
#' 
cv <- function(x, na_rm = TRUE){
  
  # Error out if X is not numeric
  if(is.numeric(x) != TRUE)
    stop("`x` must be numeric")
  
  # Coerce na_rm to TRUE if not logical and message coercion
  if(is.logical(na_rm) != TRUE){
    na_rm <- TRUE
    message("`na_rm` must be logical. Coercing to TRUE")
  }
  
  # Calculate CV
  result <- stats::sd(x = x, na.rm = na_rm) / mean(x = x, na.rm = na_rm)
  
  # Return it
  return(result) }
