import arcpy, os, string, sys, time
from arcpy import env


env.overwriteOutput = True

rasters = arcpy.ListRasters()


arcpy.CheckOutExtension("Spatial")


rastersegs = r'D:\Clark_County_2017_ImageClassification_Project\testing_seg_script\raster_Segs'

Eight_band_stacks = r'D:\Clark_County_2017_ImageClassification_Project\testing_seg_script\eight_band_stack'


output_seg_shp = r'D:\Clark_County_2017_ImageClassification_Project\testing_seg_script\segmented_shps'
output_seg_img = r'D:\Clark_County_2017_ImageClassification_Project\testing_seg_script\segmented_imgs'

def ZonalStatsBandAct(feature, out_name, Eight_band_img, output_Seg_path):
    i = 1
    
    output_segmented_imagery = output_Seg_path + '\\Band_'
  

    
    
    try:
        for i in range(1, 9):
            #arcpy.gp.ZonalStatistics_sa(feature, "Id", Image_Path + "\\Band_" + str(i), output_segmented_imagery + str(i) + '\\' + outImage[:-4] + '_' + str(i) + '.tif', "MEAN", "DATA")
            arcpy.gp.ZonalStatistics_sa(feature, "Id", Eight_band_img + "\\Band_" + str(i), output_segmented_imagery + str(i) + '\\' + out_name + '_' + str(i) + '.tif', "MEAN", "DATA")
    except:
        print "Not a Band"
        try:
            for i in range(1,9):
                arcpy.gp.ZonalStatistics_sa(feature, "Id", Eight_band_img + "\\Layer_" + str(i), output_segmented_imagery + str(i) + "\\" + out_name + "_" + str(i) + ".tif", "MEAN", "DATA")
        except:
            for i in range(1, 9):
                arcpy.gp.ZonalStatistics_sa(feature, "FID", Eight_band_img + "\\Band_" + str(i), output_segmented_imagery + str(i) + "\\" + out_name + '_' + str(i) + '.tif', "MEAN", "DATA")



def ConvertRasterSegsToPolys(RasterSeg, output_segs):

    raster = RasterSeg.replace('.tif', '.shp')
    

    if not os.path.exists(output_segs):
        os.makedirs(output_segs)
    
    print "converting " + RasterSeg + " to feature class"
    dsc = arcpy.Describe(r'R:\Image_ClarkCounty\2017\ClarkCounty_Collection\122\o12204.tif')
    coord_sys = dsc.spatialReference
        
    arcpy.DefineProjection_management(RasterSeg, coord_sys)

    print RasterSeg
    print output_segs + '\\' + raster
    
    arcpy.RasterToPolygon_conversion(RasterSeg, output_segs + '\\' + raster, "SIMPLIFY")
    outFeature = output_segs + '\\' + raster
    return (outFeature, raster.replace('.shp', ''))
     







def runFirstLoop(rastersegs, output_seg_shp, eight_band_stack_dir, output_seg_img):
    env.workspace = rastersegs
    rasters = arcpy.ListRasters()


                

    for raster in rasters:
        outFeature = ConvertRasterSegsToPolys(raster, output_seg_shp)
        print outFeature[0]
        print outFeature[1]
        env.workspace = eight_band_stack_dir
        EightRasters = arcpy.ListRasters()
        for raster2 in EightRasters:
            if outFeature[1] == raster2[:-4]:
                print raster2[:-4]
                ZonalStatsBandAct(outFeature[0], outFeature[1], raster2, output_seg_img)
                env.workspace = rastersegs
                



runFirstLoop(rastersegs, output_seg_shp, Eight_band_stacks, output_seg_img)


#ZonalStatsBandAct(feature, imagery)


#FeatureClassList = []

"""for root, dirs, files in os.walk(input1):
    for filename in files: 
        if filename[-4:] == '.tif' and int(filename[1:6]) > 16227:      
            outFeature = ConvertRasterSegsToPolys(root + '\\' + filename)
            FeatureClassList.append(outFeature)"""


