# ---
# title: "Exercice 5 -  module 7"
# ---  
# Adapter la carte régionale à l'EPCI de l'exercice 4, pour le web :    
# - au survol d'un EPCI, afficher son nom, le prix au m2 et son évolution 2014-2017,  
# - au survol du rond d'un EPCI, afficher son nom, le nb de ventes 2017.  
library(ggiraph)
library(mapfactory)
p_web <- prix_m2_maisons_epci_sf %>% 
  mutate(
    sign_evol = if_else(evo_prix_m2 >=0, "+", ""),
    tooltip_fill = paste0(NOM_EPCI, " :\n", format_fr(x = prix_m2, dec = 0)," €/m2 en 2017\n", sign_evol,
                          format_fr(x = evo_prix_m2, pourcent = TRUE), " depuis 2014"),
    tooltip_size = paste0(NOM_EPCI, " :\n", n," ventes en 2017")
    ) %>% 
  ggplot() +
  geom_sf_interactive(aes(fill = evo_prix_m2, tooltip = tooltip_fill)) +
  scale_fill_gouv_continuous(palette = "pal_gouv_div1") +
  geom_point_interactive(stat = "sf_coordinates", aes(geometry = geometry, size = n, tooltip = tooltip_size), alpha = .5) +
  theme_gouv_map(plot_title_size = 16, subtitle_size = 12, plot_margin = margin(3, 3, 3, 3), 
                 plot_title_margin = 3, caption_margin = 2, subtitle_margin = 2) +
  guides(size = "none") +
  labs(
    fill = "En %", title = "Evolution du prix au m2 des maisons neuves",
    subtitle = "Entre 2014 et 2017",
    caption = "source : DVF"
  )
ggiraph(ggobj = p_web)

