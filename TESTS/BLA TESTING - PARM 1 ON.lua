-- PARM 1 ON

MasterTrack = reaper.GetMasterTrack(0)
RLXT = reaper.TrackFX_GetByName(MasterTrack, "RL - XT", 0)

reaper.TrackFX_SetParam(MasterTrack, RLXT, 0, 1)
reaper.TrackFX_SetParam(MasterTrack, RLXT, 1, 0)