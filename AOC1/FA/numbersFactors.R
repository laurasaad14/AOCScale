########################
### Experiment setup ###
########################

experimentName <- "AOC1"
whoami <- Sys.info()[["user"]]
if (whoami == "trafton") {
    workingDirectory <- "~/Documents/graphics/AOCScale/"
} else if (whoami == "saad-admin") {
  workingDirectory <- "~/PerceivedDanger/"
} ## you need to put your own workingDirectory here with your whoami

source(paste0(workingDirectory, "R/helper.R"))
source(paste0(workingDirectory, "R/SummarizeParticipants.R"))
graphSaveDirectory <- paste0(workingDirectory, "graphs/", experimentName, "/")
dataDirectory <- paste0(workingDirectory, "data/raw/", experimentName, "/")
setwd(workingDirectory)
VerifyPathIsSafe(graphSaveDirectory)
VerifyPathIsSafe(dataDirectory)

source(paste0(workingDirectory, "R/GetData", experimentName, ".R"))

require(psych)
require(MHSPackage)  ## funky install from github : it fails if you don't have all the packages it needs installed

##################################################
##### How many factors does this data have? ######
##################################################

### Multiple ways of determining number of factors:
### 1) nfactors : gives VSS, MAP,
### 2) parallel analysis (also shows scree)
### 3) EFA.Comp.Data based on Ruscio and Roche
###    Still a bit speculative in use for me

### Look for consistency between the results of parallel analysis,
### the scree, the MAP and VSS tests and then trying to understand why
### the results differ is probably the most recommended way to choose
### the number of factors. (from revelle book)

##################################################
#################   nfactors   ###################
##################################################

nfactors(aoc1.itemsOnly)

##################################################
############   parallel analysis   ###############
##################################################

### parallel analysis
fa.parallel(aoc1.itemsOnly)
### how to interpret:
## Look at PC actual data and FA actual data.
## Then compare those lines to PC and FA simulated data (random dataset)
## Find he number of actual points above the simulated lines:  that is the number of factors
## (it also gives you a text result)

##################################################
############## EFA.Comp.Data     #################
##################################################

##source(paste0(workingDirectory, "R/extractFacComp.R"))
### can use above code or load it from library.  either should work...

EFA.Comp.Data(as.matrix(aoc1.itemsOnly), F.Max=9, Graph=T)
