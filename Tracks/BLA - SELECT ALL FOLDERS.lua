tbTracks = {}       -- MediaTracks
tbNames = {}        -- Names of MediaTracks
tbNewTracks = {}    -- new selection of MediaTracks from specified Names


-------------
-- 
-------------


reaper.Main_OnCommand(40941, 0) -- select track 03

ExcludeTrack1 = reaper.GetSelectedTrack(0, 0)

_, ExcludeName1 = reaper.GetTrackName(ExcludeTrack1)

reaper.Main_OnCommand(40297, 0)  -- unselect all tracks



reaper.Main_OnCommand(40963, 0) -- select track 25

ExcludeTrack2 = reaper.GetSelectedTrack(0, 0)

_, ExcludeName2 = reaper.GetTrackName(ExcludeTrack2)

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

-- check names and specify ones to put from the TABLE:tbTracks into TABLE:tbNewTracks
for i=1, #tbNames do
  if not string.find(tbNames[i], ExcludeName1) and not string.find(tbNames[i], ExcludeName2) then
    table.insert(tbNewTracks, tbTracks[i])
  end
end

reaper.Main_OnCommand(40297, 0)  -- unselect all tracks



-- select all tracks from TABLE: tbNewTracks
for i=1, #tbNewTracks do
  reaper.SetTrackSelected(tbNewTracks[i], true)
end
