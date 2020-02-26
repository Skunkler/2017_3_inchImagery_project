pro SOBELFILTERAPPLY
Compile_opt IDL2
e=envi(/headless)

files = file_search('E:\LiDAR_factor\Sobel_input2', '*.tif')
output = 'E:\LiDAR_factor\Sobel_output\'
foreach file, files do begin
  print, 'starting to filter images'
  raster = e.openraster(file)
  Task=ENVITask('SobelFilter')
  Task.ADD_BACK = 1
  Task.INPUT_RASTER = raster
  
  Task.OUTPUT_RASTER_URI = output + file_basename(file, '.tif') + '_sobelNeedsProj.dat'

  Task.Execute

  raster2_fileinput = output + file_basename(file, '.tif') + '_sobelNeedsProj.dat'
  raster2 = e.openraster(raster2_fileinput, SPATIALREF_OVERRIDE = raster.spatialref)

  raster2.export, output + file_basename(file, '.tif') + '_sobel.tif', 'TIFF'

  raster2.close
  raster.close
  print, "done with " + output + file_basename(file, '.tif') + '_sobel.tif'
  
endforeach




e.close



END