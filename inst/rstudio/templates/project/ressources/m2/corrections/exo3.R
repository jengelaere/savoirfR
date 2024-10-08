# ---
# title: "Exercice 3 -  module 2"
# ---  
# A partir des données “sitadel” chargées dans l'exercice 1, effectuer les opérations suivantes en utilisant l’opérateur `%>%` :  
#    - effectuer les mêmes calculs que ceux réalisés sur la région 52, mais sur chacune des régions --> à stocker dans 'sit_ind'  
#    - calculer les agrégations par année civile pour chacune des régions, puis leur taux d’évolution d’une année sur l’autre 
#      (exemple : (val2015-val2014)/val2014) --> à stocker dans 'sit_annuel'  
library(readxl)
library(RcppRoll)
library(tidyverse)


sitadel <- read_excel("extdata/ROES_201702.xls",
  sheet = "AUT_REG",
  col_types = c("text", "text", "numeric", "numeric", "numeric", "numeric")
)



sit_ind <- sitadel %>%
  group_by(REG) %>%
  arrange(date) %>%
  mutate(i_AUT = ip_AUT + ig_AUT,
    i_AUT_cum12 = roll_sumr(i_AUT, 12),
    i_AUT_cum12_lag12 = lag(i_AUT_cum12, 12), # création d'une colonne intermédiaire qui décale les valeurs de 12 mois pour mettre côte à côte les cumul d'autorisations espacés de 12 mois
    i_AUT_cum_evo = (i_AUT_cum12 - i_AUT_cum12_lag12) / i_AUT_cum12_lag12 * 100,
    log_AUT_cum12 = roll_sumr(log_AUT, 12), # création d'une colonne intermédiaire pour calculer le cumul de logements autorisés les 12 derniers mois
    part_i_AU = i_AUT_cum12 / log_AUT_cum12 * 100
  ) %>%
  ungroup()

sit_ind


sit_annuel <- sitadel %>%
  mutate(annee = substr(date, 1, 4)) %>%
  group_by(REG, annee) %>%
  summarise(log_AUT = sum(log_AUT, na.rm = TRUE), # le paramètre na.rm = TRUE permet d'ignorer les éventuelles valeusr manquantes
    ip_AUT = sum(ip_AUT, na.rm = TRUE),
    ig_AUT = sum(ig_AUT, na.rm = TRUE),
    colres_AUT = sum(colres_AUT, na.rm = T),
    .groups = "drop_last") %>%
  arrange(annee) %>%
  mutate(evol_an_log_AUT = (log_AUT - lag(log_AUT)) / lag(log_AUT) * 100,
    evol_an_ip_AUT = (ip_AUT - lag(ip_AUT)) / lag(ip_AUT) * 100,
    evol_an_ig_AUT = (ig_AUT - lag(ig_AUT)) / lag(ig_AUT) * 100,
    evol_an_colres_AUT = (colres_AUT - lag(colres_AUT)) / lag(colres_AUT) * 100
  ) %>%
  ungroup()

sit_annuel

