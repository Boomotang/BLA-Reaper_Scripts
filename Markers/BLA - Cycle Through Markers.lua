

keyWord = "VERSE"


function goToFirst(searchWord)
  retval, num_markers, num_regions = reaper.CountProjectMarkers(0)
  
  for i=0, num_markers + num_regions do
    _, _, pos, _, name, _ = reaper.EnumProjectMarkers(i)

    if string.find(name, searchWord) then
      reaper.SetEditCurPos(pos, 1, 1)
      break
    end
  end
end

-------------------------------------------------------------------------------------------

cursorPos = reaper.GetCursorPosition()

marker, region = reaper.GetLastMarkerAndCurRegion(0, cursorPos)

_, _, M_Pos, _, M_name, M_IDX = reaper.EnumProjectMarkers(marker)
_, _, R_Pos, _, R_name, R_IDX = reaper.EnumProjectMarkers(region)

if region == -1 or R_Pos < M_Pos then
  _, isRgn, startPos, rgnEnd, name, startIDX = reaper.EnumProjectMarkers(marker)
else
  _, isRgn, startPos, rgnEnd, name, startIDX = reaper.EnumProjectMarkers(region)
end



if string.find(name, keyWord) then
  retval, num_markers, num_regions = reaper.CountProjectMarkers(0)

  for i=0, num_markers + num_regions do
    _, _, pos, _, name, _ = reaper.EnumProjectMarkers(i)
    
    if string.find(name, keyWord) and pos > startPos then
      reaper.SetEditCurPos(pos, 1, 1)
      break
    
    elseif i == num_markers + num_regions and string.find(name, keyWord) == nil then
      goToFirst(keyWord)
    end
  end
else
  goToFirst(keyWord)
end
