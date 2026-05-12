-- Apply Track Template (FULL + Hardware I/O)

local track = reaper.GetSelectedTrack(0, 0)
if not track then
    reaper.ShowMessageBox("No track selected", "Error", 0)
    return
end

reaper.Undo_BeginBlock()

-- Basic track data
local track_idx = reaper.GetMediaTrackInfo_Value(track, "IP_TRACKNUMBER") - 1
local _, track_name = reaper.GetTrackName(track)
local track_color = reaper.GetTrackColor(track)
local folder_depth = reaper.GetMediaTrackInfo_Value(track, "I_FOLDERDEPTH")
local nchan = reaper.GetMediaTrackInfo_Value(track, "I_NCHAN")

-- Master send state
local main_send = reaper.GetMediaTrackInfo_Value(track, "B_MAINSEND")
local main_send_nch = reaper.GetMediaTrackInfo_Value(track, "I_MAINSEND_NCH")
local main_send_offs = reaper.GetMediaTrackInfo_Value(track, "C_MAINSEND_OFFS")

-- Hardware input
local recinput = reaper.GetMediaTrackInfo_Value(track, "I_RECINPUT")
local recmode  = reaper.GetMediaTrackInfo_Value(track, "I_RECMODE")
local recmon   = reaper.GetMediaTrackInfo_Value(track, "I_RECMON")
local recarm   = reaper.GetMediaTrackInfo_Value(track, "I_RECARM")
local midi_in  = reaper.GetMediaTrackInfo_Value(track, "I_MIDI_INPUT")

-- Hardware outputs
local hwouts = {}
for i = 0, reaper.GetTrackNumSends(track, 1)-1 do
    hwouts[#hwouts+1] = {
        vol  = reaper.GetTrackSendInfo_Value(track, 1, i, "D_VOL"),
        pan  = reaper.GetTrackSendInfo_Value(track, 1, i, "D_PAN"),
        mute = reaper.GetTrackSendInfo_Value(track, 1, i, "B_MUTE"),
        phase = reaper.GetTrackSendInfo_Value(track, 1, i, "B_PHASE"),
        srcchan = reaper.GetTrackSendInfo_Value(track, 1, i, "I_SRCCHAN"),
        dstchan = reaper.GetTrackSendInfo_Value(track, 1, i, "I_DSTCHAN")
    }
end

-- Sends (normal)
local sends = {}
for i = 0, reaper.GetTrackNumSends(track, 0)-1 do
    sends[#sends+1] = {
        dest = reaper.GetTrackSendInfo_Value(track, 0, i, "P_DESTTRACK"),
        vol  = reaper.GetTrackSendInfo_Value(track, 0, i, "D_VOL"),
        pan  = reaper.GetTrackSendInfo_Value(track, 0, i, "D_PAN"),
        mute = reaper.GetTrackSendInfo_Value(track, 0, i, "B_MUTE"),
        phase = reaper.GetTrackSendInfo_Value(track, 0, i, "B_PHASE"),
        srcchan = reaper.GetTrackSendInfo_Value(track, 0, i, "I_SRCCHAN"),
        dstchan = reaper.GetTrackSendInfo_Value(track, 0, i, "I_DSTCHAN"),
        mode    = reaper.GetTrackSendInfo_Value(track, 0, i, "I_SENDMODE"),
        midi    = reaper.GetTrackSendInfo_Value(track, 0, i, "I_MIDIFLAGS")
    }
end

-- Receives
local receives = {}
for i = 0, reaper.GetTrackNumSends(track, -1)-1 do
    receives[#receives+1] = {
        src = reaper.GetTrackSendInfo_Value(track, -1, i, "P_SRCTRACK"),
        vol = reaper.GetTrackSendInfo_Value(track, -1, i, "D_VOL"),
        pan = reaper.GetTrackSendInfo_Value(track, -1, i, "D_PAN"),
        mute = reaper.GetTrackSendInfo_Value(track, -1, i, "B_MUTE"),
        phase = reaper.GetTrackSendInfo_Value(track, -1, i, "B_PHASE"),
        srcchan = reaper.GetTrackSendInfo_Value(track, -1, i, "I_SRCCHAN"),
        dstchan = reaper.GetTrackSendInfo_Value(track, -1, i, "I_DSTCHAN"),
        midi    = reaper.GetTrackSendInfo_Value(track, -1, i, "I_MIDIFLAGS")
    }
