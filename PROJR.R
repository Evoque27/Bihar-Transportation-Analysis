#Importing libraries#

library("rgdal")
library("rgeos")
library(RColorBrewer)
library(tmap)
library(leaflet)
library(ggplot2)
library(tidyverse)
library(sf)
library(dplyr)
library(sp)
library(htmltools)
library(rnaturalearth)
library(leaflet.extras)

#Importing CSV file & shapefile#

myData <- read.csv("C:\\Users\\RAHUL\\OneDrive\\Desktop\\21070243033_RProgrammingProject\\BiharTransport.csv")
myShpfile<- readOGR(choose.files(caption = "Select Shapefile", multi = FALSE))
View(myData)
View(myShpfile)

#Merging the shapefile & CSV file#

merged_data <- merge(myShpfile, myData, by.x="collection", by.y="district_name")

#Analyzing the total collection from different districts of Bihar#

tm_shape(merged_data) + tm_fill("collection",style = "quantile",palette = "Reds" )+tm_layout(legend.position = c('right','top')) + tm_text("district_n", size = 1)+ tm_borders(alpha=.4)+tm_compass()+tm_layout(title = "Bihar Total Collection [District Wise]",  title.position = c('center', 'top'),legend.text.size = 1,legend.title.size = 1, legend.position = c(.95, .5), frame = FALSE)
tmap_mode('view')
tmap_last()

#Analyzing district-wise pollution in Bihar#

ggplot(data = myData[1:38,])+geom_col(mapping = aes(x = pollution, y = district_name, fill = pollution))

#Analyzing the number of two-wheelers, four-wheelers & trucks in different districts of Bihar#

merged2<- merge(myShpfile,myData, by.x="objectid", by.y="objectid")
merged2 <- merged2 %>% 
  sf::st_as_sf(coords = c("lat", "lon"),crs = 4326)
palPwr <- leaflet::colorFactor(palette = "Brewer Blues", domain = merged2$districtna)
leaflet(data = merged2) %>%
  addTiles() %>%
  setView(lng =85.3131,lat=25.0961,zoom=6)%>%
  addPolygons(data = merged2,fillColor = ~palPwr(merged2$districtna),stroke = TRUE,fillOpacity = 0.7, smoothFactor = 0.5,color = "reds",weight = 1,opacity =0.5,popup = paste("District Name:",merged2$district_name,"<br>","Total Two wheeler:",merged2$two_wheeler,"<br>","Total Four Wheeler:",merged2$four_wheeler,"<br>","Total Bus:",merged2$bus),fill = "district_name",highlight = highlightOptions(weight = 5,color = "white",fillOpacity = 0.7,bringToFront = FALSE),label = merged2$district_name)

#Analyzing district-wise registered / unregistered vehicles in Bihar#

data_plot <- data.frame(name = c("Arwal","Bhagalpur","Purnia","Madhepura","Kishanganj","Gaya","Banka","Aurangabad","Nawada","Araria",
                                 "Pashchim Champaran","Muzaffarpur","Saran","Sheikhpura","Jehanabad","Saharsa","Gopalganj","Vaishali","Siwan",
                                 "Sheohar","Buxar","Madhubani","Supaul","Patna","Bhojpur","Darbhanga","Samastipur","Kaimur (Bhabua)",
                                 "Rohtas","Khagaria","Munger","Sitamarhi","Purba Champaran","Lakhisarai","Jamui","Begusarai","Nalanda","Katihar"),
                        lon = c(84.6688, 86.9842, 87.4753, 86.7946, 87.945, 85.0002, 86.9198, 75.3433, 85.5435, 87.4528, 84.3542, 85.3844, 
                                84.8568, 85.8629, 84.9853, 86.5928, 84.4366, 85.355, 84.36, 85.2942, 83.9777, 85.1386, 86.6045, 85.1376, 84.5222, 85.8918, 
                                85.7868, 83.6774, 84.0167, 86.4701, 86.4734, 85.5013, 84.8568, 86.0452, 86.2247, 86.1272, 85.4788, 87.6186),
                        lat = c(25.1643, 25.2425, 25.7771, 25.924, 26.0982, 24.7914, 24.8874, 19.8762, 24.8867, 26.1325, 27.1543, 26.1204, 25.856, 25.1417, 
                                25.2133, 25.8774, 26.4832, 25.6838, 26.2243, 26.5146, 25.5647, 26.4414, 26.1234, 25.5941, 25.4662, 26.1542, 25.856, 25.0546,
                                25.0686, 25.5045, 25.3708, 26.5887, 26.6098, 25.1571, 24.9195, 25.4182, 25.2622, 25.5488))
View(data_plot)
label=paste0("<br>","District::",htmlEscape(myData$district_name),"<br>","Total Registered Truck::",htmlEscape(myData$registered_truck),"<br>","Total Unregistered Truck::",htmlEscape(myData$unregistered_truck))
dataset1 <- data_plot %>%
  sf::st_as_sf(coords=c("lon","lat"),crs=4326)
myMap <- leaflet(dataset1)%>%
  addProviderTiles("Stamen.Toner")%>%
  addCircleMarkers(radius = 10,fillOpacity = .7,stroke = FALSE,popup = ~label,color = palPwr(dataset1$name),clusterOptions = markerClusterOptions())%>%
  leaflet::addLegend(position = "bottomright",values = ~name,opacity = .7,pal = palPwr,title = "Districts")%>%
  leaflet.extras::addResetMapButton()
htmltools::save_html(myMap,"leaflet.html")
myMap
