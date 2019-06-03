library(tidyverse)
library(purrr)
library(janitor)

read_csv('vijaya_data/all.csv.gz') %>%
  clean_names () %>% 
  { . } -> all




all %>% 
  select( starts_with('diag' ) ) %>%
  gather( pos, diag ) %>%
  filter( !is.na( diag )) %>% 
  { . } -> all_diag



all %>%
  select( starts_with('oper' ) ) %>%
  gather( pos, oper ) %>%
  filter( !is.na( oper )) %>% 
  { . } -> all_oper

all %>% distinct( age_group ) %>% c()

all_diag %>%
  filter( pos == 'diag1') %>%
  count( diag, sort=TRUE) %>% 
  dim() %>% 
  pluck(1)



all_diag %>%
  count( diag, sort=TRUE) %>% 
  dim() %>% 
  pluck(1)


all_oper %>%
  count( oper, sort=TRUE) %>% 
  dim() %>% 
  pluck(1)






d_vaed %>%
  select( starts_with('hospital'))

d_vaed %>%
  select( starts_with('audit'))


d_vaed %>%
  select( 
         -starts_with('hospital_diagnosis')
         , -starts_with('hospital_procedure')
         , -starts_with('hospital_prefix')
         , -starts_with('audit')
         ) %>% names()




