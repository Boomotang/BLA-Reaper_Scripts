local start_time = reaper.time_precise()

local MasterTrack = reaper.GetMasterTrack(0)
local fx_count = reaper.TrackFX_GetCount(MasterTrack)

-- Parameters to turn OFF
local params = {}
for i = 0, 19 do
    params[#params + 1] = i
end

local function lights_off_delayed()
    if reaper.time_precise() - start_time >= 0.5 then

        for fx = 0, fx_count - 1 do
            local retval, name = reaper.TrackFX_GetFXName(MasterTrack, fx)
            
            if retval and name:find("RL %-") then
                for _, param in ipairs(params) do
                    reaper.TrackFX_SetParam(MasterTrack, fx, param, 0)
                end
            end
        end

    else
        reaper.defer(lights_off_delayed)
    end
end

lights_off_delayed()