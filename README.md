# README - CTT Reports

Author: Miles Buddy

CTT Reports visualize data recorded by Cellular Tracking Technologies wildlife tracking systems. The visualizations are comprehensively displayed in documents
rendered by R Markdown. They may be used to evaluate information such as tag RSSI, node RSSI, and tag locations over a specified time interval. They are meant to
be flexible, and we encourage the modification of the files as any specific project may dictate. Examples of CTT Reports are included in the current release. These reports are designed for use with a system task scheduler, but may also be generated manually. 

Users must install the CTT ```data_tools``` repository before creating CTT Reports. See https://github.com/cellular-tracking-technologies/data_tools for details. We
reccomend reading the README at that page before proceeding. The code for creating CTT Reports sources functions from ```data_tools/functions/localization.R``` and 
```data_tools/functions/data_manager.R```. For details about RStudio and RMarkdown, visit https://www.rstudio.com and https://www.rmarkdown.rstudio.com, respectively. 

New in v2.0: Profound reworking of file structure allowing for greater flexibility. Data preparation is looped to save memory. 


## reports_main.R

```reports_main.R``` is the main file. It loads all dependencies and creates one or more CTT Reports by calling the function ```ctt_report```. It can be scheduled to generate reports on a regular basis using a system task scheduler. It sources ```ctt_report_tools.R``` and runs the API to download any new data. 

## ctt_report_tools.R

This file contains all functions and variables for generating reports. The function ```ctt_report``` renders ```CTTReport.Rmd``` once for each argument passed to it. Each such argument must be a 'site info' list corresponding to a single node array and containing the following variables:

* ```site_name```: the name of your sampling site
* ```infile```: path to directory containing all raw downloaded files from the SensorStation in one folder or subfolders (node, raw, gps, etc.)
* ```tags```: a dataframe containing a column named ```TagId``` with tag ID numbers (path to CSV file also accepted) 
* ```nodes```: a dataframe containing columns ```NodeId```, ```lat```, and ```lng``` corresponding to node ID numbers and locations (path to CSV also accepted)
* ```outpath```: directory to create output
* ```start_time```: lower bound of time interval, must be in POSIXct format
* ```centerLon```: longitude coordinate of basemap center
* ```centerLat```: latitude coordinate of basemap center

An optional upper bound to the time interval, ```end_time```, may be specified in the list. Including an ```export.locs``` variable that evaluates to ```TRUE``` will copy a CSV of calculated locations to ```outpath```. We reccomend creating these objects within ```ctt_report_tools.Rmd```. 

Example implementation:
```r
RCR.info <- list(
  site_name = 'FF',
  infile = '~/Desktop/CTT/Data/Winter Marsh Sparrows/277805DD663C',
  tags = read.csv('~/Desktop/CTT/Tools/FF_tagsdeployed_2021.csv', as.is=TRUE, na.strings = c('NA', "")),
  nodes = read.csv('~/Desktop/CTT/Tools/FF_NodeLocs.csv', as.is=TRUE, na.strings=c("NA", "")),
  outpath = '~/Desktop/CTT/Output/FF',
  start_time = as.POSIXct('2021-02-28 00:00:00', tz = 'America/New_York'),
  end_time = as.POSIXct('2021-03-31 08:00:00', tz = 'America/New_York'), # optional
  centerLon = -77.9615,
  centerLat = 33.8835
)

ctt_report(RCR.info)
```

Data prep functions:

* ```prep_info```: Called within file ```CTTReport.Rmd```. Takes a 'site info' list. Argument ```dB``` specifies the mimimum TagRSSI eligible for consideration in location estimates. ```freq``` is the sampling interval for resampled data. Returns same list with added components. 
* ```locs_prep```: Called within file ```CTTReport.Rmd```. Takes a value returned by ```prep_info```. Argument ```n``` is the floor for filtering locations based on number of nodes detecting the tag during sampling interval. Returns same list with added components. 
* ```dimouts.get```: Method for ```data.frame``` called within function ```prep_info```. Generic function for recovering or fixing beeps with incorrect TagId. Takes dataset, correct TagId spelling, name of TagId column. 

Plotting functions:

These are intended to be customized at the user's discretion. Plotting functions load the dataset (return value of ```locs_prep```) into the function environment and return that same value if ```return.ls``` is set to ```TRUE```. Users are encouraged to compose their own plotting functions for their purposes. 

* ```plotNodeRSSI```: Facet-wrapped plots of RSSI over time for each node. 
* ```plotTagRSSI```: Facet-wrapped plots of RSSI over time for each tag. 
* ```plotTagDetections```: Spatial bubble plots with each bubble representing a node and its size representing number of tag detections. Facet-wrapped by tag. 
* ```PlotNodeLocs```: Satellite map showing each node and its NodeId. Requires Google API key with Maps Static access as ```api.token```. 
* ```plotDistinctNodes```: Number of unique nodes detecting a tag within the sampling interval over time. Facet-wrapped by tag. 
* ```wrapLocsAllTime```: Sampled tag locations plotted with node locations. Facet-wrapped by tag.
* ```wrapRecentLocs```: Sampled tag locations from the past seven days plotted with node locations. Facet-wrapped by tag. 
* ```printRecentMaps```: Series of satellite map plots of recent locations. 

## DailyReport.Rmd

```DailyReport.Rmd``` contains the Markdown for Daily Reports. This file is rendered by the function ```ctt_report```. It serves as documentation for how to use the plotting functions within a Markdown file, and creative liscense is encouraged. 








