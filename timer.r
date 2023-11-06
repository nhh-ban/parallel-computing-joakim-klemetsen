# Load packages
library(tictoc) # timer
library(dplyr)  # pipe-operator
library(tidyr)
library(stringr)


# --- Method 1: Solution as is ---

# Start timer
tic("(1) Solution as is")

# Execute the script containing the solution
source("scripts/method1.r")

# Stop timer
toc(log = TRUE)


# --- Method 2: Parallel computing ---

# Start timer
tic("(2) Solution using parallel computing")

# Execute the script containing the solution
source("scripts/method2.r")

# Stop timer
toc(log = TRUE)


# --- Method 3: Splitting simulations in multiple cores ---

# Start timer
tic("(3) Solution splitting simulations in multiple cores")

# Execute the script containing the solution
source("scripts/method3.r")

# Stop timer
toc(log = TRUE)


# --- Comparing of methods, which is fastest? ---

# Get the printTicTocLog-function
source("functions/functions.r")

# Compare the times of all methods
printTicTocLog() %>% 
  knitr::kable()

# Determine the fastest method. 
# What might explain the result?
'Method (3) was the fastest. This result is likely due to the solution
of dividing the computational workload of running the simulations on several cores.
Method (2) is quicker than (1) but slower than (3). This is beacuse it is more 
time efficient to parallelize the simulations than the loop.'