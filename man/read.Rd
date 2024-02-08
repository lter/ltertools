% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read.R
\name{read}
\alias{read}
\title{Read Data from Folder}
\usage{
read(raw_folder = NULL, data_formats = c("csv", "txt", "xls", "xlsx"))
}
\arguments{
\item{raw_folder}{(character) folder / folder path containing data files to read}

\item{data_formats}{(character) file extensions to identify within the `raw_folder`. Default behavior is to search for all supported file types.}
}
\value{
(list) data found in specified folder / of specified file format
}
\description{
Reads in all data files of specified types found in the designated folder. Returns a list with one element for each data file. Currently supports CSV, TXT, XLS, and XLSX. This function was built by the following authors: Nicholas Lyon
}
\examples{
\dontrun{
# Read in all CSV files in the "raw_data" folder
df_list <- read(raw_folder = "raw_data", data_formats = "csv")
}

}