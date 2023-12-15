# Combine monthly PATHDASH reports
# There is usually too many cases to run the entire quarter without LigoLab
# crashing. The script below combines multiple excel files into a single 
# raw data file for the quarter.

# load libraries
library(tidyverse)
library(readxl)

# import monthly files
mth_1 <- read_excel("data/2020q3.1-tat.xls")
mth_2 <- read_excel("data/2020q3.2-tat.xls")
mth_3 <- read_excel("data/2020q3.3-tat.xls")

# build single raw data file
`2020q3` <- bind_rows(mth_1, mth_2, mth_3)

# write data file
writexl::write_xlsx(`2020q3`, "data/2020q3-tat.xlsx")
