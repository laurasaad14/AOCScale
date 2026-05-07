########################
### Experiment setup ###
########################
require(psych)

experimentName <- "AOC2"
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

### create the dictionary ###

## items <- c( "GATORS.P._1" = "I would feel uneasy if I was given a job where I had to use robots.",
## "GATORS.P._2" = "I fear that a robot would not understand my commands.",
## "GATORS.P._3" = "Robots scare me.",
## "GATORS.P._4" = "I would feel very nervous just being around a robot",
## "GATORS.P._5" = "I don't want a robot to touch me.",
## "NARS_1" = "I would feel uneasy if robots really had emotions.",
## "NARS_2" = "Something bad might happen if robots developed into living beings.",
## "NARS_3" = "I would feel relaxed talking with robots.",
## "NARS_4" = "I would feel uneasy if I was given a job where I had to use robots.",
## "NARS_5" = "If robots had emotions, I would be able to make friends with them.",
## "NARS_6" = "I feel comforted being with robots that have emotions.",
## "NARS_7" = "The word \"robot\" means nothing to me.",
## "NARS_8" = "I would feel nervous operating a robot in front of other people.",
## "NARS_9" = "I would hate the idea that robots or artificial intelligences were making judgments about things.",
## "NARS_10" = "I would feel very nervous standing in front of a robot.",
## "NARS_11" = "I feel that if I depend on robots too much, something bad might happen.",
## "NARS_12" = "I would feel paranoid talking with a robot.",
## "NARS_13" = "I am concerned that robots would be a bad influence on children.",
## "NARS_14" = "I feel that in the future society will be dominated by robots.",
## "RAS_1" = "Robots may talk about something irrelevant during conversation.",
## "RAS_2" = "Conversationg with robots may be inflexible.",
## "RAS_3" = "Robots may be able to understand complex stories.",
## "RAS_4" = "How robots will act.",
## "RAS_5" = "What robots will do.",
## "RAS_6" = "What power robots will have.",
## "RAS_7" = "What speed robots will move at.",
## "RAS_8" = "How I should talk with robots.",
## "RAS_9" = "How I should reply to robots when they talk to me.",
## "RAS_10" = "Whether robots understand the contents of my utterance to them.",
## "RAS_11" = "I may be unable to understand the contents of the robots' utterances to me." )

## ## To create a dictionary, create an object with row names as the item numbers,
## ## and the columns as the item content.

## items.dict <- data.frame(Item=as.character(items))
## rownames(items.dict) <- names(items)


########################
### FA for questions ###
########################

### following not super useful for now ...
## pd2.keys <- list(pd=names(pd2.itemsOnly))
## pd.scores <- scoreItems(pd2.keys, pd2.itemsOnly )


##################################################
##### How many factors does this data have? ######
##################################################

## Look at NumberFactors.R

## unidim(AOC2.itemsOnly) ## is it unidimensional?  bit unsure how to interpret : higher they are the more unidimeionsional
### not terrible
### psych::reliability(AOC2.itemsOnly)

## single factor
## f1 <- fa(AOC2.itemsOnly, nfactors=1)
## summary(f1)
## fa.lookup(f1, dictionary=names(aoc2.itemsOnly))
## fa.lookup(f1, dictionary=items.dict)

## ###################################
## #######  2 factor solution ########
## ###################################
##   ## Some writers say to “Factor the data by several different analytical procedures and
##   ## hold sacred only those factors that appear across all the procedures used.” (Gorsuch,
##   ## Factor Analysis,p. 330, 1983).
##   ### so that means look for close to 1 diagonal
## ## > pca1=principal(asiq, nfactors=5, rotate="promax",scores=F)
## ## > paf1=fa(asiq,nfactors=5,rotate="varimax",SMC=T,symmetric=T, fm="pa")
## f2 <- fa(aoc2.itemsOnly, nfactors=2)
## p2 <- principal(aoc2.itemsOnly,nfactors=2)
## factor.congruence(f2,p2)  ## how similar are they? --> pretty similar [looking for ~1 diagonal]

## fa.lookup(f2, dictionary=names(aoc2.itemsOnly))
## fa.diagram(f2)

## summary(f2)
## ### NOT 2 factors.  none of the items in second dimension are > .35!

## f2 <- fa(aoc2.itemsOnly, nfactors=2, rotate="varimax")
## fa.lookup(f2, dictionary=names(aoc2.itemsOnly))
## ### reasonable 2 factor solution, though lots of cross loadings!
## ## internal (anxious, frightned) vs. external (hazardous, cause pain)

## ###################################
## #######  3 factor solution ########
## ###################################
f3 <- fa(aoc2.itemsOnly, nfactors=3)
p3 <- principal(aoc2.itemsOnly,nfactors=3)
factor.congruence(f3,p3)
##fa.lookup(f3, dictionary=items.dict)
fa.lookup(f3, dictionary=names(aoc2.itemsOnly))


## ###################################
## ######  4 factor solution #########
## ###################################
f4 <- fa(aoc2.itemsOnly, nfactors=4)
p4 <- principal(aoc2.itemsOnly,nfactors=4)
factor.congruence(f4,p4)
##fa.lookup(f3, dictionary=items.dict)
fa.lookup(f4, dictionary=names(aoc2.itemsOnly))



## summary(f3)

### alpha:

alpha(aoc2.itemsOnly)  ##
omega(aoc2.itemsOnly, nfactors=3)  ##
