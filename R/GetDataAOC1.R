### AOC1 Wed May 22 09:18:19 2024

require(tidyverse)
require(lubridate)  ## for today()
require(Hmisc) ## for stat_summary

########################
### Get Original file###
########################

# dataFileName <- paste0(dataDirectory, "AOC1_20Ps_10.28.25.csv") # first 16 AOC1_test_forGreg
dataFileName <- paste0(dataDirectory, "AOC1_278Ps_12.16.25.csv")
dateExpr <- "\\d{1,2}.\\d{1,2}.\\d{4}"  ## super simple, easy to be wrong so check
dataDate <- str_match(dataFileName, dateExpr)
cat("This data was finished collected on", dataDate, fill=TRUE)

aoc1.df <- SafeReadCSV(dataFileName)

########################
### Wonky Participants #
########################

ParticipantsToRemove <- NULL
ParticipantsToRemove <- c(ParticipantsToRemove, 6, 15, 16, 19, 37, 38, 39, 52, 74, 75, 81, 84,
                          87, 108, 109, 116, 117, 120, 123, 133, 146, 148, 150, 156, 162, 172,
                          190, 192, 196, 201, 206, 242, 243, 258, 268, 273, 277, 293, 298, 299,
                          300, 302, 307, 321, 326, 327, 332, 333, 334, 336, 338)  ## attention check
ParticipantsToRemove <- c(ParticipantsToRemove, 223, 207, 215, 223, 260, 263,
                          275, 276, 89, 90, 96, 97, 121, 141, 147, 149, 165, 274, 297, 31, 166)  ## language: other
if (!is.null(ParticipantsToRemove)) {
    cat("** Removing participant(s):  ")
    cat(ParticipantsToRemove, fill=TRUE)
}

aoc1.df <- RemoveParticipants(aoc1.df, ParticipantsToRemove, report=TRUE)

aoc1.df <- rename(aoc1.df,
                 TotalAttentionChecksMissed = AttentionCheckQuestionsMissed)


########################
### common dataframes  #
########################

### df.wide is primarily for psych and correlations
aoc1.wide <- aoc1.df %>%
    dplyr::select(Subject, Condition, Question, Response) %>% 
    pivot_wider(
        names_from = Question,
        values_from = Response
    )
aoc1.long <- aoc1.wide %>%
    pivot_longer(!c(Subject, Condition),
                 names_to = "Question",
                 values_to = "Response")

######################################
### Any other datasets needed?   #####
######################################

AOC.wide <- aoc1.wide


AOCAll <- c("makes own decisions to act",
            "can intentionally control own behavior",
            "has a sequence of steps to follow",
            "has actions that are based on own beliefs",
            "is controlled by an external entity",
            "is being puppeted",
            "has actions that are scripted",
            "acts according to a predefined set of rules",
            "acts based on own goals",
            "can decide to act without input from others",
            "is dependent on an operator",
            "acts on someone else's decision",
            "has a predetermined set of actions",
            "follows a fixed procedure",
            "is remotely controlled",
            "has behavior that is routine",
            "acts habitually ",
            "follows actions chosen by another",
            "can decide to behave differently",
            "wanted to perform these actions",
            "is told how to act"
)  


AOCPredetermined <- c("follows a fixed procedure",
                      "acts according to a predefined set of rules",
                      "has a predetermined set of actions",
                      "has actions that are scripted",
                      "has behavior that is routine",
                      "has a sequence of steps to follow",
                      "acts habitually ")

AOCExternal <- c("is controlled by an external entity",
                 "is remotely controlled",
                 "is being puppeted",
                 "acts on someone else's decision",
                 "follows actions chosen by another",
                 "is dependent on an operator",
                 "is told how to act")

AOCSelf <- c("acts based on own goals",
             "can intentionally control own behavior",
             "has actions that are based on own beliefs",
             "can decide to act without input from others",
             "makes own decisions to act",
             "wanted to perform these actions",
             "can decide to behave differently"
             )


IDS <- NULL

ExpInfo <- c("Subject", "Condition")

GroupingVars <- c(ExpInfo, IDS)

itemsAOC <- AOC.wide %>%
    ungroup() %>%
    dplyr::select(all_of(c(ExpInfo, AOCAll)))

itemsSelf <- AOC.wide %>%
  ungroup() %>%
  dplyr::select(all_of(c(ExpInfo, AOCSelf)))

itemsExternal <- AOC.wide %>%
  ungroup() %>%
  dplyr::select(all_of(c(ExpInfo, AOCExternal)))

itemsPredetermined <- AOC.wide %>%
  ungroup() %>%
  dplyr::select(all_of(c(ExpInfo, AOCPredetermined)))

aoc1.itemsOnly <- itemsAOC %>%
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
