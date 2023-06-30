--------------------==========--------------------
----------<<<<<<<<<< MCP Solo >>>>>>>>>>----------
--------------------==========--------------------

---------------------------------------
----- SET THE FOLLOWING VARIABLES -----
---------------------------------------
Group1 = 42254          --  << COMMAND ID     KIT
Group2 = 42255          --  << COMMAND ID     BASS
Group3 = 42252          --  << COMMAND ID     PERC

Name1 = " KIT  "
Name2 = "PUNCH"
Name3 = " ROOM "
Name4 = "KICK"
Name5 = "SNARE"
Name6 = "  OH  "
Name7 = "nul"
Name8 = "TOMS"
Name9 = "RVB"
Name10 = "%(KIT%-MCP%)"
Name11 = "%(KIT2%-MCP%)"


Name12 = "BASS"

Name13 = "TRACKS"


tbTracks = {}       -- MediaTracks
tbNames = {}        -- Names of MediaTracks
tbNewTracks = {}    -- new selection of MediaTracks from specified Names
tbFinalTracks = {}  -- final selection of MediaTracks


--------------------------------------------------------------------------


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
    string.find(tbNames[i], Name1) or
    string.find(tbNames[i], Name2) or
    string.find(tbNames[i], Name3) or
    string.find(tbNames[i], Name4) or
    string.find(tbNames[i], Name5) or
    string.find(tbNames[i], Name6) or
    string.find(tbNames[i], Name7) or
    string.find(tbNames[i], Name8) or
    string.find(tbNames[i], Name9) or
    string.find(tbNames[i], Name10) or
    string.find(tbNames[i], Name11) then
      table.insert(tbFinalTracks, tbTracks[i])
  end
end

reaper.Main_OnCommand(40297, 0)  -- unselect all tracks



tbTracks = nil
tbNames = nil

tbTracks = {}
tbNames = {}


--------------------------------------------------------------------------


reaper.Main_OnCommand(Group2, 0)  -- select group
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
    string.find(tbNames[i], Name12) then
      table.insert(tbFinalTracks, tbTracks[i])
  end
end

reaper.Main_OnCommand(40297, 0)  -- unselect all tracks



tbTracks = nil
tbNames = nil

tbTracks = {}
tbNames = {}


--------------------------------------------------------------------------


reaper.Main_OnCommand(Group3, 0)  -- select group

-- put selected tracks into TABLE: tbFinalTracks
for i=0, trCount do
  selTrack = reaper.GetSelectedTrack(0, i)
  table.insert(tbFinalTracks, selTrack)
end



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

-- check names and specify ones to put from the TABLE:tbTracks into TABLE:tbNewTracks
for i=1, #tbNames do
  if
    string.find(tbNames[i], Name13) then
      table.insert(tbNewTracks, tbTracks[i])
  end
end

reaper.Main_OnCommand(40297, 0)  -- unselect all tracks


tbTracks = nil
tbNames = nil

tbTracks = {}
tbNames = {}


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




-- select all tracks from TABLE: tbFinalTracks
for i=1, #tbFinalTracks do
  reaper.SetTrackSelected(tbFinalTracks[i], true)
end


reaper.Main_OnCommand(reaper.NamedCommandLookup("_SWSTL_SHOWMCPEX"), 0)

reaper.Main_OnCommand(40297, 0)  -- unselect all tracks
