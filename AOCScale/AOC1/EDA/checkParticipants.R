########################
### Experiment setup ###
########################

experimentName <- "PD1"
whoami <- Sys.info()[["user"]]
if (whoami == "trafton") {
    workingDirectory <- "~/Documents/graphics/PerceivedDanger/"
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

################################################################
## every new set of P go through (if looking at incrementally) #
################################################################

IgnorePrevious <- TRUE  ## FALSE
if (IgnorePrevious) {
    MaxSubject <- 0 ## 

    pd1.df <- pd1.df %>%
        filter(Subject > MaxSubject)

    pd1.wide <- pd1.wide %>%
        filter(Subject > MaxSubject)

}
showSummary <- TRUE  ## FALSE
showAttentionCheck <- TRUE ## FALSE

####################################################################################
## Prints out trial summaries (not needed in PD)  and final experiment summaries  ##
## I find that our attention check captures P who do not do task and is defensible #
####################################################################################

if (showSummary) {

    df.summaryVideo <- pd1.df %>%
        group_by(Subject) %>%
        slice_head(n=1) %>%
        dplyr::select(Subject, Language, Condition, VideoFeedback, ExperimentFeedback)

    for (S in unique(df.summaryVideo$Subject)) {
        df.participant <- df.summaryVideo %>% filter(Subject == S)
        cat("Participant =", S, "(Language:", unique(df.participant$Language), ")", fill=TRUE)
### not needed because no instance based feedback in pd1
        ## for (v in df.participant$Video) {
        cat("Video:", unique(df.participant$Condition), ": ")
        cat(df.participant$VideoFeedback, fill=TRUE)
        ## }
        cat("ExperimentFeedback: ")
        cat(unique(as.character(df.participant$ExperimentFeedback)), fill=TRUE)
        cat(fill=TRUE)
    }
}


####################
## Attention check #
####################

if (showAttentionCheck) {
    AttentionCheck.df <- pd1.df %>%
        group_by(Subject) %>%
        slice_tail(n=1) %>%
        dplyr::select(Subject, 'TotalAttentionChecksMissed')  ## ask malcolm to keep consistent
    Problems.df <- subset(AttentionCheck.df, TotalAttentionChecksMissed > 0)
    if (nrow(Problems.df) > 0) {
      print(as.data.frame(subset(AttentionCheck.df, TotalAttentionChecksMissed > 0)))
      cat("Any P who missed attention check should be put in the variable ParticipantsToRemove", fill=TRUE)
      cat("in the file", paste0(workingDirectory, "/R/GetData", experimentName, ".R"), fill=TRUE)
    } else {
        cat("All participants passed all attention checks!", fill=TRUE)
    }
}

SummarizedInfo.df <- SummarizeParticipants(pd1.df)

## I run this script, first checking for attention check problems
## Then I look at summaries to do a quick check about what P think about the experiment.
## If there is something very very odd there, I look carefully but don't do much if they pass attention check 
## I remove Ps who miss attention check 
## To remove Ps I put them in the ParticipantsToRemove in GetData*.R

