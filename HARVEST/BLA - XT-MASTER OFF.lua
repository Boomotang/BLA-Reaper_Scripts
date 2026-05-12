-- Turn all XT-MASTER JSFX parameters OFF (0)
-- Track 1 only, fast lookup

local track = reaper.GetTrack(0, 0) -- Track #1 (0-based index)

if not track then return end

-- Find FX by name on Track 1
local fx_index = reaper.TrackFX_GetByName(track, "XT-MASTER", false)

if fx_index < 0 then return end

-- Set all 28 sliders to OFF (0)
for i = 0, 27 do
    reaper.TrackFX_SetParam(track, fx_index, i, 0)
end

reaper.UpdateArrange()