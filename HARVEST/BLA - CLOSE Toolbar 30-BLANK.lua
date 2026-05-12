-- =============================================
-- CLOSE TOOLBAR 30 & OPEN TOOLBAR 2 (STATE-SAFE)
-- =============================================

local cmd_toolbar_30 = 42726
local cmd_toolbar_2 = 41680

-- Only run if Toolbar 30 is currently OPEN
if reaper.GetToggleCommandStateEx(0, cmd_toolbar_30) == 1 then
  reaper.Main_OnCommand(cmd_toolbar_30, 0)
end

-- Only run if Toolbar 2 is currently CLOSED
if reaper.GetToggleCommandStateEx(0, cmd_toolbar_2) == 0 then
  reaper.Main_OnCommand(cmd_toolbar_2, 0)
end