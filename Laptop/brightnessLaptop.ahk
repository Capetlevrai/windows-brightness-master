#Requires AutoHotkey v2.0
#SingleInstance Force

; Laptop internal display brightness only.
; This script uses Windows WMI brightness APIs and does not touch gamma,
; overlays, HDR controls, or external monitor settings.

^!Up::AdjustLaptopBrightness(5)
^!Down::AdjustLaptopBrightness(-5)

AdjustLaptopBrightness(delta) {
    try {
        WMI := ComObjGet("winmgmts:\\.\root\wmi")
        current := ""

        for monitor in WMI.ExecQuery("SELECT * FROM WmiMonitorBrightness")
            current := monitor.CurrentBrightness

        if current = "" {
            ShowBrightnessTip("Laptop brightness API unavailable")
            return
        }

        newValue := Max(0, Min(100, current + delta))

        for monitor in WMI.ExecQuery("SELECT * FROM WmiMonitorBrightnessMethods")
            monitor.WmiSetBrightness(1, newValue)

        ShowBrightnessTip("Laptop brightness: " newValue "%")
    } catch Error as err {
        ShowBrightnessTip("Laptop brightness error")
    }
}

ShowBrightnessTip(text) {
    ToolTip(text)
    SetTimer(() => ToolTip(), -1500)
}
