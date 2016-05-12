numStates <- 6
statesNames <- c("CHBV_nEFT", #1
                    "CHBV_EFT",  #2
                    "clearance", #3
                    "Cirrhosis", #4
                    "HCC",       #5
                    "death"      #6
                    ) #
                    

baselineFunction <- function(cohortSize) {
  data.frame(sex=rbinom(cohortSize, 1, .5), age=runif(cohortSize, 10,60))
}



hfNames <- array(rep("Exponential", 36), dim = c(6,6))
hfNames[3,4:5] <-  rep("impossible",2)
hfNames[col(hfNames)<=row(hfNames)]<-"NULL"
rownames(hfNames) <- statesNames
colnames(hfNames) <- statesNames
print(hfNames)
print(dim(hfNames))
M <- makeM(hfNames)

#M@list.matrix[row(M@list.matrix)<col(M@list.matrix)]<-"Exponential"
#hf@list.matrix[2,3:6] <- rep("impossible",4)
#M@list.matrix[3,4:5] <- rep("AToB",2)
#print(hf)

pp <- generateParameterMatrix(M)
pp[[1,2]] <- list(rate=(0.7))
pp[[1,3]] <- list(rate=(0.7))
pp[[1,4]] <- list(rate=(0.02))
pp[[1,5]] <- list(rate=(0.01))
pp[[1,6]] <- list(rate=(0.007))

pp[[2,3]] <- list(rate=(0.02))
pp[[2,4]] <- list(rate=(0.03))
pp[[2,5]] <- list(rate=(0.04))
pp[[2,6]] <- list(rate=(0.007))

pp[[3,4]] <- list()
pp[[3,5]] <- list()
pp[[3,6]] <- list(rate=0.007)

pp[[4,5]] <- list(rate=0.1)
pp[[4,6]] <- list(rate=0.06)

pp[[5,6]] <- list(rate=0.25)

params <- pp

cohortSize <- 200
