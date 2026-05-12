-- ReaperToAHK_WindowMsg.lua   (Fixed version)

local TARGET_TITLE      = "ReaperAHKBridgeWindow"
local WM_REAPER_COMMAND = 0x8000   -- Your custom message

local cachedHWND = nil

function GetAHK_HWND()
    if cachedHWND and reaper.JS_Window_IsWindow(cachedHWND) then
        return cachedHWND
    end

    cachedHWND = reaper.JS_Window_Find(TARGET_TITLE, true)  -- exact match
    return cachedHWND
end

function SendToAHK(commandID, data)
    data = data or 0
    local hwnd = GetAHK_HWND()

    if not hwnd then
        reaper.ShowConsoleMsg("AHK bridge window not found! Is the AHK script running?\n")
        return
    end

    -- Correct way: use raw decimal/hex value or proper WM_USER offset
    -- Option 1: Raw number as string (most reliable for high values)
    local msgStr = string.format("0x%X", WM_REAPER_COMMAND)   -- e.g. "0x8000"

    local success = reaper.JS_WindowMessage_Post(
        hwnd,
        msgStr,      -- ← Fixed
        commandID,   -- wParam
        0,           -- wParamHighWord
        data,        -- lParam
        0            -- lParamHighWord
    )

    if success then
        -- reaper.ShowConsoleMsg(string.format("Sent command %d (data=%d) successfully\n", commandID, data))
    else
        reaper.ShowConsoleMsg("PostMessage still failed. Trying alternative message format...\n")

        -- Option 2: Try as decimal string
        local success2 = reaper.JS_WindowMessage_Post(hwnd, tostring(WM_REAPER_COMMAND), commandID, 0, data, 0)
        if success2 then
            reaper.ShowConsoleMsg("Success with decimal message ID!\n")
        else
            reaper.ShowConsoleMsg("Both formats failed. Check AHK window title and that js_ReaScriptAPI is loaded.\n")
        end
    end
end


SendToAHK(10)   -- Reaper Window Switch (PLUGINS <-> BROADCAST)