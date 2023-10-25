# The solution script where you rewrite 
# the final loop to use parallel computing.
# ------------------------------------------------

# Assignment 1:  
library(tweedie) 
library(ggplot2)

simTweedieTest <-  
  function(N){ 
    t.test( 
      rtweedie(N, mu=10000, phi=100, power=1.9), 
      mu=10000 
    )$p.value 
  } 


# Assignment 2:  
MTweedieTests <-  
  function(N,M,sig){ 
    sum(replicate(M,simTweedieTest(N)) < sig)/M 
  } 


# Assignment 3: 
df <-  
  expand.grid( 
    N = c(10,100,1000,5000, 10000), 
    M = 1000, 
    share_reject = NA) 

# --- Parallel computing ---
library(parallel)
library(doParallel)
library(foreach)

# Define number of cores to use
Cores <- 4

# Register a parallel backend
cl <- makeCluster(Cores)
registerDoParallel(cl)

# Parallelize the loop
results <- foreach(
  i = 1:nrow(df), 
  .combine = c) %dopar% 
  {
  MTweedieTests(
    N = df$N[i], 
    M = df$M[i], 
    sig = 0.05)
}

# Assign the results to df$share_reject
df$share_reject <- results

# Stop the parallel backend
stopCluster(cl)