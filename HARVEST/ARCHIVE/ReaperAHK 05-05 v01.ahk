#Requires AutoHotkey v2.0
#SingleInstance Force

; ================== CONFIG ==================
CustomWindowTitle := "ReaperAHKBridgeWindow"
WM_REAPER_COMMAND := 0x8000

; Create hidden window
MyGui := Gui("-Caption +ToolWindow +AlwaysOnTop")
MyGui.Title := CustomWindowTitle
MyGui.Show("w1 h1 x-9999 y-9999 Hide")

OnMessage(WM_REAPER_COMMAND, ReaperMessageHandler)

ReaperMessageHandler(wParam, lParam, *) {
    switch wParam {
        case 1:  ProQ_ClickMacro()
        case 2:  COMPS_Macro()
        case 3:  ProMB_ClickMacro()
        case 10: ReaperWindowSwitch()
        default: TrayTip("Unknown: " wParam)
    }
    return 0
}

CompressorTitles := [
    "CLA 76",
    "1176",
    "CLA 2A",
    "LA-2A",
    "CLA 3A",
    "LA-3A",
    "Distressor",
    "Arousor",
    "Pro-C",
    "dbx-160",
    "Dyna-mite",
    "API-2500"
    "API 2500"
]

; =================================================
; ================== PRO-Q MACRO ==================
; =================================================
; Hardcoded positions for first 4 windows (adjust these X values if needed)
ProQ_Positions := [
    [0,   0],     ; 1st window (oldest) - top left
    [950, 0],     ; 2nd window
    [0,   450],    ; 3rd window  (note: 966*2 + small gap)
    [950, 450]     ; 4th window
]

ProQ_ClickMacro() {
    if !WinActive("Pro-Q")
        return

    validWindows := WinGetList("Pro-Q", , "ahk_class ToolWindow|ahk_class #32770")

    count := validWindows.Length
    if (count = 0)
        return

    if (count = 1) {
        CenterWindow(validWindows[1])
        Sleep 80
        CoordMode "Mouse", "Window"
        MouseGetPos &origX, &origY
        Click 890, 75
        MouseMove origX, origY, 0
    }
    else {
        ReverseArray(validWindows)           ; oldest first
        ArrangeHardcodedPositions(validWindows)
        Sleep 25
        WinActivate(validWindows[1])
        ;TrayTip("Arranged " count " Pro-Q windows (hardcoded)", "Reaper-AHK Bridge", 1)
    }
}

