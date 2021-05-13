##' R Eriksson 04/17/2021
##'
##' Replicating the R-number calculated by the Public health agency of Sweden (FHM)
##'

library(readxl)
library(dplyr)
library(ggplot2)
library(gridExtra)
library(zoo)
library(EpiEstim)

##' Get the incidence data
##' @param start starting date
##' @param region specify the region
##' @return data frame of incidence
loadData <- function(start="2021/03/19",region="Sweden") {
    file = paste(getwd(), "..", "data",  "Folkhalsomyndigheten_Covid19.xlsx", sep="/")
    data <- read_excel(file, sheet="Antal per dag region")

    if (region == "Sweden")
        region <- "Totalt_antal_fall"

    df <- data %>% filter(Statistikdatum > start) %>% select(Statistikdatum,region)
    colnames(df) <- c("date","incidence")

    return(df)

}

##' Compute the R-number and create the plot
##' @param region specific region to use data from
##' @param roll if rolling mean on incidence
##' @param fixed if the parameters in the Gamma dist are uncertain or not
##' @return ggplot with incidence and R
compute <- function(region="Uppsala", roll=FALSE,fixed=TRUE) {
    df <- loadData("2020/08/01", region=region)
    if (roll)
        df$incidence <- rollmean(df$incidence,7,fill=0)

    if (fixed) {
        config <- make_config(list(
            mean_si = 4.8,
            std_si = 2.3))
        method <- "parametric_si"


    } else {
        config <- make_config(
            list(mean_si = 4.8, std_mean_si = 1,
                 min_mean_si = 1, max_mean_si = 8,
                 std_si = 2.3, std_std_si = 0.5,
                 min_std_si = 0.25, max_std_si = 5))
        method <- "uncertain_si"
    }

   res <- estimate_R(df$incidence,
                      method=method,
                      config = config)

    size <- dim(df)
    df$R_mi <- NA

    df$R_mi[res$R$t_end] <- res$R[,"Mean(R)"]
    df$R_lo <- NA
    df$R_lo[res$R$t_end] <- res$R[,"Quantile.0.025(R)"]
    df$R_hi <- NA
    df$R_hi[res$R$t_end] <- res$R[,"Quantile.0.975(R)"]


    pi <- ggplot(df, aes(x=date,y=incidence, fill="incidence")) +
        geom_col(aes(fill="incidence"))
    pr <- ggplot(df, aes(x=date,y=R_mi)) +
        geom_line(aes(color="mean")) +
        geom_ribbon(aes(ymin=R_lo,ymax=R_hi, fill="95% CrI"),
    alpha=0.2) +
        geom_hline(aes(yintercept=1)) +
        ylim(c(0,3))

    p <- grid.arrange(pi,pr,nrow=2)
    return(list("plot"=p,"table"=df))
}

##' ***********************************
##' Below follows 4 cases.
##' 1) base case, replicate FHM
##' 2) smooth the incidence data
##' 3) uncertainty in the exposed parameters
##' 4) 2+3 together.
##'
##' Suggestion -> Go through each case and see how it affects the
##' output prediciton. And finally, use case #4 for your predictions.
##'


##' Base case
##' @param region what region to make prediciton on
FHM <- function(region="Uppsala") {
    return(compute(region=region,
                   roll=FALSE,
                   fixed=TRUE))
}

##' Rolling mean
##' @param region what region to make prediciton on
FHM_roll <- function(region="Uppsala") {
    return(compute(region=region,
                   roll=TRUE,
                   fixed=TRUE))
}

##' Uncertain paramaters
##' @param region what region to make prediciton on
FHM_uc <- function(region="Uppsala") {
    return(compute(region=region,
                   roll=FALSE,
                   fixed=FALSE))

}

##' Uncertain parameters and rolling mean
##' @param region what region to make prediciton on
FHM_uc_roll <- function(region="Uppsala") {
    return(compute(region=region,
                   roll=TRUE,
                   fixed=FALSE))

}
