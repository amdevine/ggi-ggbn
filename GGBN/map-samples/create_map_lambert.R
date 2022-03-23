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

# Convert records from WGS 84 to Lambert
sp.rec.sf <- st_as_sf(records, 
                      coords = c("longitude", "latitude"), 
                      crs = 4326,   # WGS 84
                      remove = FALSE)  # keep lat and lon columns in df
sp.rec.sf <- st_transform(sp.rec.sf, crs = 6933)

# Convert map from Mercator to Lambert
world.cyl <- st_transform(world, crs = 6933)

# Plot map
lambert <- ggplot(data = world.cyl) +
    geom_sf(color = 'white', fill = '#dddddd', size = .2) +
    geom_sf(data = sp.rec.sf, color = '#009cd6', alpha = 0.25, size = 0.15) +
    theme(axis.line=element_blank(), axis.text.x=element_blank(),
          axis.text.y=element_blank(), axis.ticks=element_blank(),
          axis.title.x=element_blank(), axis.title.y=element_blank(),
          panel.border=element_blank(), panel.grid.major=element_blank(),
          panel.grid.minor=element_blank(), text = element_text(size = 16))

# Output as PNG
ggsave('GGBN_Records_2022-03_Lambert.png', lambert, 
       width = 10, height = 5, units = 'in')