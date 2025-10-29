### PD1 Wed May 22 09:18:19 2024

require(tidyverse)
require(lubridate)  ## for today()
require(Hmisc) ## for stat_summary

########################
### Get Original file###
########################

dataFileName <- paste0(dataDirectory, "PD1_16Ps_5.24.2024.csv") # first 16
dateExpr <- "\\d{1,2}.\\d{1,2}.\\d{4}"  ## super simple, easy to be wrong so check
dataDate <- str_match(dataFileName, dateExpr)
cat("This data was finished collected on", dataDate, fill=TRUE)

pd1.df <- SafeReadCSV(dataFileName)

########################
### Wonky Participants #
########################

ParticipantsToRemove <- NULL
ParticipantsToRemove <- c(ParticipantsToRemove)  ## attention check
ParticipantsToRemove <- c(ParticipantsToRemove)  ## language: other

if (!is.null(ParticipantsToRemove)) {
    cat("** Removing participant(s):  ")
    cat(ParticipantsToRemove, fill=TRUE)
}

pd1.df <- RemoveParticipants(pd1.df, ParticipantsToRemove, report=TRUE)

pd1.df <- rename(pd1.df,
                 TotalAttentionChecksMissed = AttentionCheckQuestionsMissed)


########################
### common dataframes  #
########################

### df.wide is primarily for psych and correlations
pd1.wide <- pd1.df %>%
    dplyr::select(Subject, Condition, Question, Response) %>% 
    pivot_wider(
        names_from = Question,
        values_from = Response
    )
pd1.long <- pd1.wide %>%
    pivot_longer(!c(Subject, Condition),
                 names_to = "Question",
                 values_to = "Response")

######################################
### Any other datasets needed?   #####
######################################

PD.wide <- pd1.wide


PDAll <- c("how anxious would you feel?",
           "how cautious would you be?",
           "how vulnerable to harm would you be?",
           "how vigilant would you be?",
           "how alert would you be?",
           "how worried would you feel?",
           "how frightened would you feel?",
           "how stressed would you feel?",
           "how likely would the robot cause bodily harm?",
           "how threatening was the robot?",
           "how nervous would you feel?",
           "how likely was the robot to cause pain?",
           "how exposed to physical injury would you be?",
           "how hazardous was the robot?",
           "how dangerous was the robot?",
           "how scared would you feel?",
           "how severely might you be injured?",
           "how concerned would you be?",
           "how alarmed would you be?",
           "how menacing was the robot?",
           "how tense would you be?",
           "how intimidating was the robot?"
)  

IDS <- NULL

ExpInfo <- c("Subject", "Condition")

GroupingVars <- c(ExpInfo, IDS)

itemsPD <- PD.wide %>%
    ungroup() %>%
    dplyr::select(all_of(c(ExpInfo, PDAll)))

pd1.itemsOnly <- itemsPD %>%
    dplyr::select(-c("Subject", "Condition"))

###############################################
##################  Gators  ###################
###############################################

GatorsPMinus <- c("I would feel uneasy if I was given a job where I had to use robots",
                  "I don't want a robot to touch me",
                  "I fear that a robot would not understand my commands ",
                  "Robots scare me",
                  "I would feel very nervous just being around a robot")

GatorsALL <- GatorsPMinus

itemsPMinus <- PD.wide %>%
    ungroup() %>%
    dplyr::select(all_of(c(ExpInfo, GatorsPMinus)))

itemsGatorsALL <- itemsPMinus
