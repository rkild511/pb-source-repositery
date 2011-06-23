; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3002&highlight=
; Author: J-The-Grey (updated for PB3.93 by ts-soft)
; Date: 03. December 2003
; OS: Windows
; Demo: No


; Original-Code von Galaxy: 

#ENUM_CURRENT_SETTINGS = -1 
Global scrn_dev 

Procedure ChangeDisplay(newX, newY, newB) 
  If scrn_dev = 0 
    scrn_dev = AllocateMemory(160) 
    RtlFillMemory_(scrn_dev,160,0) 
    EnumDisplaySettings_(#Null, #ENUM_CURRENT_SETTINGS, @info.DEVMODE) 
    sx = GetSystemMetrics_(#SM_CXSCREEN) 
    sy = GetSystemMetrics_(#SM_CYSCREEN) 
    sc = info\dmBitsPerPel 
    PokeL(scrn_dev +148,sc) 
    PokeL(scrn_dev +152,sx) 
    PokeL(scrn_dev +156,sy) 
    
    EnumDisplaySettings_(0,0,scrn_dev) 
    PokeW(scrn_dev +104,newB) 
    PokeL(scrn_dev +108,newX) 
    PokeL(scrn_dev +112,newY) 
    ChangeDisplaySettings_(scrn_dev,4) 
  EndIf 
EndProcedure 

Procedure RestoreDisplay() 
  If scrn_dev >0 
    EnumDisplaySettings_(0,0,scrn_dev) 
    PokeW(scrn_dev +104,PeekL(scrn_dev +148)) 
    PokeL(scrn_dev +108,PeekL(scrn_dev +152)) 
    PokeL(scrn_dev +112,PeekL(scrn_dev +156)) 
    ChangeDisplaySettings_(scrn_dev,4) 
    scrn_dev = 0 
  EndIf 
EndProcedure 


; bei diesem Aufruf wird einfach die Desktop-Auflösung als Parameter mit übergeben (und als Farbtiefe eben 16 Bit) - fertig... 

ChangeDisplay(GetSystemMetrics_(#SM_CXSCREEN),GetSystemMetrics_(#SM_CYSCREEN),16) 
MessageRequester("Test","Test") 
RestoreDisplay() 
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
