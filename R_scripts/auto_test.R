
path <- "H:/2017_3_inch_samples/convolution_morph_Tests/testing_morphology_stacks/segmentedimagery/stacked"

file.names <- dir(path, pattern = ".tif", full.names = TRUE)

for(i in 1:length(file.names)){
 print(file.names[i]) 
  
}