library(tidyverse)
library(purrr)
library(janitor)
library(readxl)


read_in_csv = function () {

  read_csv('all1.csv')
    clean_names () %>% 
    { . } -> all

  cs = spec(all)


  all %>%
    select_if( function(x) { !is.numeric(x) }) %>%
    map( function(x) { x %>% na.omit() %>% str_length() %>% max( ) }) %>% 
    { . } -> specx

  require("RPostgreSQL")

  # loads the PostgreSQL driver
  drv <-  
  # creates a connection to the postgres database
  # note that "con" will be used later in each connection to the database
  con <- dbConnect(dbDriver("PostgreSQL"), 
                  dbname = "vijaya_vaed",
                  host = "localhost", port = 5432,
                  user = "dewoller", password  = Sys.getenv('PASSWD'))

  # check for the cartable

  dbWriteTable(con, name='vaed', value=all, overwrite=T )


}

read_in_excel = function() {


  vaed1314 <-  read_excel("vijaya_data/VAHI_R5771_Audit Data_201314_148542.xlsx")
  vaed1415 <-  read_excel("vijaya_data/VAHI_R5771_Audit Data_201415_148540.xlsx")
  vaed1516 <-  read_excel("vijaya_data/VAHI_R5771_Audit Data_201516_148541.xlsx")

  identical(names(vaed1314[[1]]), names(vaed1415[[2]]) )
  identical(names(vaed1516[[1]]), names(vaed1415[[2]]) )
  identical(names(vaed1314[[1]]), names(vaed1516[[2]]) )

  names(vaed1314) %>%
    setdiff(names(vaed1415))

  names(vaed1415) %>%
    setdiff(names(vaed1516))

  names(vaed1314) %>%
    setdiff(names(vaed1516))


  names(vaed1516) %>%
    setdiff(names(vaed1314))

  colnames(vaed1314)[colnames(vaed1314)=="DERIVED hospital _separation_year"] <- "DERIVED hospital_separation_year"
  colnames(vaed1314)[colnames(vaed1314)=="DERIVED hospital_ LOS"] <- "DERIVED hospital_LOS"
  colnames(vaed1314)[colnames(vaed1314)=="DERIVED audit_ LOS"] <- "DERIVED audit_LOS"


  d_vaed <- rbind(vaed1314, vaed1415, vaed1516)

  d_vaed <- clean_names( d_vaed)
  rm(vaed1314, vaed1415, vaed1516)

 }

