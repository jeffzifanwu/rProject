
library(copula) # check if the library is already installed
install.packages("copula")

library(dataHelper) # check if the library is already installed
library(dataHelper)

library(did)
install.packages("lava")
install.packages("BH")
install.packages("did")

library(devtools)
install.packages("devtools")

remove.packages("dataHelper")
library(dataHelper)
devtools::install_github("jeffzifanwu/dataHelper")

# Setting up copilot
install.packages("chattr", repos = c("https://mlverse.r-universe.dev", "https://cloud.r-project.org"))
chattr::chattr_app()
