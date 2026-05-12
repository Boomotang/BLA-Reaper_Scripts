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
]

; =================================================
; =================================================
; =============== EQ WINDOWS MACRO ================
; =================================================
; =================================================

ProQ_Positions := [
    [0,   0],     
    [950, 0],     
    [0,   460],   
    [950, 460]    
]

EQ_Titles := ["Pro-Q", "VEQ3", "VEQ4", "EQP", "MEQ"]

EQ_ClickMacro() {
    if !IsEQWindowActive()
        return

    windows := GetAllEQWindows()
    if (windows.Length = 0)
        return

    proqWindows := []
    otherWindows := []

    for hwnd in windows {
        title := WinGetTitle(hwnd)
        if InStr(title, "Pro-Q")
            proqWindows.Push(hwnd)
        else
            otherWindows.Push(hwnd)
    }

    ; ================== SINGLE PRO-Q + OTHERS ==================
    if (proqWindows.Length = 1 && otherWindows.Length > 0) {
        WinMove(0, 175,,, proqWindows[1])
        Sleep 60
        
        CoordMode "Mouse", "Window"
        MouseGetPos &origX, &origY
        Click 890, 75
        MouseMove origX, origY, 0

        ReverseArray(otherWindows)
        ArrangeOtherEQsVerticalRight(otherWindows)
        
        WinActivate(proqWindows[1])
        return
    }

    ; ================== PURE SINGLE PRO-Q (no others) ==================
    if (proqWindows.Length = 1 && otherWindows.Length = 0) {
        hwnd := proqWindows[1]
        CenterWindow(hwnd)
        Sleep 80
        
        CoordMode "Mouse", "Window"
        MouseGetPos &origX, &origY
        Click 890, 75
        MouseMove origX, origY, 0
        return
    }

    ; ================== MULTIPLE PRO-Qs ==================
    if (proqWindows.Length > 1) {
        ReverseArray(proqWindows)
        ArrangeProQPositions(proqWindows)
    }

    if (otherWindows.Length > 0) {
        if (proqWindows.Length = 0) {
            ReverseArray(otherWindows)
            ArrangeCenteredVertical(otherWindows)
        } else {
            ReverseArray(otherWindows)
            ArrangeOtherEQs(otherWindows)
        }
    }

    ; Activation
    if (proqWindows.Length >= 1)
        WinActivate(proqWindows[1])
    else if (otherWindows.Length > 0)
        WinActivate(otherWindows[1])
}

; ================== HELPERS ==================

IsEQWindowActive() {
    activeTitle := WinGetTitle("A")
    for t in EQ_Titles {
        if InStr(activeTitle, t)
            return true
    }
    return false
}

GetAllEQWindows() {
    allWindows := []
    candidates := WinGetList(, , "ahk_exe reaper.exe ahk_class #32770")

    for hwnd in candidates {
        title := WinGetTitle(hwnd)
        if (title = "")
            continue
        if (WinGetProcessName(hwnd) ~= "chrome.exe|msedge.exe|firefox.exe")
            continue

        for eq in EQ_Titles {
            if InStr(title, eq) {
                allWindows.Push(hwnd)
                break
            }
        }
    }
    return allWindows
}

