# Run all tests in this script:
## testthat::test_file(file.path("tests", "testthat", "test-convert.R"))

# `convert_temp` Tests ----

# Simple error testing
test_that("Only accepts correct inputs", {
  expect_error(convert_temp())
  expect_error(convert_temp(value = "xxx"))
  expect_error(convert_temp(value = 10, from = "fake unit", to = "celsius"))
  expect_error(convert_temp(value = 10, from = 0, to = 1))
})

# Output testing
test_that("Outputs are correct", {
  ## Class is correct
  expect_type(convert_temp(value = 15, from = "C", to = "F"), "double")
  ## F & C
  expect_equal(convert_temp(value = 15, from = "C", to = "F"), 59)
  expect_equal(convert_temp(value = 59, from = "F", to = "C"), 15)
  ## C & K
  expect_equal(convert_temp(value = 0, from = "C", to = "K"), 273.15)
  expect_equal(convert_temp(value = 273.15, from = "K", to = "C"), 0)
  ## F & K
  expect_equal(convert_temp(value = 32, from = "F", to = "K"), 273.15)
  expect_equal(convert_temp(value = 273.15, from = "K", to = "F"), 32)
})
