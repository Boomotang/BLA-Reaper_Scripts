-- =============================================
-- CONFIG
-- =============================================

local MAX_DISTANCE = 2
local FX_NAME_MATCH = "TUNE"

-- =============================================
-- ENUM SIZES
-- =============================================

local ROOT_COUNT = 16
local SCALE_COUNT = 43  -- 44 items (0–43)

-- =============================================
-- ROOT MAP
-- =============================================

local ROOT_MAP = {
  ["C"]  = 0,
  ["C#"] = 1,
  ["Db"] = 2,
  ["D"]  = 3,
  ["D#"] = 4,
  ["Eb"] = 5,
  ["E"]  = 6,
  ["F"]  = 7,
  ["F#"] = 8,
  ["Gb"] = 9,
  ["G"]  = 10,
  ["G#"] = 11,
  ["Ab"] = 12,
  ["A"]  = 13,
  ["A#"] = 14,
  ["Bb"] = 15,
  ["B"]  = 16
}

-- =============================================
-- SCALE TYPES
-- =============================================

local SCALE_TYPES = {
  Major      = 2,
  Minor      = 3,
  Mixolydian = 10
}

-- =============================================
-- HELPERS
-- =============================================

local function clamp01(x)
  if x < 0 then return 0 end
  if x > 1 then return 1 end
  return x
end

local function norm(index, max)
  if max == 0 then return 0 end
  local v = index / max
  if v >= 0.999999 then v = 0.999999 end
  return v
end

-- =============================================
-- MARKERS
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
        closest = { name = name or "" }
      end
    end
  end

  return closest
end

-- =============================================
-- PARSE MARKER
-- =============================================

function parse_marker(name)
  if not name or name == "" then return nil end

  name = name:gsub("^%s+", ""):gsub("%s+$", "")

  local root, mode = name:match("^([A-G][b#]?)[%s%-_]*(%a*)")

  if not root then return nil end

  if mode == "" then
    mode = "Major"
  else
    mode = mode:sub(1,1):upper() .. mode:sub(2):lower()
  end

  return { root = root, mode = mode }
end

-- =============================================
-- TRACK CHECK
-- =============================================

function is_v_track(track)
  local _, name = reaper.GetTrackName(track)
  return name and name:match("^V%d+$") ~= nil
end

-- =============================================
-- FX PROCESS
-- =============================================

function process_fx(track, fx, root_norm, scale_norm)

  local _, fx_name = reaper.TrackFX_GetFXName(track, fx)
  if not fx_name:lower():find(FX_NAME_MATCH:lower(), 1, true) then return end

  local root_param, scale_param = nil, nil
  local param_count = reaper.TrackFX_GetNumParams(track, fx)

  for p = 0, param_count - 1 do
    local _, name = reaper.TrackFX_GetParamName(track, fx, p)
    local lower = name:lower()

    if lower == "scale root" then
      root_param = p
    elseif lower == "scale type" then
      scale_param = p
    end
  end

  if root_param then
    reaper.TrackFX_SetParam(track, fx, root_param, clamp01(root_norm))
  end

  if scale_param then
    reaper.TrackFX_SetParam(track, fx, scale_param, clamp01(scale_norm))
  end
end

-- =============================================
-- MAIN
-- =============================================

reaper.Undo_BeginBlock()

local cursor = reaper.GetCursorPosition()
local marker = get_nearest_marker(cursor)
if not marker then return end

local parsed = parse_marker(marker.name)
if not parsed then return end

local root_index = ROOT_MAP[parsed.root]
local scale_index = SCALE_TYPES[parsed.mode] or SCALE_TYPES.Major

local root_norm = norm(root_index, ROOT_COUNT)
local scale_norm = norm(scale_index, SCALE_COUNT)

for i = 0, reaper.CountTracks(0) - 1 do
  local track = reaper.GetTrack(0, i)

  if is_v_track(track) then
    for fx = 0, reaper.TrackFX_GetCount(track) - 1 do
      process_fx(track, fx, root_norm, scale_norm)
    end
  end
end

reaper.Undo_EndBlock("TUNE RT from marker", -1)