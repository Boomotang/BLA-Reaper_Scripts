--------------------============--------------------
----------<<<<<<<<<< TCP Toggle >>>>>>>>>>----------
--------------------============--------------------

---------------------------------------
----- SET THE FOLLOWING VARIABLES -----
---------------------------------------
Group1 = 42254          --  << COMMAND ID
Name1 = "ROOM"
Name2 = "  OH  "
TrackName1 = "KICK"
TrackName2 = "SNARE"
TrackName3 = "TOMS"
TrackName4 = "DIRECT"


tbTracks = {}       -- MediaTracks
tbNames = {}        -- Names of MediaTracks
tbNewTracks = {}    -- new selection of MediaTracks from specified Names
tbFinalTracks = {}  -- final selection of tracks after excluding "PFX"


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
    string.find(tbNames[i], Name1) or
    string.find(tbNames[i], Name2) or
    string.find(tbNames[i], TrackName1) or
    string.find(tbNames[i], TrackName2) or
    string.find(tbNames[i], TrackName3) or
    string.find(tbNames[i], TrackName4) then
      table.insert(tbNewTracks, tbTracks[i])
  end
end

reaper.Main_OnCommand(40297, 0)  -- unselect all tracks



tbNames = nil
tbTracks = nil
tbTracks = {}       -- MediaTracks
tbNames = {}        -- Names of MediaTracks



-- select all tracks from TABLE: tbNewTracks
for i=1, #tbNewTracks do
      reaper.SetTrackSelected(tbNewTracks[i], true)
end

reaper.Main_OnCommand(reaper.NamedCommandLookup("_SWS_SELCHILDREN2"), 0)

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
  if not string.find(tbNames[i], "PFX") and not string.find(tbNames[i], "SMP") then
      table.insert(tbFinalTracks, tbTracks[i])
  end
end

reaper.Main_OnCommand(40297, 0)  -- unselect all tracks


-- select all tracks from TABLE: tbFinalTracks
for i=1, #tbFinalTracks do
      reaper.SetTrackSelected(tbFinalTracks[i], true)
end

reaper.Main_OnCommand(40853, 0)  -- Toggle TCP Visibility

reaper.Main_OnCommand(40297, 0)  -- unselect all tracks
