## Data generating process plots ##
library(spatstat)

## Simulating the Covariates ##

#Grid for simulation
x0 <- seq(-1.3, 4.3, length = 100)
y0 <- seq(-1.3,4.3, length = 100)
gridlocs <- expand.grid(x0,y0)

# Covariates for true ecological state
gridcov <- outer(x0, y0, function(x,y) cos(x) - sin(y - 2))
covariate.im <- im(gridcov, x0, y0)

#Covariate for the sampling process
gridcov_thin <- outer(x0, y0, function(x,y) cos(2*x) - sin(2*y-4))
covariate_thin.im <- im(gridcov_thin, x0, y0)

#Covariate for the detection
gridcov_det <- outer(x0, y0, function(x,y) (x/2)^2+(y/2)^2)
covariate_detect.im <- im(gridcov_det, x0, y0)

# cov: a list with the covariates needed by both the data generating process and the model we want to fit.
cov <- list(covariate.im,covariate_thin.im,covariate_detect.im)

## Generating the data ##

source("DataGeneration.R")

nspecies <- 4#nspecies: Number of species we want to simulate 

#input: List with the parameters of the model that generates CS data
input <-{list(
  ecological = list(
    fixed.effect=list(
      intercept = c(0.8, 2.5, -1.5, 1.2),
      betacov = c(1.5, -0.12, 2,-0.4)
    ),
    hyperparameters = list(
      sigma2 = c(0.2, 1.2, 2, 0.1),
      range = c(1.2, 2.5, 3.2, 0.22)
    )
  ),
  sampling = list(
    fixed.effect = list(
      intercept = c(1.3),
      betacov = c(-1.5)
    ),
    hyperparameters=list(
      sigma2 = c(0.2),
      range = c(2.5)
    )
  ),
  detection = list(
    
    fixed.effect = list(
      intercept=c(2,-0.3, 5, 1.2),
      betacov = c(-2, -0.5, -2.5, 2)
    )
  ),
  
  misclassification = list(
    
    class_prob <- matrix(c(0.9, 0.02, 0.04, 0.04,
                           0.05, 0.89, 0.04, 0.02,
                           0.1,0.1, 0.8, 0,
                           0, 0.05, 0.25, 0.7),
                         nrow=4, ncol=4, byrow = TRUE)
    
    
  )
)}

#idxs: A very simple list which tells which covariates belong to each stage of the data generating process
idxs <- list(eco=c(1),sampling=c(2),detection=c(3))

#seed: Random seed for replicating the datasets generated
seed <- 1036610602

#plot: Do we want to plot the results? Which results? ISSUE
plot = list(all=TRUE)

#Data simulation
simulateddata <- csdata(nspecies=nspecies,input=input,cov=cov,idxs=idxs,seed=seed,plot=plot)







