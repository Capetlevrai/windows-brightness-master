#Requires AutoHotkey v2.0
#SingleInstance Force

; Toggle Windows HDR with Ctrl+Alt+B.
; Requires HDRCmd.exe from HDRTray in C:\HDRTRAY.

hdrCmdPath := "C:\HDRTRAY\HDRCmd.exe"
hdrCmdDir := "C:\HDRTRAY"

^!b::ToggleHDR()

ToggleHDR() {
    global hdrCmdPath, hdrCmdDir

    if !FileExist(hdrCmdPath) {
        ToolTip("HDRCmd.exe not found in C:\HDRTRAY")
        SetTimer(() => ToolTip(), -2000)
        return
    }

    exitCode := RunWait('"' hdrCmdPath '" status -m x', hdrCmdDir, "Hide")
    if (exitCode = 0)
        RunWait('"' hdrCmdPath '" off', hdrCmdDir, "Hide")
    else
        RunWait('"' hdrCmdPath '" on', hdrCmdDir, "Hide")
}
