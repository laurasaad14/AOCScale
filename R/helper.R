options(pillar.width = Inf)  ## make tibble show all columns

VerifyPathIsSafe <- function(path) {

  if (!file.exists(path))
    dir.create(path, recursive=T)

}

SafeReadCSV <- function(fileName) {
    if (file.exists(fileName)) {
        return(read.csv(fileName))
    } else {
        stop(paste0(fileName, " does not exist"))
    }
}

RemoveParticipants <- function(original.df, ParticipantsToRemove, report=TRUE) {

    OriginallyRunN <- length(unique(original.df$Subject))
    pruned.df <- original.df %>%
        filter(!Subject %in% ParticipantsToRemove)

    FinalN <- length(unique(pruned.df$Subject))

    if (report) {
        cat("Original n =", OriginallyRunN, fill=TRUE)
        cat("Final n =", FinalN, fill=TRUE)
        cat("(deleted", OriginallyRunN - FinalN, "[", round((OriginallyRunN - FinalN)/OriginallyRunN * 100, 2), "%]", "participants)", fill=TRUE)
    }
    return(pruned.df)

}

ConvertToNewRange <- function(Value, OriginalMin, OriginalMax, NewMin, NewMax) {

## NewValue = (((OldValue - OldMin) * (NewMax - NewMin)) / (OldMax - OldMin)) + NewMin

    NewValue <- (((Value - OriginalMin) * (NewMax - NewMin)) / (OriginalMax - OriginalMin)) + NewMin
    return(NewValue)
}

### which estimator?
### https://link.springer.com/article/10.3758/s13428-018-1055-2
### suggests that ML (default) is not appropriate for Likert data but DWLS is
### of course thresholds may be slightly different too (point of above paper)
### cfi want > .9; rmsea want <= .05
### following paper suggests to use srmr since it does not change based on estimation method
### https://journals.sagepub.com/doi/10.1177/0013164419885164
### Other work suggests to use ordered=TRUE for Likert data
### ordered=TRUE uses WLSMV so you can leave it unspecified
RunCFA <- function(df, description, estimator="WLSMV", ordered=TRUE, orthogonal=FALSE) {

##    estimator <- "ML"
    cfa.model <- cfa(description, data=df,estimator=estimator, ordered=ordered, orthogonal=orthogonal)
    print(summary(cfa.model))

    print(fitmeasures(cfa.model, c('cfi', 'tli', 'rmsea', 'srmr', 'bic')))
    cat("cfi >= .95; tli >= .95; rmsea <= .06; srmr <= .08", fill=TRUE)
#    print(fitmeasures(cfa.model))

}

### NAs muck this up
checkRange <- function(df, scaleLable, min, max, display=TRUE) {
  if (display)
    cat("The range for", scaleLable, "should be between", min, "and", max, fill=TRUE)
  data <- t(sapply(df, range, na.rm=TRUE))
  colnames(data) <- c("min", "max")
  if (display) {
    print(data)
    cat(fill=TRUE)
    } else
      return(data)
}

newline <- function() {
  cat(fill=TRUE)
}
