library(dplyr)
library(rlang)

# Sample:
# df.ans = summariseDataframe(df.sv, c("work_mode"), exprs( cnt = n() ) )

# Function
summariseDataframe <- function(df, group_expr, summarise_expr) {
  
  # Debug print
  inputRowNumber = nrow(df)
  logFile <- file("log.txt", open = "a")
    sink(logFile)
    funcName = paste(as.character(match.call()), collapse = "~")
    cat(paste0(funcName, ": begins \n"))
    cat(paste0("Input dataframe row number: ", inputRowNumber, "\n"))
    sink()
  close(logFile)
  
  # Function
  # cat("1")
  df <- df %>%
    group_by(!!!syms(group_expr)) %>%
    summarise(!!!summarise_expr)
  # cat("2")
  # Debug print
  outputRowNumber = nrow(df)
  outputDf        = capture.output(print(df))
  logFile <- file("log.txt", open = "a")
    sink(logFile)
    cat(paste0("Output dataframe row number: ", outputRowNumber, "\n"))
    cat(outputDf, sep = "\n")
    sink()
  close(logFile)
  
  return(df)
  
}