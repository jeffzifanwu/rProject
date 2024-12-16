# Example:
# tmp = compareDataframe(df.invOhWorkDay, df.invOhWorkDay.New)

# df1 = df.main
# df2 = df.main_

# Load necessary library
library(dplyr)

# Define the function to compare two dataframes
compareDataframe <- function(df1, df2) {
  # Check if both dataframes have the same number of columns and the same column names
  if (!identical(colnames(df1), colnames(df2))) {
    stop("Dataframes have different column names or number of columns")
  }
  
  # Ensure both dataframes have the same number of rows
  if (nrow(df1) != nrow(df2)) {
    stop("Dataframes have different number of rows")
  }
  
  # Replace all NA values with "N/A"
  df1 <- df1 %>%
    mutate_all(~ ifelse(is.na(.), "N/A", .))
  df2 <- df2 %>%
    mutate_all(~ ifelse(is.na(.), "N/A", .))
  
  
  # Create a logical matrix where TRUE indicates a difference between the dataframes
  diff_matrix <- df1 != df2
  
  # Find the rows that differ
  differing_rows <- apply(diff_matrix, 1, any)
  
  # Report the rows that differ
  differing_df <- df1[differing_rows, , drop = FALSE]
  
  if (nrow(differing_df) == 0) {
    cat("The dataframes are identical\n")
  } else {
    cat("Rows that differ:\n")
    print(differing_df)
  }
  
  return(differing_df)
}
