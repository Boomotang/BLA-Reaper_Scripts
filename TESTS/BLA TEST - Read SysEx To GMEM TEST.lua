reaper.gmem_attach("SysExToGMEM")

local last_time = reaper.time_precise()
local interval = 1 -- seconds (0.5 = 500ms)

function readGMEM()
    local now = reaper.time_precise()
    if now - last_time >= interval then
        local gmem1 = reaper.gmem_read(1002)
        reaper.ShowConsoleMsg("GMEM = " .. gmem1 .. "\n")
        last_time = now
    end
    reaper.defer(readGMEM) -- Repeat on next cycle
end

readGMEM()

