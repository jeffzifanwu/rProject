# Check optimal values
HC <- committedLabour(w, me1)
ump.H1 <- uncompensatedLabour(w, me1, te1)
ump.T1 <- totalLabour(ump.H1, HC)
ump.U1 <- utility(ump.H1, w, me1, te1)

# marginal utilities
mUC = 2 * alphaC * w * ump.H1 + betaC  
mUCC= 2 * alphaC
D = mUC + w * mUCC * ump.T1 # segment determinant


# Print results
cat(headerStr, "\n")
cat("  Time endowment:", te1, "\n")
cat("  HC: ", HC, "\n")
cat("  ump.H1: ", ump.H1, "\n")
cat("  ump.T1:", ump.T1, "\n")
cat("  ump.T1 (% change):", (ump.T1 - ump.T)/ump.T, "\n")
cat("  ump.U1:", ump.U1, "\n")
cat("  ump.U1 (% change):", (ump.U1 - ump.U)/ump.U, "\n\n")

cat("  Determinant (D)", "\n")
cat("    if D < 0, then occupies the upper segment", "\n")
cat("    otherwise, middle segment", "\n")
cat("  D: ", D, "\n\n")