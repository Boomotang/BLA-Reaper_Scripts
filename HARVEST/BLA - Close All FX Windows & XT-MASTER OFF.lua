reaper.Undo_BeginBlock()

local close_floating = reaper.NamedCommandLookup("_S&M_WNCLS3")
local close_chain    = reaper.NamedCommandLookup("_S&M_WNCLS4")

if close_floating ~= 0 then
    reaper.Main_OnCommand(close_floating, 0)
end

if close_chain ~= 0 then
    reaper.Main_OnCommand(close_chain, 0)
end

local track = reaper.GetTrack(0, 0) -- Track #1 (0-based index)

if not track then return end

-- Find FX by name on Track 1
local fx_index = reaper.TrackFX_GetByName(track, "XT-MASTER", false)

if fx_index < 0 then return end

-- Set all 28 sliders to OFF (0)
for i = 0, 27 do
    reaper.TrackFX_SetParam(track, fx_index, i, 0)
end

-- =============================================
-- CLOSE TOOLBAR 30 & OPEN TOOLBAR 2 (STATE-SAFE)
-- =============================================
local cmd_toolbar_30 = 42726
local cmd_toolbar_2 = 41680

-- Only run if Toolbar 30 is currently OPEN
if reaper.GetToggleCommandStateEx(0, cmd_toolbar_30) == 1 then
  reaper.Main_OnCommand(cmd_toolbar_30, 0)
end

-- Only run if Toolbar 2 is currently CLOSED
if reaper.GetToggleCommandStateEx(0, cmd_toolbar_2) == 0 then
  reaper.Main_OnCommand(cmd_toolbar_2, 0)

  -- Force UI refresh
  reaper.TrackList_AdjustWindows(false)
end

reaper.UpdateArrange()

reaper.Undo_EndBlock("Close all FX windows", -1)