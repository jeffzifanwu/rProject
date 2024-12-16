# Housekeeping
rm(list = ls())
cat("\014")
options(scipen = 999)
options(digits = 2)

# Log
library(dataHelper)
myLog = logging$new("log.txt") # Warning: Must not change the file name!!! It is hard-coded everywhere
myLog$createFile()

# library
library(dplyr)

# Load data ----
load("dataProcessed/00_myData.rdata")

# - - - - - - - - - - - - - - - - - - - - - - - -
# Level 1 ----
# - - - - - - - - - - - - - - - - - - - - - - - -

## Level 2####


# - - - - - - - - - - - - - - - - - - - - - - - -
# Output  ----
# - - - - - - - - - - - - - - - - - - - - - - - -

save(df0,  file = "dataProcessed/00_myData.rdata")

# clean up ----
rm(list = ls())
cat("\014")
