########################
### Experiment setup ###
########################

experimentName <- "PD1"
whoami <- Sys.info()[["user"]]
if (whoami == "trafton") {
    workingDirectory <- "~/Documents/graphics/PerceivedDanger/"
}
source(paste0(workingDirectory, "R/helper.R"))
graphSaveDirectory <- paste0(workingDirectory, "graphs/", experimentName, "/")
dataDirectory <- paste0(workingDirectory, "data/raw/", experimentName, "/")
setwd(workingDirectory)
VerifyPathIsSafe(graphSaveDirectory)
VerifyPathIsSafe(dataDirectory)

source(paste0(workingDirectory, "R/GetData", experimentName, ".R"))

require(psych)

########################
### FA for questions ###
########################

### score the items/scales

## ## create scoring keys:  1: use it; 0: ignore it; -1: reverse code it
## pd1.key <- c("experiences sensations",
##              "can perceive their environment",
##              "can pay attention to objects",
##              "can control their attention",
##              "can follow the attention of others",
##              "can combine different sources of information",
##              "can process complex information",
##              "is aware of their actions",
##              "is aware of their environment",
##              "is aware they exist",
##              ##                                                   "has a nose",
##              "has a sense of self",
##              "experiences an inner life",
##              "has a subjective experience of the world",
##              "has a unique way it feels like to be them",
##              "goes through the world mindfully",
##              "has a unified experience of the world",
##              "can reflect on perceptions of their environment",
##              "can reflect on their actions",
##              "can reflect on their internal processes",
##              "is capable of introspection")

### following not super useful for now ...
## pd1.keys <- list(pd=names(pd1.itemsOnly))
## pd.scores <- scoreItems(pd1.keys, pd1.itemsOnly )

nfactors(pd1.itemsOnly)
### NOTE to interpret VSS graphs:
### each line is complexity (figure out)
## Complexity is the number of factors that each variable loads on.
## Choose the number of factors based on the maximum value of the VSS.
### SO:
### VSS complexity 1 achieves a maximimum of 0.64 with 2 factors
### VSS complexity 2 achieves a maximimum of 0.78 with 4 factors
### complexity 2 has a higher VSS so VSS suggests 4 factors (I think)

### if you think complexity is 1, find the 1 line and then find the highest point on the y;
### the x axis is the number of factors
### if complexity is 2, find highest point (highest fit) and read off number of factors on x

### Looking for consistency between the results of parallel analysis,
### the scree, the MAP and VSS tests and then trying to understand why
### the results differ is probably the most recommended way to choose
### the number of factors. (from revelle book)

### NOTE that most people seem to use PCA to determine number of factors
## so if fa.parallel says:Parallel analysis suggests that the number of factors =  3  and the number of components =  2
### most popular seem to be MAP, parallel,

### parallel analysis
fa.parallel(pd1.itemsOnly)
### how to interpret:
## Look at PC actual data and FA actual data.
## Then compare those lines to PC and FA simulated data (random dataset)
## Find he number of actual points above the simulated lines:  that is the number of factors
## (it also gives you a text result)

## unidim(pd1.itemsOnly) ## is it unidimensional?  bit unsure how to interpret : higher they are the more unidimeionsional
## psych::reliability(pd1.itemsOnly)

## single factor
## f1 <- fa(pd1.itemsOnly, nfactors=1)
## summary(f1)
## fa.lookup(f1, dictionary=names(pd1.itemsOnly))

###################################
#######  2 factor solution ########
###################################
if (F) {
f2 <- fa(pd1.itemsOnly, nfactors=2)
p2 <- principal(pd1.itemsOnly,nfactors=2)
factor.congruence(f2,p2)  ## how similar are they? --> pretty similar [looking for ~1 diagonal]

fa.lookup(f2, dictionary=names(pd1.itemsOnly))
fa.diagram(f2)

summary(f2)
}

###################################
#######  3 factor solution ########
###################################
if (F) {
f3 <- fa(pd1.itemsOnly, nfactors=3)
p3 <- principal(pd1.itemsOnly,nfactors=3)
factor.congruence(f3,p3)  ## how similar are they? --> pretty similar [looking for ~1 diagonal]
fa.lookup(f3, dictionary=names(pd1.itemsOnly))
}

###################################
#######  4 factor solution ########
###################################
if (F) {
f4 <- fa(pd1.itemsOnly, nfactors=4)
p4 <- principal(pd1.itemsOnly,nfactors=4)
factor.congruence(f4,p4)  ## how similar are they? --> pretty similar [looking for ~1 diagonal]
fa.lookup(f4, dictionary=names(pd1.itemsOnly))
}

scree(pd1.itemsOnly)

## summary(f3)

### alpha:

alpha(pd1.itemsOnly)  ## 
omega(pd1.itemsOnly)  ## 
