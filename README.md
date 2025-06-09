# R project - A quick start template

This repository serves as a template to help quickly initiate an R project for data processing and modeling. It includes a pre-configured structure and essential scripts, enabling you to focus on analysis while streamlining project setup.

## Use case 1

Start a new repository based on this template.\
Use the `00_installPackages.R script` to install libraries.\
The `scriptTemplate` folder provides templates to help you start scripting in R.

## Use case 2

Source reusable functions, class definitions, and procedures directly from this repository in other projects.

``` r
# functions
source("https://raw.githubusercontent.com/jeffzifanwu/rProject/main/function/my_function.R")

# classes
source("https://raw.githubusercontent.com/jeffzifanwu/rProject/main/class/my_class.R")

# procedures
source("https://raw.githubusercontent.com/jeffzifanwu/rProject/main/procedures/beginScript.R")
source("https://raw.githubusercontent.com/jeffzifanwu/rProject/main/procedures/endScript.R")
source("https://raw.githubusercontent.com/jeffzifanwu/rProject/main/procedures/setGgplotThemes.R")
```

Note: functions and classes are being migrated to the [**dataHelper**](https://github.com/jeffzifanwu/dataHelper) R package.New functions and classes will only be updated there.

## Use case 3

Use the synthetic datasets in `synDataAndModel` for testing your models and/or algorithms.

`synData1_`: collinear predictors

`synData2_`, `synData3_`, `synData4_`: difference-in-differences

`synData5_`: binary outcomes
