; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8747&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 15. December 2003
; OS: Windows
; Demo: No


; The function 'SetLayeredWindowAttributes' isnt available 
; on Win9x, so the procedure just ignores it on Win9x. 
; Works fine on Win2000+

Procedure SetWinTransparency(win,level) 
  If level>=0 And level<101 
    hLib = LoadLibrary_("user32.dll") 
    If hLib 
      adr = GetProcAddress_(hLib,"SetLayeredWindowAttributes") 
      If adr 
        SetWindowLong_(WindowID(win),#GWL_EXSTYLE,GetWindowLong_(WindowID(win),#GWL_EXSTYLE)|$00080000) ; #WS_EX_LAYERED = $00080000 
        CallFunctionFast(adr,WindowID(win),0,255*level/100,2) 
      EndIf 
      FreeLibrary_(hLib) 
    EndIf 
  EndIf 
EndProcedure 

OpenWindow(0,0,0,300,300,"Layered Window",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
  SetWinTransparency(0,60)
  If CreateGadgetList(WindowID(0)) 
    ButtonGadget(0,10,10,200,30,"Test")
  EndIf
Repeat:Until WaitWindowEvent()=#PB_Event_CloseWindow 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
