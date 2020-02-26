PRO Band_stack_Texture_Morph

COMPILE_OPT IDL2
E=envi(/headless)

input='D:\testImage'
output_initial='D:\testOutput'
output_initial2 = 'D:\testOutputTif'



files = file_search(input, '*.tif')

foreach file, files do begin
  print, file
  raster = e.openraster(file)
  FID = envirastertofid(raster[0])
  fileBase = FILE_Basename(file, '.tif')
  
  if(FID eq -1) then begin
    e.close
    return
    endif
  
  
    Coord = ENVICoordSys(COORD_SYS_CODE = 3421)
    
    
    print, 'query input file for parameters'
    envi_open_file, file, r_fid=r_rid
    envi_file_query, fid, ns=ns, nl=nl, nb=nb
    dims=[1l, 0, ns-1, 0, nl-1]
    output_name1 = output_initial + '\\' + fileBase + '_Meanstats.dat'
    output_name2 = output_initial + '\\' + fileBase + '_NIRSecond.dat'
    output_name3 = output_initial + '\\' + fileBase + '_NDVI.dat'
    outBname = ['Green_mean', 'NIR_mean']
    pos=[1,3]
    
    
    
    
    print, 'calculating NDVI'
    ENVI_DOIT, 'NDVI_DOIT', /CHECK, DIMS=dims, fid=fid, $
      OUT_DT = 4, OUT_NAME = output_name3, pos = [3,0], r_fid=r_fid
    
 
    
    
    print, 'calculating texture occurance'
    ENVI_DOIT, 'texture_stats_doit', fid=fid, pos=pos, dims=dims, $
      kx=7, ky=7, method=[0,1,0,0,0], $
      OUT_NAME=output_name1, R_FID=R_FID, out_bname=out_bname
    
    print, 'calculating texture cooccurance'
    ENVI_DOIT, 'texture_cooccur_doit', fid=fid, pos=[3], dims=dims, $
      method = [0,0,0,0,0,0,1,0], kx=7, ky=7, direction=[2,2], $
      OUT_BNAME=['NIR_SECONDMOMENT'], out_name = output_name2, r_fid=r_fid
      
      
  
    print, 'opening texture and NDVI images'  
    NDVI_Image = e.openraster(output_name3, SPATIALREF_OVERRIDE = raster.spatialref)
    meanTextures = e.openraster(output_name1,SPATIALREF_OVERRIDE = raster.spatialref)
    secondMotion = e.openraster(output_name2,SPATIALREF_OVERRIDE = raster.spatialref)  
    
    
    Bandstack_file = output_initial + '\\' + fileBase + '_stacked.tif'
    
    print, 'outputing initial band stack'
    BandStack = ENVIMetaspectralRaster([raster, NDVI_Image, meanTextures, secondMotion])
   
    BandStack.export, Bandstack_file, "TIFF"
    BandStack.close
    
    
    meanTextures.close
    secondMotion.close
    NDVI_Image.close
    
    
    
    
    print, 'outputing band stack with correct spatial reference'
    BandStack_Corr_Proj = e.openraster(BandStack_file,SPATIALREF_OVERRIDE = raster.spatialref)
    BandStack_Corr_Proj.export, output_initial2 + '\\' + fileBase + '_stacked.tif', "TIFF"
    BandStack_Corr_Proj.close
    
    
endforeach

e.close






END