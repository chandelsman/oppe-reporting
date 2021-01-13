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
    cl_grp = client_group(`Sequence Group`)
  ) %>% 
  select(`Collected date`, 
         `Result ID`, 
         `Primary Pathologist`, 
         cl_grp,
         Correlation
  ) %>% 
  rename(Client = cl_grp)

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
    cl_grp = client_group(`Sequence Group`)
  ) %>% 
  select(`Collected date`, 
         `Result ID`, 
         `Primary Pathologist`, 
         cl_grp,
         Correlation
  ) %>% 
  rename(Client = cl_grp)

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
    cl_grp = client_group(`Sequence Group`)
  ) %>% 
  select(`Collected date`, 
         `Result ID`, 
         `IntraOp Path`, 
         cl_grp,
         Correlation
  ) %>% 
  rename(Client = cl_grp, `Primary Pathologist` = `IntraOp Path`)

# Merge consult data ------------------------------------------------------

consult_review <- 
  consult_ext %>% 
  bind_rows(consult_int) %>% 
  bind_rows(consult_iop) %>% 
  filter(as_date(`Collected date`) >= "2020-10-01" & 
           as_date(`Collected date`) <= "2020-12-31", 
         Correlation != "YES" & 
           Correlation != "Select") %>% 
  arrange(Client, `Primary Pathologist`)

write_csv(consult_review, 
          here("output", "2020q4-consults-for-review.csv"))