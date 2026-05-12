-- Toggle Mute on Track Under Mouse (Fixed)
-- Works reliably in FX extended mixer context

local track = reaper.BR_GetMouseCursorContext_Track()

-- Fallback if SWS doesn't return a track
if not track then
    local x, y = reaper.GetMousePosition()
    track = reaper.GetTrackFromPoint(x, y)
end

if track then
    local isMuted = reaper.GetMediaTrackInfo_Value(track, "B_MUTE")
    reaper.SetMediaTrackInfo_Value(track, "B_MUTE", 1 - isMuted)
    
    -- Refresh UI
    reaper.TrackList_AdjustWindows(false)
    
    -- Correct undo call (0 = current project)
    reaper.Undo_OnStateChange2(0, "Toggle mute track under mouse")
else
    reaper.ShowConsoleMsg("No track found under mouse!\n")
end