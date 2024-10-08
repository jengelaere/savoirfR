# ---
# title: "Exercice 5 -  module 1"
# ---  
# Nous travaillons toujours sur le dataset `df` calculé à l'exercice précédent.
# À l’aide de l’aide mémoire ggplot2 :
#    
# - Réaliser un histogramme de la population communale  
# - Transformer les données avec la fonction log pour y voir plus clair  
# - Faire un barplot (qui n'est pas un histogramme !!!!) du nombre de communes par REG.  
# - Utiliser le paramètre `fill` de la fonction `aes()` pour améliorer le graphique  
# - Réaliser un graphique (nuage de points) croisant la densité de population et le taux de mortalité  
# - Ajouter une dimension supplémentaire avec la couleur des points (paramètre color de `aes()`)  
library(dplyr)
df <- read.csv(file = "extdata/Base_synth_territoires.csv",
               header = TRUE, sep = ";", dec = ",",
               colClasses = c(rep("character", 2), rep("factor", 4) , rep(NA, 32))) %>% 
  mutate(densite = P14_POP / SUPERF,
         tx_natal = 1000 * NAISD15 / P14_POP,
         tx_mort = 1000 * DECESD15 / P14_POP)



library(ggplot2)
ggplot(data = df, aes(x = P14_POP)) +
  geom_histogram()

# Ce n'est pas très informatif, avec une transformation log, on y voit plus clair !
ggplot(data = df, aes(x = log(P14_POP))) +
  geom_histogram()

# barplot 
ggplot(data = df, aes(x = REG)) +
  geom_bar()

# améliorer avec le paramètre `fill`
ggplot(data = df, aes(x = REG, fill = REG)) +
  geom_bar()

# nuage de points
ggplot(data = df, aes(x = densite, y = tx_mort)) +
  geom_point()

# ajout couleur
ggplot(data = df, aes(x = densite, y = tx_mort, color = REG)) +
  geom_point()

