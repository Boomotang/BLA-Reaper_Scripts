
for i=10, 19 do
  reaper.TrackFX_SetParam(reaper.GetMasterTrack(0), reaper.TrackFX_GetByName(reaper.GetMasterTrack(0), "RL - TEST", 0), i, 1)
end

