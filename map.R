library("rgdal")
library("rgeos")
library(RColorBrewer)
library(tmap)
library(leaflet)

myData <- read.csv("D:\\Project\\Project\\Bihar Transport\\Bihar%3A_Transport.csv")
Output.Areas<- readOGR(choose.files(caption = "Select Shapefile", multi = FALSE))

merged_data <- merge(Output.Areas, myData, by.x="collection", by.y="district_name")
tm_shape(merged_data) + tm_fill("collection",style = "quantile",palette = "Reds",legend.hist = TRUE,title = "Total Collection") + tm_text("district_n", size = 1)+ tm_borders(alpha=.4)+tm_compass()+tm_layout(title = "Bihar Total Collection District Wise",  title.position = c('left', 'top'),legend.text.size = 1,
legend.title.size = 1, legend.position = c(.95, .5), frame = FALSE) 

