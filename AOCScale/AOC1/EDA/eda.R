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

########################
### very simple hist ###
########################

## pd1.long %>%
##   ggplot(aes(x=Response)) +
##   geom_histogram()
## ggsave(paste0(graphSaveDirectory, "overallHist.pdf"))

## p <- p + facet_wrap(~factor(Video, levels=c("welding.mp4", "taichi.mp4", "asimo.mp4", "secrets.mp4", "bargaining3.mp4", "closeted.mp4", "teacher.mp4", "feeder.mp4", "cheater.mp4", "service.mp4")))
## ggsave(paste0(graphSaveDirectory, "VideoByHist.pdf"))

## p <- ggplot(Ranking, aes(x=Video))
## p <- p + geom_histogram()
## print(p)
## ggsave(paste0(graphSaveDirectory, "overallHist.pdf"))

################################
## everyone answered questions##
################################

##print(table(pa6.long$Subject, pa6.long$Video))
###
cat(fill=TRUE)
cat("Number of questions that each P answered:", fill=TRUE)
print(rowSums(table(pd1.long$Subject, pd1.long$Response)))

totalItems <- 28  ## have to change it for every experiment
cat("Participants that did not answer", totalItems, "questions:", fill=TRUE)
rowSums(table(pd1.long$Subject, pd1.long$Response))[which(rowSums(table(pd1.long$Subject, pd1.long$Response)) != totalItems)]

#### PD items
itemsPD %>%
  rowwise() %>%
  dplyr::mutate(PDMean = mean(c_across(where(is.numeric)))) %>%
  ggplot(aes(x=reorder(Condition, PDMean, FUN=mean), y=PDMean)) +
  geom_boxplot() +
  theme(axis.text.x = element_text(angle = 45)) +
  ggtitle("PDMean (all items)") +
  ylim(1, 6)
ggsave(paste0(graphSaveDirectory, "PD.boxplot.pdf"))

for (i in 1:length(PDAll)) {
pd1.long %>%
  filter(Question == PDAll[i]) %>%
  ggplot(aes(x=reorder(Condition, Response, FUN=mean), y=Response)) +
  geom_boxplot() +
  geom_jitter(height=.01, width = 0.2) +
  theme(axis.text.x = element_text(angle = 45)) +
  ggtitle(PDAll[i]) +
  ylim(.9, 6.1)
ggsave(paste0(graphSaveDirectory, PDAll[i], ".boxplot.pdf"))
}

#### Gators (P- )items
itemsPMinus %>%
  rowwise() %>%
  dplyr::mutate(pMinus = mean(c_across(where(is.numeric)))) %>%
  ggplot(aes(x = reorder(Condition, pMinus, FUN=mean), y=pMinus)) +
  geom_boxplot() +
  theme(axis.text.x = element_text(angle = 45)) +
  ggtitle("PMinus (all items)")
ggsave(paste0(graphSaveDirectory, "PMinus.boxplot.pdf"))

