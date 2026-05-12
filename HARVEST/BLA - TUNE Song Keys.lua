-- =============================================
-- CONFIG
-- =============================================

local KEYS = {
  "A","B","C","D","E","F","G", "",
  "Ab","Bb","Cb","C#","Db","Eb","F#","Gb",
}

local BUTTON_COLS = 4
local BUTTON_W = 150
local BUTTON_H = 100
local PADDING = 10

local MAX_DISTANCE = 2.0
local DEBOUNCE_TIME = 0.15
local FX_NAME_MATCH = "TUNE"

local TOP_BAR_H = 50

-- =============================================
-- SINGLE INSTANCE CHECK / TOGGLE
-- =============================================

local _, _, sectionID, cmdID = reaper.get_action_context()
local SCRIPT_ID = "KeySignatureGUI_" .. tostring(sectionID) .. "_" .. tostring(cmdID)

if reaper.HasExtState(SCRIPT_ID, "running") then
  reaper.DeleteExtState(SCRIPT_ID, "running", false)
  return
end

reaper.SetExtState(SCRIPT_ID, "running", "1", false)

-- =============================================
-- STATE
-- =============================================

local active_key = nil
local active_mode = nil

local press_time = 0
local running = true

local flash_prev_until = 0
local flash_next_until = 0
local flash_exit_until = 0

local mouse_was_down = false

-- =============================================
-- ROOT MAP & SCALE TYPES
-- =============================================

local ROOT_MAP = {
  ["C"]  = 0,  ["C#"] = 1,  ["Db"] = 2,  ["D"]  = 3,
  ["D#"] = 4,  ["Eb"] = 5,  ["E"]  = 6,  ["F"]  = 7,
  ["F#"] = 8,  ["Gb"] = 9,  ["G"]  = 10, ["G#"] = 11,
  ["Ab"] = 12, ["A"]  = 13, ["A#"] = 14, ["Bb"] = 15,
  ["B"]  = 16
}

local SCALE_TYPES = {
  Major      = 2,
  Minor      = 3,
  Mixolydian = 10
}

-- =============================================
-- TOOLBAR
-- =============================================

local cmd_toolbar_30 = 42726
local toolbar_initialized = false

local function ensure_toolbar_30_open()
  if reaper.GetToggleCommandStateEx(0, cmd_toolbar_30) == 0 then
    reaper.Main_OnCommand(cmd_toolbar_30, 0)
  end
end

local function close_toolbar_30()
  if reaper.GetToggleCommandStateEx(0, cmd_toolbar_30) == 1 then
    reaper.Main_OnCommand(cmd_toolbar_30, 0)
  end
end

-- =============================================
-- CLEANUP
-- =============================================

local function cleanup()
  reaper.DeleteExtState(SCRIPT_ID, "running", false)
  close_toolbar_30()
  gfx.quit()
end

-- =============================================
-- MARKERS + REGIONS
-- =============================================

function get_nearest_marker(cursor_pos)
  local _, num_markers, num_regions = reaper.CountProjectMarkers(0)
  local total = num_markers + num_regions

  local closest = nil
  local closest_dist = MAX_DISTANCE

  for i = 0, total - 1 do
    local retval, isrgn, pos, _, name, idx = reaper.EnumProjectMarkers(i)
    if retval and not isrgn then
      local dist = math.abs(pos - cursor_pos)
      if dist <= closest_dist then
        closest_dist = dist
        closest = {
          markrgnindexnumber = idx,
          pos = pos,
          name = name or ""
        }
      end
    end
  end
  return closest
end

function get_displayed_region()
  local cursor = reaper.GetCursorPosition() + 1.0
  local _, num_markers, num_regions = reaper.CountProjectMarkers(0)
  local total = num_markers + num_regions

  local current = nil
  local next_region = nil
  local next_pos = math.huge

  for i = 0, total - 1 do
    local retval, isrgn, pos, rgn_end, name, idx = reaper.EnumProjectMarkers(i)
    if retval and isrgn then
      if cursor >= pos and cursor <= rgn_end then
        current = {
          markrgnindexnumber = idx,
          pos = pos,
          rgn_end = rgn_end,
          name = name or ""
        }
      end
      if pos > cursor and pos < next_pos then
        next_pos = pos
        next_region = {
          markrgnindexnumber = idx,
          pos = pos,
          rgn_end = rgn_end,
          name = name or ""
        }
      end
    end
  end

  return current or next_region
