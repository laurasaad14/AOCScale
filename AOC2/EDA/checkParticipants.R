########################
### Experiment setup ###
########################

experimentName <- "AOC2"
whoami <- Sys.info()[["user"]]
if (whoami == "trafton") {
    workingDirectory <- "~/Documents/graphics/PerceivedDanger/"
} else if (whoami == "saad-admin") {
  workingDirectory <- "~/AOCScale/"
} ## you need to put your own workingDirectory here with your whoami

source(paste0(workingDirectory, "R/helper.R"))
source(paste0(workingDirectory, "R/SummarizeParticipants.R"))
graphSaveDirectory <- paste0(workingDirectory, "graphs/", experimentName, "/")
dataDirectory <- paste0(workingDirectory, "data/", experimentName, "/")
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

    aoc2.df <- aoc2.df %>%
        filter(subjID > MaxSubject)

    # aoc2.wide <- aoc2.wide %>%
    #     filter(subjID > MaxSubject)

}
showSummary <- TRUE  ## FALSE
showAttentionCheck <- TRUE ## FALSE

####################################################################################
## Prints out trial summaries (not needed in aoc)  and final experiment summaries  ##
## I find that our attention check captures P who do not do task and is defensible #
####################################################################################

if (showSummary) {

    df.summaryVideo <- aoc2.df %>%
        group_by(subjID) %>%
        slice_head(n=1) %>%
        dplyr::select(subjID, Language, expFeedback)
# 
#     for (S in unique(df.summaryVideo$subjID)) {
#         df.participant <- df.summaryVideo %>% filter(subjID == S)
#         cat("Participant =", S, "(Language:", unique(df.participant$Language), ")", fill=TRUE)
# ### not needed because no instance based feedback in aoc2
#         ## for (v in df.participant$Video) {
#         cat("Video:", unique(df.participant$condition), ": ")
#         cat(df.participant$video_summary, fill=TRUE)
#         ## }
#         cat("ExperimentFeedback: ")
#         cat(unique(as.character(df.participant$ExpFeedback)), fill=TRUE)
#         cat(fill=TRUE)
#     }
}


####################
## Attention check #
####################

if (showAttentionCheck) {
  AttentionCheck.df <- aoc2.df %>%
    group_by(subjID) %>%
    dplyr::select(subjID, 'attn_check_missed')  
  Problems.df <- subset(AttentionCheck.df, attn_check_missed > 0)
  if (nrow(Problems.df) > 0)
    print(as.data.frame(subset(AttentionCheck.df, attn_check_missed > 0)))
  else {
    cat("All participants passed all attention checks!", fill=TRUE)
  }
}

SummarizedInfo.df <- SummarizeParticipants(aoc2.df)

## I run this script, first checking for attention check problems
## Then I look at summaries to do a quick check about what P think about the experiment.
## If there is something very very odd there, I look carefully but don't do much if they pass attention check 
## I remove Ps who miss attention check 
## To remove Ps I put them in the ParticipantsToRemove in GetData*.R

