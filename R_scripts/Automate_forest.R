require(sp)
require(rgdal)
require(raster)
require(randomForest)

path <- "D:/Clark_County_2017_ImageClassification_Project/segmented8_bandStack_125"

file.names <- dir(path, pattern = ".img", full.names = TRUE)

OutFile.names <- dir(path, pattern = ".img")

rf <- readRDS("D:/Clark_County_2017_ImageClassification_Project/Samples_models/book_137_models/137_samples_models/RF_model_137_Model.rds")

output_path <- "D:/Clark_County_2017_ImageClassification_Project/Samples_models/book_125_models/classified/"
set.seed(01234567890)

for(i in 1:length(file.names)){
  print(file.names[i])
  image <- brick(file.names[i])
  image_class <- image
  
  
  names(image_class) = c("b1", "b2", "b3", "b4", "b5", "b6", "b7", "b8")
  
  
  OutputFile <- toString(OutFile.names[i])
  OutputComplete <- paste(output_path, OutputFile, sep="")
  image_pred <- predict(image_class, rf, OutputComplete, type = "response", index = 7, progress="window", overwrite = TRUE, na_rm = TRUE)
  
}