

keyWord = "VERSE"


function goToFirst(searchWord)
  retval, num_markers, num_regions = reaper.CountProjectMarkers(0)
  
  for i=0, num_markers + num_regions do
    retVal, isRgn, pos, rgnEnd, name, IDX = reaper.EnumProjectMarkers(i)

    if string.find(name, searchWord) then
      reaper.SetEditCurPos(pos, 1, 1)
      break
    end
  end
end

-------------------------------------------------------------------------------------------

cursorPos = reaper.GetCursorPosition()

marker, region = reaper.GetLastMarkerAndCurRegion(0, cursorPos)

if region == -1 then
  retVal, isRgn, pos, rgnEnd, name, startIDX = reaper.EnumProjectMarkers(marker)
else
  retVal, isRgn, pos, rgnEnd, name, startIDX = reaper.EnumProjectMarkers(region)
end


if string.find(name, keyWord) then
  retval, num_markers, num_regions = reaper.CountProjectMarkers(0)

  for i=0, num_markers + num_regions do
    retVal, isRgn, pos, rgnEnd, name, IDX = reaper.EnumProjectMarkers(i)
    
    if string.find(name, keyWord) and IDX > startIDX then
      reaper.SetEditCurPos(pos, 1, 1)
      break
    
    elseif i == num_markers + num_regions and string.find(name, keyWord) == nil then
      goToFirst(keyWord)
    end
  end
else
  goToFirst(keyWord)
end

