; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8148&highlight=
; Author: fsw (updated for PB4.00 by blbltheworm)
; Date: 02. November 2003
; OS: Windows
; Demo: Yes

; Example Of A Statusbar Click Event 
; (c) 2003 - By FSW 
; 
; Tested under WinXP + Win98SE
; do whatever you want with it 
; 
#Window = 10 
#StatusbarFocus = 528 
#StatusBar = 1 

Procedure.l  LoWord (var.l) 
  ProcedureReturn var & $FFFF 
EndProcedure 


Procedure MyWindowCallback(WindowID, Message, wParam, lParam) 
  Result = #PB_ProcessPureBasicEvents 

  wParamLo = LoWord (wParam) 
  lParamLo = LoWord (lParam) 

;   If Message = #StatusbarFocus 
;     If wParamLo = 513 ;Left MouseButton 
;        MessageRequester("Message", "Left Mouse Click In StatusBar. "+"MousePos: "+Str(lParamLo)) 
;     ElseIf wParamLo = 516 ;Right MouseButton 
;       MessageRequester("Message", "Right Mouse Click In StatusBar") 
;     EndIf 
;   EndIf 

  If Message = #StatusbarFocus 
    If wParamLo = 513 And lParamLo < 270 ; 270 is the width of field 1 
      MessageRequester("Message", "Left Mouse Click In StatusBar Field 1. "+"MousePos: "+Str(lParamLo)) 
    ElseIf wParamLo = 513 And lParamLo > 270 + 2 ; there is a BAR between the 2 fields... 
      MessageRequester("Message", "Left Mouse Click In StatusBar Field 2. "+"MousePos: "+Str(lParamLo)) 
    ElseIf wParamLo = 516 
      MessageRequester("Message", "Right Mouse Click In StatusBar. "+"MousePos: "+Str(lParamLo)) 
    EndIf 
  EndIf 
  
  ProcedureReturn Result 
EndProcedure 


If OpenWindow(#Window,0,0,355,180,"Statusbar Click",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
    
  CreateStatusBar(#StatusBar, WindowID(#Window)) 
  StatusBarText(#StatusBar, 0, "Hello World!") 
    AddStatusBarField(270) 
    AddStatusBarField(80) 
  SetWindowCallback(@MyWindowCallback()) 

  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow 
    
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
