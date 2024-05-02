# Run all tests in this script:
## testthat::test_file(file.path("tests", "testthat", "test-begin_key.R"))

# Simple error testing
# test_that("Only accepts correct inputs", {
#   ## Mostly handled by `read`
# })

# Warning testing
test_that("Warnings are returned", {
  
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
  
  # Generate a column key with "guesses" at tidy column names
  expect_warning(ltertools::begin_key(raw_folder = temp_folder, data_format = "csv", 
                                      guess_tidy = "true"))
  
  # Delete files post-testing
  unlink(temp_folder, recursive = TRUE)
})


# Output testing
test_that("Outputs are correct", {
  
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
  
  # Generate a column key with "guesses" at tidy column names
  key_v1 <- ltertools::begin_key(raw_folder = temp_folder, data_format = "csv", 
                                 guess_tidy = TRUE)
  
  # Read in all CSV files in that folder
  expect_true(class(key_v1) == "data.frame")
  
  # Delete files post-testing
  unlink(temp_folder, recursive = TRUE)
})

