library(dplyr)
library(datapkg)
library(tidyr)

##################################################################
#
# Processing Script for Bullying
# Created by Jenna Daly
# On 03/15/2017
#
##################################################################

#Setup environment
sub_folders <- list.files()
raw_location <- grep("^raw", sub_folders, value=T)
path_to_raw <- (paste0(getwd(), "/", raw_location))
all_csvs <- dir(path_to_raw, recursive=T, pattern = ".csv") 
all_state_csvs <- dir(path_to_raw, recursive=T, pattern = "ct.csv") 
all_dist_csvs <- all_csvs[!all_csvs %in% all_state_csvs]


#District level data
bullying_dist <- data.frame(stringsAsFactors = F)
for (i in 1:length(all_dist_csvs)) {
  current_file <- read.csv(paste0(path_to_raw, "/", all_dist_csvs[i]), stringsAsFactors=F, header=F)
  current_file <- current_file[-c(1:3),]
  colnames(current_file) <- current_file[1,]
  current_file <- current_file[-1,]
  current_file <- current_file[, !(names(current_file) == "District Code")]
  get_year <- as.numeric(substr(unique(unlist(gsub("[^0-9]", "", unlist(all_dist_csvs[i])), "")), 1, 4))
  get_year <- paste0(get_year, "-", get_year + 1) 
  current_file$Year <- get_year
  bullying_dist <- rbind(bullying_dist, current_file)
}

#State level data
bullying_state <- data.frame(stringsAsFactors = F)
for (i in 1:length(all_state_csvs)) {
  current_file <- read.csv(paste0(path_to_raw, "/", all_state_csvs[i]), stringsAsFactors=F, header=F )
  current_file <- current_file[-c(1:3),]
  colnames(current_file) <- current_file[1,]
  current_file <- current_file[-1,]
  names(current_file)[names(current_file)=="STATE"] <- "DISTRICT"
  current_file$DISTRICT <- "Connecticut"
  get_year <- as.numeric(substr(unique(unlist(gsub("[^0-9]", "", unlist(all_state_csvs[i])), "")), 1, 4))
  get_year <- paste0(get_year, "-", get_year + 1) 
  current_file$Year <- get_year
  bullying_state <- rbind(bullying_state, current_file)
}

#Combine district and state
bullying <- rbind(bullying_dist, bullying_state)

#backfill Districts
district_dp_URL <- 'https://raw.githubusercontent.com/CT-Data-Collaborative/ct-school-district-list/master/datapackage.json'
district_dp <- datapkg_read(path = district_dp_URL)
districts <- (district_dp$data[[1]])

bullying_fips <- merge(bullying, districts, by.x = "DISTRICT", by.y = "District", all=T)

bullying_fips$DISTRICT <- NULL

bullying_fips <- unique(bullying_fips)

#backfill year
years <- c("2012-2013",
           "2013-2014",
           "2014-2015",
           "2015-2016", 
           "2016-2017")

backfill_years <- expand.grid(
  `FixedDistrict` = unique(districts$`FixedDistrict`),
  `Year` = years 
)

backfill_years$FixedDistrict <- as.character(backfill_years$FixedDistrict)
backfill_years$Year <- as.character(backfill_years$Year)

backfill_years <- arrange(backfill_years, FixedDistrict)

complete_bullying <- merge(bullying_fips, backfill_years, all.y=T)

#Rename variables
complete_bullying <- complete_bullying %>% 
  rename(`Students with at least 1 incident` = `Number of students with at least 1 bullying incident`, `Total Incidents` = `Counts of Bullying Incidents`)

#reshape from wide to long format
complete_bullying_long <- gather(complete_bullying, Variable, Value, 3:4, factor_key=FALSE)

#Add Measure Type
complete_bullying_long$`Measure Type` <- "Number"
complete_bullying_long$`Incident Type` <- "Bullying"

#Order, sort, and rename columns
complete_bullying_long <- complete_bullying_long %>% 
  select(FixedDistrict, FIPS, Year, `Incident Type`, `Measure Type`, Variable, Value) %>% 
  rename(District = FixedDistrict) %>% 
  arrange(District, Year, `Incident Type`)

#return blank in FIPS if not reported
complete_bullying_long$FIPS <- as.character(complete_bullying_long$FIPS)
complete_bullying_long[["FIPS"]][is.na(complete_bullying_long[["FIPS"]])] <- ""

#recode suppressed data with -9999
complete_bullying_long[complete_bullying_long == "*"]<- -9999

#Write CSV
write.table(
  complete_bullying_long,
  file.path(getwd(), "data", "bullying_2013-2017.csv"),
  sep = ",",
  na = "-6666",
  row.names = F
)
