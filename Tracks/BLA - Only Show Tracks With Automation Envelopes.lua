-- Only show tracks with automation envelopes.

tbTracks = {}     -- MediaTracks
tbNewTracks = {}  -- new selection of MediaTracks from specified Names


trCount = reaper.CountTracks(0)

reaper.Main_OnCommand(40296, 0)

-- put selected tracks into TABLE: tbTracks
for i=0, trCount do
  selTrack = reaper.GetSelectedTrack(0, i)
  table.insert(tbTracks, selTrack)
end

for i=1, #tbTracks do
  EnvCount = reaper.CountTrackEnvelopes(tbTracks[i])
  if EnvCount > 0 then
    table.insert(tbNewTracks, tbTracks[i])
  end
end

reaper.Main_OnCommand(40297, 0)  -- unselect all tracks



-- select all tracks from TABLE: tbNewTracks
for i=1, #tbNewTracks do
  reaper.SetTrackSelected(tbNewTracks[i], true)
end

reaper.Main_OnCommand(reaper.NamedCommandLookup("_SWSTL_SHOWTCPEX"), 0)
