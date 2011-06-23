; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=815&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 30. April 2003
; OS: Windows
; Demo: No

; 
; 
; by Danilo, 30.04.2003 - german forum 
; 
;   modified 11.12.2003 
; 
Procedure WindowClientMouseX(win)             ; added param, 11.12.03 
  ; Returns X-Position of MouseCursor 
  ; in the current window's client area 
  ; or -1 if mouse cursor isnt in this area. 
  GetCursorPos_(mouse.POINT) 
  ScreenToClient_(WindowID(win),mouse) 
  GetClientRect_(WindowID(win),rect.RECT) 
  If mouse\x < 0 Or mouse\x > rect\right 
    ProcedureReturn -1 
  ElseIf mouse\y < 0 Or mouse\y > rect\bottom ; added 11.12.03 
    ProcedureReturn - 1 
  Else 
    ProcedureReturn mouse\x 
  EndIf 
EndProcedure 

Procedure WindowClientMouseY(win)             ; added param, 11.12.03 
  ; Returns Y-Position of MouseCursor 
  ; in the current window's client area 
  ; or -1 if mouse cursor isnt in this area. 
  GetCursorPos_(mouse.POINT) 
  ScreenToClient_(WindowID(win),mouse) 
  GetClientRect_(WindowID(win),rect.RECT) 
  If mouse\y < 0 Or mouse\y > rect\bottom 
    ProcedureReturn -1 
  ElseIf mouse\x < 0 Or mouse\x > rect\right  ; added 11.12.03 
    ProcedureReturn - 1 
  Else 
    ProcedureReturn mouse\y 
  EndIf 
EndProcedure 

OpenWindow(1,200,200,300,300,"MousePos",#PB_Window_SystemMenu) 

Repeat 
  Select WaitWindowEvent() 
    Case #PB_Event_CloseWindow 
      End 
    Default 
      StartDrawing(WindowOutput(1)) 
        Box(0,0,300,300,0) 
        DrawingMode(1):FrontColor(RGB($FF,$FF,$00)) 
        DrawText(30,100,"MouseX: "+Str( WindowClientMouseX(1) )) 
        DrawText(30,120,"MouseY: "+Str( WindowClientMouseY(1) )) 
      StopDrawing()  
  EndSelect 
ForEver

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
