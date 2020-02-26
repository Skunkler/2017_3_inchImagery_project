require(sp)
require(rgdal)
require(raster)
require(e1071)


path <- "H:/2017_3_inch_samples/convolution_morph_Tests/testing_morphology_stacks/segmentedimagery/stacked"

file.names <- dir(path, pattern = '.tif', full.names = TRUE)
intable <- read.csv("H:/2017_3_inch_samples/proprietary_stack/samples_4_2_2018/Comprehensive.csv")
indata <- intable[3:11]

SVM_model <- svm(desc~., data = indata, gamma = 0.1, cost = 10)

OutFile.names <- dir(path, pattern = ".tif")


output_path <- "H:/2017_3_inch_samples/classified_imagery/SVMRound1/"


for(i in 1:length(file.names)){
  print(file.names[i])
  image <- brick(file.names[i])
  image_class <- image
  
  
  names(image_class) = c("b1", "b2", "b3", "b4", "b5", "b6", "b7", "b8")
  
  
  OutputFile <- toString(OutFile.names[i])
  OutputComplete <- paste(output_path, OutputFile, sep="")
  image_pred <- predict(image_class, SVM_model, OutputComplete, fun=predict, index = 1, progress="window", overwrite = TRUE, na_rm = TRUE)
  
}