# Dataframes to be compared
df1 = read.csv("dataRaw/t2_3_traffic - count.csv")
df2 = read.csv("dataRaw/archive/t2_3_traffic - count.csv")

# Load comparison function
source("function/compareDataframes.R")

# Results
tmp = compareDataframe(df1, df2) 
tmp1 = tmp$extra_in_df1
tmp2 = tmp$extra_in_df2
tmp3 = tmp$differences
