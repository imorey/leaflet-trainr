#-------------------------------------------------------------------------------
#
### Loop generation of Markdown documents
#
#-------------------------------------------------------------------------------
# Generate Markdown reports looped for each Network
setwd("~/GitHub/leaflet-trainr")
library(readxl)
library(markdown)
library(rmarkdown)
# See reference for generating multiple reports: https://reed.edu/data-at-reed/software/R/markdown_multiple_reports.html

### Prepare data ---------------------------------------------------------------
schools <- read.csv("https://data.cityofchicago.org/api/views/2m8w-izji/rows.csv",
                    stringsAsFactors = FALSE) %>%
  within({
    temp <- Latitude
    Latitude <- Longitude # ...because these are accidentally backwards
    Longitude <- temp
    PolicyLevel <- factor(CPS.Performance.Policy.Level)
    rm(temp)
  })
  
# Download and merge an Excel file with enrollment data
download.file(url = "http://cps.edu/Performance/Documents/Datafiles/enrollment_20th_day_2014.xls",
              destfile = "sch_enrollment_xls.xls", method = "curl")
sch_enrollment <- read_excel("sch_enrollment_xls.xls")
sch_merge <- merge(x = schools,
                   y = sch_enrollment,
                   by.x = "School.ID",
                   by.y = "School ID") %>%
  subset(grepl("LEVEL", CPS.Performance.Policy.Level))


### Run reports ----------------------------------------------------------------
# /!\ This generates html documents that have everything (including titles with
# values defined by the loop) but not the interactive Shiny elements. 
for (myNetwork in unique(sch_merge$Network)){
  rmarkdown::render(input = "code/demo-of-shiny-and-leaflet--for-multiple-reports.Rmd",
                    output_format = "all",
                    output_file = paste0("School-explorer-5Essentials_", gsub(" ", "-", myNetwork), ".html"),
                    output_dir = "output",
                    runtime = "shiny")
}

