library(sf)          # classes and functions for vector data
library(dplyr)
library(data.table)
library(ggplot2)
theme_set(theme_bw())
library(mapproj)
library(spData)      # world map

# Read data file
records <- fread('sample_coordinates.tsv') %>%
    filter(!is.na(latitude), !is.na(longitude))
    # slice_head(n = 1000)

# Sample from NMNH or not
records$institution <- if_else(records$datasource == 'NMNH, Washington', 
                               'NMNH', 'Other')

# Specify colors for scale
data_colors <- c('NMNH' = '#d64400', 'Other' = '#009cd6')

# Plot map
mercator <- ggplot(data = world) +
    geom_sf(color = 'white', fill = '#dddddd', size = .2) +
    geom_point(data = subset(records, institution == 'Other'),
               aes(longitude, latitude, color = institution),
               alpha = 0.25, size = 0.15) +
    geom_point(data = subset(records, institution == 'NMNH'),
               aes(longitude, latitude, color = institution),
               alpha = 0.5, size = 0.15) +
    scale_color_manual(values = data_colors, 
                       labels = c('NMNH     ', 'Other GGBN Institutions')) +
    guides(colour = guide_legend(override.aes = list(size = 3, alpha = 0.4))) +
    theme(axis.line=element_blank(), axis.text.x=element_blank(),
          axis.text.y=element_blank(), axis.ticks=element_blank(),
          axis.title.x=element_blank(), axis.title.y=element_blank(),
          panel.border=element_blank(), panel.grid.major=element_blank(),
          panel.grid.minor=element_blank(), text = element_text(size = 20),
          legend.text = element_text(size = 20),
          legend.title = element_blank(),
          legend.direction = 'horizontal',
          legend.position = c(0.5, 0))

# Output as PNG
ggsave('NMNH_GGBN_Records_2022-03_Mercator.png', mercator, 
       width = 10, height = 5.5, units = 'in')
