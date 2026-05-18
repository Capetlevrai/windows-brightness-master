#Requires AutoHotkey v2.0
#SingleInstance Force

; Desktop HDR monitor correction.
; Ctrl+Alt+Up       : reduce black overlay
; Ctrl+Alt+Down     : increase black overlay
; Ctrl+Shift+Alt+Up : increase gamma boost for dark pages
; Ctrl+Shift+Alt+Down : decrease gamma boost
; Ctrl+Alt+0 or Ctrl+Shift+Alt+0 : reset overlay and gamma

targetMonitor := 1
dimPercent := 0
gammaBoostPercent := 0
stepPercent := 5
gammaStepPercent := 0.5
maxDimPercent := 85
maxGammaBoostPercent := 5
overlay := 0
lastGeometry := ""

CreateOrUpdateOverlay()
SetTimer(CreateOrUpdateOverlay, 3000)
OnExit(ResetGammaOnExit)

^!Up::AdjustDim(-stepPercent)
^!Down::AdjustDim(stepPercent)
^!+Up::AdjustGammaBoost(gammaStepPercent)
^!+Down::AdjustGammaBoost(-gammaStepPercent)
^!0::ResetCorrection()
^!+0::ResetCorrection()

AdjustDim(delta) {
    global dimPercent, maxDimPercent
    SetDim(Max(0, Min(maxDimPercent, dimPercent + delta)))
}

AdjustGammaBoost(delta) {
    global gammaBoostPercent, maxGammaBoostPercent
    SetGammaBoost(Round(Max(0, Min(maxGammaBoostPercent, gammaBoostPercent + delta)), 1))
}

SetDim(value) {
    global dimPercent
    dimPercent := value
    if dimPercent > 0
        SetGammaBoost(0, false)
    CreateOrUpdateOverlay(true)
    if dimPercent > 0
        ShowBrightnessTip("Desktop dim overlay: " dimPercent "%")
    else
        ShowBrightnessTip("Desktop correction: off")
}

SetGammaBoost(value, showTip := true) {
    global dimPercent, gammaBoostPercent
    gammaBoostPercent := value
    if gammaBoostPercent > 0
        dimPercent := 0
    CreateOrUpdateOverlay(true)

    ok := ApplyGammaBoost(gammaBoostPercent)
    if !showTip
        return

    if !ok
        ShowBrightnessTip("Gamma refused by Windows/driver")
    else if gammaBoostPercent > 0
        ShowBrightnessTip("Gamma boost: " gammaBoostPercent)
    else
        ShowBrightnessTip("Desktop correction: off")
}

ResetCorrection() {
    global dimPercent, gammaBoostPercent
    dimPercent := 0
    gammaBoostPercent := 0
    CreateOrUpdateOverlay(true)
    ApplyGammaBoost(0)
    ShowBrightnessTip("Desktop correction: off")
}

CreateOrUpdateOverlay(force := false) {
    global targetMonitor, dimPercent, overlay, lastGeometry

    monitorCount := MonitorGetCount()
    monitorIndex := Min(targetMonitor, monitorCount)
    MonitorGet(monitorIndex, &left, &top, &right, &bottom)

    width := right - left
    height := bottom - top
    geometry := left "," top "," width "," height

    if (dimPercent <= 0) {
        if IsObject(overlay)
            overlay.Destroy()
        overlay := 0
        lastGeometry := geometry
        return
    }

    if force || !IsObject(overlay) || geometry != lastGeometry {
        if IsObject(overlay)
            overlay.Destroy()

        overlay := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20 +Disabled")
        overlay.BackColor := "000000"
        overlay.Show("x" left " y" top " w" width " h" height " NoActivate")
        lastGeometry := geometry
    }

    WinSetTransparent(Round(dimPercent * 255 / 100), overlay.Hwnd)
}

ApplyGammaBoost(boostPercent) {
    global targetMonitor

    deviceName := MonitorGetName(Min(targetMonitor, MonitorGetCount()))
    hdc := DllCall("gdi32\CreateDC", "Str", "DISPLAY", "Str", deviceName, "Ptr", 0, "Ptr", 0, "Ptr")
    createdDC := !!hdc
    if !hdc {
        hdc := DllCall("user32\GetDC", "Ptr", 0, "Ptr")
        createdDC := false
    }

    if !hdc
        return false

    ramp := Buffer(256 * 3 * 2, 0)
    gamma := 1 + (boostPercent / 10)

    Loop 256 {
        i := A_Index - 1
        if boostPercent <= 0
            value := i * 257
        else
            value := Round((i / 255) ** (1 / gamma) * 65535)

        value := Max(0, Min(65535, value))
        NumPut("UShort", value, ramp, i * 2)
        NumPut("UShort", value, ramp, 512 + i * 2)
        NumPut("UShort", value, ramp, 1024 + i * 2)
    }

    ok := DllCall("gdi32\SetDeviceGammaRamp", "Ptr", hdc, "Ptr", ramp)

    if createdDC
        DllCall("gdi32\DeleteDC", "Ptr", hdc)
    else
        DllCall("user32\ReleaseDC", "Ptr", 0, "Ptr", hdc)

    return ok
}

ResetGammaOnExit(*) {
    ApplyGammaBoost(0)
}

ShowBrightnessTip(text) {
    ToolTip(text)
    SetTimer(() => ToolTip(), -1500)
}
