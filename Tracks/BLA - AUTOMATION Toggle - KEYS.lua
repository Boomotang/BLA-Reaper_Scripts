--------------------===================--------------------
----------<<<<<<<<<< AUTOMATION Toggle >>>>>>>>>>----------
--------------------===================--------------------

---------------------------------------
----- SET THE FOLLOWING VARIABLES -----
---------------------------------------
Group1 = 42262          --  << COMMAND ID
Group2 = 42261          --  << COMMAND ID
Group3 = 42260          --  << COMMAND ID
TrackName1 = "PFX"
TrackName2 = "FX"
TrackName3 = "REVERB"
TrackName4 = "DELAY"


tbTracks = {}       -- MediaTracks
tbNames = {}        -- Names of MediaTracks
tbNewTracks = {}    -- new selection of MediaTracks from specified Names
tbFinalTracks = {}  -- final selection of MediaTracks




------------------------------------------------------------------------------------------------
-- Populate tbTracks & tbNames w/ KEYS FOLDER & children, then specify tracks for tbFinalTracks.
------------------------------------------------------------------------------------------------


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

-- check names and specify ones to put in new TABLE:tbFinalTracks from the TABLE:tbTracks
for i=1, #tbNames do
  if
    string.find(tbNames[i], TrackName1) or
    string.find(tbNames[i], TrackName2) or
    string.find(tbNames[i], TrackName3) or
    string.find(tbNames[i], TrackName4) then
      table.insert(tbFinalTracks, tbTracks[i])
  end
end

reaper.Main_OnCommand(40297, 0)  -- unselect all tracks


tbTracks = nil
tbNames = nil
tbNewTracks = nil

tbTracks = {}
tbNames = {}
tbNewTracks = {}




------------------------------------------------------------------------------------------------
-- Populate tbTracks & tbNames w/ PADS FOLDER & children, then specify tracks for tbFinalTracks.
------------------------------------------------------------------------------------------------


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

-- check names and specify ones to put in new TABLE:tbFinalTracks from the TABLE:tbTracks
for i=1, #tbNames do
  if
    string.find(tbNames[i], TrackName1) or
    string.find(tbNames[i], TrackName2) or
    string.find(tbNames[i], TrackName3) or
    string.find(tbNames[i], TrackName4) then
      table.insert(tbFinalTracks, tbTracks[i])
  end
end

reaper.Main_OnCommand(40297, 0)  -- unselect all tracks


tbTracks = nil
tbNames = nil
tbNewTracks = nil

tbTracks = {}
tbNames = {}
tbNewTracks = {}




--------------------------------------------------------------------------------------------------
-- Populate tbTracks & tbNames w/ SYNTHS FOLDER & children, then specify tracks for tbFinalTracks.
--------------------------------------------------------------------------------------------------


reaper.Main_OnCommand(Group3, 0)  -- select group
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

-- check names and specify ones to put in new TABLE:tbFinalTracks from the TABLE:tbTracks
for i=1, #tbNames do
  if
    string.find(tbNames[i], TrackName1) or
    string.find(tbNames[i], TrackName2) or
    string.find(tbNames[i], TrackName3) or
    string.find(tbNames[i], TrackName4) then
      table.insert(tbFinalTracks, tbTracks[i])
  end
end

reaper.Main_OnCommand(40297, 0)  -- unselect all tracks



--------------------------
-- Add 'Separator' tracks.
--------------------------



reaper.Main_OnCommand(Group2, 0)  -- select group

reaper.Main_OnCommand(reaper.NamedCommandLookup("_XENAKIOS_SELPREVTRACK"), 0)  -- select previous track

-- put selected tracks into TABLE: tbFinalTracks
for i=0, trCount do
  selTrack = reaper.GetSelectedTrack(0, i)
  table.insert(tbFinalTracks, selTrack)
end

reaper.Main_OnCommand(40297, 0)  -- unselect all tracks


reaper.Main_OnCommand(Group3, 0)  -- select group

reaper.Main_OnCommand(reaper.NamedCommandLookup("_XENAKIOS_SELPREVTRACK"), 0)  -- select previous track

-- put selected tracks into TABLE: tbFinalTracks
for i=0, trCount do
  selTrack = reaper.GetSelectedTrack(0, i)
  table.insert(tbFinalTracks, selTrack)
end

reaper.Main_OnCommand(40297, 0)  -- unselect all tracks




-- select all tracks from TABLE: tbFinalTracks
for i=1, #tbFinalTracks do
  reaper.SetTrackSelected(tbFinalTracks[i], true)
end


reaper.Main_OnCommand(40853, 0)  -- Toggle show/hide in TCP

reaper.Main_OnCommand(40297, 0)  -- unselect all tracks
