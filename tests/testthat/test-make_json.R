# Run all tests in this script:
## testthat::test_file(file.path("tests", "testthat", "test-make_json.R"))

# Simple error testing
test_that("Only accepts correct inputs", {
  # No missing args
  expect_error(make_json(x = NULL, file = "hello"))
  expect_error(make_json(x = "hello", file = NULL))
  # Non-numeric args
  expect_error(make_json(x = 1:3, file = "hello"))
  expect_error(make_json(x = "hello", file = 6))
  # No names
  expect_error(make_json(x = "hello", file = "test.json"))
  # Some missing names
  expect_error(make_json(x = c("greeting" = "hello", "goodbye"), file = "test.json"))
  # Non-unique names
  expect_error(make_json(x = c("greeting" = "hello", "greeting" = "goodbye"), file = "test.json"))
  # Too many file names
  expect_error(make_json(x = c("greeting" = "hello"), file = c("first_name", "second_name")))
  # File name missing ".json"
  expect_error(make_json(x = c("greeting" = "hello"), file = "test"))
})

# Warning testing
# test_that("Warnings are returned",{
#   # This function contains no warnings (currently)
# })

# Output testing
test_that("Outputs are correct", {

  # Create contents
  my_info <- c("data_path" = "Users/me/documents/my_project/data")
  
  # Generate a local folder for exporting
  temp_folder <- tempdir()
  
  # Create a JSON with those contents
  testthat::expect_no_error(make_json(x = my_info, file = file.path(temp_folder, "user.json")))
  
  # Delete files post-testing
  unlink(temp_folder, recursive = TRUE)
})
