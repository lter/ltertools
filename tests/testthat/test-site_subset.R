# Run all tests in this script:
## testthat::test_file(file.path("tests", "testthat", "test-site_subset.R"))

# Simple error testing
test_that("Only accepts correct inputs", {
  expect_error(site_subset(sites = "xxxxx")) # too many chars
  expect_error(site_subset(sites = "AND", habitat = "marine")) # no sites returned
})

# Warning testing
test_that("Warnings are returned", {
  expect_warning(site_subset(sites = c("AND", "YYY"))) # unrecognized site code
  expect_warning(site_subset(habitat = c("forest", "space"))) # habitat not in data
})

# Output testing
test_that("Outputs are correct", {
  site_df <- site_subset(sites = "JRN")
  expect_equal(class(site_df), "data.frame")
})
