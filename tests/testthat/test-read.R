# Run all tests in this script:
## testthat::test_file(file.path("tests", "testthat", "test-read.R"))

# Simple error testing
test_that("Only accepts correct inputs", {
  expect_error(read(raw_folder = NULL, data_format = "CSV"))
  expect_error(read(raw_folder = "hello", data_format = "CSV"))
})

# Output testing
test_that("Error for no files in folder", {
  
  # Generate a local folder for exporting
  temp_folder <- tempdir()
  
  # Read in all CSV files in that folder
  expect_error(read(raw_folder = temp_folder, data_format = "csv"))
  
  # Delete files post-testing
  unlink(temp_folder, recursive = TRUE)
})

# More output testing
test_that("Error for no files in folder", {
  # Generate two simple tables
  ## Dataframe 1
  df1 <- data.frame("xx" = c(1:3),
                    "unwanted" = c("not", "needed", "column"),
                    "yy" = letters[1:3])
  ## Dataframe 2
  df2 <- data.frame("LETTERS" = letters[4:7],
                    "NUMBERS" = c(4:7),
                    "BONUS" = c("plantae", "animalia", "fungi", "protista"))
  
  # Generate a local folder for exporting
  temp_folder <- tempdir()
  
  # Export both files to that folder
  utils::write.csv(x = df1, file = file.path(temp_folder, "df1.csv"), row.names = FALSE)
  utils::write.csv(x = df2, file = file.path(temp_folder, "df2.csv"), row.names = FALSE)
  
  # Read them back in
  my_data <- read(raw_folder = temp_folder, data_format = "csv")
  
  # Read in all CSV files in that folder
  expect_true(class(my_data) == "list")
  
  # Delete files post-testing
  unlink(temp_folder, recursive = TRUE)
})
