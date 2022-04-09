library(ggplot2)

df <- read.csv(file="D:\\Project\\Project\\Bihar Transport\\Bihar%3A_Transport.csv")

ggplot(data = df[1:6,]) +
  geom_col(mapping = aes(x = district_name, y = pollution, fill = pollution))

