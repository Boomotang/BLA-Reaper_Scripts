function scroll_to_track(track_id, relative_x_pos)
  relative_x_pos = relative_x_pos or 0 -- 0=left, 0.5=center, 1=right etc.

  if not reaper.IsTrackVisible(track_id, true) then return end

  local mcp_x = reaper.GetMediaTrackInfo_Value(track_id, "I_MCPX")
  local mcp_w = reaper.GetMediaTrackInfo_Value(track_id, "I_MCPW")

  local mixer_id = reaper.BR_Win32_GetMixerHwnd()
  local mcp_id = reaper.JS_Window_FindChild(mixer_id, "", true)

  local ok, pos, page, min, max, trackPos = reaper.JS_Window_GetScrollInfo(mcp_id, "h")

  if ok then
    ok = reaper.JS_Window_SetScrollPos(mcp_id, "h", math.max(0, mcp_x + pos - math.floor(relative_x_pos*(page - mcp_w) + 0.5)))
  end
end

local tr = reaper.GetSelectedTrack(0, 0)
if tr then
  scroll_to_track(tr, 0.5) -- 0=left, 0.5=center, 1=right etc.
end