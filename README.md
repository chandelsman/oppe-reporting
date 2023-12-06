# OPPE Reporting

Ongoing Professional Practice Evaluation stats are produced quarterly as 
part of compliance reporting. Stats for turnaround time and consultations 
are produced for most hospital networks.

## Overview

Quarterly Ongoing Professional Practice Evaluation Reports provided to clients. Report data are obtained from three dynamic reports in LigoLab (PATHDASH, Intraop, Consultation information). The final OPPE Reports are generated from an Rmarkdown script that compiles and summarizes data by client. PDF versions of the Reports are saved in client specific folders in SharePoint (Compliance > Pathologist Quality Data Reports).

Each report includes OPPE Reporting > Turnaround Time statistics (for the facility and per pathologist) and counts of OPPE Reporting > Internal Consultations, OPPE Reporting > External Consultations, and OPPE Reporting > Intraoperative Consultations consultations summarized by corroboration status. Note that not all consultations are performed at every facility.

Each OPPE Reporting > OPPE Reporting Clients Facilities receives its own report and has pathologist responsible for seeing that "pathologist reports" are filled out and submitted to the client.

## Data

Independent datasets are combined to summarize turnaround time, internal consultations, external consultations, and intra-operative consultations.

### Turnaround Time

Query is performed in LigoLab 

- Reporting > Dynamic Reports > Stats Pathologist TAT
- needs to be run for each month of the quarter independently or LigoLab will crash
    - LigoLab may freeze and need to be force quit

**Main Tab**

- Received Date = range of appropriate month
- SURG and NON-GYN cases should be included
    - this is already filtered by the dynamic report

**Export Data**

- export data as Excel to IT > Projects > oppe-reporting > data
    - file naming: YYYYqX.#-tat

### Internal Consultations

Query is performed in LigoLab

- Reporting > Dynamic Reports > Stats Consultations

**Base Tab**

- Received Date = Last Quarter
- Consult Type = Internal
- Consult Status = Complete

**Export Data**

- export data as Excel to IT > Projects > oppe-reporting > data
    - file naming: YYYYqX-int

### **External** Consultations

Query is performed in LigoLab

- Reporting > Dynamic Reports > Stats Consultations

**Base Tab**

- Received Date = Last Quarter
- Consult Type = External
- Consult Status = Complete

**Export Data**

- export data as Excel to IT > Projects > oppe-reporting > data
    - file naming: YYYYqX-ext

### Intraoperative Consultations

Query is performed in LigoLab

- Reporting > Dynamic Reports > Stats Intraop

**Base Tab**

- Created Date Range = Last Quarter

**IntraOp Consultation Tab**

- set 'IntraOp' to 'present'

**Export Data**

- export data as Excel to IT > Projects > oppe-reporting > data
    - file naming: YYYYqX-iop

### Melissa Memorial

A case report is produced for Dr. Hamner to review with Melissa Memorial Hospital

Query is performed in LigoLab

- Reporting > Dynamic Reports > Melissa Memorial Hospital Case Report

**Main Tab**

- Received = Last Quarter
- Client = 6222

**Export Data**

- export data as Excel to Compliance > Pathologist Quality Data Reports > Melissa Memorial Hospital > YYYY_Q#
- Name file Melissa-Cases-YYYYq#

## Output

### Build Reports

Two Rmarkdown scripts run all reports. The *ta-time-ind-facilities.Rmd* file produces reports for individual hospitals and clinics. The *ta-time-client-groups.Rmd* file produces reports for client groups with multiple facilities. *Note that UCHealth South facilities are run independently and UCHealth South is also run as a client group. Thus, there will be four individual reports plus one comprehensive report for UCHealth South.*

### Printing Reports

HTML files are opened in Chrome and printed to PDF at 100% scaling with headers and footers disabled.

### Sharing Reports

PDF Reports are uploaded to their respective client/facility folders in the Compliance SharePoint site (Compliance > General > Pathologist Quality Data Reports)

---

## Action items

- 

---

### Notes, links, and updates

### OPPE Reporting Clients/Facilities

*Last updated: 2020-01-01*

- Banner (BHS)
- Centers for Gastroenterology (CFG)
- Colorado Plains Medical Center (CPMC)
- Cheyenne Regional Medical Center (CRMC)
- Estes Park Health Hospital (EPMC)
- Ivinson Memorial Hospital (IMH)
- Kimball County Hospital (KHS) ← **Not being completed**
- Melissa Memorial Hospital (HS, MMH)
- Memorial Hospital of Carbon County (Rawlins, MH-Carbon)
- Memorial Hospital of Converse County (MHCC DC, MH-Converse)
- UC Health North (UCH-North)
- UC Health South (UCH-South_Summary)
- UC Health South Grandview Hospital (UCH-South_Grandview)
- UC Health South Memorial Hospital Central (UCH-South_Mem-Central)
- UC Health South Memorial Hospital North (UCH-South_Mem-North)
- UC Health South Pikes Peak Regional Hospital (UCH-South_Pikes-Peak)
- Wyoming Veterans Administration (WYVA)