# Housekeeping
rm(list = ls())
cat("\014")
options(digits = 2)
set.seed(123)

# Log
library(dataHelper)
sink("log.txt") # Warning: Must not change the file name!!! It is hard-coded everywhere
sink()

# Library
library(dplyr)


# - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Create ids ----
# - - - - - - - - - - - - - - - - - - - - - - - - - - - -

nSite = 30 # we assume 2/3 are in treatment group, 1/3 in control group
nPeriod = 28

# dataframe
df.tc = genDimIds(
  dimSize = c(nSite, nPeriod)
  , dimName = c("site_id", "period_id")
)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Error terms ----
# - - - - - - - - - - - - - - - - - - - - - - - - - - - -

df.tc$error_term   = rnorm(nrow(df.tc), mean = 0, sd = 10)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Fixed effects ----
# - - - - - - - - - - - - - - - - - - - - - - - - - - - -

## site effect ####
df.siteEffect = data.frame(site_id = 1:nSite) %>%
  mutate(site_fixed_effect = if_else(site_id %% 2 == 0, 20, 10))

df.tc = df.tc %>%
  left_join(df.siteEffect, by = "site_id")

## period effect ####
df.tc = df.tc %>%
  group_by(period_id) %>%
  mutate(period_fixed_effect = ifelse(period_id %% 7 == 0, -20, 0)) %>%
  ungroup()

# - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Predictors ----
# - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# base traffic
df.tc$base = 100

# treatment group
df.tc = df.tc %>%
  mutate(treatment_group = if_else(site_id <= 2/3*nSite, TRUE, FALSE))

# post policy indicator
df.tc = df.tc %>%
  mutate(post_policy = if_else(period_id > 14, TRUE, FALSE))

# LTN size
df.tc = df.tc %>%
  mutate( ltn_size = case_when(
      site_id <= 1/3*nSite ~ 5
    , site_id <= 2/3*nSite ~ 9
    , .default = 99
  ))

# Composite indicator - treated unit
df.tc = df.tc %>%
  mutate(is_treated     = if_else(treatment_group & post_policy, 1, 0)) %>%
  mutate(treatment_size = is_treated*ltn_size )

# treatment effect
user.treatmentEffect = "size" # user defined variable

if (user.treatmentEffect == "homogenous") {

  f.homoTreatment = function(x) -50*x 
  
  df.tc = df.tc %>% mutate(treatment_effect = f.homoTreatment(is_treated))
  
} else if (user.treatmentEffect == "size") {
  
  f.sizeTreatment = function(x) -5*x 
  
  df.tc = df.tc %>% mutate(treatment_effect = f.sizeTreatment(treatment_size))
  
} else {
  
  stop("Unknown treatment effect")
  
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Outcome ----
# - - - - - - - - - - - - - - - - - - - - - - - - - - - -

df.tc = df.tc %>%
  mutate(obsv = base + 
           treatment_effect +
           site_fixed_effect +
           period_fixed_effect +
           error_term
  )

# - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Estimate: Homogenous treatment ----
# - - - - - - - - - - - - - - - - - - - - - - - - - - - -

df.est = df.tc # %>%
  # mutate(is_day7 = if_else(period_id %% 7 == 0, TRUE, FALSE))

mdl = lm(obsv ~ as.factor(is_treated) + as.factor(site_id) + as.factor(period_id), data = df.est)

summary(mdl)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Estimate: Heterogenous treatment by ltn size ----
# - - - - - - - - - - - - - - - - - - - - - - - - - - - -

df.est = df.tc

mdl = lm(obsv ~ treatment_size + as.factor(site_id) + as.factor(period_id), data = df.est)

summary(mdl)


