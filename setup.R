###########################
###     SIU set up      ###
###########################

###Load libraries (that are required for this script)
library(ROracle)

drv <- dbDriver("Oracle")
connect.string <- paste("(DESCRIPTION_LIST=(FAILOVER=on)(LOAD_BALANCE=off)   (DESCRIPTION=(LOAD_BALANCE=on)(RETRY_COUNT=3) (ADDRESS=(PROTOCOL=tcp)(HOST=ok700p-scan)(PORT=1521))   (CONNECT_DATA=(SERVICE_NAME=ALCZR)))   (DESCRIPTION=(LOAD_BALANCE=on)(RETRY_COUNT=3) (ADDRESS=(PROTOCOL=tcp)(HOST=op700p-scan)(PORT=1521))   (CONNECT_DATA=(SERVICE_NAME=ALCZR))))")
con <- dbConnect(drv = drv, username='XXX', password='XXXX',dbname=connect.string)



###############################################
####
#### Title: ggplot2 theme functions for the IRD
#### Date:10 November 2016
####
#### Directions: Load ggplot2 and compile both 
#### functions. See testing code at the botom
#### for an example.
#### 
###############################################

# library(ggplot2)

####theme####
theme <- function(base_size = 12, base_family = "") 
{
  half_line <- base_size/2
  theme_minimal(base_size = base_size, base_family = base_family) %+replace% 
    theme(
      axis.text = element_text(colour = "#315259", family = 'Century Gothic', size = rel(0.8)),
      axis.title = element_text(colour = "black", family = 'Century Gothic'),
      axis.ticks = element_line(colour = "black"), 
      legend.key = element_rect(colour = NA),
      legend.title = element_blank(),
      legend.position = "bottom",
      plot.title = element_text(color = "#588D97", family = 'Century Gothic', size = 15, 
                                margin = margin(b = half_line * 1.2)),
      plot.margin = margin(half_line, half_line, half_line, half_line),
      panel.grid = element_blank()
    )
}



###############################################################################################

####scale_colour#####
scale_colour <- function(..., values) {
  # ggplot2:::manual_scale("colour", values = c("#588D97", "#F47C20", "#414258", "#315259", "#262638"), ...)
  ggplot2:::manual_scale("colour", values = c("#262638", rep("#BDBAC0",10)), ...)
}

#Put in ggplot2 environment to inherit ggplot2 functionality
# environment(scale_colour_siu) <- asNamespace("ggplot2")

###############################################################################################

####scale_fill_siu#####
scale_fill <- function(..., values) {
  # ggplot2:::manual_scale("fill", values = c("#588D97", "#F47C20", "#414258", "#315259", "#262638"), ...)
  ggplot2:::manual_scale("fill", values = c("#262638", rep("#BDBAC0",10)), ...)
}

#Put in ggplot2 environment to inherit ggplot2 functionality
# environment(scale_fill_siu) <- asNamespace("ggplot2")

###############################################################################################
