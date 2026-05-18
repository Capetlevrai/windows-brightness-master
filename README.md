# windows-brightness-master

[AutoHotkey v2](https://www.autohotkey.com/) scripts to control brightness-like behavior on Windows laptops and desktop monitors, with extra helpers for HDR/local dimming issues.

## Scripts

### Desktop/brightnessDesktop.ahk

Designed for a fixed desktop monitor such as the Gigabyte M28U in HDR.

It provides two different corrections:

- A black click-through overlay to visually reduce brightness.
- A gamma boost to lift dark pages when HDR/local dimming makes them too dim.

Hotkeys:

| Hotkey | Action |
| --- | --- |
| `Ctrl+Alt+Up` | Reduce black overlay |
| `Ctrl+Alt+Down` | Increase black overlay |
| `Ctrl+Shift+Alt+Up` | Increase gamma boost by `0.5` |
| `Ctrl+Shift+Alt+Down` | Decrease gamma boost by `0.5` |
| `Ctrl+Shift+Alt+0` | Reset overlay and gamma |

Notes:

- The overlay is not a hardware brightness change.
- Gamma boost uses the Windows/GDI gamma ramp. In HDR, some drivers or apps may ignore it.
- The script resets gamma when it exits.

### Laptop/brightnessLaptop.ahk

Designed only for laptop internal panels.

It uses Windows WMI laptop brightness APIs:

- `WmiMonitorBrightness`
- `WmiMonitorBrightnessMethods`

It does not touch gamma, overlays, HDR, or external monitor controls.

Hotkeys:

| Hotkey | Action |
| --- | --- |
| `Ctrl+Alt+Up` | Laptop brightness +5% |
| `Ctrl+Alt+Down` | Laptop brightness -5% |

## Requirements

Install AutoHotkey v2:

- https://www.autohotkey.com/

For HDR desktop workflows, install HDRTray from the official GitHub repository:

- https://github.com/res2k/HDRTray

HDRTray is not required by the scripts in this repository, but it is useful for toggling Windows HDR and for command-line HDR helpers.

If you use HDRTray helper files, place the required HDRTray files in:

```text
C:\HDRTRAY
```

Only these files are useful for the optional HDR toggle workflow:

- `HDRTray.exe`
- `HDRCmd.exe`

This project does not use `set_sdrwhite.exe` or `set_maxtml.exe`.

## Installation

1. Install AutoHotkey v2.
2. Download or clone this repository.
3. Pick the script for your machine:
   - Desktop HDR monitor: `Desktop/brightnessDesktop.ahk`
   - Laptop internal screen: `Laptop/brightnessLaptop.ahk`
4. Open Windows Run with `Win+R`.
5. Type:

```text
shell:startup
```

6. Copy the chosen `.ahk` file into the Startup folder.
7. Double-click the `.ahk` file once, or restart Windows.

Only put the script you actually need in `shell:startup`.

## Recommended Desktop Setup

For a desktop HDR monitor:

1. Put HDRTray files in `C:\HDRTRAY` if you use HDR toggling helpers.
2. Put `Desktop/brightnessDesktop.ahk` in `shell:startup`.
3. Use `Ctrl+Shift+Alt+0` before gaming if you want a fully reset image.
4. Use `Ctrl+Shift+Alt+Up/Down` to compensate dark web pages caused by HDR/local dimming.

## Recommended Laptop Setup

For a laptop:

1. Put `Laptop/brightnessLaptop.ahk` in `shell:startup`.
2. Do not use the desktop script unless you specifically want overlay/gamma behavior.
