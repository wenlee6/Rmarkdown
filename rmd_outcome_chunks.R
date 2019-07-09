### rmd outcome chunks

## Month breakdown
bl_chunk <- function(){
  
  df_rr3 <- pop_counts("year")
  
  plt <- df_rr3 %>% ggplot_bar("year", "prop", "pop_ind", "Date", "Count")
  plt<-ggplotly(plt)
  
  tb <- df_rr3 %>% rmd_table("year")
  
  return(list(plot = plt, table = tb))
  
} 

## City Brekdown
city_chunk <- function(){
  
  df_rr3 <- pop_counts("CITY")%>% filter(CITY %in% c("Auckland", "Christchurch","Wellington","Hamilton","Tauranga","Papamoa","Pukekohe","Palmerston North"))
  
  plt <- df_rr3 %>% ggplot_column("CITY", "prop", "pop_ind", "City", "Count")
  plt<-ggplotly(plt)
  
  tb <- df_rr3 %>% rmd_table("CITY")
  
  return(list(plot = plt, table = tb))
  
} 

## Duration Chunks - desnity plot
duration_chunk <- function(){

  plt<- ggplot(
  data = analysis_dataset,
  aes(x= duration, 
             fill = 
               pop_ind
  )
) +
  geom_density(alpha = 0.3, colour = NA) +
  xlim(c(-2000,100))+
  theme()
# scale_fill_siu()+
  
  plt<-ggplotly(plt)
  
return(plt)
  
}


## IRD Individual number of transactions from 1- 5 2019

replicate_chunk <- function(){
df_rr3 <- pop_counts_ird()
plt <-  ggplot(
  data = df_rr3,
  aes(band, 
             prop, 
             fill = pop_ind
  )
) +
  geom_bar(stat = "identity", alpha = 0.8, position = "dodge", colour = NA, width = 0.6) +
  # theme_minimal() +
  labs(x = "Band", y = "Prop") +
  theme() +
  scale_fill() +
  # scale_fill_grey() +
  scale_y_continuous(labels = percent_format()) +
  guides(fill = guide_legend(nrow = 2, byrow = TRUE))

plt<-ggplotly(plt)

tb <- df_rr3 %>% rmd_table("band")

return(list(plot = plt, table = tb))

}