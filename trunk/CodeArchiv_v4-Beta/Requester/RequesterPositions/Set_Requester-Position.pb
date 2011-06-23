; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6719 
; Author: eddy (updated for PB3.93 by ts-soft, updated for PB 4.00 by Leonhard + KeyPusher) 
; Date: 25. June 2003 
; OS: Windows
; Demo: Yes


; Place the next requester at the current mouse position
; Platziert den nächsten Requester an der aktuellen Mausposition

;- Procedure-Code 
Global WINDOW_Requester 
; ///////////////////// 
; Set position 
; ///////////////////// 

Procedure SetRequesterPosition(x,y, ParentID=#PB_Ignore) 
  ;create the invisible window which defines the position of requester 
  If WINDOW_Requester = 0 
    If ParentID=#PB_Ignore 
      WINDOW_Requester =  OpenWindow(#PB_Any,x,y,0,0,"Temp Hidden Window",#PB_Window_BorderLess) 
    Else 
      WINDOW_Requester =  OpenWindow(#PB_Any,x,y,0,0,"Temp Hidden Window",#PB_Window_BorderLess,ParentID) 
    EndIf 
  EndIf 
  
  If WindowID(WINDOW_Requester) 
    ResizeWindow(WINDOW_Requester,x,y,#PB_Ignore,#PB_Ignore) 
  EndIf 
EndProcedure 


;- Example-Code 
GetCursorPos_(@pt.POINT) 
SetRequesterPosition(pt\x,pt\y) 
c = ColorRequester() 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
