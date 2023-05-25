--------------------===================--------------------
----------<<<<<<<<<< AUTOMATION Toggle >>>>>>>>>>----------
--------------------===================--------------------

---------------------------------------
----- SET THE FOLLOWING VARIABLES -----
---------------------------------------
Group1 = 42266          --  << COMMAND ID
Group2 = 42268          --  << COMMAND ID
Bus1 = "VOX%-2"
Bus2 = "V2%-DBL"
TrackName1 = "VOX%-2"
TrackName2 = "PFX"
TrackName3 = "SF%-D"
TrackName4 = "LD%-D"



---------------------------------------------------------------------------------------
-- Populate tbTracks & tbNames w/ L-VOX FOLDER TRACKS then single out VOX-1 & children.
---------------------------------------------------------------------------------------


tbTracks = {}       -- MediaTracks
tbNames = {}        -- Names of MediaTracks
tbNewTracks = {}    -- new selection of MediaTracks from specified Names
tbFinalTracks = {}  -- final selection of MediaTracks


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
  if
    string.find(tbNames[i], Bus1) then
      table.insert(tbNewTracks, tbTracks[i])
  end
end

reaper.Main_OnCommand(40297, 0)  -- unselect all tracks

-- select all tracks from TABLE: tbNewTracks
for i=1, #tbNewTracks do
  reaper.SetTrackSelected(tbNewTracks[i], true)
end


tbTracks = nil
tbNames = nil
tbNewTracks = nil

tbTracks = {}
tbNames = {}
tbNewTracks = {}


reaper.Main_OnCommand(reaper.NamedCommandLookup("_SWS_SELCHILDREN2"), 0)




------------------------------------
-- Put VOX-1 & PFX in tbFinalTracks.
------------------------------------


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
  if
    string.find(tbNames[i], TrackName1) or
    string.find(tbNames[i], TrackName2) then
      table.insert(tbFinalTracks, tbTracks[i])
  end
end


tbTracks = nil
tbNames = nil
tbNewTracks = nil

tbTracks = {}
tbNames = {}
tbNewTracks = {}




---------------------------------------------------------------------------------------
-- Populate tbTracks & tbNames w/ L-VOX FOLDER TRACKS then single out V1-DBL & children.
---------------------------------------------------------------------------------------


reaper.Main_OnCommand(Group2, 0)  -- select group
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
  if
    string.find(tbNames[i], Bus2) then
      table.insert(tbNewTracks, tbTracks[i])
  end
end

reaper.Main_OnCommand(40297, 0)  -- unselect all tracks

-- select all tracks from TABLE: tbNewTracks
for i=1, #tbNewTracks do
  reaper.SetTrackSelected(tbNewTracks[i], true)
end


tbTracks = nil
tbNames = nil
tbNewTracks = nil

tbTracks = {}
tbNames = {}
tbNewTracks = {}

reaper.Main_OnCommand(reaper.NamedCommandLookup("_SWS_SELCHILDREN2"), 0)




------------------------------------
-- Put SF-D & LD-D in tbFinalTracks.
------------------------------------


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
  if
    string.find(tbNames[i], TrackName3) or
    string.find(tbNames[i], TrackName4) then
      table.insert(tbFinalTracks, tbTracks[i])
  end
end


reaper.Main_OnCommand(40297, 0)  -- unselect all tracks

-- select all tracks from TABLE: tbFinalTracks
for i=1, #tbFinalTracks do
  reaper.SetTrackSelected(tbFinalTracks[i], true)
end



reaper.Main_OnCommand(40853, 0)  -- Toggle show/hide in TCP

reaper.Main_OnCommand(40297, 0)  -- unselect all tracks
