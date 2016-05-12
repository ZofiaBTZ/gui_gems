# An example for Gems_GUI package 
# A simple hepatitis progression model with 6 states,
# Exponential and Weibull hazard functions are used 
# as well as time to transition function.
# The hazard functions in this example are not based on real data.
#
# Author: ZOfia Baranczuk

cohortSize <- 1000
numStates <- 6
statesNames <- c("hep_no_treatment", #1
                 "hep_treatment",    #2
                 "clearance",        #3
                 "cirrhosis",        #4
                 "HCC",              #5
                 "death"             #6
) 


# baselineFunction samples from user defined distributions to set 
# the baseline for the whole cohort. Here, the factors in the baseline are 
# sex and age. Sex is sampled from the binomial distribution with p=0.5, 
# age is uniformly distributed from the range from 10 years to 60 years. 
baselineFunction <- function(par_cohortSize) {
  data.frame(sex=rbinom(par_cohortSize, 1, .5), age=runif(par_cohortSize, 10,60))
}


# bl_hf is an example of hazard function based on the baseline 
bl_hf_const <- function(t,bl){
  rep(10/bl["Age"], length(t))
}


# bl_hf is an example of hazard function based on the baseline 
bl_hf <- function(t,bl){
  rep(10/(80-(bl["Age"] + t)))
}


# hfNames is an array with the names of hazard functions. On the diagonal 
# and below only "NULL" is allowed, because only the transitions to states 
# with higher numbers are allowed.  
#
hfNames <- array(rep("impossible", 36), dim = c(6,6))
hfNames[col(hfNames)<=row(hfNames)]<-"NULL"
hfNames[1, 2:4] <- rep("Exponential",3)
hfNames[5,6] <-"Exponential"
hfNames[3,4:5] <-  rep("bl_hf",2)
hfNames[1:4,6] <- rep("bl_hf", 4)
hfNames[2, 4:5] <- rep("Weibull", 2)

rownames(hfNames) <- statesNames
colnames(hfNames) <- statesNames

# generating the matrix with hazard functions based on its names (hfNames)
# for the simulation
M <- makeM(hfNames)


# generateParameterMatrix generates a matrix with parameters for 
# the hazard functions defined in matrix M.hf The lists of parameters are  
#pp <- generateParameterMatrix(M)
#for (f in seq(2:6)){ 
 # for (g in seq(1:(f-1))){
  #  pp[[g,f]] <- list(rate=runif(1,0.005, 0.4))
  #}
#}

pp[[5,6]] <- list(rate=0.25)

#pp[[3,4]] <- list()
#pp[[3,5]] <- list()

#pp[[1,6]] <- list()
#pp[[2,6]] <- list()
#pp[[3,6]] <- list()
#pp[[4,6]] <- list()

#pp[[2,4]] <- list()
#pp[[2,5]] <- list()
params <- pp




