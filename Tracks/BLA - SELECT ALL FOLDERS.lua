tbTracks = {}       -- MediaTracks
tbNames = {}        -- Names of MediaTracks
tbNamesRemove = {}  -- names of tracks to remove
tbFinalTracks = {}  -- final selection of MediaTracks


-------------
-- 
-------------


--  HAVE TO USE tbNAMES FOR PUTTING THE "NAMES" IS tbNamesRemove


reaper.Main_OnCommand(40941, 0) -- select track 03

trCount = reaper.CountSelectedTracks(0)

-- put selected tracks into TABLE: tbNamesRemove
for i=0, trCount do
  selTrack = reaper.GetSelectedTrack(0, i)
  table.insert(tbNamesRemove, selTrack)
  table.insert(tbFinalTracks, selTrack)
end

reaper.Main_OnCommand(40297, 0)  -- unselect all tracks


reaper.Main_OnCommand(40963, 0) -- select track 03

trCount = reaper.CountSelectedTracks(0)

-- put selected tracks into TABLE: tbNamesRemove
for i=0, trCount do
  selTrack = reaper.GetSelectedTrack(0, i)
  table.insert(tbNamesRemove, selTrack)
  table.insert(tbFinalTracks, selTrack)
end

reaper.Main_OnCommand(40297, 0)  -- unselect all tracks



------------------------------------------------------------



reaper.Main_OnCommand(reaper.NamedCommandLookup("_SWS_SELALLPARENTS"), 0) -- select all parent folders

trCount = reaper.CountSelectedTracks(0)

-- put selected tracks into TABLE: tbTracks
for i=0, trCount do
  selTrack = reaper.GetSelectedTrack(0, i)
  table.insert(tbTracks, selTrack)
end

-- get track names and put them in new TABLE: tbNames
for i=1, #tbTracks do
  _, selName = reaper.GetTrackName(tbTracks[i])
  table.insert(tbNames, selName)
end

reaper.Main_OnCommand(40297, 0)  -- unselect all tracks



-- -- Remove matches from tbNames & tbNamesRemove.

for i=#tbNames, 1, -1 do
  for j=1, #tbNamesRemove do
    if tbNames[i] == tbNamesRemove[j] then
      table.remove(tbFinalTracks, i)
      break
    end
  end
end










-- select all tracks from TABLE: tbFinalTracks
for i=1, #tbFinalTracks do
  reaper.SetTrackSelected(tbFinalTracks[i], true)
end







-- reaper.Main_OnCommand(group, 0)  -- select group
