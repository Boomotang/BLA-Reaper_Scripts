-- =============================================
-- CONFIG
-- =============================================

local FX_NAME_MATCH = "Pro-MB"

local TRACK_MAP = {
  [17] = "V1",
  [18] = "V2",
  [19] = "V3",
}

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

local function get_track_by_name(name)
  local count = reaper.CountTracks(0)

  for i = 0, count - 1 do
    local track = reaper.GetTrack(0, i)
    local _, track_name = reaper.GetTrackName(track)

    if track_name:lower():gsub("%s+", "") == name:lower():gsub("%s+", "") then
      return track
    end
  end
end

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

local function get_active_button(track, fx_index)
  for param = 17, 19 do
    local val = reaper.TrackFX_GetParam(track, fx_index, param)
    if val > 0.5 then
      return param
    end
  end
end

-- =============================================
-- MAIN
-- =============================================

function main()

  local xt_track = reaper.GetTrack(0, 0)
  if not xt_track then return end

  local xt_fx = find_xt_master(xt_track)
  if xt_fx < 0 then return end

  local active_param = get_active_button(xt_track, xt_fx)
  if not active_param then return end

  local track_name = TRACK_MAP[active_param]
  if not track_name then return end

  local track = get_track_by_name(track_name)
  if not track then return end

  reaper.SetOnlyTrackSelected(track)

  -- =============================================
  -- OPEN TOOLBAR 30 & CLOSE TOOLBAR 2
  -- =============================================

  local cmd_toolbar_30 = 42726
  local cmd_toolbar_2 = 41680

  -- Only run if Toolbar 30 is currently CLOSED
  if reaper.GetToggleCommandStateEx(0, cmd_toolbar_30) == 0 then
    reaper.Main_OnCommand(cmd_toolbar_30, 0)
  end

  -- Only run if Toolbar 2 is currently OPEN
if reaper.GetToggleCommandStateEx(0, cmd_toolbar_2) == 1 then
  reaper.Main_OnCommand(cmd_toolbar_2, 0)
end

  -- =============================================
  -- FIND + OPEN PRO-MB
  -- =============================================

  local fx_count = reaper.TrackFX_GetCount(track)

  for i = 0, fx_count - 1 do
    local _, fx_name = reaper.TrackFX_GetFXName(track, i)

    if fx_name:lower():find(FX_NAME_MATCH:lower(), 1, true) then

      reaper.TrackFX_Show(track, i, 3)

      -- =============================================
      -- AHK BRIDGE (300ms delay)
      -- =============================================

      local start = reaper.time_precise()

      local function wait_and_send()
        if reaper.time_precise() - start < 0.05 then
          reaper.defer(wait_and_send)
          return
        end

        send_to_ahk(3)
      end

      reaper.defer(wait_and_send)

      return
    end
  end
end

-- START

wait_100ms()