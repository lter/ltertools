% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/convert.R
\name{convert}
\alias{convert}
\title{Convert Units of a Value}
\usage{
convert(value = NULL, from = NULL, to = NULL)
}
\arguments{
\item{value}{(numeric) value to convert between}

\item{from}{(character) starting units of the value. Casing (upper vs. lower) does not matter though spelling does}

\item{to}{(character) units to which to convert. Again, casing does not affect the function}
}
\value{
(numeric) value converted from specified units to desired units
}
\description{
Converts a given set of values from one user-specified unit to another. Currently only supports inter-conversion of temperature (i.e., Kelvin, Fahrenheit, Celsius) or miles to kilometers. If you would like other units added, please post an issue on our GitHub repository with your requested units and the formula used to convert between them. This function was built by the following authors: Nicholas Lyon
}
\examples{
# Convert from Fahrenheit to Celsius
convert(value = 32, from = "Fahrenheit", to = "c")

# Convert from kilometers to miles
convert(value = 5, from = "km", to = "mi")

}
