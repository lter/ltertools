


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
  result <- sd(x = x, na.rm = na_rm) / mean(x = x, na.rm = na_rm)
  
  # Return it
  return(result) }
