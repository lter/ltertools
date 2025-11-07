# Run all tests in this script:
## testthat::test_file(file.path("tests", "testthat", "test-check_key.R"))

# Simple error testing
test_that("Only accepts correct inputs", {
  
  # Generate a data key
  key_obj <- data.frame("source" = c(rep(x = "df1.csv", times = 3),
                                     rep(x = "df2.csv", times = 3)),
                        "raw_name" = c("xx", "unwanted", "yy", "LETTERS", "NUMBERS", "BONUS"),
                        "good_name" = c("letters", "", "numbers", "letters", "numbers", ""))

  # Generate a column key with "guesses" at tidy column names
  expect_error(ltertools::check_key(key = key_obj))

  # Generate a data key
  key_obj <- data.frame("source" = c(rep(x = "df1.csv", times = 3),
                                     rep(x = "df2.csv", times = 3)),
                        "raw_name" = c("xx", "unwanted", "yy", "LETTERS", "NUMBERS", "BONUS"),
                        "tidy_name" = c("source", "", "numbers", "letters", "numbers", ""))

  # Generate a column key with "guesses" at tidy column names
  expect_error(ltertools::check_key(key = key_obj))
})

# Warning testing
# test_that("Warnings are returned", {
#   ## No warnings in function (currently)
# })


# Output testing
# test_that("Outputs are correct", {
#   ## Leaving aside for now
# })

