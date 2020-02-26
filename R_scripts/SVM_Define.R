require(raster)
require(rgdal)
require(e1071)

imagery <- brick("D:\\UHII_Proj\\o16216_sw.img")

training <- readOGR("D:\\imageTest\\sigFiles\\training.shp", 'training')

roi_data <- extract(imagery, training, df = TRUE)

roi_data$desc <- as.factor(training$classname[roi_data$ID])

colnames(roi_data) <- c('ID', 'b1', 'b2', 'b3', 'b4','b5', 'b6', 'desc')

index <- 1:nrow(roi_data)
testindex <- sample(index, trunc(length(index)/3))
testset <- roi_data[testindex,]
trainset <- roi_data[-testindex,]
tuned <- tune.svm(desc~., data=trainset, gamma = 10^(-6:-1), cost = 10^(-1:1))
summary(tuned)

write.csv(roi_data, "D:\\imageTest\\sigFiles\\svmModel.csv")

#intable <- read.csv()

#svmModel <- svm(desc~., data = intable, kernel = "radial", gamma = , cost = )

#svmModel <- svm(desc~.,)
#print(svmModel)
#summary(svmModel)