end

function get_region_text_at_cursor()
  local region = get_displayed_region()
  if not region then return "No region" end

  -- Changed: Show blank when region name is empty
  if region.name == "" or region.name == nil then
    return tostring(region.markrgnindexnumber) .. ":"
  else
    return tostring(region.markrgnindexnumber) .. ": " .. region.name
  end
end

-- =============================================
-- TUNE PLUGIN UPDATE
-- =============================================

local function clamp01(x)
  return math.max(0, math.min(1, x))
end

local function norm(index, max)
  if max == 0 then return 0 end
  local v = index / max
  return v >= 0.999999 and 0.999999 or v
end

local function parse_marker(name)
  if not name or name == "" then return nil end
  name = name:gsub("^%s+", ""):gsub("%s+$", "")
  local root, mode = name:match("^([A-G][b#]?)[%s%-_]*(%a*)")
  if not root then return nil end
  if mode == "" then mode = "Major" else
    mode = mode:sub(1,1):upper() .. mode:sub(2):lower()
  end
  return { root = root, mode = mode }
end

local function is_v_track(track)
  local _, name = reaper.GetTrackName(track)
  return name and name:match("^V%d+$") ~= nil
end

local function process_fx(track, fx, root_norm, scale_norm)
  local _, fx_name = reaper.TrackFX_GetFXName(track, fx)
  if not fx_name:lower():find(FX_NAME_MATCH:lower(), 1, true) then return end

  local root_param, scale_param = nil, nil
  local param_count = reaper.TrackFX_GetNumParams(track, fx)

  for p = 0, param_count - 1 do
    local _, name = reaper.TrackFX_GetParamName(track, fx, p)
    local lower = name:lower()
    if lower == "scale root" then root_param = p
    elseif lower == "scale type" then scale_param = p end
  end

  if root_param then reaper.TrackFX_SetParam(track, fx, root_param, clamp01(root_norm)) end
  if scale_param then reaper.TrackFX_SetParam(track, fx, scale_param, clamp01(scale_norm)) end
end

local function update_tune_plugins()
  local marker = get_nearest_marker(reaper.GetCursorPosition())
  if not marker then return end
  local parsed = parse_marker(marker.name)
  if not parsed then return end

  local root_index = ROOT_MAP[parsed.root]
  if not root_index then return end

  local scale_index = SCALE_TYPES[parsed.mode] or SCALE_TYPES.Major
  local root_norm = norm(root_index, 16)
  local scale_norm = norm(scale_index, 43)

  for i = 0, reaper.CountTracks(0) - 1 do
    local track = reaper.GetTrack(0, i)
    if is_v_track(track) then
      for fx = 0, reaper.TrackFX_GetCount(track) - 1 do
        process_fx(track, fx, root_norm, scale_norm)
      end
    end
  end
end

-- =============================================
-- SYNC & APPLY
-- =============================================

local function extract_key(name)
  local first = name:match("^[^%s]+")
  if not first then return nil end
  for _, key in ipairs(KEYS) do
    if first == key then return key end
  end
  return nil
end

function sync_state_from_marker()
  local marker = get_nearest_marker(reaper.GetCursorPosition())
  if not marker then return end
  local name = marker.name or ""
  active_key = extract_key(name)

  if name:find("Minor",1,true) then
    active_mode = "Minor"
  elseif name:find("Mixolydian",1,true) then
    active_mode = "Mixolydian"
  else
    active_mode = nil
  end
end

-- =============================================
-- EDIT REGION
-- =============================================

local function edit_current_region_name()
  local region = get_displayed_region()
  if not region then 
    reaper.ShowMessageBox("No region found.", "Key Signature GUI", 0)
    return 
  end

  -- "Song Name:" + optimized width = minimal gap
  local ok, new_name = reaper.GetUserInputs("Edit Region Name", 1, "Song Name:,extrawidth=150", region.name or "")

  if ok then
    local final_name = new_name and new_name:match("^%s*(.-)%s*$") or ""

    reaper.DeleteProjectMarker(0, region.markrgnindexnumber, true)
    reaper.AddProjectMarker(0, true, region.pos, region.rgn_end, final_name, -1)

    reaper.UpdateArrange()
    reaper.UpdateTimeline()
    reaper.TrackList_AdjustWindows(false)
    
    update_tune_plugins()
    sync_state_from_marker()
  end
