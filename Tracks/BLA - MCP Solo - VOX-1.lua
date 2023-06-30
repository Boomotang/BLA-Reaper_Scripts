--------------------==========--------------------
----------<<<<<<<<<< MCP Solo >>>>>>>>>>----------
--------------------==========--------------------

---------------------------------------
----- SET THE FOLLOWING VARIABLES -----
---------------------------------------
Group1 = 42268          --  << COMMAND ID
Bus1 = "VOX%-1"
Bus2 = "V1%-DBL"
ExcludeName = "%(%-MCP%)"
ExcludeChildrenFolder1 = "V1%-SF"
ExcludeChildrenFolder2 = "V1%-LD"


tbTracks = {}       -- MediaTracks
tbNames = {}        -- Names of MediaTracks
tbNewTracks = {}    -- new selection of MediaTracks from specified Names
tbNamesRemove = {}  -- names of tracks to remove
tbFinalTracks = {}  -- final selection of MediaTracks




----------------------------------------------------------------------------------------------------------------
-- Populate tbTracks & tbNames w/ L-VOX FOLDER TRACKS & populate tbFinalTracks w/ ROOM, PFX, & Separator tracks.
----------------------------------------------------------------------------------------------------------------


reaper.Main_OnCommand(Group1, 0)  -- select group
reaper.Main_OnCommand(reaper.NamedCommandLookup("_SWS_SELCHILDREN2"), 0)

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



-- check names and specify ones to put from the TABLE:tbTracks into TABLE:tbFinalTracks
for i=1, #tbNames do
  if string.find(tbNames[i], "ROOM") then
      table.insert(tbFinalTracks, tbTracks[i])
  end
end

-- check names and specify ones to put from the TABLE:tbTracks into TABLE:tbFinalTracks
for i=1, #tbNames do
  if string.find(tbNames[i], "PFX") and string.find(tbNames[i], "%u1") then
      table.insert(tbFinalTracks, tbTracks[i])
  end
end

-- check names and specify ones to put from the TABLE:tbTracks into TABLE:tbFinalTracks
for i=1, #tbNames do
  if string.find(tbNames[i], "%(%+SOLO%)") or string.find(tbNames[i], "%(V1%)") then
      table.insert(tbFinalTracks, tbTracks[i])
  end
end



-------------------------------
-- Single out VOX-1 & children.
-------------------------------



-- check names and specify ones to put in new TABLE:tbNewTracks from the TABLE:tbTracks
for i=1, #tbNames do
  if string.find(tbNames[i], Bus1) then
      table.insert(tbNewTracks, tbTracks[i])
  end
end

reaper.Main_OnCommand(40297, 0)  -- unselect all tracks

-- select all tracks from TABLE: tbNewTracks
for i=1, #tbNewTracks do
  reaper.SetTrackSelected(tbNewTracks[i], true)
end

reaper.Main_OnCommand(reaper.NamedCommandLookup("_SWS_SELCHILDREN2"), 0)


tbTracks = nil
tbNames = nil
tbNewTracks = nil

tbTracks = {}
tbNames = {}
tbNewTracks = {}




-------------------------------------------------------
-- Populate tbFinalTracks w/ all except (-AUTO) TRACKS.
-------------------------------------------------------


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

-- check names and specify ones to put in new TABLE:tbFinalTracks from the TABLE:tbTracks
for i=1, #tbNames do
  if not string.find(tbNames[i], ExcludeName) then
      table.insert(tbFinalTracks, tbTracks[i])
  end
end


tbTracks = nil
tbNames = nil
tbNewTracks = nil

tbTracks = {}
tbNames = {}
tbNewTracks = {}




--------------------------------------------------------------------------------
-- Populate tbNamesRemove from Soft & Loud FOLDERS from tracks in tbFinalTracks.
--------------------------------------------------------------------------------


reaper.Main_OnCommand(40297, 0)  -- unselect all tracks

-- select all tracks from TABLE: tbFinalTracks
for i=1, #tbFinalTracks do
  reaper.SetTrackSelected(tbFinalTracks[i], true)
end

-- get track names and put them in new TABLE: tbNames
for i=1, #tbFinalTracks do
  _, selName = reaper.GetTrackName(tbFinalTracks[i])
  table.insert(tbNames, selName)
end

