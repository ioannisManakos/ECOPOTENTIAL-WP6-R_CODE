library(rgdal)
library(raster)
library(pixmap)
library(bmp)
library(RCurl)
library(bitops)

rm(list=ls())

download.file(url='https://dl.dropboxusercontent.com/s/l81f5tyijq25sz6/gewata.zip', destfile='gewata.zip',method='curl')
unzip("gewata.zip",exdir="./")

gewata <- brick('LE71700552001036SGS00_SR_Gewata_INT1U.tif')

ndvi <- (gewata[,,4] - gewata[,,3]) / (gewata[,,4] + gewata[,,3])

thres=0.4

M2 <- ndvi
M2[ndvi < thres] <- 0
M2[ndvi >= thres] <- 1

R_1<-gewata[,,2]
G_1<-gewata[,,1]
B_1<-gewata[,,3]

R_1[ndvi<thres]<-0
G_1[ndvi<thres]<-0
B_1[ndvi<thres]<-0

R_raster<-raster(R_1)
G_raster<-raster(G_1)
B_raster<-raster(B_1)

rr <- stack(R_raster,G_raster,B_raster)

write.table(M2, file="mymatrix.txt", row.names=FALSE, col.names=FALSE)
writeRaster(rr, filename='ndvi10.tif',Format="GTiff",overwrite=TRUE)
