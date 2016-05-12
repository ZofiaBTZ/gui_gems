numStates <- 6
statesNames <- c("CHBV_nEFT", #1
                    "CHBV_EFT",  #2
                    "clearance", #3
                    "Cirrhosis", #4
                    "HCC",       #5
                    "death"      #6
                    ) #
                    

baselineFunction <- function(cohortSize) {
  data.frame(sex=rbinom(cohortSize, 1, .5), age=runif(cohortSize, 10,60), 
             Genotype=floor(runif(cohortSize, 0,4)))
}



hfNames <- array(rep("Exponential", 36), dim = c(6,6))
hfNames[3,4:5] <-  rep("bl_hf",2)
hfNames[1:4,6] <- rep("bl_hf", 4)
hfNames[2, 4:5] <- rep("treat.fun", 2)
hfNames[col(hfNames)<=row(hfNames)]<-"NULL"
rownames(hfNames) <- statesNames
colnames(hfNames) <- statesNames
M <- makeM(hfNames)

#M@list.matrix[row(M@list.matrix)<col(M@list.matrix)]<-"Exponential"
#hf@list.matrix[2,3:6] <- rep("impossible",4)
#M@list.matrix[3,4:5] <- rep("AToB",2)
#print(hf)

pp <- generateParameterMatrix(M)
for (f in seq(2:6)){ 
for (g in seq(1:(f-1))){
  pp[[g,f]] <- list(rate=runif(1,0.005, 0.4))
}
}

pp[[5,6]] <- list(rate=0.25)
pp[[3,4]] <- list()
pp[[3,5]] <- list()


pp[[1,6]] <- list()
pp[[2,6]] <- list()
pp[[3,6]] <- list()
pp[[4,6]] <- list()

pp[[2,4]] <- list()
pp[[2,5]] <- list()
params <- pp

cohortSize <- 200
