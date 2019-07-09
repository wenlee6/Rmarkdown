###Read in and pre-preocess data


bl_clean <- brightline_nw %>%
  rename(
    city = CITY
    # ,region = ant_region_code
  ) %>%
  mutate(
    ## Reorder pop_ind
    month = month(as.Date(SALE_DATE))
    # ,cyf_abuse = ifelse(cyf_abuse_2yrs_flag == 1, "Yes", "No")
    # ,cnp_event = ifelse(cyf_cnpevent_2yrs_flag == 1, "Yes", "No")
    # ,yju_event = ifelse(cyf_yjuevent_2yrs_flag == 1, "Yes", "No")
    #
    # ,no_phoenrol_ind_2yrs = ifelse(pho_enrolled_flag == 0, "Yes", "No")

    #,dep_index = factor(dep_index)
  )
