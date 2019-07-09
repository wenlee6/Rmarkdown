### Scripts and functions for SIA rmarkdown reports

### SIU ggplot functions

## Bar chart
ggplot_siu_bar <- function(datasetname, var, val, groupvar, xlb, ylb){
  
  ggplot(
    data = datasetname,
    aes_string(var, 
               val, 
               fill = groupvar
    )
  ) +
    geom_bar(stat = "identity", alpha = 0.8, position = "dodge", colour = NA, width = 0.6) +
    # theme_minimal() +
    labs(x = xlb, y = ylb) +
    theme_siu() +
    scale_fill_siu() +
    # scale_fill_grey() +
    scale_y_continuous(labels = percent_format()) +
    guides(fill = guide_legend(nrow = 2, byrow = TRUE))
  
}

## Column chart
ggplot_siu_column <- function(datasetname, var, val, groupvar, xlb, ylb){
  ggplot_siu_bar(datasetname, var, val, groupvar, xlb, ylb) + 
    coord_flip()
}

## Bar chart with no tick label. Used when only looking at the presence of 
## something (e.g. social housing tenancy = 'Yes')
ggplot_siu_bar_no_tick_lab <- function(datasetname, var, val, groupvar, xlb, ylb){
  ggplot_siu_bar(datasetname, groupvar, val, groupvar, xlb, ylb) + 
    theme(axis.text.x = element_blank(), 
          axis.title.x = element_blank(),
          axis.ticks.x = element_blank())
}



## Line chart
ggplot_siu_line <- function(datasetname, var, val, groupvar, xlb, ylb){
  
  ggplot(
    data = datasetname,
    aes_string(var, 
               val, 
               col = 
                 groupvar
    )
  ) +
    geom_line(stat = "identity", alpha = 0.8, lwd = 1) +
    # theme_minimal() +
    labs(x = xlb, y = ylb) +
    theme_siu() +
    scale_colour_siu() +
    # scale_colour_grey() +
    scale_y_continuous(labels = percent_format()) +
    guides(colour = guide_legend(nrow = 2, byrow = TRUE))
  
}

## Density chart
ggplot_siu_density <- function(datasetname, var, val, groupvar, xlb, ylb){
  
  ggplot(
    data = datasetname,
    aes_string(var, 
               val, 
               fill = 
                 groupvar
               
    )
  ) +
    geom_density(stat = "identity", alpha = 0.3, colour = NA) +
    # theme_minimal() +
    labs(x = xlb, y = ylb) +
    theme_siu() +
    # scale_fill_siu() +
    scale_fill_grey() +
    scale_y_continuous(labels = percent_format()) +
    guides(fill = guide_legend(nrow = 2, byrow = TRUE))
  
}

### Generate RR3 counts by population type

pop_counts_rr3 <- function(var_name){
  
  x <- analysis_dataset %>%
    group_by_("pop_ind", var_name) %>%
    summarise(cnt = n()) %>%
    mutate(cnt = rrn(cnt, 3)) %>% #random rounding base 3
    group_by(pop_ind) %>%
    mutate(prop = cnt / sum(cnt))
  
  return(x)
}

### Generate RR3 counts by population type for adults only

pop_counts_rr3_adults <- function(var_name){
  
  x <- analysis_dataset %>%
    filter(between(as_at_age,15,100)) %>%
    group_by_("pop_ind", var_name) %>%
    summarise(cnt = n()) %>%
    mutate(cnt = rrn(cnt, 3)) %>% #random rounding base 3
    group_by(pop_ind) %>%
    mutate(prop = cnt / sum(cnt))
  
  return(x)
}

### Generate RR3 counts by population type for working age adults only

pop_counts_rr3_adults_working <- function(var_name){
  
  x <- analysis_dataset %>%
    filter(between(as_at_age,15,65)) %>%
    group_by_("pop_ind", var_name) %>%
    summarise(cnt = n()) %>%
    mutate(cnt = rrn(cnt, 3)) %>% #random rounding base 3
    group_by(pop_ind) %>%
    mutate(prop = cnt / sum(cnt))
  
  return(x)
}

### Generate RR3 counts by population type

pop_counts_rr3_0_5 <- function(var_name){
  
  x <- analysis_dataset %>%
    filter(between(as_at_age,0,5)) %>%
    group_by_("pop_ind", var_name) %>%
    summarise(cnt = n()) %>%
    mutate(cnt = rrn(cnt, 3)) %>% #random rounding base 3
    group_by(pop_ind) %>%
    mutate(prop = cnt / sum(cnt))
  
  return(x)
}

### Generate RR3 counts by population type

pop_counts_rr3_0_12 <- function(var_name){
  
  x <- analysis_dataset %>%
    filter(between(as_at_age,0,12)) %>%
    group_by_("pop_ind", var_name) %>%
    summarise(cnt = n()) %>%
    mutate(cnt = rrn(cnt, 3)) %>% #random rounding base 3
    group_by(pop_ind) %>%
    mutate(prop = cnt / sum(cnt))
  
  return(x)
}

pop_counts_rr3_10_plus_females <- function(var_name){
  
  x <- analysis_dataset %>%
    filter(between(as_at_age,10,100)) %>%
    filter(sex_char == 'Female') %>%
    group_by_("pop_ind", var_name) %>%
    summarise(cnt = n()) %>%
    mutate(cnt = rrn(cnt, 3)) %>% #random rounding base 3
    group_by(pop_ind) %>%
    mutate(prop = cnt / sum(cnt))
  
  return(x)
}

### Generate knitr table for rmarkdown

siu_rmd_table <- function(dset, var_name){
  
  dset %>%
    dplyr::select(-prop) %>%
    spread_(var_name, "cnt") %>%
    rename(Population = pop_ind) %>%
    kable(align = "l", format.args = list(big.mark = ","), format = "markdown")
  
}
