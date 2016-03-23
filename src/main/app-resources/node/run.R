library(rgdal)
library(raster)
library(pixmap)
library(bmp)

rm(list=ls())

setwd("C:\\Users\\kordelas\\Downloads\\rasterLayers_tif\\rasterLayers_tif\\example\\")
download.file(url = 'https://github.com/GeoScripting-WUR/IntroToRaster/raw/gh-pages/data/gewata.zip', destfile = 'gewata.zip', method = 'auto')

unzip('gewata.zip')

#gewata <- brick('LE71700552001036SGS00_SR_Gewata_INT1U.tif')
gewata <- brick('C:\\Users\\kordelas\\Desktop\\Lufa\\Merged_Tiff2.tif')

gewata_sub<- gewata[1:1000,1:1000,4]
dim(gewata_sub) <- c(1000, 1000,4)

ndvi <- (gewata_sub[,,4] - gewata_sub[,,3]) / (gewata_sub[,,4] + gewata_sub[,,3])

thres=0.4

M2 <- ndvi

M2[ndvi < thres] <- 0
M2[ndvi >= thres] <- 1 

R_1<-gewata_sub[,,2]
G_1<-gewata_sub[,,1]
B_1<-gewata_sub[,,3]

R_1[ndvi<thres]<-0
G_1[ndvi<thres]<-0
B_1[ndvi<thres]<-0

R_raster<-raster(R_1)
G_raster<-raster(G_1)
B_raster<-raster(B_1)

rr <- stack(R_raster,G_raster,B_raster)

write.table(M2, file="mymatrix.txt", row.names=FALSE, col.names=FALSE)
writeRaster(rr, filename='ndvi10.tif',format="GTiff",overwrite=TRUE)
