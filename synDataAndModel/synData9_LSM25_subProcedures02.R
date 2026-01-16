# starting values
w1 <- w
increment <- 0.001
tol <- 1e-2  # tolerance level
max_iter <- 1000  # to prevent infinite loops
for (i in 1:max_iter) {
  
  HC    <- committedLabour(w1, me1)
  ump.H1 <- uncompensatedLabour(w1, me1, te1)
  ump.T1 <- totalLabour(ump.H1, HC)
  ump.U1 <- utility(ump.H1, w1, me1, te1)
  
  # check convergence
  if (abs(ump.U1 - ump.U) < tol) {
    cat("Converged at w1 =", w1, "after", i, "iterations\n")
    break
  }
  
  # cat("  ump.U1:", ump.U1, "\n")
  # cat("  abs(diff):", abs(ump.U1 - ump.U), "\n")
  
  # increment w1
  w1 <- w1 + increment
}

if (i == max_iter) {
  cat("Reached maximum iterations without convergence\n")
}

# marginal utilities
mUC = 2 * alphaC * w * ump.H1 + betaC  
mUCC= 2 * alphaC
D = mUC + w * mUCC * ump.T1 # segment determinant

cat("  --- After policy (Wage rate-compensated) ---", "\n")
cat("  Target utility =", ump.U, "\n")
cat("  Wage rate:", w1, "\n")
cat("  Monetary endowment:", me1, "\n")
cat("  Time endowment:", te1, "\n")
cat("  HC: ", HC, "\n")
cat("  ump.T1:", ump.T1, "\n")
cat("  ump.T1 (% change):", (ump.T1 - ump.T)/ump.T, "\n")
cat("  ump.U1:", ump.U1, "\n")
cat("  ump.U1 (% change):", (ump.U1 - ump.U)/ump.U, "\n\n")

cat("  Determinant (D)", "\n")
cat("    if D < 0, then occupies the upper segment", "\n")
cat("    otherwise, middle segment", "\n")
cat("  D: ", D, "\n\n")