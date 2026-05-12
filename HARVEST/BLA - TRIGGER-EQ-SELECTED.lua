-- =============================================
-- CONFIG
-- =============================================

local FX_MATCHES = {
  "pro-q",
  "veq3",
  "veq4",
  "eqp",
  "meq",
  "ssleq",
  "api-550a",
  "api-550b"
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

  -- =============================================
  -- OPEN TOOLBAR 30 & CLOSE TOOLBAR 2
  -- =============================================

  local cmd_toolbar_30 = 42726
  local cmd_toolbar_2  = 41680

  -- Only run if Toolbar 30 is currently CLOSED
  if reaper.GetToggleCommandStateEx(0, cmd_toolbar_30) == 0 then
    reaper.Main_OnCommand(cmd_toolbar_30, 0)
  end

  -- Only run if Toolbar 2 is currently OPEN
  if reaper.GetToggleCommandStateEx(0, cmd_toolbar_2) == 1 then
    reaper.Main_OnCommand(cmd_toolbar_2, 0)
  end

  -- =============================================
  -- FIND + OPEN ALL MATCHING EQs
  -- =============================================

  local total_opened = 0

  for t = 0, selected_count - 1 do

    local track = reaper.GetSelectedTrack(0, t)

    if track then

      local fx_count = reaper.TrackFX_GetCount(track)

      -- ================== OPEN IN CHAIN ORDER ==================
      for i = 0, fx_count - 1 do

        local _, fx_name = reaper.TrackFX_GetFXName(track, i)
        local name_lower = fx_name:lower()

        for _, match in ipairs(FX_MATCHES) do

          if name_lower:find(match, 1, true) then
            reaper.TrackFX_Show(track, i, 3)
            total_opened = total_opened + 1
            break
          end

        end
      end
    end
  end

  -- =============================================
  -- FOCUSED (XT-MASTER PARAM 26)
  -- =============================================

  local xt_track = reaper.GetTrack(0, 0)

  if xt_track then

    local xt_fx = find_xt_master(xt_track)

    if xt_fx >= 0 then

      local has_proq = false

      for t = 0, selected_count - 1 do

        local track = reaper.GetSelectedTrack(0, t)

        if track then

          local fx_count = reaper.TrackFX_GetCount(track)

          for i = 0, fx_count - 1 do

            local _, fx_name = reaper.TrackFX_GetFXName(track, i)

            if fx_name:lower():find("pro%-q", 1, false) then
              has_proq = true
              break
            end
          end
        end

        if has_proq then break end
      end

      if total_opened > 1 or not has_proq then
        reaper.TrackFX_SetParam(xt_track, xt_fx, 25, 1.0)
      else
        reaper.TrackFX_SetParam(xt_track, xt_fx, 25, 0.0)
      end

    end
  end

  -- =============================================
  -- AHK BRIDGE (ALWAYS SEND)
  -- =============================================

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

-- START

wait_100ms()