-- check names and specify ones to put in new TABLE:tbNewTracks from the TABLE:tbFinalTracks
for i=1, #tbNames do
  if string.find(tbNames[i], ExcludeChildrenFolder1) or string.find(tbNames[i], ExcludeChildrenFolder2) then
      table.insert(tbNewTracks, tbFinalTracks[i])
  end
end

reaper.Main_OnCommand(40297, 0)  -- unselect all tracks

-- select all tracks from TABLE: tbNewTracks
for i=1, #tbNewTracks do
  reaper.SetTrackSelected(tbNewTracks[i], true)
end

reaper.Main_OnCommand(reaper.NamedCommandLookup("_SWS_SELCHILDREN"), 0)


tbTracks = nil
tbNames = nil
tbNewTracks = nil

tbTracks = {}
tbNames = {}
tbNewTracks = {}


-- put selected tracks into TABLE: tbTracks
for i=0, trCount do
  selTrack = reaper.GetSelectedTrack(0, i)
  table.insert(tbTracks, selTrack)
end

-- get track names and put them in new TABLE: tbNamesRemove
for i=1, #tbTracks do
  _, selName = reaper.GetTrackName(tbTracks[i])
  table.insert(tbNamesRemove, selName)
end

reaper.Main_OnCommand(40297, 0)  -- unselect all tracks


tbTracks = nil
tbTracks = {}




-----------------------------------------------------
-- Remove matches from tbFinalTracks & tbNamesRemove.
-----------------------------------------------------


-- select all tracks from TABLE: tbFinalTracks
for i=1, #tbFinalTracks do
  reaper.SetTrackSelected(tbFinalTracks[i], true)
end

-- get track names and put them in new TABLE: tbNames
for i=1, #tbFinalTracks do
  _, selName = reaper.GetTrackName(tbFinalTracks[i])
  table.insert(tbNames, selName)
end

for i=#tbNames, 1, -1 do
  for j=1, #tbNamesRemove do
    if tbNames[i] == tbNamesRemove[j] then
      table.remove(tbFinalTracks, i)
      break
    end
  end
end

reaper.Main_OnCommand(40297, 0)  -- unselect all tracks


tbNames = nil
tbNamesRemove = nil

tbNames = {}
tbNamesRemove = {}




----------------------------------------------------------------------------------------
-- Populate tbTracks & tbNames w/ L-VOX FOLDER TRACKS then single out V1-DBL & children.
----------------------------------------------------------------------------------------


reaper.Main_OnCommand(Group1, 0)  -- select group
reaper.Main_OnCommand(reaper.NamedCommandLookup("_SWS_SELCHILDREN2"), 0)

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

-- check names and specify ones to put in new TABLE:tbNewTracks from the TABLE:tbTracks
for i=1, #tbNames do
  if string.find(tbNames[i], Bus2) then
      table.insert(tbNewTracks, tbTracks[i])
  end
end

reaper.Main_OnCommand(40297, 0)  -- unselect all tracks

-- select all tracks from TABLE: tbNewTracks
for i=1, #tbNewTracks do
  reaper.SetTrackSelected(tbNewTracks[i], true)
end

reaper.Main_OnCommand(reaper.NamedCommandLookup("_SWS_SELCHILDREN2"), 0)


tbTracks = nil
tbNames = nil
tbNewTracks = nil

tbTracks = {}
tbNames = {}
tbNewTracks = {}




-------------------------------------------------------
-- Populate tbFinalTracks w/ all except (-AUTO) TRACKS.
-------------------------------------------------------


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

-- check names and specify ones to put in new TABLE:tbFinalTracks from the TABLE:tbTracks
for i=1, #tbNames do
  if not string.find(tbNames[i], ExcludeName) and not
    string.find(tbNames[i], "LD%-D") and not
    string.find(tbNames[i], "SF%-D") then
      table.insert(tbFinalTracks, tbTracks[i])
  end
end


tbTracks = nil
tbNames = nil
tbNewTracks = nil

tbTracks = {}
tbNames = {}
tbNewTracks = {}


reaper.Main_OnCommand(40297, 0)  -- unselect all tracks

-- select all tracks from TABLE: tbFinalTracks
for i=1, #tbFinalTracks do
  reaper.SetTrackSelected(tbFinalTracks[i], true)
end


reaper.Main_OnCommand(reaper.NamedCommandLookup("_SWSTL_SHOWMCPEX"), 0)

reaper.Main_OnCommand(40297, 0)  -- unselect all tracks
