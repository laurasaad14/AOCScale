########################
### Experiment setup ###
########################

whoami <- Sys.info()[["user"]]

experimentName <- "ROSAS"
workingDirectory <- "~/Documents/graphics/HRICFA/"
source(paste0(workingDirectory, "R/helper.R"))
graphSaveDirectory <- paste0(workingDirectory, "graphs/", experimentName, "/")
dataDirectory <- paste0(workingDirectory, "data/raw/", experimentName, "/")
##dataDirectory <- paste0(workingDirectory, "data/processed/", experimentName, "/")  ## for random data
setwd(workingDirectory)
VerifyPathIsSafe(graphSaveDirectory)
VerifyPathIsSafe(dataDirectory)

source(paste0(workingDirectory, "R/GetData", experimentName, ".R"))

require(psych)
require(foreign)
require(lavaan)

## item names of RoSASAll
## itemsRosas : wide version
## RoSASWarmth : item names
## itemsWarmth : wide version 
## RoSASCompetence : item names
## itemsCompetence : wide version
## RoSASDiscomfort : item names
## itemsDiscomfort : wide version

## StimulusType:  "FIRSTPERSON" "WORD"        "IMAGE"       "VIDEO"       "VIGNETTE"   
## Stimulus:  2 of each stimulusType : "maria.mp4"   "robot"       "homemate"    "asimo.mp4"   "bight"       "nao"   "pmp1.mp4"    "welding.mp4" "octavia"

itemsRoSAS.itemsOnly <- itemsRoSAS %>%
  dplyr::select(-c(StimulusType, Stimulus))

### =~ means "is measured by"
RoSASFactors <- '
  warmth =~ Happy + Feeling + Social + Organic + Compassionate + Emotional    
  discomfort =~ Scary + Strange + Awkward + Dangerous + Awful + Aggressive
  competence =~ Capable + Responsive + Interactive + Reliable + Competent + Knowledgable
'
### ordered means ordinal
### For ordinal data, lavaan uses a weighted least square means and variances (WLSMV) fitting function.  OK to leave estimator unspecified as if you include it they are the same (fitmeasures at least)
RoSAS.model <- cfa(model=RoSASFactors, data=itemsRoSAS.itemsOnly, ordered=TRUE)

RunCFA(df=itemsRoSAS.itemsOnly, description=RoSASFactors)