end

function apply_key(key)
  local marker = get_nearest_marker(reaper.GetCursorPosition())
  if not marker then return end

  local name = key
  if active_mode then name = name .. " " .. active_mode end

  reaper.SetProjectMarker(marker.markrgnindexnumber, false, marker.pos, 0, name)
  reaper.UpdateArrange()
  update_tune_plugins()
end

function set_mode(mode)
  if active_mode == mode then
    active_mode = nil
  else
    active_mode = mode
  end
  if active_key then
    apply_key(active_key)
  else
    update_tune_plugins()
  end
end

function jump(dir)
  local cursor = reaper.GetCursorPosition()
  local _, num_markers, num_regions = reaper.CountProjectMarkers(0)
  local total = num_markers + num_regions
  local best = nil

  if dir == "next" then
    local min_pos = math.huge
    for i=0,total-1 do
      local r,isrgn,pos,_,_,idx = reaper.EnumProjectMarkers(i)
      if r and not isrgn and pos > cursor and pos < min_pos then
        min_pos = pos
        best = {idx=idx,pos=pos}
      end
    end
  else
    local max_pos = -math.huge
    for i=0,total-1 do
      local r,isrgn,pos,_,_,idx = reaper.EnumProjectMarkers(i)
      if r and not isrgn and pos < cursor and pos > max_pos then
        max_pos = pos
        best = {idx=idx,pos=pos}
      end
    end
  end

  if best then
    reaper.SetEditCurPos(best.pos, true, false)
    sync_state_from_marker()
    update_tune_plugins()
  end
end

-- =============================================
-- GUI
-- =============================================

