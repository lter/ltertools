# Run all tests in this script:
## testthat::test_file(file.path("tests", "testthat", "test-harmonize.R"))

# Simple error testing
## (much of this is handled by `read` input testing)
test_that("Only accepts correct inputs", {
  
  # Generate a local folder for exporting
  temp_folder <- tempdir()
  
  # Make a fake column key (with incorrect column names)
  key_obj <- data.frame("wrong_name" = c("hiya"),
                        "tidy_name" = c("hello"),
                        "source" = c("test.csv"))
  
  # Generate a column key with "guesses" at tidy column names
  expect_error(harmonize(key = key_obj, raw_folder = temp_folder))
  
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
  
  # Start the key
  key_obj <- begin_key(raw_folder = temp_folder, data_format = "csv", guess_tidy = TRUE)
  
  # Harmonize the data
  tidy_v0 <- harmonize(key = key_obj, raw_folder = temp_folder, data_format = "csv")
  
  # Check output class
  expect_equal(class(tidy_v0), c("tbl_df", "tbl", "data.frame"))
  
  # Delete files post-testing
  unlink(temp_folder, recursive = TRUE)
})

