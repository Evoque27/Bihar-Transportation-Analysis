library(tidyverse)
library(rgdal)
library(sf)
library(ggplot2)
library(dplyr)
library(RColorBrewer)
library(tmap)
library(leaflet)
library(sp)
library(htmltools)
library(leaflet.extras)

data7 = read.csv("D:\\Project\\Project\\Bihar Transport\\Bihar%3A_Transport.csv")
sjp<-readOGR("D:\\Project\\Project\\Bihar Transport\\Bihar%3A_Transport.shp")
merged2<- merge(sjp,data7, by.x="objectid", by.y="objectid")
merged2 <- merged2 %>% 
  sf::st_as_sf(coords = c("lat", "lon"),crs = 4326)

palPwr <- leaflet::colorFactor(palette = "Brewer Blues",
                               domain = merged2$districtna)

leaflet(data = merged2) %>%
  addTiles() %>%
  setView(lng =85.3131,lat=25.0961,zoom=6)%>%
  addPolygons(data = merged2,
              fillColor = ~palPwr(merged2$districtna),
              stroke = TRUE, 
              fillOpacity = 0.7, 
              smoothFactor = 0.5,
              color = "reds", 
              weight = 1,
              opacity =0.5,
              popup = paste("District Name:",merged2$district_name,"<br>","Total Two wheeler:",merged2$two_wheeler,"<br>","Total Four Wheeler:",merged2$four_wheeler,"<br>","Total Bus:",merged2$bus),
              fill = "district_name",
              highlight = highlightOptions(weight = 5,
                                           color = "white",
                                           fillOpacity = 0.7,
                                           bringToFront = FALSE),
              label = merged2$district_name)
