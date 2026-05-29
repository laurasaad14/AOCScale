### aoc3 Wed May 22 09:18:19 2024

require(tidyverse)
require(lubridate)  ## for today()
require(Hmisc) ## for stat_summary

########################
### Get Original file###
########################

# dataFileName <- paste0(dataDirectory, "AOC1_20Ps_10.28.25.csv") # first 16 AOC1_test_forGreg
dataFileName <- paste0(dataDirectory, "AOC3_5Ps_5.29.26.csv")
dateExpr <- "\\d{1,2}.\\d{1,2}.\\d{4}"  ## super simple, easy to be wrong so check
dataDate <- str_match(dataFileName, dateExpr)
cat("This data was finished collected on", dataDate, fill=TRUE)

aoc3.df <- SafeReadCSV(dataFileName)

########################
### Wonky Participants #
########################

ParticipantsToRemove <- NULL
ParticipantsToRemove <- c(ParticipantsToRemove)  ## attention check


if (!is.null(ParticipantsToRemove)) {
  cat("** Removing participant(s):  ")
  cat(ParticipantsToRemove, fill=TRUE)
}

aoc3.df <- RemoveParticipants(aoc3.df, ParticipantsToRemove, report=TRUE)

aoc3.df <- aoc3.df %>% rename(Subject = subjID)
aoc3.df <- aoc3.df %>% rename(Condition = condition)
aoc3.df <- aoc3.df %>% rename(Gender = Sex)

### greg stopped b/c ran out of time
### [2026-02-19 Thu 12:06]

## ########################
## ### common dataframes  #
## ########################

aoc3.long <- aoc3.df %>%
    pivot_longer(!c(Subject, Condition, video_summary, Gender, Language, Education, Age, Race, expFeedback, Gello_AOC_17, attn_check_missed, X),
                 names_to = "Question",
                 values_to = "Response") %>%
  mutate(Question = str_replace_all(Question, "\\.", " ")) %>%
  mutate(Question = str_squish(Question))


## ### df.wide is primarily for psych and correlations
aoc3.wide <- aoc3.long %>%
    dplyr::select(Subject, Condition, Question, Response) %>%
    pivot_wider(
        names_from = Question,
        values_from = Response
    )

## ## ######################################
## ### Any other datasets needed?   #####
## ######################################

AOC.wide <- aoc3.wide

AOCAll <- c("can intentionally control own behavior",
            "Has actions that are based on own beliefs",
            "Can decide to behave differently",
            "Acts based on own goals",
            "Is told how to act by a supervisor",
            "Needs to interpret verbal instructions to determine what actions to take",
            "Only follows verbal or written communication from a boss",
            "Exclusively acts based on instructions communicated by a manager",
            "Is being puppeted",
            "Is remotely controlled",
            "Is directly maneuvered by another",
            "Actions are directly linked to physical actions of another",
            "Repeats same set of actions over and over again",
            "Acts according to a fixed pattern",
            "Only moves using preplanned actions",
            "Responds according to a pre established set of actions")

AOCPredetermined <- c("Repeats same set of actions over and over again",
            "Acts according to a fixed pattern",
            "Only moves using preplanned actions",
            "Responds according to a pre established set of actions")

AOCSelf <- c("can intentionally control own behavior",
             "Has actions that are based on own beliefs",
             "Can decide to behave differently",
             "Acts based on own goals")

AOCTeleOp <- c("Is being puppeted",
               "Is remotely controlled",
               "Is directly maneuvered by another",
               "Actions are directly linked to physical actions of another")

AOCSupervisor <- c("Is told how to act by a supervisor",
                   "Needs to interpret verbal instructions to determine what actions to take",
                   "Only follows verbal or written communication from a boss",
                   "Exclusively acts based on instructions communicated by a manager")



IDS <- NULL

ExpInfo <- c("Subject", "Condition")

GroupingVars <- c(ExpInfo, IDS)

itemsAOC <- AOC.wide %>%
    ungroup() %>%
    dplyr::select(all_of(c(ExpInfo, AOCAll)))

itemsSelf <- AOC.wide %>%
  ungroup() %>%
  dplyr::select(all_of(c(ExpInfo, AOCSelf)))

itemsPredetermined <- AOC.wide %>%
  ungroup() %>%
  dplyr::select(all_of(c(ExpInfo, AOCPredetermined)))

itemsTeleOp <- AOC.wide %>%
  ungroup() %>%
  dplyr::select(all_of(c(ExpInfo, AOCTeleOp)))

itemsSupervisor <- AOC.wide %>%
  ungroup() %>%
  dplyr::select(all_of(c(ExpInfo, AOCSupervisor)))

aoc3.itemsOnly <- itemsAOC %>%
    dplyr::select(-c("Subject", "Condition"))

# ###############################################
# ##################  Gators  ###################
# ###############################################
# 
# GatorsPMinus <- c("I would feel uneasy if I was given a job where I had to use robots",
#                   "I don't want a robot to touch me",
#                   "I fear that a robot would not understand my commands ",
#                   "Robots scare me",
#                   "I would feel very nervous just being around a robot")
# 
# GatorsALL <- GatorsPMinus
# 
# itemsPMinus <- AOC.wide %>%
#     ungroup() %>%
#     dplyr::select(all_of(c(ExpInfo, GatorsPMinus)))
# 
# itemsGatorsALL <- itemsPMinus
