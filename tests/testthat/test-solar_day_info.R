# Run all tests in this script:
## testthat::test_file(file.path("tests", "testthat", "test-solar_day_info.R"))

# Simple error testing
test_that("Only accepts correct inputs", {
  expect_error(solar_day_info(lat = 4000, lon = -119, 
                              start_date = "2022-02-07", 
                              end_date = "2022-02-08", quiet = TRUE))
  expect_error(solar_day_info(lat = 34, lon = 4000, 
                              start_date = "2022-02-07", 
                              end_date = "2022-02-08", quiet = TRUE))
  expect_error(solar_day_info(lat = 34, lon = -119, 
                              start_date = "feb 7, 2022", 
                              end_date = "2022-02-08", quiet = TRUE))
  expect_error(solar_day_info(lat = 34, lon = -119, 
                              start_date = "2022-02-07", 
                              end_date = "2022/02/08", quiet = TRUE))
  expect_error(solar_day_info(lat = 34, lon = -119, 
                              start_date = "2022-02-07", 
                              end_date = "22-02-08", quiet = TRUE))
})

# Warning testing
test_that("Warnings are returned",{
  expect_warning(solar_day_info(lat = 34, lon = -119, 
                                start_date = "2022-02-07", end_date = "2022-02-08", 
                                quiet = "xxx"))
})

# Output testing
test_that("Outputs are correct", {
  
  sun_faq <- solar_day_info(lat = 34, lon = -119, 
                            start_date = "2022-02-07", end_date = "2022-02-08", 
                            quiet = TRUE)
  
  expect_equal(class(sun_faq), "data.frame")
})
