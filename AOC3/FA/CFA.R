########################
### Experiment setup ###
########################

whoami <- Sys.info()[["user"]]

experimentName <- "AOC3"
if (whoami == "trafton") {
  workingDirectory <- "~/Documents/graphics/AOCScale/"
} else if (whoami == "saad-admin") {
  workingDirectory <- "~/AOCScale/"
} ## you need to put your own workingDirectory here with your whoami
source(paste0(workingDirectory, "R/helper.R"))
graphSaveDirectory <- paste0(workingDirectory, "graphs/", experimentName, "/")
dataDirectory <- paste0(workingDirectory, "data/", experimentName, "/")
##dataDirectory <- paste0(workingDirectory, "data/processed/", experimentName, "/")  ## for random data
setwd(workingDirectory)
VerifyPathIsSafe(graphSaveDirectory)
VerifyPathIsSafe(dataDirectory)

source(paste0(workingDirectory, "R/GetData", experimentName, ".R"))

require(psych)
require(foreign)
require(lavaan)

# 
# itemsaoc3.itemsOnly <- itemsaoc3 %>%
#   dplyr::select(-c(StimulusType, Stimulus))

### =~ means "is measured by"
# AOCFactors <- '
#   Self =~ can intentionally control own behavior + Has actions that are based on own beliefs + Can decide to behave differently + Acts based on own goals    
#   Teleop =~ Is being puppeted + Is remotely controlled + Is directly maneuvered by another + Actions are directly linked to physical actions of another
#   Supervisor =~ Is told how to act by a supervisor + Needs to interpret verbal instructions to determine what actions to take + Only follows verbal or written communication from a boss + Exclusively acts based on instructions commuicated by a manager
#   Predetermined =~ Repeats same set of actions over and over again + Acts according to a fixed pattern + Only moves using preplanned actions + Responds according to a pre established set of actions
# '

# renaming columns because lavaan has trouble with the whole items

aoc3.cfa <- aoc3.itemsOnly
colnames(aoc3.cfa) <- paste0("AOC", 1:16)

AOCFactors <- '
  Self =~ AOC1 + AOC2 + AOC3 + AOC4
  Supervisor =~ AOC5 + AOC6 + AOC7 + AOC8
  Teleop =~ AOC9 + AOC10 + AOC11 + AOC12
  Predetermined =~ AOC13 + AOC14 + AOC15 + AOC16
'

# AOCFactors <- '
#   Self =~ `can intentionally control own behavior` +
#            `Has actions that are based on own beliefs` +
#            `Can decide to behave differently` +
#            `Acts based on own goals`
# 
#   Teleop =~ `Is being puppeted` +
#              `Is remotely controlled` +
#              `Is directly maneuvered by another` +
#              `Actions are directly linked to physical actions of another`
# 
#   Supervisor =~ `Is told how to act by a supervisor` +
#                  `Needs to interpret verbal instructions to determine what actions to take` +
#                  `Only follows verbal or written communication from a boss` +
#                  `Exclusively acts based on instructions communicated by a manager`
# 
#   Predetermined =~ `Repeats same set of actions over and over again` +
#                    `Acts according to a fixed pattern` +
#                    `Only moves using preplanned actions` +
#                    `Responds according to a pre established set of actions`
# '
### ordered means ordinal
### For ordinal data, lavaan uses a weighted least square means and variances (WLSMV) fitting function.  OK to leave estimator unspecified as if you include it they are the same (fitmeasures at least)
AOC.model <- cfa(model=AOCFactors, data=aoc3.cfa, ordered=TRUE)

RunCFA(df=aoc3.cfa, description=AOCFactors)

summary(AOC.model, standardized = TRUE)

modindices(AOC.model, sort. = TRUE, minimum.value = 10)
