


cv <- function(x, na_rm = TRUE){
  
  # Calculate CV
  result <- sd(x = x, na.rm = na_rm) / mean(x = x, na.rm = na_rm)
  
  # Return it
  return(result) }

