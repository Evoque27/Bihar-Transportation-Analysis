library(sf)
library(dplyr)
library(leaflet)
library(htmltools)
library(rnaturalearth)
library(leaflet.extras)
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
mydata1=read.csv("D:\\Project\\Project\\Bihar Transport\\Bihar%3A_Transport.csv")





label=paste0("<br>","District::",htmlEscape(mydata1$district_name),"<br>","Total Registered Truck::",htmlEscape(mydata1$registered_truck),"<br>","Total Unregistered Truck::",htmlEscape(mydata1$unregistered_truck))
dataset1<-data_plot%>%
  sf::st_as_sf(coords=c("lon","lat"),crs=4326)
myMapp <- leaflet(dataset1)%>%
  addProviderTiles("Stamen.Toner")%>%
  addCircleMarkers(radius = 10,fillOpacity = .7,stroke = FALSE,popup = ~label,color = palPwr(dataset1$name),clusterOptions = markerClusterOptions())%>%
  leaflet::addLegend(position = "bottomright",values = ~name,opacity = .7,pal = palPwr,title = "Districts")%>%
  leaflet.extras::addResetMapButton()
 htmltools::save_html(myMapp,"leaflet.html")
myMapp
