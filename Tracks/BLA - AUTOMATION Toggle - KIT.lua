--------------------===================--------------------
----------<<<<<<<<<< AUTOMATION Toggle >>>>>>>>>>----------
--------------------===================--------------------

---------------------------------------
----- SET THE FOLLOWING VARIABLES -----
---------------------------------------
Group1 = 42254          --  << COMMAND ID
TrackName1 = "RVB"
TrackName2 = "CMP"
TrackName3 = "DELAY"
TrackName4 = "KICK"
TrackName5 = "SNARE"
TrackName6 = "TOMS"
TrackName7 = "%(%+AUTO%)"

Bus1 = "%(KIT2%-MCP%)"

ExcludeName = " ROOM "


tbTracks = {}     -- MediaTracks
tbNames = {}      -- Names of MediaTracks
tbNewTracks = {}  -- new selection of MediaTracks from specified Names
tbFinalTracks = {}  -- final selection of MediaTracks

reaper.Main_OnCommand(Group1, 0)  -- select group
reaper.Main_OnCommand(reaper.NamedCommandLookup("_SWS_SELCHILDREN"), 0)

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
  if
    string.find(tbNames[i], TrackName1) or
    string.find(tbNames[i], TrackName2) or
    string.find(tbNames[i], TrackName3) or
    string.find(tbNames[i], TrackName4) or
    string.find(tbNames[i], TrackName5) or
    string.find(tbNames[i], TrackName6) or
    string.find(tbNames[i], TrackName7) then
      table.insert(tbFinalTracks, tbTracks[i])
  end
end


-- check names and specify ones to put from the TABLE:tbTracks into TABLE:tbNewTracks
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

reaper.Main_OnCommand(reaper.NamedCommandLookup("_SWS_SELCHILDREN"), 0)


tbTracks = nil
tbNames = nil
tbNewTracks = nil

tbTracks = {}
tbNames = {}
tbNewTracks = {}


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


reaper.Main_OnCommand(40297, 0)  -- unselect all tracks

-- select all tracks from TABLE: tbFinalTracks
for i=1, #tbFinalTracks do
  reaper.SetTrackSelected(tbFinalTracks[i], true)
end

reaper.Main_OnCommand(40853, 0)  -- Toggle show/hide in TCP

reaper.Main_OnCommand(40297, 0)  -- unselect all tracks
