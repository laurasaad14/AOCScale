### AOC2 Wed May 22 09:18:19 2024

require(tidyverse)
require(lubridate)  ## for today()
require(Hmisc) ## for stat_summary

########################
### Get Original file###
########################

# dataFileName <- paste0(dataDirectory, "AOC1_20Ps_10.28.25.csv") # first 16 AOC1_test_forGreg
dataFileName <- paste0(dataDirectory, "AOC2_11Ps_2.17.26.csv")
dateExpr <- "\\d{1,2}.\\d{1,2}.\\d{4}"  ## super simple, easy to be wrong so check
dataDate <- str_match(dataFileName, dateExpr)
cat("This data was finished collected on", dataDate, fill=TRUE)

aoc2.df <- SafeReadCSV(dataFileName)

########################
### Wonky Participants #
########################

ParticipantsToRemove <- NULL
ParticipantsToRemove <- c(ParticipantsToRemove, 7)  ## attention check


if (!is.null(ParticipantsToRemove)) {
  cat("** Removing participant(s):  ")
  cat(ParticipantsToRemove, fill=TRUE)
}

aoc2.df <- RemoveParticipants(aoc2.df, ParticipantsToRemove, report=TRUE)

aoc2.df <- aoc2.df %>% rename(Subject = subjID)
aoc2.df <- aoc2.df %>% rename(Condition = condition)
aoc2.df <- aoc2.df %>% rename(Gender = Sex)

### greg stopped b/c ran out of time
### [2026-02-19 Thu 12:06]

## ########################
## ### common dataframes  #
## ########################

aoc2.long <- aoc2.df %>%
    pivot_longer(!c(Subject, Condition, video_summary, Gender, Language, Education, Age, Race, expFeedback, Gello_AOC_17, Taichi_AOC_17, attn_check_missed),
                 names_to = "Question",
                 values_to = "Response") %>%
  mutate(Question = str_replace_all(Question, "\\.", " ")) %>%
  mutate(Question = str_squish(Question))


## ### df.wide is primarily for psych and correlations
aoc2.wide <- aoc2.long %>%
    dplyr::select(Subject, Condition, Question, Response) %>%
    pivot_wider(
        names_from = Question,
        values_from = Response
    )

## ## ## aoc2.long <- aoc2.wide %>%
## ## aoc2.long <- aoc2.df %>%
## ##     pivot_longer(!c(Subject, Condition, video_summary, Sex, Language, Education, Race, expFeedback),
## ##                  names_to = "Question",
## ##                  values_to = "Response")

## ## ######################################
## ### Any other datasets needed?   #####
## ######################################

## AOC.wide <- aoc2.wide


## AOCAll <- c("makes own decisions to act",
##             "can intentionally control own behavior",
##             "has a sequence of steps to follow",
##             "has actions that are based on own beliefs",
##             "is controlled by an external entity",
##             "is being puppeted",
##             "has actions that are scripted",
##             "acts according to a predefined set of rules",
##             "acts based on own goals",
##             "can decide to act without input from others",
##             "is dependent on an operator",
##             "acts on someone else's decision",
##             "has a predetermined set of actions",
##             "follows a fixed procedure",
##             "is remotely controlled",
##             "has behavior that is routine",
##             "acts habitually ",
##             "follows actions chosen by another",
##             "can decide to behave differently",
##             "wanted to perform these actions",
##             "is told how to act"
## )


## AOCPredetermined <- c("follows a fixed procedure",
##                       "acts according to a predefined set of rules",
##                       "has a predetermined set of actions",
##                       "has actions that are scripted",
##                       "has behavior that is routine",
##                       "has a sequence of steps to follow",
##                       "acts habitually ")

## AOCExternal <- c("is controlled by an external entity",
##                  "is remotely controlled",
##                  "is being puppeted",
##                  "acts on someone else's decision",
##                  "follows actions chosen by another",
##                  "is dependent on an operator",
##                  "is told how to act")

## AOCSelf <- c("acts based on own goals",
##              "can intentionally control own behavior",
##              "has actions that are based on own beliefs",
##              "can decide to act without input from others",
##              "makes own decisions to act",
##              "wanted to perform these actions",
##              "can decide to behave differently"
##              )


## IDS <- NULL

## ExpInfo <- c("Subject", "Condition")

## GroupingVars <- c(ExpInfo, IDS)

## itemsAOC <- AOC.wide %>%
##     ungroup() %>%
##     dplyr::select(all_of(c(ExpInfo, AOCAll)))

## itemsSelf <- AOC.wide %>%
##   ungroup() %>%
##   dplyr::select(all_of(c(ExpInfo, AOCSelf)))

## itemsExternal <- AOC.wide %>%
##   ungroup() %>%
##   dplyr::select(all_of(c(ExpInfo, AOCExternal)))

## itemsPredetermined <- AOC.wide %>%
##   ungroup() %>%
##   dplyr::select(all_of(c(ExpInfo, AOCPredetermined)))

## aoc2.itemsOnly <- itemsAOC %>%
##     dplyr::select(-c("Subject", "Condition"))

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
