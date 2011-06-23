; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6237&highlight=
; Author: Hi-Toro (updated for PB4.00 by blbltheworm)
; Date: 26. May 2003
; OS: Windows
; Demo: No


; Get actual screenmode settings...
#ENUM_CURRENT_SETTINGS = -1 
#ENUM_REGISTRY_SETTINGS = -2 

Define.DEVMODE dm 

EnumDisplaySettings_ (#Null, #ENUM_CURRENT_SETTINGS, @dm) 

m$ = "Width: " + Str (dm\dmPelsWidth) + Chr (10) 
m$ + "Height: " + Str (dm\dmPelsHeight) + Chr (10) 
m$ + "Depth: " + Str (dm\dmBitsPerPel) + Chr (10) 
m$ + "Frequency: " + Str (dm\dmDisplayFrequency) ; FREQUENCY! 

MessageRequester ("Display mode information...", m$, #MB_ICONINFORMATION) 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
