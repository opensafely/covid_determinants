
## library
library(tidyverse)
library(here)
library(arrow)

fs::dir_create(here::here("output", "tables"))

## Redactor code (W.Hulme)
redactor <- function(n, threshold=6,e_overwrite=NA_integer_){
  # given a vector of frequencies, this returns a boolean vector that is TRUE if
  # a) the frequency is <= the redaction threshold and
  # b) if the sum of redacted frequencies in a) is still <= the threshold, then the
  # next largest frequency is also redacted
  n <- as.integer(n)
  leq_threshold <- dplyr::between(n, 1, threshold)
  n_sum <- sum(n)
  # redact if n is less than or equal to redaction threshold
  redact <- leq_threshold
  # also redact next smallest n if sum of redacted n is still less than or equal to threshold
  if((sum(n*leq_threshold) <= threshold) & any(leq_threshold)){
    redact[which.min(dplyr::if_else(leq_threshold, n_sum+1L, n))] = TRUE
  }
  n_redacted <- if_else(redact, e_overwrite, n)
}

df_input<-  read_feather (here::here ("output", "input.feather"))

sex_ethn_binary <- df_input %>%
  mutate(white_non=(case_when(is.na(as.numeric(ethnicity_5))~"NA", as.numeric(ethnicity_5)==1~"non-white",TRUE~"white"))) %>%
  select(sex,white_non) %>%
  drop_na() %>%
  filter(white_non!="NA")%>%
  group_by(sex,white_non) %>%
  summarise(N=n()) %>%
  ungroup() %>%
  mutate(Total=sum(N),
         N=redactor(N,7),
         Total=redactor(Total,7),
         percentage = round(N/Total*100,4),
         )

write_csv(sex_ethn_binary,here::here("output", "tables","sex_ethn_binary.csv"))

sex_ethn_5 <- df_input %>%
  select(sex,ethnicity_5) %>%
  drop_na() %>%
  group_by(sex,ethnicity_5) %>%
  summarise(N=n()) %>%
  ungroup() %>%
  mutate(Total=sum(N),
         N=redactor(N,7),
         Total=redactor(Total,7),
         percentage = round(N/Total*100,4),
  )

write_csv(sex_ethn_5,here::here("output", "tables","sex_ethn_5.csv"))

sex_ethn_16 <- df_input %>%
  select(sex,ethnicity_16) %>%
  drop_na() %>%
  group_by(sex,ethnicity_16) %>%
  summarise(N=n()) %>%
  ungroup() %>%
  mutate(Total=sum(N),
         N=redactor(N,7),
         Total=redactor(Total,7),
         percentage = round(N/Total*100,4),
  )

write_csv(sex_ethn_16,here::here("output", "tables","sex_ethn_16.csv"))


sex_ethn_binary_imd <- df_input %>%
  mutate(imd=as.numeric(imd),
    white_non=(case_when(is.na(as.numeric(ethnicity_5))~"NA", as.numeric(ethnicity_5)==1~"non-white",TRUE~"white"))) %>%
  filter(imd>0,white_non!="NA") %>%
  select(sex,white_non,imd) %>%
  drop_na() %>%
  group_by(sex,white_non,imd) %>%
  summarise(N=n()) %>%
  ungroup() %>%
  mutate(Total=sum(N),
         N=redactor(N,7),
         Total=redactor(Total,7),
         percentage = round(N/Total*100,4),
  )

write_csv(sex_ethn_binary_imd,here::here("output", "tables","sex_ethn_binary_imd.csv"))