"""for root, dirs, files in os.walk(r"E:\LiDAR_factor\featuresExtracted2"):
    for filename in files:
        if filename[-4:] == '.shp' and int(filename[1:6]) > 16226:
            FeatureClassList.append(root + '\\' + filename)


for root, dirs, files in os.walk(input2):
    for filename in files:
        if filename[-4:] == '.tif':
            for i in FeatureClassList:
                fc = str(i.split('\\')[-1])
                print fc
                if fc[:6] == filename[:6]:
                    ZonalStatsBandAct(i, root + '\\' + filename)

RedBands = []
GreenBands = []
BlueBands = []
NIRBands = []
NDVIBands = []
MeanGreen_Bands = []
MeanNIR_Bands = []
SecondMomentNIR_Bands = []

for root, dirs, files in os.walk(input3):
    for filename in files:
        if 'band_1' in root and filename[-4:] == '.tif':
            fws = root.replace('\\','/')
            inputLine = '"{ws}/{Infile}"'.format(ws = fws, Infile = filename)
            RedBands.append(inputLine)
            
        elif 'band_2' in root and filename[-4:] == '.tif':
            fws = root.replace('\\','/')
            inputLine = '"{ws}/{Infile}"'.format(ws = fws, Infile = filename)
            GreenBands.append(inputLine)
            
        elif 'band_3' in root and filename[-4:] == '.tif':
            fws = root.replace('\\','/')
            inputLine = '"{ws}/{Infile}"'.format(ws = fws, Infile = filename)
            BlueBands.append(inputLine)
            
        elif 'band_4' in root and filename[-4:] == '.tif':
            fws = root.replace('\\','/')
            inputLine = '"{ws}/{Infile}"'.format(ws = fws, Infile = filename)
            NIRBands.append(inputLine)
            
        elif 'band_5' in root and filename[-4:] == '.tif':
            fws = root.replace('\\','/')
            inputLine = '"{ws}/{Infile}"'.format(ws = fws, Infile = filename)
            NDVIBands.append(inputLine)
            
        elif 'band_6' in root and filename[-4:] == '.tif':
            fws = root.replace('\\','/')
            inputLine = '"{ws}/{Infile}"'.format(ws = fws, Infile = filename)
            MeanGreen_Bands.append(inputLine)
            
        elif 'band_7' in root and filename[-4:] == '.tif':
            fws = root.replace('\\','/')
            inputLine = '"{ws}/{Infile}"'.format(ws = fws, Infile = filename)
            MeanNIR_Bands.append(inputLine)
            
        elif 'band_8' in root and filename[-4:] == '.tif':
            fws = root.replace('\\','/')
            inputLine = '"{ws}/{Infile}"'.format(ws = fws, Infile = filename)
            SecondMomentNIR_Bands.append(inputLine)




RedBands.sort()
GreenBands.sort()
BlueBands.sort()
NIRBands.sort()
NDVIBands.sort()
MeanGreen_Bands.sort()
MeanNIR_Bands.sort()
SecondMomentNIR_Bands.sort()

outfile = open(r'E:\LiDAR_factor\principalComponents\SegmentCreations\InFile.bls', 'w')

outfile.write("PortInput1\tPortInput2\tPortInput3\tPortInput4\tPortInput5\tPortInput6\tPortInput7\tPortInput8\n")
for i in range(0, len(RedBands)):
    
    line = RedBands[i] + '\t' + GreenBands[i] + '\t' + BlueBands[i] + '\t' + NIRBands[i] + '\t' + NDVIBands[i] + '\t' + MeanGreen_Bands[i] + '\t' + MeanNIR_Bands[i] + '\t' + SecondMomentNIR_Bands + '\n'
    outfile.write(line)
outfile.close()"""





    
