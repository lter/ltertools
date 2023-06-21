
convert <- function(value = NULL, from = NULL, to = NULL){
  
  # Error out if any are NULL
  if(is.null(value) == TRUE | is.null(from) == TRUE | is.null(to) == TRUE)
    stop("All arguments must be specified")
  
  # Error out if value isn't a number
  if(is.numeric(value) != TRUE)
    stop("Value to convert must be numeric")
  
  # Coerce from/to into lowercase (less variation to account for later)
  from_low <- tolower(x = from)
  to_low <- tolower(x = to)
  
  # Identify supported units
  valid_units <- c("c", "celsius", "f", "fahrenheit", "k", "kelvin")
  
  # Error out if units are unknown
  if(!from %in% valid_units | !to %in% valid_units)
    stop(paste0("Units not supported. Please use one of ", valid_units))
  
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
  
  
  
  
  
  # Template conditional for future conversions
  # if(from_low %in% c() & to_low %in% c()){
  #   converted <- value
  # }
  
  # Return Conversion ----
  return(converted)
  
}



