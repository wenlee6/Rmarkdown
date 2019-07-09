###Read in and pre-preocess data


bl_clean <- brightline_nw %>%
#  rename(
 #   CITY = city
    # ,region = ant_region_code
#  ) %>%
  mutate(
    ## Reorder pop_ind
    month = month(as.Date(SALE_DATE)),
    year = year(as.Date(SALE_DATE)),
    date_text =paste(year,month,sep="/"),
    duration =difftime(PURCHASE_DATE,SALE_DATE,units="days"),
    pop_ind ="Brightline"
    # ,cyf_abuse = ifelse(cyf_abuse_2yrs_flag == 1, "Yes", "No")
    # ,cnp_event = ifelse(cyf_cnpevent_2yrs_flag == 1, "Yes", "No")
    # ,yju_event = ifelse(cyf_yjuevent_2yrs_flag == 1, "Yes", "No")
    #
    # ,no_phoenrol_ind_2yrs = ifelse(pho_enrolled_flag == 0, "Yes", "No")

    #,dep_index = factor(dep_index)
  )

all_clean <- property_all %>%
#  rename(
 #   CITY = city
    # ,region = ant_region_code
#  ) %>%
  mutate(
    ## Reorder pop_ind
    month = month(as.Date(SALE_DATE)),
    year = year(as.Date(SALE_DATE)),
    date_text =paste(year,month,sep="/"),
    duration =difftime(PURCHASE_DATE,SALE_DATE,units="days"),
    pop_ind ="All"
    # ,cyf_abuse = ifelse(cyf_abuse_2yrs_flag == 1, "Yes", "No")
    # ,cnp_event = ifelse(cyf_cnpevent_2yrs_flag == 1, "Yes", "No")
    # ,yju_event = ifelse(cyf_yjuevent_2yrs_flag == 1, "Yes", "No")
    #
    # ,no_phoenrol_ind_2yrs = ifelse(pho_enrolled_flag == 0, "Yes", "No")
    
    #,dep_index = factor(dep_index)
  )

analysis_dataset<-union_all(bl_clean,all_clean)

#save(analysis_dataset,file="analysis_dataset.RData")
