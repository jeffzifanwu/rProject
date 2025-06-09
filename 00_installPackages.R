remove.packages("dataHelper")
install.packages("copula")
install.packages("lava")
install.packages("BH")

# Data analysis
devtools::install_github("jeffzifanwu/dataHelper")

# Difference-in-differences
install.packages("did")
devtools::install_github("xuyiqing/fect")

# GitHub
library(devtools)
install.packages("devtools")

# Setting up copilot
install.packages("chattr", repos = c("https://mlverse.r-universe.dev", "https://cloud.r-project.org"))
chattr::chattr_app()

# Documentation (Quarto)
if (!require("DT")) install.packages('DT')

# Panel data
if (!require("panelView")) install.packages('panelView')

# Data visualization
if (!require("ggplot2")) install.packages('ggplot2')
