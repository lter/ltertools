# Run all tests in this script:
## testthat::test_file(file.path("tests", "testthat", "test-site_timeline.R"))

# Simple error testing
## Unnecessary because `site_subset` is doing brunt of input checking

# Warning testing
test_that("Warnings are returned",{
  expect_warning(site_timeline(sites = c("NWT", "LUQ", "ARC"), colors = "#67CDAA"))
})

# Output testing
test_that("Outputs are correct", {
  time_gg <- site_timeline(sites = c("NWT", "LUQ", "ARC"))
  expect_true(ggplot2::is_ggplot(time_gg))
})
