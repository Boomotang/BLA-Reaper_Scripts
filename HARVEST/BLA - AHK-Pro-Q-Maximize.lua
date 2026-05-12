-- ReaperToAHK_ProQ_Maximize.lua
-- Instantly sends command 9 to AHK (Pro-Q Maximize / Esc in fullscreen)

local TARGET_TITLE      = "ReaperAHKBridgeWindow"
local WM_REAPER_COMMAND = 0x8000

local cachedHWND = nil

function GetAHK_HWND()
    if cachedHWND and reaper.JS_Window_IsWindow(cachedHWND) then
        return cachedHWND
    end
    
    cachedHWND = reaper.JS_Window_Find(TARGET_TITLE, true)  -- exact title match
    return cachedHWND
end

function SendToAHK(commandID, data)
    data = data or 0
    local hwnd = GetAHK_HWND()
    
    if not hwnd then
        reaper.ShowConsoleMsg("AHK bridge window not found!\nMake sure the AHK script is running.\n")
        return false
    end

    -- Try hex string first (most reliable)
    local success = reaper.JS_WindowMessage_Post(hwnd, "0x8000", commandID, 0, data, 0)
    
    if not success then
        -- Fallback to decimal
        success = reaper.JS_WindowMessage_Post(hwnd, tostring(WM_REAPER_COMMAND), commandID, 0, data, 0)
    end

    if success then
        -- Optional: uncomment for debugging
        -- reaper.ShowConsoleMsg(string.format("Sent command %d to AHK\n", commandID))
        return true
    else
        reaper.ShowConsoleMsg("Failed to send message to AHK bridge.\nCheck that js_ReaScriptAPI is installed and AHK is running.\n")
        return false
    end
end

-- ========================
-- Main Execution
-- ========================

SendToAHK(9)   -- ← This is your Pro-Q MAXIMIZE command