local vbs_path = "C:\\PC_Setlists\\run_setlist_hidden.vbs"
local date_argument = ""   -- leave empty for next Sunday

local output_dir = "C:\\PC_Setlists\\"

-- Show "Setlist Loading..." immediately
reaper.ShowMessageBox("Setlist Loading...", "Please wait", 0)

-- Write date argument if needed
if date_argument ~= "" then
    local f = io.open(output_dir .. "date_argument.tmp", "w")
    if f then 
        f:write(date_argument) 
        f:close() 
    end
end

-- Launch the script
local success = reaper.CF_ShellExecute('"' .. vbs_path .. '"')

if not success then
    reaper.ShowMessageBox("Failed to launch setlist script", "Error", 0)
    return
end

-- Poll for completion
local start_time = reaper.time_precise()

local function check_completion()
    local now = reaper.time_precise()
    
    local found = false
    local idx = 0
    
    while true do
        local fn = reaper.EnumerateFiles(output_dir, idx)
        if not fn then break end
        
        if fn:match("^setlist_.*%.txt$") then
            local fullpath = output_dir .. fn
            -- Rough check: file exists and was likely just created
            if reaper.file_exists(fullpath) then
                found = true
                break
            end
        end
        idx = idx + 1
    end

    if found or (now - start_time > 30) then  -- 30 second timeout
        reaper.ShowMessageBox("Setlist Loading Complete", "Success", 0)
        return
    end

    reaper.defer(check_completion)  -- check again in ~0.3s
end

reaper.defer(check_completion)