end

-- Store FX envelopes INCLUDING automation items
local fx_env_data = {}

for fx = 0, reaper.TrackFX_GetCount(track)-1 do
    local _, fx_name = reaper.TrackFX_GetFXName(track, fx, "")

    for p = 0, reaper.TrackFX_GetNumParams(track, fx)-1 do
        local env = reaper.GetFXEnvelope(track, fx, p, false)

        if env then
            local env_entry = {
                fx_name = fx_name,
                param = p,
                base_points = {},
                items = {}
            }

            -- Base envelope points
            for i = 0, reaper.CountEnvelopePoints(env)-1 do
                local _, time, value, shape, tension =
                    reaper.GetEnvelopePoint(env, i)

                table.insert(env_entry.base_points, {
                    time=time, value=value, shape=shape, tension=tension
                })
            end

            -- Automation items
            for ai = 0, reaper.CountAutomationItems(env)-1 do
                local item = {
                    pos = reaper.GetSetAutomationItemInfo(env, ai, "D_POSITION", 0, false),
                    len = reaper.GetSetAutomationItemInfo(env, ai, "D_LENGTH", 0, false),
                    pool = reaper.GetSetAutomationItemInfo(env, ai, "D_POOL_ID", 0, false),
                    points = {}
                }

                local pt_count = reaper.CountEnvelopePointsEx(env, ai)

                for pt = 0, pt_count-1 do
                    local _, time, value, shape, tension =
                        reaper.GetEnvelopePointEx(env, ai, pt)

                    table.insert(item.points, {
                        time=time, value=value, shape=shape, tension=tension
                    })
                end

                table.insert(env_entry.items, item)
            end

            table.insert(fx_env_data, env_entry)
        end
    end
end


-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------


-- Choose template
local retval, template = reaper.GetUserFileNameForRead(
    "C:\\Users\\brian\\AppData\\Roaming\\REAPER\\TrackTemplates\\",
    "Select Track Template",
    ".RTrackTemplate"
    )
if not retval then return end

-- Insert template track
reaper.InsertTrackAtIndex(track_idx, true)
local new_track = reaper.GetTrack(0, track_idx)

-- Load template
local file = io.open(template, "r")
local chunk = file:read("*all")
file:close()

reaper.SetTrackStateChunk(new_track, chunk, true)



-- Restore basic properties
reaper.GetSetMediaTrackInfo_String(new_track, "P_NAME", track_name, true)
reaper.SetTrackColor(new_track, track_color)
reaper.SetMediaTrackInfo_Value(new_track, "I_FOLDERDEPTH", folder_depth)
reaper.SetMediaTrackInfo_Value(new_track, "I_NCHAN", nchan)

-- Restore master send state
reaper.SetMediaTrackInfo_Value(new_track, "B_MAINSEND", main_send)
reaper.SetMediaTrackInfo_Value(new_track, "I_MAINSEND_NCH", main_send_nch)
reaper.SetMediaTrackInfo_Value(new_track, "C_MAINSEND_OFFS", main_send_offs)

-- Restore hardware input
reaper.SetMediaTrackInfo_Value(new_track, "I_RECINPUT", recinput)
reaper.SetMediaTrackInfo_Value(new_track, "I_RECMODE", recmode)
reaper.SetMediaTrackInfo_Value(new_track, "I_RECMON", recmon)
reaper.SetMediaTrackInfo_Value(new_track, "I_RECARM", recarm)
reaper.SetMediaTrackInfo_Value(new_track, "I_MIDI_INPUT", midi_in)

