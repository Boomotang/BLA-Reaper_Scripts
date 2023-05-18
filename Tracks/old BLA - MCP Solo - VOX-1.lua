--------------------==========--------------------
----------<<<<<<<<<< MCP Solo >>>>>>>>>>----------
--------------------==========--------------------

---------------------------------------
----- SET THE FOLLOWING VARIABLES -----
---------------------------------------
Group1 = 42268          --  << COMMAND ID
Bus1 = "VOX%-1"
BusExclude1 = "V1%-SF"
BusExclude2 = "V1%-LD"


tbTracks = {}       -- MediaTracks
tbNames = {}        -- Names of MediaTracks
tbNewTracks = {}    -- new selection of MediaTracks from specified Names
tbNamesRemove = {}  -- names of tracks to remove
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
  if string.find(tbNames[i], Bus1) then
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

--------------------------------------------------------------------------

reaper.Main_OnCommand(reaper.NamedCommandLookup("_SWS_SELCHILDREN2"), 0)

-- put selected tracks into TABLE: tbTracks
for i=0, trCount do
  selTrack = reaper.GetSelectedTrack(0, i)
  table.insert(tbTracks, selTrack)
end

-- put selected tracks into TABLE: tbFinalTracks
for i=0, trCount do
  selTrack = reaper.GetSelectedTrack(0, i)
  table.insert(tbFinalTracks, selTrack)
end

-- get track names and put them in new TABLE: tbNames
for i=1, #tbTracks do
  _, selName = reaper.GetTrackName(tbTracks[i])
  table.insert(tbNames, selName)
end

-- check names and specify ones to put in new TABLE:tbNewTracks from the TABLE:tbTracks
for i=1, #tbNames do
  if string.find(tbNames[i], BusExclude1) or string.find(tbNames[i], BusExclude2) then
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


tbTracks = nil
tbNames = nil

tbTracks = {}
tbNames = {}


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


RemoveList = table.concat(tbNamesRemove, " - ", 1, #tbNamesRemove)



for i=1, #tbNames do
  if string.match(RemoveList, tbNames[i]) then
    table.remove(tbFinalTracks, i)
  end
end

reaper.Main_OnCommand(40297, 0)  -- unselect all tracks

-- select all tracks from TABLE: tbFinalTracks
for i=1, #tbFinalTracks do
  reaper.SetTrackSelected(tbFinalTracks[i], true)
end
