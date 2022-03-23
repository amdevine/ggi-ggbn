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

# Plot map
mercator <- ggplot(data = world) +
    geom_sf(color = 'white', fill = '#dddddd', size = .2) +
    geom_point(data = records,
               aes(longitude, latitude),
               color = '#009cd6',
               alpha = 0.25,
               size = 0.15) +
    theme(axis.line=element_blank(), axis.text.x=element_blank(),
          axis.text.y=element_blank(), axis.ticks=element_blank(),
          axis.title.x=element_blank(), axis.title.y=element_blank(),
          panel.border=element_blank(), panel.grid.major=element_blank(),
          panel.grid.minor=element_blank(), text = element_text(size = 16))

# Output as PNG
ggsave('GGBN_Records_2022-03_Mercator.png', mercator, 
       width = 10, height = 5, units = 'in')