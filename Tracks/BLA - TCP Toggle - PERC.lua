--------------------============--------------------
----------<<<<<<<<<< TCP Toggle >>>>>>>>>>----------
--------------------============--------------------

---------------------------------------
----- SET THE FOLLOWING VARIABLES -----
---------------------------------------
Group1 = 42252          --  << COMMAND ID
Group2 = 42251          --  << COMMAND ID
TrackName1 = "TRACKS"


tbTracks = {}     -- MediaTracks
tbNames = {}      -- Names of MediaTracks
tbNewTracks = {}  -- new selection of MediaTracks from specified Names
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

-- check names and specify ones to put from the TABLE:tbTracks into TABLE:tbNewTracks
for i=1, #tbNames do
  if
    string.find(tbNames[i], TrackName1) then
      table.insert(tbNewTracks, tbTracks[i])
  end
end

reaper.Main_OnCommand(40297, 0)  -- unselect all tracks




-- select all tracks from TABLE: tbNewTracks
for i=1, #tbNewTracks do
  reaper.SetTrackSelected(tbNewTracks[i], true)
end

reaper.Main_OnCommand(reaper.NamedCommandLookup("_SWS_SELCHILDREN"), 0)

-- put selected tracks into TABLE: tbFinalTracks
for i=0, trCount do
  selTrack = reaper.GetSelectedTrack(0, i)
  table.insert(tbFinalTracks, selTrack)
end

reaper.Main_OnCommand(40297, 0)  -- unselect all tracks



-------------------------
-- Add 'Separator' track.
-------------------------



reaper.Main_OnCommand(Group1, 0)  -- select group

reaper.Main_OnCommand(reaper.NamedCommandLookup("_XENAKIOS_SELPREVTRACK"), 0)  -- select previous track

-- put selected tracks into TABLE: tbFinalTracks
for i=0, trCount do
  selTrack = reaper.GetSelectedTrack(0, i)
  table.insert(tbFinalTracks, selTrack)
end

reaper.Main_OnCommand(40297, 0)  -- unselect all tracks


reaper.Main_OnCommand(Group2, 0)  -- select group

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

reaper.Main_OnCommand(40853, 0)  -- Toggle TCP Visibility

reaper.Main_OnCommand(40297, 0)  -- unselect all tracks
