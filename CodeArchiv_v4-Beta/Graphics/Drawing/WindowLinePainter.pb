; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8120&highlight=
; Author: einander (updated for PB4.00 by blbltheworm)
; Date: 30. October 2003
; OS: Windows
; Demo: Yes

Global mx,my,mk

Procedure mx()
  ProcedureReturn WindowMouseX(0)
EndProcedure
Procedure my()
  ProcedureReturn WindowMouseY(0)
EndProcedure

Procedure MK(EV)
  Select EV
  Case #WM_LBUTTONDOWN  : If mk=2: mk=3: Else :  mk=1 :  EndIf
  Case #WM_LBUTTONUP    : If mk=3: mk=2: Else :  mk=0 :  EndIf
  Case #WM_RBUTTONDOWN  : If mk=1: mk=3: Else :  mk=2 :  EndIf
  Case #WM_RBUTTONUP    : If mk=3: mk=1: Else :  mk=0 :  EndIf
  EndSelect
EndProcedure

OpenWindow(0,0,0,500,300,"ImageGadget",#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
xant=mx():yant=my()
StartDrawing(WindowOutput(0))
Repeat
  Event=WaitWindowEvent()
  MK(Event)
  x=mx()  : y=my()
  If mk=1
    LineXY(xant,yant,x,y,RGB(0,0,0))
  EndIf
  xant=x:yant=y
Until Event=#PB_Event_CloseWindow
StopDrawing()
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
