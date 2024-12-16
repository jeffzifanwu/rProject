library(dplyr)
library(rlang)

# Template and example
# df.worker = filterDataframe( df.worker, expr( !is.na(p_occup_workload) ) )

# Function
filterDataframe <- function(df, condition) {
  
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
  df <- df %>%
    
    filter(!!condition)
  
  # Debug print
  outputRowNumber = nrow(df)
  logFile <- file("log.txt", open = "a")
    sink(logFile)
      cat(paste0("Output dataframe row number: ", outputRowNumber, "\n"))
      cat(paste0("Removed: ", inputRowNumber - outputRowNumber, "\n"))
    sink()
  close(logFile)
  
  return(df)
  
}