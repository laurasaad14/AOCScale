########################
### Experiment setup ###
########################

experimentName <- "AOC3"
whoami <- Sys.info()[["user"]]
if (whoami == "trafton") {
    workingDirectory <- "~/Documents/graphics/AOCScale/"
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

########################
### very simple hist ###
########################

## aoc3.long %>%
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
print(rowSums(table(aoc3.long$Subject, aoc3.long$Response)))

totalItems <- 64  ## have to change it for every experiment
cat("Participants that did not answer", totalItems, "questions:", fill=TRUE)
rowSums(table(aoc3.long$Subject, aoc3.long$Response))[which(rowSums(table(aoc3.long$Subject, aoc3.long$Response)) != totalItems)]

#### aoc items
itemsAOC %>%
  mutate(Subject = factor(Subject)) %>%
  rowwise() %>%
  dplyr::mutate(aocMean = mean(c_across(where(is.numeric)))) %>%
  ggplot(aes(x=reorder(Condition, aocMean, FUN=mean), y=aocMean)) +
  geom_boxplot() +
  theme(axis.text.x = element_text(angle = 45)) +
  ggtitle("aocMean (all items)") +
  ylim(1, 6)
ggsave(paste0(graphSaveDirectory, "aoc.boxplot.pdf"))


## plot videos for each of the a priori hypothesized factors

# self (expect to see cheater, closeted, and secrets higher than the rest)

itemsSelf %>%
  mutate(Subject = factor(Subject)) %>%
  rowwise() %>%
  dplyr::mutate(aocSelfMean = mean(c_across(where(is.numeric)))) %>%
  ggplot(aes(x=reorder(Condition, aocSelfMean, FUN=mean), y=aocSelfMean)) +
  geom_boxplot() +
  theme(axis.text.x = element_text(angle = 45)) +
  ggtitle("aoc Mean (Self Items only)") +
  ylim(1, 6)
ggsave(paste0(graphSaveDirectory, "aocSelf.boxplot.pdf"))


# predetermined (expect to see feeder, welding, and dishes higher than the rest)

itemsPredetermined %>%
  mutate(Subject = factor(Subject)) %>%
  rowwise() %>%
  dplyr::mutate(aocPredMean = mean(c_across(where(is.numeric)))) %>%
  ggplot(aes(x=reorder(Condition, aocPredMean, FUN=mean), y=aocPredMean)) +
  geom_boxplot() +
  theme(axis.text.x = element_text(angle = 45)) +
  ggtitle("aoc Mean (Predetermined Items only)") +
  ylim(1, 6)
ggsave(paste0(graphSaveDirectory, "aocPredtermined.boxplot.pdf"))


# external (expect to see gello, firefighter, tai-chi higher than the rest)

itemsTeleOp %>%
  mutate(Subject = factor(Subject)) %>%
  rowwise() %>%
  dplyr::mutate(aocExterMean = mean(c_across(where(is.numeric)))) %>%
  ggplot(aes(x=reorder(Condition, aocExterMean, FUN=mean), y=aocExterMean)) +
  geom_boxplot() +
  theme(axis.text.x = element_text(angle = 45)) +
  ggtitle("aoc Mean (Teleop Items only)") +
  ylim(1, 6)
ggsave(paste0(graphSaveDirectory, "aocTeleOp.boxplot.pdf"))


itemsSupervisor %>%
  mutate(Subject = factor(Subject)) %>%
  rowwise() %>%
  dplyr::mutate(aocExterMean = mean(c_across(where(is.numeric)))) %>%
  ggplot(aes(x=reorder(Condition, aocExterMean, FUN=mean), y=aocExterMean)) +
  geom_boxplot() +
  theme(axis.text.x = element_text(angle = 45)) +
  ggtitle("aoc Mean (Supervisor Items only)") +
  ylim(1, 6)
ggsave(paste0(graphSaveDirectory, "aocSupervisor.boxplot.pdf"))


### greg does not love this with so little data.  uncomment later if want to see all items...
if (F) {
for (i in 1:length(AOCAll)) {
aoc3.long %>%
    
  mutate(Subject = factor(Subject)) %>%
  filter(Question == AOCAll[i]) %>%
  ggplot(aes(x=reorder(Condition, Response, FUN=mean), y=Response)) +
  geom_boxplot() +
  geom_jitter(height=.01, width = 0.2) +
  theme(axis.text.x = element_text(angle = 45)) +
  ggtitle(AOCAll[i]) +
  ylim(.9, 6.1)
ggsave(paste0(graphSaveDirectory, AOCAll[i], ".boxplot.pdf"))
}
}
