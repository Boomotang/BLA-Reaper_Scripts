

-- inserts mediaTracks from group into table: tb
function insertTracks(cmdID)  -- cmdID: Command ID for the group
  reaper.Main_OnCommand(cmdID, 0)  -- selects all tracks in group
  table.insert(tb, reaper.GetSelectedTrack(0, 0))  -- returns mediaTrack
end

tb = {}

-- Insert tracks from groups into table: tb.
insertTracks(42268)
insertTracks(42266)

-- Select all tracks from table.
for i=1,#tb do
  reaper.SetTrackSelected(tb[1],true)
end
