library(dplyr)
library(datapkg)

##################################################################
#
# Processing Script for Bullying
# Created by Jenna Daly
# On 03/15/2017
#
##################################################################

#Setup environment
sub_folders <- list.files()
data_location <- grep("raw$", sub_folders, value=T)
path <- (paste0(getwd(), "/", data_location))
all_csvs <- dir(path, recursive=T, pattern = ".csv") 

bullying <- data.frame(stringsAsFactors = F)
bully_files_noTrend <- grep("Trend", all_csvs, value=T, invert=T)
###Bullying###
for (i in 1:length(bully_files_noTrend)) {
  current_file <- read.csv(paste0(path, "/", bully_files_noTrend[i]), stringsAsFactors=F, header=F )
  current_file <- current_file[-c(1:3),]
  rownames(current_file) <- current_file[,1]
  colnames(current_file) <- current_file[which(rownames(current_file) %in% c("District", "DISTRICT")), ]
  rownames(current_file) <- NULL
  current_file = current_file[-1, ] 
  current_file <- current_file[, !(names(current_file) == "District Code")]
  get_year <- as.numeric(substr(unique(unlist(gsub("[^0-9]", "", unlist(bully_files_noTrend[i])), "")), 1, 4))
  get_year <- paste0(get_year, "-", get_year + 1) 
  current_file$Year <- get_year
  bullying <- rbind(bullying, current_file)
}

#Add statewide data...

#backfill Districts
district_dp_URL <- 'https://raw.githubusercontent.com/CT-Data-Collaborative/ct-school-district-list/master/datapackage.json'
district_dp <- datapkg_read(path = district_dp_URL)
districts <- (district_dp$data[[1]])

bullying_fips <- merge(bullying, districts, by.x = "DISTRICT", by.y = "District", all=T)

bullying_fips$DISTRICT <- NULL

bullying_fips<-bullying_fips[!duplicated(bullying_fips), ]

#backfill year
years <- c("2012-2013",
           "2013-2014",
           "2014-2015",
           "2015-2016")

backfill_years <- expand.grid(
  `FixedDistrict` = unique(districts$`FixedDistrict`),
  `Year` = years 
)

backfill_years$FixedDistrict <- as.character(backfill_years$FixedDistrict)
backfill_years$Year <- as.character(backfill_years$Year)

backfill_years <- arrange(backfill_years, FixedDistrict)

complete_bullying <- merge(bullying_fips, backfill_years, all=T)
complete_bullying$DISTRICT <- NULL

#remove duplicated Year rows
complete_bullying <- complete_bullying[!with(complete_bullying, is.na(complete_bullying$Year)),]

#recode missing data with -6666
complete_bullying[["Number of students with at least 1 bullying incident"]][is.na(complete_bullying[["Number of students with at least 1 bullying incident"]])] <- -6666
complete_bullying[["Counts of Bullying Incidents"]][is.na(complete_bullying[["Counts of Bullying Incidents"]])] <- -6666

#recode suppressed data with -9999
complete_bullying[["Number of students with at least 1 bullying incident"]][complete_bullying$"Number of students with at least 1 bullying incident" == "*"]<- -9999
complete_bullying[["Counts of Bullying Incidents"]][complete_bullying$"Counts of Bullying Incidents" == "*"]<- -9999

#return blank in FIPS if not reported
complete_bullying$FIPS <- as.character(complete_bullying$FIPS)
complete_bullying[["FIPS"]][is.na(complete_bullying[["FIPS"]])] <- ""


#reshape from wide to long format
cols_to_stack <- c("Number of students with at least 1 bullying incident", 
                   "Counts of Bullying Incidents")

long_row_count = nrow(complete_bullying) * length(cols_to_stack)

complete_bullying_long <- reshape(complete_bullying, 
                         varying = cols_to_stack, 
                         v.names = "Value", 
                         timevar = "Variable", 
                         times = cols_to_stack, 
                         new.row.names = 1:long_row_count,
                         direction = "long"
)
#Rename FixedDistrict to District
names(complete_bullying_long)[names(complete_bullying_long) == 'FixedDistrict'] <- 'District'

#reorder columns and remove ID column
complete_bullying_long <- complete_bullying_long[order(complete_bullying_long$District, complete_bullying_long$Year),]
complete_bullying_long$id <- NULL

#Add Measure Type
complete_bullying_long$`Measure Type` <- "Number"

#Order columns
complete_bullying_long <- complete_bullying_long %>% 
  select(`District`, `FIPS`, `Year`, `Variable`, `Measure Type`, `Value`)

#Write CSV
write.table(
  complete_bullying_long,
  file.path(getwd(), "data", "bullying_2013-2016.csv"),
  sep = ",",
  row.names = F
)
