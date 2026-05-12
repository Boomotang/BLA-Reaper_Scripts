reaper.gmem_attach("dlive_sysex")

name = ""
for i = 0, 5 do
  c = reaper.gmem_read(3000 + i)
  if c > 0 then name = name .. string.char(c) end
end

reaper.ShowConsoleMsg("Mixer Channel 1 Name: " .. name .. "\n")

