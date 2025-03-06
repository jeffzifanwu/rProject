# Housekeeping
source("procedures/beginScript.R")

# Log
library(dataHelper)
sink("log.txt") # Warning: Must not change the file name!!! It is hard-coded everywhere
sink()

# Library
library(dplyr)
library(did)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Create ids ----
# - - - - - - - - - - - - - - - - - - - - - - - - - - - -

nSite = 40 # Four groups, 10 sites in each group.
nPeriod = 28

# dataframe
df.simData = genDimIds(
  dimSize = c(nSite, nPeriod)
  , dimName = c("site_id", "period_id")
)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Error terms ----
# - - - - - - - - - - - - - - - - - - - - - - - - - - - -

df.simData$error_term   = rnorm(nrow(df.simData), mean = 0, sd = 10)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Fixed effects ----
# - - - - - - - - - - - - - - - - - - - - - - - - - - - -

## site effect ####
df.siteEffect = data.frame(site_id = 1:nSite) %>%
  mutate(site_fixed_effect = if_else(site_id %% 2 == 0, 20, 10)) %>%
  mutate(site_fixed_effect = 0)

df.simData = df.simData %>%
  left_join(df.siteEffect, by = "site_id")

## period effect ####
df.simData = df.simData %>%
  group_by(period_id) %>%
  mutate(period_fixed_effect = ifelse(period_id %% 7 == 0, -20, 0)) %>%
  mutate(period_fixed_effect = period_id) %>%
  ungroup()

# - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Predictors ----
# - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# base traffic
df.simData$base = 100

# treatment group
df.simData = df.simData %>%
  mutate(treatment_group = case_when(
      site_id <= 1/4*nSite ~ 8 # treated on period 8
    , site_id <= 2/4*nSite ~ 15 # treated on period 15
    , site_id <= 3/4*nSite ~ 22 # treated on period 22
    , .default = 0 # external sites - never treated
  )) %>%
  mutate(in_treatment_group = if_else(
      treatment_group %in% c(8, 15, 22)
    , TRUE
    , FALSE
  ))

# post policy indicator
df.simData = df.simData %>%
  mutate(post_policy = case_when(
      treatment_group == 8  & period_id >= 8  ~ TRUE
    , treatment_group == 15 & period_id >= 15 ~ TRUE
    , treatment_group == 22 & period_id >= 22 ~ TRUE
    , .default = FALSE
  )) 

# LTN size
df.simData = df.simData %>%
  mutate( ltn_size = case_when(
      treatment_group == 8  ~ 5
    , treatment_group == 15  ~ 7
    , treatment_group == 22  ~ 9
    , .default = 7
  ))

# Composite indicator - treated unit
df.simData = df.simData %>%
  mutate(is_treated     = if_else(in_treatment_group & post_policy, 1, 0)) %>%
  mutate(treatment_size = is_treated*ltn_size )

# treatment effect
user.treatmentEffect = "homogenous" # user defined variable

if (user.treatmentEffect == "homogenous") {

  f.homoTreatment = function(x) -50*x 
  
  df.simData = df.simData %>% mutate(treatment_effect = f.homoTreatment(is_treated))
  
} else if (user.treatmentEffect == "size") {
  
  f.sizeTreatment = function(x) -5*x 
  
  df.simData = df.simData %>% mutate(treatment_effect = f.sizeTreatment(treatment_size))
  
} else {
  
  stop("Unknown treatment effect")
  
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Outcome ----
# - - - - - - - - - - - - - - - - - - - - - - - - - - - -

df.simData = df.simData %>%
  mutate(obsv = base + 
   treatment_effect +
   site_fixed_effect +
   period_fixed_effect +
   error_term
  )

# - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Estimate: Homogenous treatment ----
# - - - - - - - - - - - - - - - - - - - - - - - - - - - -

df.est = df.simData # %>%
  # mutate(is_day7 = if_else(period_id %% 7 == 0, TRUE, FALSE))

mdl = lm(obsv ~ as.factor(is_treated) + as.factor(site_id) + as.factor(period_id), data = df.est)

summary(mdl)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Estimate: Heterogenous treatment by ltn size ----
# - - - - - - - - - - - - - - - - - - - - - - - - - - - -

df.est = df.simData

mdl = lm(obsv ~ treatment_size + as.factor(site_id) + as.factor(period_id), data = df.est)

summary(mdl)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Estimate: did multiple periods ----
# - - - - - - - - - - - - - - - - - - - - - - - - - - - -

df.est = df.simData

out <- att_gt(
  yname  = "obsv",
  gname  = "treatment_group",
  idname = "site_id",
  tname  = "period_id",
  # xformla = ~1,
  data = df.est,
  control_group = "nevertreated",
  est_method = "dr"
)

summary(out)
ggdid(out)

# Notes
# - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# JW 20250212: pre-test Wald statistics are not reported. This happens because 
# there are too many pre-treatment periods (hence parameters). It is okay. One
# can use the plots to check pre-test trend. The Wald statistics is reported
# in synData4_didFourPeriods.R

# - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Clean up ----
# - - - - - - - - - - - - - - - - - - - - - - - - - - - -
source("procedures/endScript.R")