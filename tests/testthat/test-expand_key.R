# Run all tests in this script:
## testthat::test_file(file.path("tests", "testthat", "test-harmonize.R"))

# Output testing
test_that("Outputs are correct", {
  
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
  key1 <- ltertools::begin_key(raw_folder = temp_folder, data_format = "csv", guess_tidy = TRUE)
  
  # Harmonize the data
  harmony <- ltertools::harmonize(key = key1, raw_folder = temp_folder)
  
  # Make a new data file
  df3 <- data.frame("xx" = c(10:15),
                    "letters" = letters[10:15])
  
  # Export this locally to the temp folder too
  utils::write.csv(x = df3, file = file.path(temp_folder, "df3.csv"), row.names = FALSE)
  
  # Identify what needs to be added to the existing column key
  key2 <- expand_key(key = key1, raw_folder = temp_folder, harmonized_df = harmony,
                        data_format = "csv", guess_tidy = TRUE)
  
  # Check output class
  expect_equal(class(key2), c("data.frame"))
  
  # Delete files post-testing
  unlink(temp_folder, recursive = TRUE)
})
