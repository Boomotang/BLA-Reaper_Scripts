--------------------===================--------------------
----------<<<<<<<<<< AUTOMATION Toggle >>>>>>>>>>----------
--------------------===================--------------------

---------------------------------------
----- SET THE FOLLOWING VARIABLES -----
---------------------------------------
Group1 = 42259          --  << COMMAND ID
TrackName1 = "PFX"
TrackName2 = "FX"
TrackName3 = "REVERB"
TrackName4 = "DELAY"
TrackName5 = "L%-AC"
TrackName6 = "R%-AC"
TrackName7 = "%(%+AUTO%)"


tbTracks = {}     -- MediaTracks
tbNames = {}      -- Names of MediaTracks
tbNewTracks = {}  -- new selection of MediaTracks from specified Names

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
    string.find(tbNames[i], TrackName1) or
    string.find(tbNames[i], TrackName2) or
    string.find(tbNames[i], TrackName3) or
    string.find(tbNames[i], TrackName4) or
    string.find(tbNames[i], TrackName5) or
    string.find(tbNames[i], TrackName6) or
    string.find(tbNames[i], TrackName7) then
      table.insert(tbNewTracks, tbTracks[i])
  end
end

reaper.Main_OnCommand(40297, 0)  -- unselect all tracks

-- select all tracks from TABLE: tbNewTracks
for i=1, #tbNewTracks do
  reaper.SetTrackSelected(tbNewTracks[i], true)
end

reaper.Main_OnCommand(40853, 0)  -- Toggle show/hide in TCP

reaper.Main_OnCommand(40297, 0)  -- unselect all tracks
