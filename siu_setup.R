###########################
###     SIU set up      ###
###########################

###Load libraries (that are required for this script)
library(RODBC)

###Create connection string function - courtesy: Christopher Ball
set_conn_string <- function(db = "IDI_Sandpit"){
  tmp <- "DRIVER=ODBC Driver 11 for SQL Server; " 
  tmp <- paste0(tmp, "Trusted_Connection=Yes; ")
  tmp <- paste0(tmp, paste0("DATABASE=", db, " ; "))
  tmp <- paste0(tmp, "SERVER=WPRDSQL36.stats.govt.nz, 49530")
  
  return(tmp)
}

###Create readquery function (for reading in and parsing SQL queries)
readquery <- function(filename){
  paste(readLines(filename), collapse="\n")
}

###Create function for reading in table from SQL (using the connection string and SQL query script) 
read_sql_table <- function(query_object = data_query, connection_string = connstr){
  ###Connect to database
  conn <- odbcDriverConnect(connection = connection_string)
  
  ###Read table and assign to object
  tmp <- sqlQuery(channel = conn, query = readquery(query_object))
  
  ###Close connections
  odbcClose(conn)
  
  return(tmp)
}

# Developed by: Chris Hansen
# Date: 30/05/16
rrn <- function(x, n=3, seed)
{
  if (!missing(seed)) set.seed(seed)
  
  rr <- function(x, n){
    if (is.na(x)) return(0)
    if ((x%%n)==0) return(x)
    res <- abs(x)
    lo <- (res%/%n) * n
    if ((runif(1) * n) <= res%%n) res <- lo + n
    else res <- lo
    return(ifelse(x<0, (-1)*res, res))
  }
  
  isint <- function(x){
    x <- x[!is.na(x)]
    sum(as.integer(x)==x)==length(x)
  }
  
  if (class(x) %in% c("numeric", "integer")){
    if(isint(x)) return(sapply(x, rr, n))
    else return(x)
  }
  
  for (i in 1:ncol(x))
  {
    if (class(x[,i]) %in% c("numeric", "integer") & isint(x[,i])) x[,i] <- sapply(x[,i], rr, n)
  }
  x
}


###############################################
####
#### Title: ggplot2 theme functions for the SIU
#### Author: Conrad MacCormick
#### Date:10 November 2016
####
#### Directions: Load ggplot2 and compile both 
#### functions. See testing code at the botom
#### for an example.
#### 
###############################################

# library(ggplot2)

####theme_siu####
theme_siu <- function(base_size = 12, base_family = "") 
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

#Put in ggplot2 environment to inherit ggplot2 functionality
# environment(theme_siu) <- asNamespace("ggplot2")

###############################################################################################

####scale_colour_siu#####
scale_colour_siu <- function(..., values) {
  # ggplot2:::manual_scale("colour", values = c("#588D97", "#F47C20", "#414258", "#315259", "#262638"), ...)
  ggplot2:::manual_scale("colour", values = c("#262638", rep("#BDBAC0",10)), ...)
}

#Put in ggplot2 environment to inherit ggplot2 functionality
# environment(scale_colour_siu) <- asNamespace("ggplot2")

###############################################################################################

####scale_fill_siu#####
scale_fill_siu <- function(..., values) {
  # ggplot2:::manual_scale("fill", values = c("#588D97", "#F47C20", "#414258", "#315259", "#262638"), ...)
  ggplot2:::manual_scale("fill", values = c("#262638", rep("#BDBAC0",10)), ...)
}

#Put in ggplot2 environment to inherit ggplot2 functionality
# environment(scale_fill_siu) <- asNamespace("ggplot2")

###############################################################################################
