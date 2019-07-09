### Scripts and functions for rmarkdown reports


## Bar chart
ggplot_bar <- function(datasetname, var, val, groupvar, xlb, ylb){
  
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
    theme() +
    scale_fill() +
    # scale_fill_grey() +
    scale_y_continuous(labels = percent_format()) +
    guides(fill = guide_legend(nrow = 2, byrow = TRUE))
  
}

## Column chart
ggplot_column <- function(datasetname, var, val, groupvar, xlb, ylb){
  ggplot_bar(datasetname, var, val, groupvar, xlb, ylb) + 
    coord_flip()
}

## Bar chart with no tick label. Used when only looking at the presence of 
## something (e.g. social housing tenancy = 'Yes')
ggplot_bar_no_tick_lab <- function(datasetname, var, val, groupvar, xlb, ylb){
  ggplot_siu_bar(datasetname, groupvar, val, groupvar, xlb, ylb) + 
    theme(axis.text.x = element_blank(), 
          axis.title.x = element_blank(),
          axis.ticks.x = element_blank())
}



## Line chart
ggplot_line <- function(datasetname, var, val, groupvar, xlb, ylb){
  
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
    theme() +
    scale_colour() +
    # scale_colour_grey() +
    scale_y_continuous(labels = comma_format()) +
    guides(colour = guide_legend(nrow = 2, byrow = TRUE))
  
}

## Density chart
ggplot_density <- function(datasetname, var, val, groupvar, xlb, ylb){
  
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
    theme() +
    # scale_fill_siu() +
    scale_fill_grey() +
    scale_y_continuous(labels = comma_format()) +
    guides(fill = guide_legend(nrow = 2, byrow = TRUE))
  
}

### Generate RR3 counts by population type

pop_counts <- function(var_name){
  
  x <- analysis_dataset %>%
    group_by(pop_ind, !!as.name(var_name)) %>%
    summarise(cnt = n()) %>%
    group_by(pop_ind) %>%
    mutate(prop = cnt / sum(cnt))
  
  return(x)
}

### Generate counts by IRD number

pop_counts_ird <- function(){
  
  x <- analysis_dataset %>%
    group_by(pop_ind,IRD_NUMBER)%>%
  summarise(count=n())%>%
  mutate(band = cut(count,c(0,1,2,3,10,20,100),labels=c('1', '2', '3', '4-10','10-20','20-100')))%>%
   na.omit%>% 
   group_by(pop_ind,band)%>% 
 summarise(cnt=n())%>%
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
    group_by(pop_ind) %>%
    mutate(prop = cnt / sum(cnt))
  
  return(x)
}

### Generate knitr table for rmarkdown

rmd_table <- function(dset, var_name){
  
  dset %>%
    dplyr::select(-prop) %>%
    spread_(var_name, "cnt") %>%
    rename(Population = pop_ind) %>%
    kable(align = "l", format.args = list(big.mark = ","), format = "markdown")
  
}
