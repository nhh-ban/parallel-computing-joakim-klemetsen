# The solution script where you rewrite the function 
# MTweedieTests to split the M simulations in more than 
# one core, and otherwise let the original script remain 
# unchanged.
# ----------------------------------------------------------

# Assignment 1:  
library(tweedie) 
library(ggplot2)

simTweedieTest <-  
  function(N){ 
    t.test( 
      tweedie::rtweedie(N, mu=10000, phi=100, power=1.9), 
      mu=10000 
    )$p.value 
  } 


# Assignment 2:

MTweedieTests <-  
  function(N,M,sig){ 
    results <- foreach(
      1:M, 
      .combine = "c"
      ) %dopar% {
      simTweedieTest(N)
    }
    sum(results < sig) / M
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

# Define number of cores to use
Cores <- 4

# Register a parallel backend
cl <- makeCluster(Cores)
registerDoParallel(cl)

# Export the simTweedieTest function to the workers
clusterExport(cl, c("simTweedieTest"))

for(i in 1:nrow(df)){ 
  df$share_reject[i] <-  
    MTweedieTests( 
      N=df$N[i], 
      M=df$M[i], 
      sig=.05) 
} 

# Stop the parallel backend
stopCluster(cl)
