library(dplyr)

##################################################################
#
# Processing Script for all "District-Level" EdSight data
# Created by Jenna Daly
# On 03/14/2017
#
##################################################################

# First step is to create the data packages you need to process, i.e. "Chronic Absenteeism", "Student-Enrollment", etc... then
# use these folder names to bring in new data and copy to the designated "raw" folders in each datapackage directory.

#Setup environment
sub_folders <- list.files()
raw_from_github_location <- grep("Raw", sub_folders, value=T)
raw_from_github_path <- (paste0(getwd(), "/", raw_from_github_location))

raw_dataset_paths <- list.dirs(raw_from_github_path, full.names = TRUE)

# Below is the list of all possible datasets, if new data is available, it goes into the 
# raw_from_github folder and copies files into their respective "raw" folders within their DPs

###Chronic Absenteeism###
chronic_absent_dp_location <- grep("Chronic", sub_folders, value=T)
chronic_absent_dp_path <- (paste0(getwd(), "/", chronic_absent_dp_location, "/", "raw"))
chronic_absent_raw_filepath <- dir(raw_dataset_paths, pattern = "attendance", full.names = TRUE)
chronic_absent_files <- dir(chronic_absent_raw_filepath, pattern = ".csv")
copy_chronic_absent <- lapply(chronic_absent_files, function(x) file.copy(paste (chronic_absent_raw_filepath, x , sep = "/"),  
                              paste (chronic_absent_dp_path,x, sep = "/"), recursive = FALSE,  copy.mode = TRUE))

###Staffing Levels###
staff_lvls_dp_location <- grep("Staffing", sub_folders, value=T)
staff_lvls_dp_path <- (paste0(getwd(), "/", staff_lvls_dp_location, "/", "raw"))
staff_lvls_raw_filepath <- dir(raw_dataset_paths, pattern = "staffing", full.names = TRUE)
staff_lvls_files <- dir(staff_lvls_raw_filepath, pattern = ".csv")
copy_staff_lvls <- lapply(staff_lvls_files, function(x) file.copy(paste (staff_lvls_raw_filepath, x , sep = "/"),  
                          paste (staff_lvls_dp_path,x, sep = "/"), recursive = FALSE,  copy.mode = TRUE))

###Bullying###
bully_dp_location <- grep("Bullying", sub_folders, value=T)
bully_dp_path <- (paste0(getwd(), "/", bully_dp_location, "/", "raw"))
bully_raw_filepath <- dir(raw_dataset_paths, pattern = "bullying", full.names = TRUE)
bully_files <- dir(bully_raw_filepath, pattern = ".csv")
copy_bully <- lapply(bully_files, function(x) file.copy(paste (bully_raw_filepath, x , sep = "/"),  
                     paste (bully_dp_path,x, sep = "/"), recursive = FALSE,  copy.mode = TRUE))

###College-Prep###
coll_prep_dp_location <- grep("College-Prep", sub_folders, value=T)
coll_prep_dp_path <- (paste0(getwd(), "/", coll_prep_dp_location, "/", "raw"))
coll_prep_raw_filepath <- dir(raw_dataset_paths, pattern = "college_prep", full.names = TRUE)
coll_prep_files <- dir(coll_prep_raw_filepath, pattern = ".csv")
copy_coll_prep <- lapply(coll_prep_files, function(x) file.copy(paste (coll_prep_raw_filepath, x , sep = "/"),  
                         paste (coll_prep_dp_path,x, sep = "/"), recursive = FALSE,  copy.mode = TRUE))

###Education-Qualifications###
edu_qual_dp_location <- grep("Qualifications", sub_folders, value=T)
edu_qual_dp_path <- (paste0(getwd(), "/", edu_qual_dp_location, "/", "raw"))
edu_qual_raw_filepath <- dir(raw_dataset_paths, pattern = "qualifications", full.names = TRUE)
edu_qual_files <- dir(edu_qual_raw_filepath, pattern = ".csv")
copy_edu_qual <- lapply(edu_qual_files, function(x) file.copy(paste (edu_qual_raw_filepath, x , sep = "/"),  
                        paste (edu_qual_dp_path,x, sep = "/"), recursive = FALSE,  copy.mode = TRUE))

###Student-Enrollment###
stdnt_enroll_dp_location <- grep("Student-Enrollment", sub_folders, value=T)
stdnt_enroll_dp_path <- (paste0(getwd(), "/", stdnt_enroll_dp_location, "/", "raw"))
stdnt_enroll_raw_filepath <- dir(raw_dataset_paths, pattern = "enrollment", full.names = TRUE)
stdnt_enroll_files <- dir(stdnt_enroll_raw_filepath, pattern = ".csv")
copy_stdnt_enroll <- lapply(stdnt_enroll_files, function(x) file.copy(paste (stdnt_enroll_raw_filepath, x , sep = "/"),  
                            paste (stdnt_enroll_dp_path,x, sep = "/"), recursive = FALSE,  copy.mode = TRUE))

###Incidents###
incidents_dp_location <- grep("Incidents", sub_folders, value=T)
incidents_dp_path <- (paste0(getwd(), "/", incidents_dp_location, "/", "raw"))
incidents_raw_filepath <- dir(raw_dataset_paths, pattern = "incidents", full.names = TRUE)
incidents_files <- dir(incidents_raw_filepath, pattern = ".csv")
copy_incidents <- lapply(incidents_files, function(x) file.copy(paste (incidents_raw_filepath, x , sep = "/"),  
                         paste (incidents_dp_path,x, sep = "/"), recursive = FALSE,  copy.mode = TRUE))

###Students-with-Disabilities###
disability_dp_location <- grep("Disabilities", sub_folders, value=T)
disability_dp_path <- (paste0(getwd(), "/", disability_dp_location, "/", "raw"))
disability_raw_filepath <- dir(raw_dataset_paths, pattern = "primarydisability", full.names = TRUE)
disability_files <- dir(disability_raw_filepath, pattern = ".csv")
copy_disability <- lapply(disability_files, function(x) file.copy(paste (disability_raw_filepath, x , sep = "/"),  
                          paste (disability_dp_path,x, sep = "/"), recursive = FALSE,  copy.mode = TRUE))

###Sanctions###
sanctions_dp_location <- grep("Sanctions", sub_folders, value=T)
sanctions_dp_path <- (paste0(getwd(), "/", sanctions_dp_location, "/", "raw"))
sanctions_raw_filepath <- dir(raw_dataset_paths, pattern = "sanctions", full.names = TRUE)
sanctions_files <- dir(sanctions_raw_filepath, pattern = ".csv")
copy_sanctions <- lapply(sanctions_files, function(x) file.copy(paste (sanctions_raw_filepath, x , sep = "/"),  
                         paste (sanctions_dp_path,x, sep = "/"), recursive = FALSE,  copy.mode = TRUE))

###Suspension-Rates
susp_rates_dp_location <- grep("Suspension-Rates", sub_folders, value=T)
susp_rates_dp_path <- (paste0(getwd(), "/", susp_rates_dp_location, "/", "raw"))
susp_rates_raw_filepath <- dir(raw_dataset_paths, pattern = "suspension_rates", full.names = TRUE)
susp_rates_files <- dir(susp_rates_raw_filepath, pattern = ".csv")
copy_susp_rates <- lapply(susp_rates_files, function(x) file.copy(paste (susp_rates_raw_filepath, x , sep = "/"),  
                          paste (susp_rates_dp_path,x, sep = "/"), recursive = FALSE,  copy.mode = TRUE))

