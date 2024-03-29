--------------------===================--------------------
----------<<<<<<<<<< AUTOMATION Toggle >>>>>>>>>>----------
--------------------===================--------------------

---------------------------------------
----- SET THE FOLLOWING VARIABLES -----
---------------------------------------
Group1 = 42263          --  << COMMAND ID
ExcludeName = "%(%-AUTO%)"


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
  if not string.find(tbNames[i], ExcludeName) then
    table.insert(tbNewTracks, tbTracks[i])
  end
end

reaper.Main_OnCommand(40297, 0)  -- unselect all tracks




-------------------------
-- Add 'Separator' track.
-------------------------




reaper.Main_OnCommand(Group1, 0)  -- select group

reaper.Main_OnCommand(reaper.NamedCommandLookup("_XENAKIOS_SELPREVTRACK"), 0)  -- select previous track

-- put selected tracks into TABLE: tbNewTracks
for i=0, trCount do
  selTrack = reaper.GetSelectedTrack(0, i)
  table.insert(tbNewTracks, selTrack)
end

reaper.Main_OnCommand(40297, 0)  -- unselect all tracks




-- select all tracks from TABLE: tbNewTracks
for i=1, #tbNewTracks do
  reaper.SetTrackSelected(tbNewTracks[i], true)
end

reaper.Main_OnCommand(40853, 0)  -- Toggle show/hide in TCP

reaper.Main_OnCommand(40297, 0)  -- unselect all tracks
