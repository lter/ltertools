#' @title Convert Temperature Values
#' 
#' @description Converts a given set of temperature values from one unit to another. This function was built by the following authors: Nicholas Lyon
#' 
#' @param value (numeric) temperature values to convert
#' @param from (character) starting units of the value, not case sensitive.
#' @param to (character) units to which to convert, not case sensitive.
#' 
#' @return (numeric) converted temperature values
#' 
#' @export
#' 
#' @examples
#' # Convert from Fahrenheit to Celsius
#' convert_temp(value = 32, from = "Fahrenheit", to = "c")
#' 
convert_temp <- function(value = NULL, from = NULL, to = NULL){
  
  # Error out if any are NULL
  if(is.null(value) == TRUE | is.null(from) == TRUE | is.null(to) == TRUE)
    stop("All arguments must be specified")
  
  # Error out if value isn't a number
  if(is.numeric(value) != TRUE)
    stop("Value to convert must be numeric")
  
  # Error out if either from or to is not a character
  if(is.character(from) != TRUE | is.character(to) != TRUE)
    stop("Units to convert between (`from` and `to` arguments) must be specified as characters")
  
  # Coerce from/to into lowercase (less variation to account for later)
  from_low <- tolower(x = from)
  to_low <- tolower(x = to)
  
  # Identify supported units
  valid_units <- c("c", "celsius", "f", "fahrenheit", "k", "kelvin")
  
  # Error out if units are unknown
  if(!from_low %in% valid_units | !to_low %in% valid_units)
    stop("Units not supported. Please use one of ", paste(valid_units, collapse = "; "))
  
  # Temperature ----
  
  # C to F conversion
  if(from_low %in% c("c", "celsius") & to_low %in% c("f", "fahrenheit")){
    converted <- (value * (9 / 5)) + 32
  }
  
  # F to C conversion
  if(from_low %in% c("f", "fahrenheit") & to_low %in% c("c", "celsius")){
    converted <- (value - 32) * (5 / 9)
  }
  
  # C to K conversion
  if(from_low %in% c("c", "celsius") & to_low %in% c("k", "kelvin")){
    converted <- value + 273.15
  }
  
  # F to K conversion
  if(from_low %in% c("f", "fahrenheit") & to_low %in% c("k", "kelvin")){
    converted <- (value - 32) * (5 / 9) + 273.15
  }
  
  # K to C conversion
  if(from_low %in% c("k", "kelvin") & to_low %in% c("c", "celsius")){
    converted <- value - 273.15
  }
  
  # From K to F conversion
  if(from_low %in% c("k", "kelvin") & to_low %in% c("f", "fahrenheit")){
    converted <- ((value - 273.15) * (9 / 5)) + 32
  }
  
  # Return Converted value ----
  return(converted) }
