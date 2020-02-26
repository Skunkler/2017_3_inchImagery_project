require(sp)
require(rgdal)
require(raster)
require(randomForest)

imagery <- brick("D:/Clark_County_2017_ImageClassification_Project/Samples_models/book_137_models/137_samples_models/mosaic_sample.img")

training_samples <- readOGR("D:/Clark_County_2017_ImageClassification_Project/Samples_models/book_137_models/137_samples_models/Book_137.shp", 'Book_137')

roi_data <- extract(imagery, training_samples, df = TRUE)

roi_data$desc <- as.factor(training_samples$ClassName[roi_data$ID])

colnames(roi_data) <- c('ID', 'b1', 'b2', 'b3', 'b4','b5', 'b6', 'b7','b8', 'desc')

write.csv(roi_data, 'D:/Clark_County_2017_ImageClassification_Project/Samples_models/book_137_models/137_samples_models/rf_model_137.csv')

intable <- read.csv('D:/Clark_County_2017_ImageClassification_Project/Samples_models/book_137_models/137_samples_models/rf_model_137.csv')

myrf2 <- randomForest(desc ~ b1+b2+b3+b4+b5+b6+b7+b8, data = intable, type="response", keep.forest = TRUE, importance = TRUE)
saveRDS(myrf2, 'D:/Clark_County_2017_ImageClassification_Project/Samples_models/book_137_models/137_samples_models/RF_model_137_Model.rds')

print(myrf2)

rm(myrf2)