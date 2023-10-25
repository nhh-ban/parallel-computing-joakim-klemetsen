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

# Define max cores
maxcores <- 4

# Update the "Cores"-value to the minimum of the 
# chosen cores and the available cores.
Cores <- min(detectCores(), maxcores)

# Initiate the cores
cl <- makeCluster(Cores)

# Register the cluster ..
registerDoParallel(cl)

for(i in 1:nrow(df)){ 
  df$share_reject[i] <-  
    MTweedieTests( 
      N=df$N[i], 
      M=df$M[i], 
      sig=.05) 
} 

# Close of the cluster
stopCluster(cl)
