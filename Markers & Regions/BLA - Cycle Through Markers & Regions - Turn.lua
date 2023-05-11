

keyWord = "Turn"


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

-- GET MARKER & REGION INFO AT CURSOR POSITION

cursorPos = reaper.GetCursorPosition()

marker, region = reaper.GetLastMarkerAndCurRegion(0, cursorPos)

_, _, M_Pos, _, M_Name, M_IDX = reaper.EnumProjectMarkers(marker)
_, _, R_Pos, _, R_Name, R_IDX = reaper.EnumProjectMarkers(region)


-- IF BOTH MARKER & REGION DON'T CONTAIN keyWord THEN,
--  GO TO FIRST keyWord & END SCRIPT

if string.find(M_Name, keyWord) == nil and string.find(R_Name, keyWord) == nil then
  goToFirst(keyWord)
  return
end


-- IF THERE IS NO REGION or,
-- IF REGION STARTS BEFORE MARKER and MARKER NAME CONTAINS keyWord THEN,
--  USE MARKER INFO GOING FORWARD, 

-- ELSE USE REGION INFO GOING FORWARD

if region == -1 or R_Pos < M_Pos and string.find(M_Name, keyWord) then
  _, isRgn, startPos, rgnEnd, startName, IDX = reaper.EnumProjectMarkers(marker)
else
  _, isRgn, startPos, rgnEnd, startName, IDX = reaper.EnumProjectMarkers(region)
end


-- USE WHICHEVER COMES LATER IN TIMELINE AS STARTING INDEX FOR THE FOLLOWING LOOP
-- (MARKER OR REGION)

if M_Pos > R_Pos then 
  startIDX = marker+1 
else 
  startIDX = region+1 
end 


count = reaper.CountProjectMarkers(0)

-- LOOP THROUGH ALL MARKERS & REGIONS AFTER CURSOR UP TO END OF PROJECT

-- IF THE keyWord IS AT CURSER and,
-- IF THE keyWord IS FOUND AFTER THE CURSOR THEN,
--  GO TO NEW MARKER/REGION & EXIT LOOP
-- ELSE IF THE keyWord IS NOT FOUND AFTER THE CURSOR THEN,
--  GO TO FIRST keyWord IN PROJECT

for i=startIDX, count do
  _, _, pos, _, name, _ = reaper.EnumProjectMarkers(i)

  if string.find(startName, keyWord) and string.find(name, keyWord) then
    reaper.SetEditCurPos(pos, 1, 1)
    break

  elseif i == count then
    goToFirst(keyWord)
    break
  end
end
