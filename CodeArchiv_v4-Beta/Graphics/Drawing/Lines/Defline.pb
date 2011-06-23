; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7754&highlight=
; Author: einander (updated for PB4.00 by blbltheworm)
; Date: 07. October 2003
; OS: Windows
; Demo: No

Procedure Lin(x,y,x1,y1,Width,color) 
   hDC=GetDC_(WindowID(0)) 
   pen=CreatePen_(#PS_SOLID,Width,color)  ; You can also change the style with #Ps_dash, #Ps_dot, #Ps_dashdotdot, but only when the pen width equals 1. 
   hPenOld=SelectObject_(hDC,pen) 
   MoveToEx_(hDC,x,y,0):LineTo_(hDC,x1,y1) 
   DeleteObject_(pen) 
   DeleteObject_(hPenOld) 
EndProcedure 


_X=GetSystemMetrics_(#SM_CXSCREEN)-8 : _Y=GetSystemMetrics_(#SM_CYSCREEN)-68 
OpenWindow(0,0,0,_X,_Y,"",#WS_OVERLAPPEDWINDOW | #WS_MAXIMIZE) 

Lin(50,200,300,400,15,#Red) 
MessageRequester("","DONE",0)

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger
