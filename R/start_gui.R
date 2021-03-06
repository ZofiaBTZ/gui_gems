
#' Starts graphical user interface for gems 
#' @name start_gui
#' @usage
#' start_gui() # start the rp.panel  with GUI for the package "gems"
#' @author Zofia Baranczuk 
#'  
#' 
#' @description This function start rp.panel-based GUI for gems.
#' The GUI can be used to define generalized multistate simulation model, 
#' run simulations for this model and analyze simulated cohorts.
#' 
#' start_gui() opens the model panel of the  Graphical User Interface for "gems".
#'
#' I. The model panel. 
#' 
#' The main part of this panel is a matrix with states and transitions between states.
#' Only transitions above the diagonal are allowed to assure no cycles in the model progression.
#'
#' There is a menu for every allowed transition.
#' One can choose one of the following options:
#' 
#' 1. Edit the current transition function.
#' \emph{current_transition_function_name_{i_j}}
#'
#'  This lets the user edit the defined transition function from state "i" to state "j".
#' The changes are automatically saved for the current R session. The is an option of saving the function as an .R file.
#' If current transition function name is one of the pre-defined
#' functions ("impossible", "Weibull", "multWeibull", "exponential"), only the text file with the name of 
#' the pre-defined function will be opened. To change the name of the function, use \emph{edit Hf names}.    
#'
#'
#' 2. Edit the parameters for the transition function. 
#' {par_{i_j}}
#' The table with the parameters for the current transition functions will be opened in the editor.
#' In the same table there is a place to set the covariance of parameters.
#' By default, it is set to 0.
#' If parameters weren't previously defined by the user, the paremeters for the transition function are set to the 
#' default value of the parameter (if it exists) or to 0. 
#'
#'
#' 3. Define a new transition function. 
#' {hf_{i_j}}
#' This options opens empty function to be edited by the user. It will be used as a transition function between states i and j.
#' After editing the function, it is saved in the environment under the name "hf_i_j". After editing the function, there is 
#' an option of saving it as an .R file.
#' 
#' Apart from defining the transition matrix, the user can:
#'
#'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#'  
#'- Set the number of states. It creates a new, empty (all transitions impossible) model with the given number of states.
#'
#'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#'
#'- Set <start rows> and <start columns>. If the model has more than 12 states, it is impossible to see the whole matrix. 
#' This way the user can choose which part of the transition matrix he/she wants to see. 
#' It sets the first row and the first column to be shown. 
#'
#'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#'
#' - Set <Cohort size>. Sets the size of the cohort to be simulated.
#' 
#' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#' 
#' - Add new state with a given <state_name>, <after> a given state number.
#' The user can write in the textentires the name of the state 
#' to be added and the state number, after which the new state should be added.
#' This is possible only, when states after the state to be added do not have history 
#' as the parameter in their transition functions. 
#' 
#' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#' 
#' - Load hazard functions:
#' Opens a dialog box so that the user can choose a directory. Source() will be called on all 
#' the files in the directory. All the functions from the files in the directory will be loaded into the current
#' environment.  
# TODO: non recursive. R files with errors? Try? 
#' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#' 
#' - Save the model:
#' Save the currently defined model using the dialog box.
#' Important - at this level only model is saved, even if the cohort was simulated. 
#' For saving the simulated cohort, save the model from the cohort panel.
#' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#'
#' - Load baseline:
#' Opens a dialogbox to choose a file. Source() is called on the chosen file. The function from the file
#'  will be used to generate baseline with the lenght of cohort size.  
#' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#' 
#' - Edit baseline:
#' The baseline function will be opened in the editor. The user can change it and save 
#' it in the current environment and as a baseline function for the current model and/or in an .R file.
#' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#' 
#' - Simulate Cohort:
#' Simulates the cohort for the model described in the panel using the function \code{simulateCohort()}.
#' After the cohort is simulated, \code{the basic cohort panel} is opened. See part II. 
#' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#' 
#' - Load model
#' Loads an .RData file or runs the .R file chosen by the user in a dialog box.
#' The file should either be a model saved in Gems session as an .RData file or be an .R file
#' inluding variables: 
#' \code{hf} - names of the hazard functions or \code{M} - hazard functions defined directly without a name;  
#' \code{parameters} - a matrix generated by \code{generateParametersMatrix(M)} with lists of names parameters for 
#'   the hazard functions defined in \code{hf} or \code{M}; 
#'  \code{cohortSize} - a number of items to be simulated,   
#'  
#' It may also include variables:
#' \code{covariances} - a matrix generated using \code{generateParametersCovariances(parameters)}. If covariances matrix
#' is not set in the file, all covariances are set to 0.  
#' \code{bl_function} - a function which will be used to generate a data frame with baseline or
#' \code{baseline} - a data frame with baseline.  
#'    
#' Loaded model can also have a simulated \code{cohort}. Then after loading the model, \code{the basic cohort panel} 
#' will be opened. See part II.
#' 
#' There are examples of defined models and hazard functions in the directory \code{Examples}. 
#'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#'
#' - Update panel
#' rp.panel after changing a parameter gets refreshed first after the next action.
#' Update panel refreshes the rp.panel and shows current values of variables.  
#'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#'
#' - Multiple cohorts
#'This button opens \code{the multiple cohorts panel}. See part IV. 
#'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#'
#' - Edit ttt matrix
#' Edits mypanel$ttt matrix - the matrix with information about which hazard functions are 
#' time to transition functions. \code{mypanel$ttt} gets changed.
#' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#' 
#' - Edit states names
#'The user can edit \code{mypanel$statesNames}. 
#'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#'
#' - Edit hf matrix
#'The user can edit \code{mypanel$hf}
#'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#'
#' - Plot hf graph. 
#' Plots a graph with all possible transitions between states.
#' Here "possible" means, that the transition between two states 
#' is allowed (above the diagonal in the matrix) and not set to "impossible".
#' Compare with \code{plotPath_n()} - the function in
#' \code{the basic cohort panel} and \code{the merged cohort panel} 
#' to plot paths that were present in the simulations  
#' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#' 
#' II. The basic cohort panel.
#' The basic cohort panel is opened after simulating a cohort or 
#' loading a model with a simulated cohort. The panel is used for running 
#' analysis on the cohort. There are following actions possible to run
#' in this panel: 
#' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#' 
#' -Edit Cohort --> TODO: change to view cohort
#' Shows the baseline and the transition times between states in the cohort.
#' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#' 
#' -Update Cohort <cohortSize>
#' Continues simulating the cohort till the size of the cohort reaches user 
#' defined new cohortSize. 
#' If user defined cohortSize is smaller or equal to the current cohort's size,
#' no action is taken.  
#' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#' 
#' -List subcohorts
#' Shows the list of all subcohorts in the model with the attached numbers, 
#' including the main subcohort (=the whole simulated cohort), the used defined subcohorts
#' and subcohorts following different progression paths, if the paths were plotted before
#' (using the button \code{plot paths})
#' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
#'    
#' -List states
#' Shows the list of all states in the model
#' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#' 
#' -Save the model
#' Opens the save dialog box to choose the name to save the model with the simulated cohort.
#' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#' 
#' -Plot paths
#' Simulated elements of the cohorts can follow different progression paths (go through different states).
#' \code{Plot paths} marks on the graph of possible
#' transitions the most frequent progression path in the cohort. The less frequent paths may be shown using 
#'  \code{plot next path}
#' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#' 
#' -Plot next paths
#' Marks on the graph of possible transitions next most frequent progression path.  
#' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#'
#' -Add subcohort <subcohort query> 
#' Creates a new subcohort according to the <subcohort query> in the text entry.
#' Subcohorts can be chosen based on the 
#' constraints about baseline characteristics or the simulated progression path and times of transmissions.
#' 
#' Examples of the input into the text entry to define a new subcohort:
#' \code{(cohortBl["sex"] ==1) & (cohortBl["age"]>40)}  will return a subcohort of people with gender 1 
#' older than 40. 
#' \code{is.na(cohortBl["HCC"])} will create a subcohort with simulated patients, who never got into "HCC" state. 
#' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#'   
#' -View subcohort <subcohort number>
#' Shows using View() the subcohort with the number defined in the text entry.
#' The numbers of cohorts with their definitions can be seen after pressing the \code{list cohorts} button.   
#' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#' 
#' -Plot <function name> <states> <subcohorts>
#' <Function name> The user can choose from the menu one of the functions to be plotted:
#' \code{transitionProbabilities}
#' \code{cumulativeIncidence} 
#' see: \code{?transitionProbabilities}, \code{?cumulativeIncidence}
#' <states> A list of states, for which the chosen function will be plotted.
#' Eg. \code{list(1:4)}, \code{list(c(1,3,5))}. 
#' If there is more than 6 states chosen, the plots will be opened in different windows.
#' 
#' <subcohorts> A list of subcohorts to be plotted. 
#' Eg. \code{list(1:3)}, \code{list(c(1,3))}
#' 
#' The user can check the numbers of defined subcohorts by clicking the button
#' \code{List subcohorts} 
#'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#'
#' -States groups <list of list of states to be merged>
#' This option let merging different states of the model. 
#' From the group of states to be merged, the time of entry to the earliest 
#' of the states counts as the entry time to the meta-state created from 
#' this group of states. The time of leaving of the last state from the group 
#' counts as the time of leaving the new meta-state. The name of the new state
#' is a convolution of the names of the states composing it connected by
#' a hyphen.
#'
#' Not all groups of states may be merged - in order to assure lack of cycles,
#' the states to be merged must be sequent ones.
#' States to be merged must be given in the form of a list of lists.
#' Eg. \code{list(list(1,2), list(3,4))} will merge the states 1 and 2 into one state, and states 3 and 4.   
#'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#'
#' Cost analysis module:
#' 
#' 1. Edit cost per unit:
#' The user can define in the editor costs per unit during the treatment. 
#' Default units are: \code{visit}, \code{test}, \code{medicine}, \code{fibroscan}
#' The user can define more cost units or change the current costs. 
#'
#' 2. Edit QALY per state:
#' The user can modify in the editor QALYs for each state of the model.
#'
#' 3. Edit cost per state:
#' The user can define cost of the treatment for each state of the model expressed in cost units 
#' in a time unit.
#' Eg. \code{3*medicine + 4* visit + fibroscan}
#' 
#' 4. Save cost:
#' Saves cost data in the form 
#' cost_list =list(units,qualy,StateCost), where units, qualy and StateCosts are lists.
#'  
#' 5. Load cost:
#' Loads the cost from the .RData file in the form as described in \code{Save cost}.
#  TODO: cost from .R file 
#' 6. Count cost:
#' It counts cost and QALY for the given cohort.
#' Units cost multiplied by the averaged time in a given state are put into the equations in \code{cost per state}.
#' At the level of one cohort, the cost and the QALYs are only shown in the new tab of R. For
#' a plot of cost vs. QALY, see the cost analysis in the \code{multiple cohort panel}.
#'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
#' 
#' III. The merged cohort panel.
#' The \code{merged cohort panel} is used to analyse the cohort after merging states. 
#' There are possible actions to be chosen:
#' 
#' -Edit cohort 
#' Shows the cohort in the new R Tab
#' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#' 
#' -List subcohorts
#' Shows the list of all subcohorts in the model with the attached numbers, including the main subcohort (=the whole simulated cohort)
#' and subcohorts following different progression paths, if the paths were plotted before (using the button \code{plot paths})
#' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
#'
#' -List states
#' Shows the list of all states in the model.
#' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#'
#' -Plot  paths
#' Simulated elements of the cohorts can follow different progression paths. \code{Plot paths} marks on the graph of possible
#'  transitions the most frequent progression path in the cohort. The less frequent paths may be shown using 
#'  \code{plot next path}
#' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#' 
#' -Plot next paths
#' Marks on the graph of possible transitions next most frequent progression path.  
#' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#' 
#' -Add subcohort <subcohort query> 
#' Creates a new subcohort according to the <subcohort query> in the text entry.
#' Subcohorts can be chosen based on the 
#' constraints about baseline characteristics or the simulated progression path and times of transmissions.
#' 
#' Examples of the input into the text entry to define a new subcohort:
#' \code{(cohortBl["sex"] ==1) & (cohortBl["age"]>40)}  will return a subcohort of people with gender 1 
#' older than 40. 
#' \code{is.na(cohortBl["HCC"])} will create a subcohort with simulated patients, who never got into "HCC" state. 
#' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#' 
#' -View subcohort <subcohort number>
#' Shows using View() the subcohort with the number defined in the text entry.
#' The numbers of cohorts with their definitions can be seen after pressing the \code{list cohorts} button.   
#' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#' 
#' 
#' IV. The multicohort panel.
#' While working with multiple cohorts, the user has similar options as with multiple subcohorts.
#' Different is adding a new cohort. The user can also analyse the cost for different cohorts.
#'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#'  
#' -Add cohort
#' Adds a new cohort created by \code{simualteCohort} from the .RData file chosen by the user. 
#' Cohort's name is then the full path of the file with the cohort.
#' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#' 
#' -Edit cohort names
#' The user can change in the editor names of the cohorts. 
#' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#' 
#' -View cost
#' Shows the cost data - unit costs, QALYs for each state and the costs expressed in units for each state. 
#' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#' 
#' -View cohort <cohort number>
#' Shows the cohort with the given number
#' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#' 
#' -List subcohorts
#' Shows the list of all cohorts in the model with the attached numbers
#' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#' 
#' Save the model TODO -- do we need to save it? No, only plots.
#' 
#' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#'
#'  -Plot <function name> <states> <cohorts>
#' <Function name> The user can choose from the menu one of the functions to be plotted:
#' \code{transitionProbabilities}
#' \code{cumulativeIncidence} 
#' see: \code{?transitionProbabilities}, \code{?cumulativeIncidence}
#' <states> A list of states, for which the chosen function will be plotted.
#' Eg. \code{list(1:4)}, \code{list(c(1,3,5))}. 
#' If there is more than 6 states chosen, the plots will be opened in different windows.
#' 
#' <cohorts> A list of cohorts to be plotted. 
#' Eg. \code{list(1:3)}, \code{list(c(1,3))}
#' 
#' The user can check the numbers of defined cohorts by clicking the button
#' \code{List cohorts} 
#' 
#' 
#'@export
#' 
#' 
start_gui <- function(){
  numStates <-6
  statesNames <-paste("state", c(1:(numStates)), sep=" ") 
  hfNames <- initHfNames(numStates)
  M<-generateHazardMatrix(numStates,statesNames)
  dimnames(hfNames) <- dimnames(M@list.matrix)
  params = generateParameterMatrix(M)
  covariance = generateParameterCovarianceMatrix(params)
  ttt <-matrix(FALSE, nrow=numStates, ncol=numStates)
  dimnames(ttt) <- dimnames(M@list.matrix)
  baselineFunction_empty <- function(cohortSize){data.frame(rep(NULL, cohortSize))}
  mypanel <- rp.control(numStates=numStates, startRow = 1, startColumn = 1, max_time=10, cohortSize = 100,
                        statesNames = paste("state", c(1:(numStates)), sep=" "), hfNames=hfNames,
                        M=M, params=params, covariance = covariance,
                        max_time=10, cohort =NULL, ttt=ttt, baselineFunction = baselineFunction_sex_age,
                        baseline = baselineFunction_sex_age(100))
 
  
  
#mypanel <- loadModel(mypanel, "./empty_6.RData")
  drawTable(mypanel)
}