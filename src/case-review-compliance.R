# Make list of all consultations where consult was not yes. This includes
# "yes w/ comments, "no", and "no w/ comments.

# Load libraries
library(tidyverse)
library(lubridate)
library(readxl)
library(here)


# Import functions --------------------------------------------------------

source(here("fns", "define-clients.R"))


# Import and clean data ---------------------------------------------------

# internal consultation data ----------------------------------------------
consult_int <- 
  list.files(path = here("data"),
             pattern = "(\\d){4}\\D\\d-int\\.xls",
             full.names = TRUE 
  ) %>% 
  sapply(read_excel, simplify = FALSE) %>% 
  bind_rows() %>% 
  mutate(
    `Collected date` = mdy(`Collected date`),
    `Sequence Group` = str_replace(`Sequence Group`, "\\*SURG", "SURG"),
    `Sequence Group` = str_replace(`Sequence Group`, "OP SURG", "SURG OP"),
    `Sequence Group` = str_replace(`Sequence Group`, "OP NGYN", "NGYN OP"),
    type = str_extract(`Sequence Group`, "()[^(]+") %>% str_trim(),
    client = str_extract(`Sequence Group`, "(?<=\\().*?(?=\\))"),
    grp = client_abbr(`Sequence Group`),
    cl_grp = client_group(`Sequence Group`),
    `Consultation Type` = "Internal",
    `Intraoperative Type` = "--",
    Site = "--"
  ) %>% 
  select(`Collected date`, 
         cl_grp,
         Accession,
         `Result ID`, 
         `Primary Pathologist`,
         `Consultation Type`,
         `Intraoperative Type`,
         Site,
         Correlation
  ) %>% 
  rename(Client = cl_grp, 
         `Pathologist` = `Primary Pathologist`)

# external consultation data ----------------------------------------------
consult_ext <- 
  list.files(path = here("data"),
             pattern = "(\\d){4}\\D\\d-ext\\.xls",
             full.names = TRUE 
  ) %>% 
  sapply(read_excel, simplify = FALSE) %>% 
  bind_rows() %>% 
  mutate(
    `Collected date` = mdy(`Collected date`),
    `Sequence Group` = str_replace(`Sequence Group`, "\\*SURG", "SURG"),
    `Sequence Group` = str_replace(`Sequence Group`, "OP SURG", "SURG OP"),
    `Sequence Group` = str_replace(`Sequence Group`, "OP NGYN", "NGYN OP"),
    type = str_extract(`Sequence Group`, "()[^(]+") %>% str_trim(),
    client = str_extract(`Sequence Group`, "(?<=\\().*?(?=\\))"),
    grp = client_abbr(`Sequence Group`),
    cl_grp = client_group(`Sequence Group`),
    `Consultation Type` = "External",
    `Intraoperative Type` = "--",
    Site = "--"
  ) %>% 
  select(`Collected date`, 
         cl_grp,
         Accession,
         `Result ID`, 
         `Primary Pathologist`, 
         `Consultation Type`,
         `Intraoperative Type`,
         Site,
         Correlation
  ) %>% 
  rename(Client = cl_grp, 
         `Pathologist` = `Primary Pathologist`)

# intraoperative consultation data ----------------------------------------
consult_iop <- 
  list.files(path = here("data"),
             pattern = "(\\d){4}\\D\\d-iop\\.xls",
             full.names = TRUE 
  ) %>% 
  sapply(read_excel, simplify = FALSE) %>% 
  bind_rows() %>% 
  mutate(
    `Collected date` = mdy(`Collected date`),
    `Sequence Group` = str_replace(`Sequence Group`, "\\*SURG", "SURG"),
    `Sequence Group` = str_replace(`Sequence Group`, "OP SURG", "SURG OP"),
    `Sequence Group` = str_replace(`Sequence Group`, "OP NGYN", "NGYN OP"),
    type = str_extract(`Sequence Group`, "()[^(]+") %>% str_trim(),
    client = str_extract(`Sequence Group`, "(?<=\\().*?(?=\\))"),
    grp = client_abbr(`Sequence Group`),
    cl_grp = client_group(`Sequence Group`),
    `Consultation Type` = "Intraoperative"
  ) %>% 
  select(`Collected date`, 
         cl_grp,
         Accession,
         `Result ID`, 
         `IntraOp Path`,
         `Consultation Type`,
         `IntraOp Type`,
         Site, 
         Correlation
  ) %>% 
  rename(Client = cl_grp, `Intraoperative Type` = `IntraOp Type`, 
         `Pathologist` = `IntraOp Path`)

# Merge consult data ------------------------------------------------------

consult_review <- 
  consult_ext %>% 
  bind_rows(consult_int) %>% 
  bind_rows(consult_iop) %>% 
  filter(as_date(`Collected date`) >= "2021-03-01" & 
           as_date(`Collected date`) <= "2021-06-30", 
         Correlation != "YES" & 
           Correlation != "Select", 
         Client == "Banner Health") %>% 
  arrange(Client, `Pathologist`, `Collected date`) %>% 
  rename(`Collected Date` = `Collected date`)

# write_csv(consult_review, 
#           here("output", "Case-Review-2021q1.csv"))

writexl::write_xlsx(consult_review, here("output", "Case-Review-2021q2.xlsx"))
