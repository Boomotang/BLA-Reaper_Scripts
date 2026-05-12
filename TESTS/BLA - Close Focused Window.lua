local hwnd = reaper.BR_Win32_GetForegroundWindow()
if hwnd ~= nil and hwnd ~= reaper.GetMainHwnd() then
  reaper.BR_Win32_SendMessage(hwnd, reaper.BR_Win32_GetConstant("WM_CLOSE"),0,0)
end 
reaper.defer(function () end)
