

keyWord = "VERSE"


cursorPos = reaper.GetCursorPosition()

marker, region = reaper.GetLastMarkerAndCurRegion(0, cursorPos)

retVal, isRgn, pos, rgnEnd, name, startingIDX = reaper.EnumProjectMarkers(marker)


if string.find(name, keyWord) then
  retval, num_markers, num_regions = reaper.CountProjectMarkers(0)

  for i=1, num_markers do
    retVal, isRgn, pos, rgnEnd, name, markIDX = reaper.EnumProjectMarkers(i-1)
    
    if string.find(name, keyWord) and markIDX > startingIDX then
      reaper.GoToMarker(0, i, 0)
      break
    end

    if i == num_markers and string.find(name, keyWord) == nil then
      for i=1, num_markers do
        retVal, isRgn, pos, rgnEnd, name, markIDX = reaper.EnumProjectMarkers(i-1)

        if string.find(name, keyWord) then
          reaper.GoToMarker(0, i, 0)
          break
        end
      end
    end
  end
else
  retval, num_markers, num_regions = reaper.CountProjectMarkers(0)
  
  for i=1, num_markers do
    retVal, isRgn, pos, rgnEnd, name, markIDX = reaper.EnumProjectMarkers(i-1)

    if string.find(name, keyWord) then
      reaper.GoToMarker(0, i, 0)
      break
    end
  end
end

