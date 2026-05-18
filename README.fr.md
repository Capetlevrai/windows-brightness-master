# windows-brightness-master

[English version](README.md)

Scripts [AutoHotkey v2](https://www.autohotkey.com/) pour les raccourcis Windows de luminosite, gamma et HDR.

Chaque script a un role dedie. Ne melangez pas les scripts sauf si vous voulez explicitement lancer tous les raccourcis concernes au demarrage.

## Prerequis

Installez AutoHotkey v2 :

- https://www.autohotkey.com/

Pour les raccourcis HDR, installez HDRTray depuis le depot GitHub officiel :

- https://github.com/res2k/HDRTray

Placez l'outil en ligne de commande HDRTray dans :

```text
C:\HDRTRAY
```

![Fichiers HDRTray dans le disque C](assets/hdrtray.jpg)

Requis pour le script de bascule HDR :

- `HDRCmd.exe`

Optionnel :

- `HDRTray.exe` si vous voulez aussi l'icone dans la zone de notification.

## Desktop/brightnessDesktop.ahk

Correction visuelle de luminosite pour ecran desktop.

Utilisez ce script sur un ecran desktop quand le controle materiel de luminosite est indisponible ou peu fiable. Il fonctionne en SDR et en HDR, mais le comportement du gamma peut dependre du pipeline HDR de Windows, du pilote GPU et de l'application ou du jeu.

Fonctions :

- Overlay noir click-through pour reduire visuellement la luminosite.
- Boost gamma pour deboucher les pages sombres quand le HDR ou le local dimming les rend trop sombres.
- Remise a zero du gamma quand le script se ferme.

Raccourcis :

| Raccourci | Action |
| --- | --- |
| `Ctrl+Alt+Haut` | Reduit l'overlay noir |
| `Ctrl+Alt+Bas` | Augmente l'overlay noir |
| `Ctrl+Shift+Alt+Haut` | Augmente le boost gamma de `0.5` |
| `Ctrl+Shift+Alt+Bas` | Diminue le boost gamma de `0.5` |
| `Ctrl+Shift+Alt+0` | Reset overlay et gamma |

Notes :

- L'overlay n'est pas un vrai changement de luminosite materielle.
- Le boost gamma utilise la gamma ramp Windows/GDI.
- Avant de jouer, utilisez `Ctrl+Shift+Alt+0` si vous voulez une image totalement remise a zero.

Installation :

1. Copiez `Desktop/brightnessDesktop.ahk` dans `shell:startup`.
2. Double-cliquez dessus une fois, ou redemarrez Windows.

## Laptop/brightnessLaptop.ahk

Luminosite de l'ecran interne de laptop uniquement.

Utilisez ce script seulement sur un laptop dont la dalle interne est exposee par l'API WMI de luminosite Windows.

Fonctions :

- Utilise `WmiMonitorBrightness`.
- Utilise `WmiMonitorBrightnessMethods`.
- Ne touche pas au gamma.
- Ne cree pas d'overlay.
- Ne controle pas le HDR.
- Ne controle pas la luminosite d'un ecran externe.

Raccourcis :

| Raccourci | Action |
| --- | --- |
| `Ctrl+Alt+Haut` | Luminosite laptop +5% |
| `Ctrl+Alt+Bas` | Luminosite laptop -5% |

Installation :

1. Copiez `Laptop/brightnessLaptop.ahk` dans `shell:startup`.
2. Double-cliquez dessus une fois, ou redemarrez Windows.

## HDR/hdrToggle.ahk

Raccourci de bascule HDR Windows.

Utilisez ce script si vous voulez un raccourci clavier direct pour activer ou desactiver le HDR Windows sans dependre de Xbox Game Bar.

C'est utile sur les PC Windows ou Game Bar a ete completement desactivee ou supprimee, surtout si ces processus sont desactives :

- `Gamebar.exe`
- `GameBarFTServer.exe`

Si Game Bar est supprimee, les raccourcis overlay Windows habituels ne sont plus disponibles. Ce script garde une bascule HDR disponible via `HDRCmd.exe` de HDRTray.

Raccourcis :

| Raccourci | Action |
| --- | --- |
| `Ctrl+Alt+B` | Active/desactive le HDR Windows |

Installation :

1. Telechargez HDRTray depuis https://github.com/res2k/HDRTray.
2. Placez `HDRCmd.exe` dans `C:\HDRTRAY`.
3. Copiez `HDR/hdrToggle.ahk` dans `shell:startup`.
4. Double-cliquez dessus une fois, ou redemarrez Windows.

Commande optionnelle pour supprimer Game Bar :

```powershell
Get-AppxPackage -AllUsers Microsoft.XboxGamingOverlay | Remove-AppxPackage
```

Executez cette commande dans PowerShell en administrateur seulement si vous voulez volontairement supprimer Xbox Game Bar.

## HDR/hdrScreenshotSafe.ahk

Raccourci de capture Windows compatible HDR.

Utilisez ce script quand les captures en HDR sont incorrectes, delavees, surexposees ou avec des couleurs faussees. Il desactive le HDR avant de lancer le raccourci de capture Windows.

Ce script est separe de `HDR/hdrToggle.ahk` volontairement :

- `HDR/hdrToggle.ahk` sert uniquement a basculer le HDR avec `Ctrl+Alt+B`.
- `HDR/hdrScreenshotSafe.ahk` sert uniquement a preparer les captures avec `Win+Shift+S`.

Raccourcis :

| Raccourci | Action |
| --- | --- |
| `Win+Shift+S` | Desactive le HDR, attend brievement, puis lance la capture Windows |

Installation :

1. Telechargez HDRTray depuis https://github.com/res2k/HDRTray.
2. Placez `HDRCmd.exe` dans `C:\HDRTRAY`.
3. Copiez `HDR/hdrScreenshotSafe.ahk` dans `shell:startup`.
4. Double-cliquez dessus une fois, ou redemarrez Windows.

## Dossier Startup

Ouvrez le dossier de demarrage Windows avec :

```text
Win+R
shell:startup
```

Copiez uniquement les scripts que vous voulez vraiment lancer a l'ouverture de session.

![Dossier Startup avec les scripts selectionnes](assets/shell-startup.png)
