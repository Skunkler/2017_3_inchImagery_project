PRO mean_shift_run_custom
compile_opt idl2


e=envi(/headless)



file=FILEPATH('o13912_sw_stack4.dat', root='H:/', subdirectory=['2017_3_inch_samples', 'proprietary_stack'])




raster = e.openraster(file)


fid=envirastertofid(raster)
ENVI_File_Query, fid, ns=ns, nl=nl, nb=nb
dims = [-1l, 0, ns-1, 0, nl-1]

nc = dims[2]-dims[1]+1
nr = dims[4]- dims[3]+1
m=nc*nr
pos=8
nb=n_elements(pos)
print, 'input file ' +file




map_info = envi_get_map_info(fid=fid)
envi_convert_file_coordinates, fid, dims[1], dims[3], ee, nn, /to_map
map_info.mc[2:3] = [ee,nn]

data = fltarr(nc, nr, nb+2)

r=float(15L)/15L

for i=0, nb-1 do data[*,*,i] = bytscl(envi_get_data(fid=fid, dims=dims, pos=pos[i]))*r
ij = lindgen(nc, nr)
data[*,*,nb] = ij mod nc
data[*,*,nb+1] = ij/nc

filtered = intarr(m, nb)
modes = fltarr(nb+2)
labeled = intarr(m)




;progressbar = Obj_New('progressbar', Color='blue', Text=' ' ,$
  ;title='Mean shift filtered...', xsize=300, ysize=20)

;progressbar ->start
idx = 0L
idx_max = 1000L
labeled = 1L

while idx lt m do begin
  mode = mean_shift(idx, cpts, cpts_max)
  idx_max = idx_max > cpts_max

  ones = fltarr((size(modes))[2],1)+1
  d2 = min(total((ones##mode-modes)^2,1),l_nn)

  indices = idx + where(cpts[idx:idx_max] and $
    not labeled[idx:idx_max],count)

  if count gt 0 then begin
    if((count lt minseg) or (d2 lt hs^2)) and $
      (l_nn ne 0) then labeled[indices]=l_nn $
    else begin
      modes = [[modes],[mode]]
      labeled[indices]=label
      label++
      pct=idx*100/m
     ; progressbar -> Update, fix(pct),$
        ;text='Modes: ' +strtrim(label,2)+$
        ;' ('+strtrim(pct,2)+'%)'

    endelse
    next = idx + $
      where(labeled[idx:idx_max] eq 0, count)
    if count gt 0 then idx = (min(next))[0] $
    else idx = m
  end else idx++
  ;if progressbar->CheckCancel() then begin
   ; print,'interrupted...'
   ; idx = m
  ;endif
endwhile
; end loop over all pixels
;progressbar->destroy
labels = (size(modes))[2]







labeled = median( long(reform(labeled,nc,nr)),3 )
boundaries = labeled*0
boundaries[where( (labeled-shift(labeled,1,0) ne 0) $
  or (labeled-shift(labeled,0,1) ne 0) )]=1

for lbl=1,labels-1 do begin
  indices = where(labeled eq lbl,count)
  if count gt 0 then begin
    ones = fltarr(count)+1
    filtered[indices,*] = fix(transpose(modes[0:nb-1,lbl])##ones)
  endif
endfor







openw, unit, result.outf.name+'_segs', /get_lun
writeu, unit, labeled
envi_setup_head ,fname=result.outf.name+'_segs', ns=nc, nl=nr, nb=1, $
  data_type=3, $
  file_type=0, $
  interleave=0, $
  map_info=map_info, $
  xstart=xstart+dims[1], $
  ystart=ystart+dims[3], $
  descrip='Mean shift segmentation of ' + result.outf.name, $
  /write
print, 'File created ', result.outf.name+'_segs'
free_lun, unit
openw, unit, result.outf.name+'_bounds', /get_lun
writeu, unit, boundaries
envi_setup_head ,fname=result.outf.name+'_bounds', ns=nc, nl=nr, nb=1, $
  data_type=3, $
  file_type=3, $
  interleave=0, $
  map_info=map_info, $
  xstart=xstart+dims[1], $
  ystart=ystart+dims[3], $
  num_classes = 2, $
  class_names = ['unclassified','boundaries'], $
  lookup = class_lookup_table([0,1]), $
  descrip='Mean shift segmentation of ' + result.outf.name, $
  /write
print, 'File created ', result.outf.name+'_bounds'
free_lun, unit
openw, unit, result.outf.name, /get_lun
writeu, unit, reform(filtered,nc,nr,nb)
envi_setup_head ,fname=result.outf.name, ns=nc, nl=nr, nb=nb, $
  data_type=2, $
  interleave=0, $
  file_type=0, $
  map_info=map_info, $
  xstart=xstart+dims[1], $
  ystart=ystart+dims[3], $
  descrip='Mean shift segmentation of ' + result.outf.name, $
  /write
print, 'File created ', result.outf.name
free_lun, unit












e.close

END