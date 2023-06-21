#' @title Convert Units of a Value
#' 
#' @description Converts a given set of values from one user-specified unit to another. Currently only supports inter-conversion of temperature (i.e., Kelvin, Fahrenheit, Celsius) or miles to kilometers. If you would like other units added, please post an issue on our GitHub repository with your requested units and the formula used to convert between them.
#' 
#' @param value (numeric) value to convert between
#' @param from (character) starting units of the value. Casing (upper vs. lower) does not matter though spelling does
#' @param to (character) units to which to convert. Again, casing does not affect the function
#' 
#' @return (numeric) value converted from specified units to desired units
#' 
#' @export
#' 
#' @examples
#' # Convert from Fahrenheit to Celsius
#' convert(value = 32, from = "Fahrenheit", to = "c")
#' 
#' # Convert from kilometers to miles
#' convert(value = 5, from = "km", to = "mi")
#' 
convert <- function(value = NULL, from = NULL, to = NULL){
  
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
  valid_units <- c("c", "celsius", "f", "fahrenheit", "k", "kelvin",
                   "km", "kilometers", "mi", "miles")
  
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
  
  # Distance ----
  
  # miles to kilometers conversion
  if(from_low %in% c("mi", "miles") & to_low %in% c("km", "kilometers")){
    converted <- value * 1.609344
  }
  
  # kilometers to miles conversion
  if(from_low %in% c("km", "kilometers") & to_low %in% c("mi", "miles")){
    converted <- value * 0.621371
  }
  
  # Template Conditional  ----
  ## For future conversions
  # if(from_low %in% c() & to_low %in% c()){
  #   converted <- value
  # }
  
  # Return Converted value ----
  return(converted) }
