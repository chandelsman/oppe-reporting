# This script calculates turnaround time for all client groups, clients,
# and outpatient cases. It summarizes findings by overall, client-specific,
# case type (NGYN, surgical), and by pathologist.


# Load required packages --------------------------------------------------

library(tidyverse)
library(readxl)
library(lubridate)
library(timeDate)
library(BusinessDuration)
library(gt)


# Load turnaround time parameters -----------------------------------------

source("./R/src_TA-time_params.R")


# Load data ---------------------------------------------------------------

# this should be replaced with a direct query of the SQL Server database

# turn around time data 
ta_time01 <- read_excel("./input/q120_01tat.xls") # January
ta_time02 <- read_excel("./input/q120_02tat.xls") # February
ta_time03 <- read_excel("./input/q120_03tat.xls") # March
ta_timeQx <- bind_rows(ta_time01, ta_time02, ta_time03) # combine 


# Clean data --------------------------------------------------------------

# make columns for case type: ngyn, surg, ngyn outpatient, surg outpatient
# reformat dates to POSIXct 
# define client groups
# drop deleted cases

ta_time <- ta_timeQx %>% 
  mutate(
    `SEQUENCE GROUP` = str_replace(`SEQUENCE GROUP`, "\\*SURG", "SURG"),
    `SEQUENCE GROUP` = str_replace(`SEQUENCE GROUP`, "OP SURG", "SURG OP"),
    `SEQUENCE GROUP` = str_replace(`SEQUENCE GROUP`, "OP NGYN", "NGYN OP"),
    PATHOLOGIST = str_replace(PATHOLOGIST, "\\[x] ", ""),
    type = str_extract(`SEQUENCE GROUP`, "()[^(]+") %>% str_trim(),
    client = str_extract(`SEQUENCE GROUP`, "(?<=\\().*?(?=\\))"), 
    Create = mdy_hm(Create),
    `original release` = mdy_hm(`original release`),
    grp = case_when(
      `SEQUENCE GROUP` == "NGYN (BFCMC)" ~ "BHS",
      `SEQUENCE GROUP` == "NGYN (CPMC)" ~ "CPMC",
      `SEQUENCE GROUP` == "NGYN (CRMC)" ~ "CRMC",
      `SEQUENCE GROUP` == "NGYN (EMCH)" ~ "BHS",
      `SEQUENCE GROUP` == "NGYN (EPMC)" ~ "EPMC",
      `SEQUENCE GROUP` == "NGYN (IMH)" ~ "IMH",
      `SEQUENCE GROUP` == "NGYN (KHS)" ~ "KHS",
      `SEQUENCE GROUP` == "NGYN (McKee)" ~ "BHS",
      `SEQUENCE GROUP` == "NGYN (MCR)" ~ "UC_NORTH",
      `SEQUENCE GROUP` == "NGYN (MHC)" ~ "UC_SOUTH",
      `SEQUENCE GROUP` == "NGYN (MHCC DC)" ~ "MHCC_DC",
      `SEQUENCE GROUP` == "NGYN (MHN)" ~ "UC_SOUTH",
      `SEQUENCE GROUP` == "NGYN (NCMC)" ~ "BHS",
      `SEQUENCE GROUP` == "NGYN (OCH)" ~ "BHS",
      `SEQUENCE GROUP` == "NGYN (PCMH)" ~ "BHS",
      `SEQUENCE GROUP` == "NGYN (PEAK)" ~ "OP_SP",
      `SEQUENCE GROUP` == "NGYN (PVH)" ~ "UC_NORTH",
      `SEQUENCE GROUP` == "NGYN (RAWLINS)" ~ "RWLNS",
      `SEQUENCE GROUP` == "NGYN (SRMC)" ~ "BHS",
      `SEQUENCE GROUP` == "NGYN (UCHGH)" ~ "UC_NORTH",
      `SEQUENCE GROUP` == "NGYN (WOODLAND)" ~ "UC_SOUTH",
      `SEQUENCE GROUP` == "NGYN (WY VA)" ~ "WYVA",
      `SEQUENCE GROUP` == "NGYN OP (MHN)" ~ "UCSOUTH",
      `SEQUENCE GROUP` == "NGYN OP (SP)" ~ "OP_SP",
      `SEQUENCE GROUP` == "NGYN OP (SPWY)" ~ "OP_SP",
      `SEQUENCE GROUP` == "SURG (BFCMC)" ~ "BHS",
      `SEQUENCE GROUP` == "SURG (CFG)" ~ "CFG",
      `SEQUENCE GROUP` == "SURG (CPMC)" ~ "CPMC",
      `SEQUENCE GROUP` == "SURG (CRMC)" ~ "CRMC",
      `SEQUENCE GROUP` == "SURG (EMCH)" ~ "BHS",
      `SEQUENCE GROUP` == "SURG (EPMC)" ~ "EPMC",
      `SEQUENCE GROUP` == "SURG (FR DERM)" ~ "TECH",
      `SEQUENCE GROUP` == "SURG (GRANDVIEW)" ~ "UC_SOUTH",
      `SEQUENCE GROUP` == "SURG (HS)" ~ "HS",
      `SEQUENCE GROUP` == "SURG (IMH)" ~ "IMH",
      `SEQUENCE GROUP` == "SURG (JL DERM)" ~ "TECH",
      `SEQUENCE GROUP` == "SURG (KHS)" ~ "KHS",
      `SEQUENCE GROUP` == "SURG (McKee)" ~ "BHS",
      `SEQUENCE GROUP` == "SURG (MCR)" ~ "UC_NORTH",
      `SEQUENCE GROUP` == "SURG (MHC)" ~ "UC_SOUTH",
      `SEQUENCE GROUP` == "SURG (MHCC DC)" ~ "MHCC_DC",
      `SEQUENCE GROUP` == "SURG (MHN)" ~ "UC_SOUTH",
      `SEQUENCE GROUP` == "SURG (NCMC)" ~ "BHS",
      `SEQUENCE GROUP` == "SURG (OCH)" ~ "BHS",
      `SEQUENCE GROUP` == "SURG (PCMH)" ~ "BHS",
      `SEQUENCE GROUP` == "SURG (PEAK)" ~ "OP_SP",
      `SEQUENCE GROUP` == "SURG (PVH)" ~ "UC_NORTH",
      `SEQUENCE GROUP` == "SURG (RAWLINS)" ~ "RWLNS",
      `SEQUENCE GROUP` == "SURG (SRMC)" ~ "BHS",
      `SEQUENCE GROUP` == "SURG (TORRINGTON)" ~ "BHS",
      `SEQUENCE GROUP` == "SURG (UCHGH)" ~ "UC_NORTH",
      `SEQUENCE GROUP` == "SURG (WOODLAND)" ~ "UC_SOUTH",
      `SEQUENCE GROUP` == "SURG (WY VA)" ~ "WYVA",
      `SEQUENCE GROUP` == "SURG OP (MH)" ~ "OP_MEM",
      `SEQUENCE GROUP` == "SURG OP (SP)" ~ "OP_SP",
      `SEQUENCE GROUP` == "SURG OP (SPWY)" ~ "OP_SP",
      TRUE ~ "Validate_Client"),
    cl_grp = case_when(
      `SEQUENCE GROUP` == "NGYN (BFCMC)" ~ "Banner Health",
      `SEQUENCE GROUP` == "NGYN (CPMC)" ~ "Colorado Plains Medical Center",
      `SEQUENCE GROUP` == "NGYN (CRMC)" ~ "Cheyenne Regional Medical Center",
      `SEQUENCE GROUP` == "NGYN (EMCH)" ~ "Banner Health",
      `SEQUENCE GROUP` == "NGYN (EPMC)" ~ "Estes Park Health Hospital",
      `SEQUENCE GROUP` == "NGYN (IMH)" ~ "Ivinson Memorial Hospital",
      `SEQUENCE GROUP` == "NGYN (KHS)" ~ "Kimball County Hospital",
      `SEQUENCE GROUP` == "NGYN (McKee)" ~ "Banner Health",
      `SEQUENCE GROUP` == "NGYN (MCR)" ~ "UC Health North",
      `SEQUENCE GROUP` == "NGYN (MHC)" ~ "UC Health South",
      `SEQUENCE GROUP` == "NGYN (MHCC DC)" ~ "Memorial Hospital of Converse County",
      `SEQUENCE GROUP` == "NGYN (MHN)" ~ "UC Health South",
      `SEQUENCE GROUP` == "NGYN (NCMC)" ~ "Banner Health",
      `SEQUENCE GROUP` == "NGYN (OCH)" ~ "Banner Health",
      `SEQUENCE GROUP` == "NGYN (PCMH)" ~ "Banner Health",
      `SEQUENCE GROUP` == "NGYN (PEAK)" ~ "Summit Pathology Outpatient",
      `SEQUENCE GROUP` == "NGYN (PVH)" ~ "UC Health North",
      `SEQUENCE GROUP` == "NGYN (RAWLINS)" ~ "Memorial Hospital of Carbon County",
      `SEQUENCE GROUP` == "NGYN (SRMC)" ~ "Banner Health",
      `SEQUENCE GROUP` == "NGYN (UCHGH)" ~ "UC Health North",
      `SEQUENCE GROUP` == "NGYN (WOODLAND)" ~ "UC Health South",
      `SEQUENCE GROUP` == "NGYN (WY VA)" ~ "Wyoming Veterans Administration",
      `SEQUENCE GROUP` == "NGYN OP (MHN)" ~ "Memorial Outpatient",
      `SEQUENCE GROUP` == "NGYN OP (SP)" ~ "Summit Pathology Outpatient",
      `SEQUENCE GROUP` == "NGYN OP (SPWY)" ~ "Summit Pathology Outpatient",
      `SEQUENCE GROUP` == "SURG (BFCMC)" ~ "Banner Health",
      `SEQUENCE GROUP` == "SURG (CFG)" ~ "Centers for Gastroenterology",
      `SEQUENCE GROUP` == "SURG (CPMC)" ~ "Colorado Plains Medical Center",
      `SEQUENCE GROUP` == "SURG (CRMC)" ~ "Cheyenne Regional Medical Center",
      `SEQUENCE GROUP` == "SURG (EMCH)" ~ "Banner Health",
      `SEQUENCE GROUP` == "SURG (EPMC)" ~ "Estes Park Health Hospital",
      `SEQUENCE GROUP` == "SURG (FR DERM)" ~ "Tech Only Clients",
      `SEQUENCE GROUP` == "SURG (GRANDVIEW)" ~ "UC Health South",
      `SEQUENCE GROUP` == "SURG (HS)" ~ "Melissa Memorial Hospital",
      `SEQUENCE GROUP` == "SURG (IMH)" ~ "Ivinson Memorial Hospital",
      `SEQUENCE GROUP` == "SURG (JL DERM)" ~ "Tech Only Clients",
      `SEQUENCE GROUP` == "SURG (KHS)" ~ "Kimball County Hospital",
      `SEQUENCE GROUP` == "SURG (McKee)" ~ "Banner Health",
      `SEQUENCE GROUP` == "SURG (MCR)" ~ "UC Health North",
      `SEQUENCE GROUP` == "SURG (MHC)" ~ "UC Health South",
      `SEQUENCE GROUP` == "SURG (MHCC DC)" ~ "Memorial Hospital of Converse County",
      `SEQUENCE GROUP` == "SURG (MHN)" ~ "UC Health South",
      `SEQUENCE GROUP` == "SURG (NCMC)" ~ "Banner Health",
      `SEQUENCE GROUP` == "SURG (OCH)" ~ "Banner Health",
      `SEQUENCE GROUP` == "SURG (PCMH)" ~ "Banner Health",
      `SEQUENCE GROUP` == "SURG (PEAK)" ~ "Summit Pathology Outpatient",
      `SEQUENCE GROUP` == "SURG (PVH)" ~ "UC Health North",
      `SEQUENCE GROUP` == "SURG (RAWLINS)" ~ "Memorial Hospital of Carbon County",
      `SEQUENCE GROUP` == "SURG (SRMC)" ~ "Banner Health",
      `SEQUENCE GROUP` == "SURG (TORRINGTON)" ~ "Banner Health",
      `SEQUENCE GROUP` == "SURG (UCHGH)" ~ "UC Health North",
      `SEQUENCE GROUP` == "SURG (WOODLAND)" ~ "UC Health South",
      `SEQUENCE GROUP` == "SURG (WY VA)" ~ "Wyoming Veterans Administration",
      `SEQUENCE GROUP` == "SURG OP (MH)" ~ "Memorial Outpatient",
      `SEQUENCE GROUP` == "SURG OP (SP)" ~ "Summit Pathology Outpatient",
      `SEQUENCE GROUP` == "SURG OP (SPWY)" ~ "Summit Pathology Outpatient",
      TRUE ~ "Validate_Client")
    ) %>%
  filter(!is.na(`original release`)) # %>%  # drop deleted records
  # group_by(grp) %>% 
  # sample_frac(size = 0.05, replace = FALSE) %>% 
  # ungroup()


# Calculate turnaround time by case ---------------------------------------

ta_time$span <- sapply(1 : nrow(ta_time), function(x){
  businessDuration(startdate = ta_time$Create[x],
                   enddate = ta_time$`original release`[x],
                   starttime = starttime,
                   endtime = endtime,
                   weekendlist = weekend_list,
                   holidaylist = US_holiday_list,
                   unit = unit_hour)})


# Calculate turnaround time for groups, clients, etc. ---------------------

# client_grp <- ta_time %>%
#   group_by(grp) %>% 
#   summarize(Total = n(), 
#             `Avg (hrs)` = mean(duration, na.rm = TRUE),
#             `< 48 hrs` = 
#               sum(duration <= 48, na.rm = TRUE)/n()
#             )