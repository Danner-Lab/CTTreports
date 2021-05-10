library(rmarkdown)

source('~/Desktop/CTT/Tools/apimarshsparrows.R')

# this function expects at least one list with site_name, infile, tags, nodes, start_time, centerLon, 
# centerLat, and outpath
# datetimes must be in POSIXct form
# It generates different site reports from dailyreport.Rmd 
# centerLon and centerLat are the coordinates of the center of the ggmap plots
# edit the file paths here
daily_report <- function(...) {
  req.vars <- c('site_name','infile','tags','nodes','outpath','start_time','centerLon','centerLat')
  for(s in list(...)) {
    if(any(!(req.vars %in% names(s)))) {
      stop(paste('site missing required variable:', req.vars[!(req.vars %in% names(s))][1]))
    }
    list2env(s, envir = environment())
    if(is.character(tags)) {tags <- read.csv(tags)}
    if(is.character(nodes)) {nodes <- read.csv(nodes)}
    render('~/Desktop/CTT/Tools/dailyreport.Rmd', 
           output_file = paste(outpath, '/', site_name, format(Sys.Date(), 
                                                               format = '%m-%d-%y'), sep = ''))  
  }
}



# site_recap also requires a parameter end_time to bound the period of sampling 
# locsfile specifies whether to write to outpath a csv file containing locations 
site_recap <- function(..., locsfile = TRUE) {
  req.vars <- c('site_name','infile','tags','nodes','outpath','start_time', 'end_time','centerLon',
                'centerLat')
  for(s in list(...)){
    if(any(!(req.vars %in% names(s)))) {
      stop(paste('site missing required variable:', req.vars[!(req.vars %in% names(s))][1]))
    }
    list2env(s, envir = environment())
    if(is.character(tags)) {tags <- read.csv(tags)}
    if(is.character(nodes)) {nodes <- read.csv(nodes)}
    render('~/Desktop/CTT/Tools/SiteRecap.Rmd', 
           output_file = paste(outpath, '/', site_name, format(Sys.Date(), 
                                                               format = '%m-%d-%y'), sep = ''))  
  }
}



# example usage:
# siteA.info <- list(
#   site_name = "OCI",
#   infile = "~/Desktop/CTT/Data/Winter Marsh Sparrows/32C74E282R14",
#   tags = read.csv("~/Desktop/CTT/Tools/siteA_tagsdeployed_2021.csv", as.is=TRUE, na.strings=c("NA", "")),
#   nodes = read.csv("~/Desktop/CTT/Tools/siteA_NodeLocs1_April21.csv", as.is=TRUE, na.strings=c("NA", "")),
#   outpath = '~/Desktop/CTT/Output/siteA',
#   start_time = as.POSIXct("2021-02-27 00:00:00", tz = "EST"),
#   centerLon = -77.8505,
#   centerLat = 34.1355
# )
# 
# daily_report(OCI.info)








