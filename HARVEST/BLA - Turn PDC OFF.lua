for t=0,reaper.CountTracks(0)-1 do
   local track = reaper.GetTrack(0, t);
   for fx=0,reaper.TrackFX_GetCount(track)-1 do
     reaper.TrackFX_SetNamedConfigParm(track, fx, 'chain_pdc_mode', 2)
   end
end