reaper.Undo_BeginBlock()

local close_floating = reaper.NamedCommandLookup("_S&M_WNCLS3")
local close_chain    = reaper.NamedCommandLookup("_S&M_WNCLS4")

if close_floating ~= 0 then
    reaper.Main_OnCommand(close_floating, 0)
end

if close_chain ~= 0 then
    reaper.Main_OnCommand(close_chain, 0)
end

reaper.Undo_EndBlock("Close all FX windows", -1)