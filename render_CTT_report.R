library(rmarkdown)

source('~/Desktop/CTT/Tools/apimarshsparrows.R')

# this function expects at least one list with site_name, infile, tags, nodes, start_time, centerLon, 
# centerLat, and outpath
# It generates different site reports from dailyreport.Rmd 
# centerLon and centerLat are the coordinates of the center of the ggmap plots
stations_daily_report <- function(...){
  sites <- list(...)
  for (s in sites){
    site_name <- s$site_name
    infile <- s$infile
    if(typeof(s$tags) == 'list'){
      tags <- s$tags
    } else{
      tags <- read.csv(s$tags)
    }
    if(typeof(s$nodes) == 'list'){
      nodes <- s$nodes
    } else{
      nodes <- read.csv(s$nodes)
    }
    colnames(tags) <- c('TagId', "species", "band.number", "date.deployed", "date.retrieved") 
    start_time <- s$start_time
    centerLon <- s$centerLon
    centerLat <- s$centerLat
    outpath <- s$outpath
    today <- format(Sys.Date(), format = '%m-%d-%y')
    render('~/Desktop/CTT/Tools/dailyreport.Rmd',
           output_file = paste(outpath, '/', site_name, today, sep = ''))
  }
}










