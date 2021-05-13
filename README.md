# README - CTT Reports

Author: Miles Buddy

CTT Reports visualize data generated by Cellular Tracking Technologies wildlife tracking systems. The visualizations are comprehensively displayed in documents
rendered by R Markdown. They may be used to evaluate information such as tag RSSI, node RSSI, and tag locations over a specified time interval. They are meant to
be flexible, and we encourage the modification of the Rmd files as any specific project may dictate. Examples of CTT Reports are included in the current release.

Users must install the CTT ```data_tools``` repository before creating CTT Reports. See https://github.com/cellular-tracking-technologies/data_tools for details. We
reccomend reading the README at that page before proceeding. The code for creating CTT Reports sources functions from ```data_tools/functions/localization.R``` and 
```data_tools/functions/data_manager.R```. For details about RStudio and RMarkdown, visit https://www.rstudio.com and https://www.rmarkdown.rstudio.com, respectively.



## Creating Reports

There are two types of CTT reports: Daily Reports and Site Recaps. Daily Reports are used during the time a SensorStation is deployed at a given site, while 
Site Recaps encompass the full time interval a SensorStation was active at a site. Reports are rendered by calling the functions ```daily_report``` and 
```site_recap```.

### Daily Reports

The function ```daily_report``` renders ```DailyReport.Rmd``` once for each list object passed to it. Each of these objects must contain the following components:

* ```site_name```: the name of your sampling site
* ```infile```: path to directory containing all raw downloaded files from the SensorStation in one folder or subfolders (node, raw, gps, etc.)
* ```tags```: a dataframe containing a column named ```TagId``` with tag ID numbers (path to CSV file also accepted) 
* ```nodes```: a dataframe containing columns ```NodeId```, ```lat```, and ```lng``` corresponding to node ID numbers and locations (path to CSV also accepted)
* ```outpath```: directory to create output
* ```start_time```: lower bound of time interval, must be in POSIXct format
* ```centerLon```: longitude coordinate basemap center
* ```centerLat```: latitude coordinate of basemap center

An optional upper bound to the time interval, ```end_time```, may be specified in the list. 

Example implementation:
```r
FF.info <- list(
  site_name = 'FF',
  infile = '~/Desktop/CTT/Data/Winter Marsh Sparrows/277805DD663C',
  tags = read.csv('~/Desktop/CTT/Tools/FF_tagsdeployed_2021.csv', as.is=TRUE, na.strings = c('NA', "")),
  nodes = read.csv('~/Desktop/CTT/Tools/FF_NodeLocs.csv', as.is=TRUE, na.strings=c("NA", "")),
  outpath = '~/Desktop/CTT/Output/FF',
  start_time = as.POSIXct('2021-02-28 00:00:00', tz = 'EST'),
  end_time = as.POSIXct('2021-03-31 08:00:00', tz = 'EST'), # optional
  centerLon = -77.9615,
  centerLat = 33.8835
)

daily_report(FF.info)
```

### Site Recaps

```site_recap``` renders ```SiteRecap.Rmd``` for each list object passed to it. ```end_time```, the upper bound of the time interval, must be specified as a component
of every list passed as a parameter. The behavior of this function is otherwise identical to that of ```daily_report```. 


```locsfile```: This parameter is set to ```TRUE``` by default. It indicates whether to write a CSV file with locations to ```outpath```.

Example implementation:
```r
RCR.info <- list(
  site_name = 'RCR',
  infile = "~/Desktop/CTT/Data/Winter Marsh Sparrows/32D74E282514",
  tags = read.csv("~/Desktop/CTT/Tools/Tags_RCR_2021.csv", as.is=TRUE, na.strings=c("NA", "")),
  nodes = read.csv('~/Desktop/CTT/Tools/RCR_Node_Locations_CTT.csv', as.is=TRUE, na.strings=c("NA", "")),
  outpath = '~/Desktop/CTT/Output/RCR',
  start_time = as.POSIXct("2021-01-13 00:00:00", tz = "EST"),
  end_time = as.POSIXct("2021-02-27 00:00:00", tz = "EST"),
  centerLon = -76.6369,
  centerLat = 34.7015
)

site_recap(RCR.info, HBSP.info)
```

## DailyReport.Rmd

```DailyReport.Rmd``` contains the Markdown for Daily Reports. Output type, title, and author may be specified on lines 2, 43, and 44, respectively. The code chunks
are as follows:

* ```defaults``` (line 8): Sets some defaults to prevent unwanted messages in the output. Do not edit.
* ```setup``` (lines 12-39): Downloads raw data and prepares it for plotting. Lines 37 and 39 can be edited to change sampling interval.
* ```nodes``` (lines 53-54): Prints plot of NodeRSSI over time. Modify ```fig.width``` and ```fig.height``` depending on the number of nodes.
* ```tags``` (lines 60-61): Prints plot of TagRSSI over time. Modify ```fig.width``` and ```fig.height``` depending on the number of tags.
* ```apikey``` (lines 66-69): Registers your Google API key. Before running, you must regsiter an API key on Google Cloud Platform with access to the following APIs: 
Maps Static, Geocoding, Geolocation, Maps Embed. Edit line 68 to include your Google API key. 
* ```nodelocs``` (lines 76-84): Prints a map with node locations marked. 
* ```locsetup``` (lines 90-109): Prepares location data for plotting. Minimum RSSI (line 90), sampling frequency (line 91), and minimum number of nodes (line 93) may be edited. 
* ```locsalltime``` (lines 113-116): Prints facet-wrapped (by tag) plot of all locations. 
* ```recentlocs``` (lines 122-125): Prints facet-wrapped (by tag) plot of all locations sampled since one week ago. 
* ```recentmaps``` (lines 129-151): For each tag, prints a location plot with Google satellite basemap. Only locations recorded within past week are plotted. Options
for indicating species ID by label or color are commented out. 


## SiteRecap.Rmd contains the Markdown for Site Recaps. Output type, title, and author may be specified on lines 2, 38, and 39, respectively. The code chunks
are as follows:

* ```defaults``` (line 8): Sets some defaults to prevent unwanted messages in the output. Do not edit.
* ```setup``` (lines 10-34): Downloads raw data and prepares it for plotting. Lines 37 and 39 can be edited to change sampling interval.
* ```nodes``` (lines 45-46): Prints plot of NodeRSSI over time. Modify ```fig.width``` and ```fig.height``` depending on the number of nodes.
* ```tags``` (lines 52-53): Prints plot of TagRSSI over time. Modify ```fig.width``` and ```fig.height``` depending on the number of tags.
* ```apikey``` (lines 57-60): Registers your Google API key. Before running, you must regsiter an API key on Google Cloud Platform with access to the following APIs: 
Maps Static, Geocoding, Geolocation, Maps Embed. Edit line 68 to include your Google API key. 
* ```nodelocs``` (lines 67-75): Prints a map with node locations marked. 
* ```locsalltime``` (lines 80-114): For each tag, prints a location plot with Google satellite basemap. Options for indicating species ID by label or color 
are commented out. 






