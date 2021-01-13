# Calculate holidays observed by Summit -----------------------------------

# New Years
# Memorial Day
# Labor Day
# Independence Day
# Thanksgiving
# Christmas Day


# Load libraries ----------------------------------------------------------

library(timeDate)

# Make vector of dates by day from 2020-01-01 to 2099-12-31
x <- seq(as.Date("2020-01-01"), as.Date("2099-12-31"), by = "day")

# Determine date of holidays
GetHolidays <- function(x) {
  years = as.POSIXlt(x)$year + 1900
  years = unique(years)
  holidays <- NULL
  for (y in years) {
    if (y >= 1885)
      holidays <-
        c(holidays, as.character(USNewYearsDay(y)))
    if (y >= 1885)
      holidays <- 
        c(holidays, as.character(USMemorialDay(y)))
    if (y >= 1885)
      holidays <- 
        c(holidays, as.character(USLaborDay(y)))
    if (y >= 1885)
      holidays <-
        c(holidays, as.character(USIndependenceDay(y)))
    if (y >= 1885)
      holidays <-
        c(holidays, as.character(USThanksgivingDay(y)))
    if (y >= 1885)
      holidays <-
        c(holidays, as.character(USChristmasDay(y)))
  }
  holidays = as.Date(holidays, format = "%Y-%m-%d")
  ans = x %in% holidays
  return(ans)
}

# Make vector with date of each holiday from 2020 through 2099
sp_holidays <- x[GetHolidays(x)]


# Parameters for turnaround time ------------------------------------------

# Clock counts 24-hours per day and excludes weekends and holidays
# Start 24 hour clock at midnight
starttime <- "00:00:00"

# Finish 24 hour clock at 11:59:59
endtime <- "23:59:59"

# Weekend list
weekend_list <- c("Saturday","Sunday")

# Custom US holidays: NYD, Mem, Labor, Ind, Thanksgiving, Christmas
US_holiday_list <- sp_holidays

# Business duration - day, hour, min, sec
unit_hour <- "hour"