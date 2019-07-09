### rmd outcome chunks

## bl
bl_chunk <- function(){
  
  df_rr3 <- pop_counts_rr3("month")
  
  plt <- df_rr3 %>% ggplot_line("month", "prop", "pop_ind", "Month", "Proportion")
  
  tb <- df_rr3 %>% rmd_table("month")
  
  return(list(plot = plt, table = tb))
  
} 

