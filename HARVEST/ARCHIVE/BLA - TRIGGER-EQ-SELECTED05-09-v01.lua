-- =============================================
-- CONFIG
-- =============================================

local FX_NAME_MATCH = "Pro-Q"

-- =============================================
-- CLOSE ALL FX WINDOWS
-- =============================================

local close_floating = reaper.NamedCommandLookup("_S&M_WNCLS3")
local close_chain    = reaper.NamedCommandLookup("_S&M_WNCLS4")

reaper.Main_OnCommand(close_floating, 0)
reaper.Main_OnCommand(close_chain, 0)

-- =============================================
-- DELAY (100ms sync)
-- =============================================

local start_time = reaper.time_precise()

local function wait_100ms()
  if reaper.time_precise() - start_time < 0.1 then
    reaper.defer(wait_100ms)
    return
  end
  main()
end

-- =============================================
-- AHK BRIDGE
-- =============================================

local TARGET_TITLE      = "ReaperAHKBridgeWindow"
local WM_REAPER_COMMAND = 0x8000

local function send_to_ahk(commandID)
  local hwnd = reaper.JS_Window_Find(TARGET_TITLE, true)
  if not hwnd then return end

  reaper.JS_WindowMessage_Post(
    hwnd,
    string.format("0x%X", WM_REAPER_COMMAND),
    commandID,
    0,
    0,
    0
  )
end

-- =============================================
-- HELPERS
-- =============================================

local function find_xt_master(track)
  local fx_count = reaper.TrackFX_GetCount(track)

  for i = 0, fx_count - 1 do
    local _, name = reaper.TrackFX_GetFXName(track, i)

    if name:lower() == "xt-master" then
      return i
    end
  end

  return -1
end

-- =============================================
-- MAIN
-- =============================================

function main()

  local selected_count = reaper.CountSelectedTracks(0)
  if selected_count == 0 then return end

  -- Assume XT-MASTER is on track 0 (same as before)
  local xt_track = reaper.GetTrack(0, 0)
  if not xt_track then return end

  local xt_fx = find_xt_master(xt_track)
  if xt_fx < 0 then return end

  -- =============================================
  -- OPEN TOOLBAR 30
  -- =============================================

  local cmd_toolbar_30 = 42726

  if reaper.GetToggleCommandStateEx(0, cmd_toolbar_30) == 0 then
    reaper.Main_OnCommand(cmd_toolbar_30, 0)
  end

  -- =============================================
  -- FIND + OPEN ALL PRO-Q ON SELECTED TRACKS
  -- =============================================

  local opened_count = 0

  for t = 0, selected_count - 1 do
    local track = reaper.GetSelectedTrack(0, t)
    local fx_count = reaper.TrackFX_GetCount(track)

    for i = 0, fx_count - 1 do
      local _, fx_name = reaper.TrackFX_GetFXName(track, i)

      if fx_name:lower():find(FX_NAME_MATCH:lower(), 1, true) then
        reaper.TrackFX_Show(track, i, 3)
        opened_count = opened_count + 1
      end
    end
  end

  -- =============================================
  -- MULTI-INSTANCE FLAG (XT-MASTER PARAM 26)
  -- =============================================

  if opened_count > 1 then
    reaper.TrackFX_SetParam(xt_track, xt_fx, 25, 1.0)
  end

  -- =============================================
  -- AHK BRIDGE (ONLY IF ONE INSTANCE)
  -- =============================================

  if opened_count == 1 then
    local start = reaper.time_precise()

    local function wait_and_send()
      if reaper.time_precise() - start < 0.05 then
        reaper.defer(wait_and_send)
        return
      end

      send_to_ahk(1)
    end

    reaper.defer(wait_and_send)
  end
end

-- START

wait_100ms()