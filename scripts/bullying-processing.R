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

#Name to EdSight top level folder
raw_from_github_location <- grep("Raw", sub_folders, value=T)

#Path to EdSight top level folder
raw_from_github_path <- (paste0(getwd(), "/", raw_from_github_location))

#paths to EdSight data folder
raw_dataset_paths <- list.dirs(raw_from_github_path, full.names = TRUE)

#all DP "raw" paths
all_DP_raw_paths <- ls(pattern="_dp_path")
all_DP_raw_files <- ls(pattern="_files")

# "bully_dp_path"          
# "chronic_absent_dp_path" 
# "coll_prep_dp_path"      
# "disability_dp_path"     
# "ed_qual_dp_path"       
# "incidents_dp_path"      
# "sanctions_dp_path"      
# "staff_lvls_dp_path"     
# "stdnt_enroll_dp_path"   
# "susp_rates_dp_path"


#assign rownames based on first column
#assign colnames based on which ever row starts with District
#remove rownames
#colnames(current_file) = current_file[1, ] # the first row will be the header
#remove first row
#remove district code column

bullying <- data.frame(stringsAsFactors = F)
bully_files_noTrend <- grep("Trend", bully_files, value=T, invert=T)
###Bullying###
for (i in 1:length(bully_files_noTrend)) {
  current_file <- read.csv(paste0(bully_dp_path, "/", bully_files_noTrend[i]), stringsAsFactors=F, header=F )
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

#backfill Districts




# #define categories based on filenames
# extract <- gsub('.csv', '', sub('.*\\_', '', all_csvs))
# categories <- unique(extract)
# 
# for (i in 1:length(categories)) {
#   current_cat <- categories[1]
#   current_list <- dir(path, pattern = current_cat)
#   assign(paste0(current_cat, "_files"), dir(path, pattern = categories[i]))
#   for (j in 1:length(current_list)) {
#     current_file <- read.csv(paste0(path, "/", current_list[1]), stringsAsFactors=F, header=F )
#     #remove first 2 rows
#     current_file <- current_file[-c(1:2),]
#     #assign rownames based on first column
#     rownames(current_file) <- current_file[,1]
#     #assign colnames based on which ever row starts with District
#     colnames(current_file) <- current_file[which(rownames(current_file) %in% c("District")), ]
#     #remove rownames
#     rownames(current_file) <- NULL
#     #colnames(current_file) = current_file[1, ] # the first row will be the header
#     #remove first row
#     current_file = current_file[-1, ] 
#     #remove district code column
#     current_file <- current_file[, !(names(current_file) == "District Code")]
#     #current_file$Category <- NA
#     current_file$Category <- current_cat
#     get_year <- as.numeric(substr(unique(unlist(gsub("[^0-9]", "", unlist(current_list[1])), "")), 1, 4))
#     get_year <- paste0(get_year, "-", get_year + 1) 
#     current_file$Year <- get_year
#   }
# }




