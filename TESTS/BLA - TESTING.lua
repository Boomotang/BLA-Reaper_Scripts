targetDB = -8
targetSet = 10^(targetDB/20)

item = reaper.GetSelectedMediaItem(0, 0)
take = reaper.GetActiveTake(item)
reaper.SetMediaItemTakeInfo_Value(take, "D_VOL", targetSet)

reaper.UpdateArrange()