#' prepares a baseline function with sex and age of individuals 
#' @name baselineFunction_sex_age
#' @usage
#' cohortSize <- 1000
#' baseline <- baselineFunction_sex_age(cohortSize) # returns a data.frame with age and sex of individuals
#' @author Zofia Baranczuk 
#'  
#' 
#' @description This function prepares a data.frame baseline

#'@export
baselineFunction_sex_age <- function(cohortSize) {
  age_lower_limit = 20
  age_upper_limit = 60
  data.frame(sex=rbinom(cohortSize, 1, .5), age=runif(cohortSize, age_lower_limit,age_upper_limit)) 
}