; ================== HELPERS ==================
CenterWindow(hwnd) {
    WinMove( (1920 - 966)//2 , (1080 - 636)//2 , , , hwnd)
}

ReverseArray(arr) {
    left := 1
    right := arr.Length
    while (left < right) {
        temp := arr[left]
        arr[left] := arr[right]
        arr[right] := temp
        left++
        right--
    }
}

; ================== HARDCODED POSITIONS ==================
ArrangeHardcodedPositions(windows) {
    ; Place first 4 in hardcoded positions
    for i, hwnd in windows {
        if (i <= 4) {
            x := ProQ_Positions[i][1]
            y := ProQ_Positions[i][2]
        } else {
            ; Extra windows go in the center
            x := (1920 - 966) // 2
            y := (1080 - 636) // 2 + 50
        }
        WinMove(x, y, , , hwnd)
        Sleep 30
    }
}

; =================================================
; ================== COMPS MACRO ==================
; =================================================

COMPS_Macro() {
    Sleep 180

    compWindows := GetAllCompressorWindows()

    if (compWindows.Length = 0)
        return

    ; ===================== 76 + 2A =====================
    if (compWindows.Length = 2) {
        cla76 := FindWindowContaining("CLA 76")
        cla2a := FindWindowContaining("CLA 2A")
        
        if (cla76 && cla2a) {
            PositionCLA76andCLA2A(cla76, cla2a)
            return
        }
    }

    ; ===================== SINGLE COMPRESSOR =====================
    if (compWindows.Length = 1) {
        hwnd := compWindows[1]
        
        ; Check if it's Pro-C
        if (IsWindowProC(hwnd)) {
            CenterWindowDynamically(hwnd)
            ClickProCButton()           ; Click at 1055, 310 on screen
        }
        else {
            CenterWindowDynamically(hwnd)   ; Normal centering for other single compressors
        }
    }
    ; Add more rules later as needed
}

; =================================================
; ================== Pro-C CLICK ==================
; =================================================

ClickProCButton() {
    ; Save current mouse position
    MouseGetPos &origX, &origY
    
    ; Small delay to let the window settle (optional but recommended)
    Sleep 50

    ; === Perform the click (relative to window) ===
    CoordMode "Mouse", "Window"
    MouseGetPos &origX, &origY
    Click 832, 75
    MouseMove origX, origY, 0
}

; ================== Pro-C DETECTION ==================

IsWindowProC(hwnd) {
    title := WinGetTitle(hwnd)
    return InStr(title, "Pro-C", true)
}

; =================================================
; ================== CENTERING ====================
; =================================================

CenterWindowDynamically(hwnd) {
    if !WinExist(hwnd) 
        return

    WinGetPos(&winX, &winY, &winW, &winH, hwnd)

    centerX := (1920 - winW) // 2
    centerY := (1080 - winH) // 2

    WinMove(centerX, centerY, , , hwnd)
    WinActivate(hwnd)
}

; =================================================
; ================== 76 + 2A ======================
; =================================================

PositionCLA76andCLA2A(hwnd76, hwnd2a) {
    if !WinExist(hwnd76) || !WinExist(hwnd2a)
        return

    WinGetPos(,, &w76,, hwnd76)
    WinGetPos(,, &w2a,, hwnd2a)

    x76 := (1920 - w76) // 2
    x2a := (1920 - w2a) // 2

    WinMove(x76, 103, , , hwnd76)
    WinMove(x2a, 560, , , hwnd2a)

    WinActivate(hwnd76)
}

; ================== FINDER ==================

FindWindowContaining(part) {
    list := WinGetList(part,, "ahk_class ToolWindow|ahk_class #32770")
    return list.Length > 0 ? list[1] : 0
}

; ================== COMPRESSOR HELPERS ==================

GetAllCompressorWindows() {
    windows := []
    for titlePart in CompressorTitles {
        list := WinGetList(titlePart,, "ahk_class ToolWindow|ahk_class #32770")
        for hwnd in list {
            windows.Push(hwnd)
        }
    }
    return windows
}

; ==================================================
; ================== PRO-MB MACRO ==================
; ==================================================
ProMB_ClickMacro() {
    if !WinActive("Pro-MB")
        return

    ; === Center the Pro-MB window on the primary monitor ===
    WinGetPos &winX, &winY, &winW, &winH, "Pro-MB"
    
    ; Calculate center position (primary monitor)
    centerX := (A_ScreenWidth - winW) // 2
    centerY := (A_ScreenHeight - winH) // 2
    
    ; Move and activate the window
    WinMove centerX, centerY, , , "Pro-MB"
    WinActivate "Pro-MB"  ; Ensure it's active after moving
    
    ; Small delay to let the window settle (optional but recommended)
    Sleep 50

    ; === Perform the click (relative to window) ===
    CoordMode "Mouse", "Window"
    MouseGetPos &origX, &origY
    Click 890, 75
    MouseMove origX, origY, 0
}

; ================================================================
; ================== REAPER WINDOW SWITCH MACRO ==================
; ================================================================
ReaperWindowSwitch() {
    ; Get the currently active window's title
    activeTitle := WinGetTitle("A")

    ; If a PLUGINS window is currently focused → switch to BROADCAST
    if (InStr(activeTitle, "PLUGINS", true) && InStr(activeTitle, "REAPER", true)) {
        if WinExist("BROADCAST ahk_exe reaper.exe") {
            WinActivate("BROADCAST ahk_exe reaper.exe")
            ;WinRestore("BROADCAST ahk_exe reaper.exe")  ; Optional: ensure it's not minimized
        }
        return
    }

    ; If a BROADCAST window is currently focused → switch to PLUGINS
    if (InStr(activeTitle, "BROADCAST", true) && InStr(activeTitle, "REAPER", true)) {
        if WinExist("PLUGINS ahk_exe reaper.exe") {
            WinActivate("PLUGINS ahk_exe reaper.exe")
            ;WinRestore("PLUGINS ahk_exe reaper.exe")
        }
        return
    }

    ; Optional: fallback (e.g. if neither is active, you could activate one of them)
    ; if WinExist("PLUGINS ahk_exe reaper.exe")
    ;     WinActivate("PLUGINS ahk_exe reaper.exe")
}

; ================== STARTUP ==================
Persistent
TrayTip("Reaper→AHK Bridge Active`nCommand 1 = Hardcoded 4 Positions")