CenterWindow(hwnd) {
    WinMove((1920 - 966)//2, (1080 - 636)//2,,, hwnd)
}

ArrangeProQPositions(windows) {
    for i, hwnd in windows {
        if (i <= 4) {
            x := ProQ_Positions[i][1]
            y := ProQ_Positions[i][2]
        } else {
            x := (1920 - 966)//2
            y := (1080 - 636)//2 + 30
        }
        WinMove(x, y,,, hwnd)
        Sleep 25
    }
}

ArrangeCenteredVertical(windows) {
    y := 175
    spacing := 30

    for hwnd in windows {
        WinGetClientPos(,, &w, &h, hwnd)
        x := (1920 - w) // 2
        
        WinMove(x, y,,, hwnd)
        Sleep 25
        y += h + spacing
    }
}

ArrangeOtherEQs(windows) {
    screenW     := 1920
    screenH     := 1080
    topY        := 630
    rightMargin := 15
    bottomMargin:= 30

    for i, hwnd in windows {
        WinGetClientPos(,, &w, &h, hwnd)

        if (i = 1) {
            x := 0
            y := topY
        } else if (i = 2) {
            x := screenW - w - rightMargin
            y := topY
        } else if (i = 3) {
            x := 0
            y := screenH - h - bottomMargin
        } else if (i = 4) {
            x := screenW - w - rightMargin
            y := screenH - h - bottomMargin
        } else {
            x := (screenW - w) // 2
            y := topY + 80
        }

        WinMove(x, y,,, hwnd)
        Sleep 25
    }
}

ArrangeOtherEQsVerticalRight(windows) {
    rightMargin := 15
    startY      := 175
    spacing     := 30

    y := startY

    for hwnd in windows {
        WinGetClientPos(,, &w, &h, hwnd)
        x := 1920 - w - rightMargin
        
        WinMove(x, y,,, hwnd)
        Sleep 25
        y += h + spacing
    }
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

; =================================================
; =================================================
; ================== COMPS MACRO ==================
; =================================================
; =================================================

COMPS_Macro() {
    Sleep 180

    compWindows := GetAllCompressorWindows()

    if (compWindows.Length = 0)
        return

    if (compWindows.Length = 2) {
        cla76 := FindWindowContaining("CLA 76")
        cla2a := FindWindowContaining("CLA 2A")
        
        if (cla76 && cla2a) {
            PositionCLA76andCLA2A(cla76, cla2a)
            return
        }
    }

    if (compWindows.Length >= 2) {
        ArrangeCompressorsVertical(compWindows)
        return
    }

    if (compWindows.Length = 1) {
        hwnd := compWindows[1]
        
        if (IsWindowProC(hwnd)) {
            CenterWindowDynamically(hwnd)
            ClickProCButton()
        }
        else {
            CenterWindowDynamically(hwnd)
        }
    }
}

ClickProCButton() {
    MouseGetPos &origX, &origY
    Sleep 50
    CoordMode "Mouse", "Window"
    Click 832, 75
    MouseMove origX, origY, 0
}

IsWindowProC(hwnd) {
    title := WinGetTitle(hwnd)
    return InStr(title, "Pro-C", true)
}

CenterWindowDynamically(hwnd) {
    if !WinExist(hwnd) 
        return

    WinGetPos(&winX, &winY, &winW, &winH, hwnd)

    centerX := (1920 - winW) // 2
    centerY := (1080 - winH) // 2

    WinMove(centerX, centerY, , , hwnd)
    WinActivate(hwnd)
}

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

ArrangeCompressorsVertical(windows) {
    startY     := 103
    spacing    := 35
    screenW    := 1920

    y := startY

    for hwnd in windows {
        WinGetClientPos(,, &w, &h, hwnd)
        x := (screenW - w) // 2
        
        WinMove(x, y,,, hwnd)
        Sleep 25
        y += h + spacing
    }

    if (windows.Length > 0)
        WinActivate(windows[1])
}

FindWindowContaining(part) {
    list := WinGetList(part,, "ahk_class ToolWindow|ahk_class #32770")
    return list.Length > 0 ? list[1] : 0
}

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
; ==================================================
; ================== PRO-MB MACRO ==================
; ==================================================
; ==================================================
ProMB_ClickMacro() {
    if !WinActive("Pro-MB")
        return

    WinGetPos &winX, &winY, &winW, &winH, "Pro-MB"
    
    centerX := (A_ScreenWidth - winW) // 2
    centerY := (A_ScreenHeight - winH) // 2
    
    WinMove centerX, centerY, , , "Pro-MB"
    WinActivate "Pro-MB"
    
    Sleep 50
    CoordMode "Mouse", "Window"
    MouseGetPos &origX, &origY
    Click 890, 75
    MouseMove origX, origY, 0
}

; ==================================================
; ================== PRO-Q MAXIMIZE =================
; ==================================================

ProQ_MAXIMIZE() {
    hwnd := WinExist("A")
    if !hwnd
        return

    ; === Updated detection for fullscreen Pro-Q (no title) ===
    if !IsProQWindow(hwnd)
        return

    if IsWindowFullScreen(hwnd) {
        Send "{Esc}"
        return
    }

    ; Not fullscreen → direct click (no centering)
    CoordMode "Mouse", "Window"
    MouseGetPos &origX, &origY
    Click 890, 75
    MouseMove origX, origY, 0
}

; ================== IMPROVED Pro-Q DETECTION ==================
IsProQWindow(hwnd) {
    title := WinGetTitle(hwnd)
    if InStr(title, "Pro-Q")
        return true

    ; Fallback for fullscreen Pro-Q (title disappears)
    class := WinGetClass(hwnd)
    if (class = "FF_UIWindow")
        return true

    return false
}

; ================== FULLSCREEN DETECTION ==================
IsWindowFullScreen(hwnd := "A") {
    if (hwnd = "A")
        hwnd := WinExist("A")

    if !WinExist(hwnd)
        return false

    style := WinGetStyle(hwnd)
    WinGetPos(&x, &y, &w, &h, hwnd)

    borderless := !(style & 0x20800000)
    coversScreen := (w >= A_ScreenWidth - 8) && (h >= A_ScreenHeight - 8) && (x <= 8) && (y <= 8)

    if (WinGetMinMax(hwnd) = -1)
        return false

    return borderless && coversScreen
}

; ================================================================
; ================================================================
; ================== REAPER WINDOW SWITCH MACRO ==================
; ================================================================
; ================================================================
ReaperWindowSwitch() {
    activeTitle := WinGetTitle("A")

    if (InStr(activeTitle, "PLUGINS", true) && InStr(activeTitle, "REAPER", true)) {
        if WinExist("BROADCAST ahk_exe reaper.exe") {
            WinActivate("BROADCAST ahk_exe reaper.exe")
        }
        return
    }

    if (InStr(activeTitle, "BROADCAST", true) && InStr(activeTitle, "REAPER", true)) {
        if WinExist("PLUGINS ahk_exe reaper.exe") {
            WinActivate("PLUGINS ahk_exe reaper.exe")
        }
        return
    }
}

; ================== MESSAGE HANDLER ==================
ReaperMessageHandler(wParam, lParam, *) {
    switch wParam {
        case 1:  EQ_ClickMacro()
        case 2:  COMPS_Macro()
        case 3:  ProMB_ClickMacro()
        case 9:  ProQ_MAXIMIZE()
        case 10: ReaperWindowSwitch()
        default: TrayTip("Unknown: " wParam)
    }
    return 0
}

; ================== STARTUP ==================
Persistent
TrayTip("Reaper→AHK Bridge Active")