library(sf)          # classes and functions for vector data
library(dplyr)
library(data.table)
library(ggplot2)
theme_set(theme_bw())
library(mapproj)
library(spData)      # world map

# Lambert cylindrical equal-area projection: CRS 6933
# github.com/SciTools/cartopy/issues/1098

# Read data file
records <- fread('sample_coordinates.tsv') %>%
    filter(!is.na(latitude), !is.na(longitude))

# Sample from NMNH or not
records$institution <- if_else(records$datasource == 'NMNH, Washington', 
                               'NMNH', 'Other')

# Convert records from WGS 84 to Lambert
rec_sf <- st_as_sf(records, 
                   coords = c("longitude", "latitude"), 
                   crs = 4326,       # WGS 84
                   remove = FALSE)   # keep lat and lon columns in df
rec_sf <- st_transform(rec_sf, crs = 6933)

# Convert map from Mercator to Lambert
world_cyl <- st_transform(world, crs = 6933)

# Specify colors for scale
data_colors <- c('NMNH' = '#d64400', 'Other' = '#009cd6')

# Plot map
lambert <- ggplot(data = world_cyl) +
    geom_sf(color = 'white', fill = '#dddddd', size = .2) +
    geom_sf(data = subset(rec_sf, institution == 'Other'), 
            aes(color = institution),
            alpha = 0.25, size = 0.15) +
    geom_sf(data = subset(rec_sf, institution == 'NMNH'), 
            aes(color = institution),
            alpha = 0.50, size = 0.15) +
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
ggsave('NMNH_GGBN_Records_2022-03_Lambert.png', lambert, 
       width = 10, height = 5.5, units = 'in')