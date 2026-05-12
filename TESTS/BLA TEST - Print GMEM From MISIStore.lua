-- ReaScript Name: Print gmem MIDI bytes
-- Description: Reads and prints the MIDI status, data1, and data2 from gmem
-- Author: Reaper DAW Ultimate Assistant
-- Version: 1.0

local namespace = "MIDIStore"

-- Attach to the gmem namespace used by JSFX
if reaper.gmem_attach(namespace) then
    -- Read bytes from gmem[0], [1], [2]
    local status = reaper.gmem_read(0)
    local data1 = reaper.gmem_read(1)
    local data2 = reaper.gmem_read(2)

    -- Print to console
    reaper.ShowConsoleMsg(string.format(
        "MIDI Bytes from gmem[%s]:\nStatus: 0x%X\nData1: %d\nData2: %d\n",
        namespace, status, data1, data2
    ))
else
    reaper.ShowConsoleMsg("Failed to attach to gmem namespace: " .. namespace .. "\n")
end

