#Requires AutoHotkey v2.0
#SingleInstance Force

; HDR-safe Windows screenshot shortcut.
; Turns HDR off before launching Win+Shift+S.
; Requires HDRCmd.exe from HDRTray in C:\HDRTRAY.

hdrCmdPath := "C:\HDRTRAY\HDRCmd.exe"
hdrCmdDir := "C:\HDRTRAY"

#+s::StartHdrSafeScreenshot()

StartHdrSafeScreenshot() {
    global hdrCmdPath, hdrCmdDir

    if !FileExist(hdrCmdPath) {
        ToolTip("HDRCmd.exe not found in C:\HDRTRAY")
        SetTimer(() => ToolTip(), -2000)
        Send("#+s")
        return
    }

    RunWait('"' hdrCmdPath '" off', hdrCmdDir, "Hide")
    Sleep(400)
    Send("#+s")
}