-- Remove all hardware outputs from new track
for i = reaper.GetTrackNumSends(new_track, 1)-1, 0, -1 do
    reaper.RemoveTrackSend(new_track, 1, i)
end

-- Restore hardware outputs
for _, h in ipairs(hwouts) do
    local idx = reaper.CreateTrackSend(new_track, nil) -- nil = hardware out

    reaper.SetTrackSendInfo_Value(new_track, 1, idx, "D_VOL", h.vol)
    reaper.SetTrackSendInfo_Value(new_track, 1, idx, "D_PAN", h.pan)
    reaper.SetTrackSendInfo_Value(new_track, 1, idx, "B_MUTE", h.mute)
    reaper.SetTrackSendInfo_Value(new_track, 1, idx, "B_PHASE", h.phase)
    reaper.SetTrackSendInfo_Value(new_track, 1, idx, "I_SRCCHAN", h.srcchan)
    reaper.SetTrackSendInfo_Value(new_track, 1, idx, "I_DSTCHAN", h.dstchan)
end

-- Restore sends
for _, s in ipairs(sends) do
    if s.dest then
        local idx = reaper.CreateTrackSend(new_track, s.dest)
        for k,v in pairs(s) do
            if k ~= "dest" then
                reaper.SetTrackSendInfo_Value(new_track, 0, idx, ({
                    vol="D_VOL", pan="D_PAN", mute="B_MUTE", phase="B_PHASE",
                    srcchan="I_SRCCHAN", dstchan="I_DSTCHAN",
                    mode="I_SENDMODE", midi="I_MIDIFLAGS"
                })[k], v)
            end
        end
    end
end

-- Restore receives
for _, r in ipairs(receives) do
    if r.src then
        local idx = reaper.CreateTrackSend(r.src, new_track)
        for k,v in pairs(r) do
            if k ~= "src" then
                reaper.SetTrackSendInfo_Value(r.src, 0, idx, ({
                    vol="D_VOL", pan="D_PAN", mute="B_MUTE", phase="B_PHASE",
                    srcchan="I_SRCCHAN", dstchan="I_DSTCHAN",
                    midi="I_MIDIFLAGS"
                })[k], v)
            end
        end
    end
end

-- Restore FX envelopes (with automation items)
for _, envdata in ipairs(fx_env_data) do
    for fx = 0, reaper.TrackFX_GetCount(new_track)-1 do
        local _, fx_name = reaper.TrackFX_GetFXName(new_track, fx, "")

        if fx_name == envdata.fx_name then
            local env = reaper.GetFXEnvelope(new_track, fx, envdata.param, true)

            if env then
                -- Clear everything
                reaper.DeleteEnvelopePointRange(env, -math.huge, math.huge)

                -- Remove existing automation items
                for ai = reaper.CountAutomationItems(env)-1, 0, -1 do
                    reaper.DeleteAutomationItem(env, ai)
                end

                -- Restore base points
                for _, pt in ipairs(envdata.base_points) do
                    reaper.InsertEnvelopePoint(
                        env, pt.time, pt.value, pt.shape, pt.tension, false, true
                    )
                end

                -- Restore automation items
                for _, item in ipairs(envdata.items) do
                    local new_ai = reaper.InsertAutomationItem(
                        env, -1, item.pos, item.len
                    )

                    -- Restore pooled state
                    reaper.GetSetAutomationItemInfo(env, new_ai, "D_POOL_ID", item.pool, true)

                    -- Restore points inside item
                    for _, pt in ipairs(item.points) do
                        reaper.InsertEnvelopePointEx(
                            env, new_ai,
                            pt.time, pt.value, pt.shape, pt.tension,
                            false, true
                        )
                    end
                end

                reaper.Envelope_SortPoints(env)
            end
        end
    end
end

-- Delete old track
reaper.DeleteTrack(track)

reaper.TrackList_AdjustWindows(false)
reaper.UpdateArrange()

reaper.Undo_EndBlock("Apply Track Template (FULL + HW I/O)", -1)