local key_rows = math.ceil(#KEYS / BUTTON_COLS)
local grid_h = key_rows * (BUTTON_H + PADDING)
local mode_h = BUTTON_H + PADDING
local nav_h  = BUTTON_H

local total_h = TOP_BAR_H + PADDING + grid_h + PADDING + mode_h + PADDING + nav_h
local win_w = BUTTON_COLS * (BUTTON_W + PADDING) + PADDING

gfx.init("Key Signature + TUNE", win_w, total_h, 0, 150, 200)
gfx.dock(0)

function draw_button(x,y,w,h,label,active,flash,red,cyan,black)
  if black then
    gfx.set(flash and 0.3 or 0, flash and 0.3 or 0, flash and 0.3 or 0)
  elseif red then
    gfx.set(flash and 1 or 0.7, flash and 0.6 or 0.1, flash and 0.6 or 0.1)
  elseif cyan then
    gfx.set(flash and 0.6 or 0, flash and 1 or 0.7, flash and 1 or 0.7)
  else
    gfx.set(flash and 0.8 or (active and 0.5 or 0.2),
            flash and 0.8 or (active and 0.5 or 0.2),
            flash and 0.8 or (active and 0.5 or 0.2))
  end
  gfx.rect(x,y,w,h,1)

  if black then
    gfx.set(1,1,1)
  elseif cyan then
    gfx.set(1,1,1)
  elseif red then
    gfx.set(1,1,1)
  else
    gfx.set(1,1,1)
  end

  gfx.setfont(1,"Arial Bold",28)
  local tw,th = gfx.measurestr(label)
  gfx.x = x + (w-tw)/2
  gfx.y = y + (h-th)/2
  gfx.drawstr(label)
end

local function hit(x,y,w,h)
  return gfx.mouse_x >= x and gfx.mouse_x <= x+w and gfx.mouse_y >= y and gfx.mouse_y <= y+h
end

-- =============================================
-- MAIN LOOP
-- =============================================

function main()
  if not reaper.HasExtState(SCRIPT_ID, "running") then
    cleanup()
    return
  end

  if not toolbar_initialized then
    ensure_toolbar_30_open()
    toolbar_initialized = true
  end

  gfx.set(0.1,0.1,0.1)
  gfx.rect(0,0,gfx.w,gfx.h,1)

  local mouse_down = (gfx.mouse_cap & 1) == 1
  local click = mouse_down and not mouse_was_down
  local now = reaper.time_precise()

  local clicked_key, clicked_mode, clicked_nav, clicked_exit

  if click and gfx.mouse_y < TOP_BAR_H then
    edit_current_region_name()
    press_time = now
  end

  for i,key in ipairs(KEYS) do
    if key == "" then goto continue end
    local col = (i-1) % BUTTON_COLS
    local row = math.floor((i-1)/BUTTON_COLS)
    local x = PADDING + col*(BUTTON_W + PADDING)
    local y = TOP_BAR_H + PADDING + row*(BUTTON_H + PADDING)

    if hit(x,y,BUTTON_W,BUTTON_H) and click and now-press_time > DEBOUNCE_TIME then
      clicked_key = key
      press_time = now
    end

    draw_button(x,y,BUTTON_W,BUTTON_H,key,active_key==key,false,false,false,false)
    ::continue::
  end

  local bottom1_y = TOP_BAR_H + PADDING + key_rows*(BUTTON_H+PADDING)
  local full_w = BUTTON_COLS*(BUTTON_W+PADDING)+PADDING
  local btn_w = (full_w - 3*PADDING)/2

  local minor_x = PADDING
  local mix_x = minor_x + btn_w + PADDING

  if hit(minor_x,bottom1_y,btn_w,BUTTON_H) and click then clicked_mode = "Minor"; press_time = now end
  if hit(mix_x,bottom1_y,btn_w,BUTTON_H) and click then clicked_mode = "Mixolydian"; press_time = now end

  draw_button(minor_x,bottom1_y,btn_w,BUTTON_H,"Minor",active_mode=="Minor",false,false,false,false)
  draw_button(mix_x,bottom1_y,btn_w,BUTTON_H,"Mixolydian",active_mode=="Mixolydian",false,false,false,false)

  local bottom2_y = bottom1_y + BUTTON_H + PADDING
  local nav_w = (full_w - 4*PADDING)/3

  local prev_x = PADDING
  local next_x = prev_x + nav_w + PADDING
  local exit_x = next_x + nav_w + PADDING

  if hit(prev_x,bottom2_y,nav_w,BUTTON_H) and click then
    clicked_nav = "prev"
    flash_prev_until = now + 0.12
    press_time = now
  end
  if hit(next_x,bottom2_y,nav_w,BUTTON_H) and click then
    clicked_nav = "next"
    flash_next_until = now + 0.12
    press_time = now
  end
  if hit(exit_x,bottom2_y,nav_w,BUTTON_H) and click then
    clicked_exit = true
    flash_exit_until = now + 0.12
    press_time = now
  end

  draw_button(prev_x,bottom2_y,nav_w,BUTTON_H,"Previous Song",false,now<flash_prev_until,false,true,false)
  draw_button(next_x,bottom2_y,nav_w,BUTTON_H,"Next Song",false,now<flash_next_until,false,true,false)
  draw_button(exit_x,bottom2_y,nav_w,BUTTON_H,"EXIT",false,now<flash_exit_until,false,false,true)

  if clicked_key then active_key = clicked_key; apply_key(clicked_key) end
  if clicked_mode then set_mode(clicked_mode) end
  if clicked_nav == "next" then jump("next") end
  if clicked_nav == "prev" then jump("prev") end
  if clicked_exit then running = false end

  local text = get_region_text_at_cursor()
  gfx.set(0.1,0.1,0.1)
  gfx.rect(0,0,gfx.w,TOP_BAR_H,1)
  gfx.set(1,1,1)
  gfx.setfont(1,"Arial",35)
  local tw,th = gfx.measurestr(text)
  gfx.x = (gfx.w - tw)/2
  gfx.y = (TOP_BAR_H - th)
  gfx.drawstr(text)

  mouse_was_down = mouse_down

  if running and gfx.getchar() >= 0 then
    reaper.defer(main)
  else
    cleanup()
  end
end

-- START
sync_state_from_marker()
update_tune_plugins()
main()