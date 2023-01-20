

keyWord = "VERSE"


function goToFirst(keyWord)
  count = reaper.CountProjectMarkers(0)

  for i=0, count do
    _, _, pos, _, name, _ = reaper.EnumProjectMarkers(i)

    if string.find(name, keyWord) then
      reaper.SetEditCurPos(pos, 1, 1)
      break
    end
  end
end

------------------------------------------------------------------------------------------

cursorPos = reaper.GetCursorPosition()

marker, region = reaper.GetLastMarkerAndCurRegion(0, cursorPos)

_, _, M_Pos, _, M_Name, M_IDX = reaper.EnumProjectMarkers(marker)
_, _, R_Pos, _, R_Name, R_IDX = reaper.EnumProjectMarkers(region)


if string.find(M_Name, keyWord) == nil and string.find(R_Name, keyWord) == nil then
  goToFirst(keyWord)
  return
end


returnTest = "ON"