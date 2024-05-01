# Test this function:
## test_file(file.path("tests", "testthat", "test-cv.R"))

# Simple error testing
test_that("Only accepts correct inputs", {
  expect_error(cv(x = c("x", "y", "z"), na_rm = TRUE))
})

# Warning testing
test_that("Warnings are returned",{
  expect_warning(cv(x = c(1:10), na_rm = "false"))
})

# Output testing
test_that("Outputs are correct", {
  expect_equal(cv(x = c(1:10), na_rm = TRUE), 0.55048188)
})

