import arcpy
from arcpy import env

env.workspace = r'D:\RetroStudy\2008_textureStacks'

env.overwriteOutput = True

rasters = arcpy.ListRasters()

dsc = arcpy.Describe(r'D:\RetroStudy\FLS_Tests\13836_test1.tif')
coord_sys = dsc.spatialReference


for raster in rasters:
    try: 
        print "projecting " + raster
        arcpy.DefineProjection_management(raster, coord_sys)
        print "succuess projecting " + raster + " to " + str(coord_sys)
    except:
        print arcpy.GetMessages(2)
