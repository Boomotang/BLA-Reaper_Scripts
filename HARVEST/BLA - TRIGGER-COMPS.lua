-- =============================================
-- CONFIG
-- =============================================

local FX_MATCHES = {
  "cla 76",
  "1176",
  "cla 2a",
  "la-2a",
  "cla 3a",
  "la-3a",
  "distressor",
  "arousor",
  "pro-c",
  "dbx-160",
  "dyna-mite",
  "api-2500",
  "api 2500"
}

local TRACK_MAP = {
  [0] = "V1",
  [1] = "V2",
  [2] = "V3",
  [3] = "KEYS",
  [4] = "AC 1",
  [5] = "AC 2",
  [6] = "AXE 1",
  [7] = "AXE 2",
  [8] = "BASS",
  [9] = "KICK",
  [10] = "SNARE",
  [11] = "RT",
  [12] = "FT",
  [13] = "OH",
  [14] = "HH"
}

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
  for param = 0, 14 do
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
  if active_param == nil then return end

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

  if reaper.GetToggleCommandStateEx(0, cmd_toolbar_30) == 0 then
    reaper.Main_OnCommand(cmd_toolbar_30, 0)
  end

  if reaper.GetToggleCommandStateEx(0, cmd_toolbar_2) == 1 then
    reaper.Main_OnCommand(cmd_toolbar_2, 0)
  end

  -- =============================================
  -- OPEN ALL COMPRESSORS
  -- =============================================

  local fx_count = reaper.TrackFX_GetCount(track)

  local opened_count = 0
  local cla76_count = 0
  local cla2a_count = 0
  local proc_count  = 0

  for _, match in ipairs(FX_MATCHES) do
    for i = 0, fx_count - 1 do
      local _, fx_name = reaper.TrackFX_GetFXName(track, i)

      if fx_name:lower():find(match:lower(), 1, true) then
        reaper.TrackFX_Show(track, i, 3)

        opened_count = opened_count + 1

        local lower_name = fx_name:lower()

        -- CLA-76 / 1176
        if lower_name:find("cla 76", 1, true)
        or lower_name:find("1176", 1, true) then
          cla76_count = cla76_count + 1
        end

        -- CLA-2A / LA-2A
        if lower_name:find("cla 2a", 1, true)
        or lower_name:find("la-2a", 1, true) then
          cla2a_count = cla2a_count + 1
        end

        -- Pro-C
        if lower_name:find("pro%-c", 1) then
          proc_count = proc_count + 1
        end
      end
    end
  end

  -- =============================================
  -- FOCUSED FLAG (XT-MASTER PARAM 29)
  -- =============================================

  local only_76_and_2a =
    opened_count == 2 and
    cla76_count == 1 and
    cla2a_count == 1

  local only_proc =
    opened_count == 1 and
    proc_count == 1

  if only_76_and_2a or only_proc then
    reaper.TrackFX_SetParam(xt_track, xt_fx, 28, 0.0)
  else
    reaper.TrackFX_SetParam(xt_track, xt_fx, 28, 1.0)
  end

  -- =============================================
  -- AHK BRIDGE - Send Command 2 (COMPS)
  -- =============================================

  local start = reaper.time_precise()

  local function wait_and_send()
    if reaper.time_precise() - start < 0.05 then
      reaper.defer(wait_and_send)
      return
    end

    send_to_ahk(2)        -- 2 = COMPS_ClickMacro in AHK
  end

  reaper.defer(wait_and_send)

  -- =============================================
  -- LED REFRESH (100ms delay + OFF/ON gap)
  -- =============================================

  local function refresh_led()
    if reaper.time_precise() - start < 0.1 then
      reaper.defer(refresh_led)
      return
    end

    -- OFF
    reaper.TrackFX_SetParam(xt_track, xt_fx, active_param, 0)

    local gap_start = reaper.time_precise()

    local function turn_on_again()
      if reaper.time_precise() - gap_start < 0.03 then
        reaper.defer(turn_on_again)
        return
      end

      -- ON
      reaper.TrackFX_SetParam(xt_track, xt_fx, active_param, 1)
    end

    reaper.defer(turn_on_again)
  end

  reaper.defer(refresh_led)
end

-- START
wait_100ms()