selMediaTrack = reaper.GetSelectedTrack(0, 0)

if selMediaTrack then
  selTrack = reaper.GetMediaTrackInfo_Value(selMediaTrack, "IP_TRACKNUMBER") * 0.001
  
  reaper.TrackFX_SetParam(reaper.GetMasterTrack(0), 0, 0, selTrack)
end
