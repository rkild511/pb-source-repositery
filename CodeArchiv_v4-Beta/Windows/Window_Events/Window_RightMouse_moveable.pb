; French forum: (http://www.serveurperso.com/~cederavic/forum/)
; Author: Le Soldat Inconnu (updated for PB4.00 by blbltheworm)
; Date: 24. June 2003
; OS: Windows
; Demo: Yes

; This example show how to move a window without title bar. Use 
; right click to start move and a new right click to stop it.

; NOTE by André: You need debugger enabled, to "kill" the window, as the example has no close button!



;- Window Constants 
; 
#Window_0 = 0 
#SizeWindowX = 300 
#SizeWindowY = 200 

Procedure Open_Window_0() 

  If OpenWindow(#Window_0, 366, 211, #SizeWindowX , #SizeWindowY, "New window ( 0 )", #PB_Window_BorderLess) 
    If CreateGadgetList(WindowID(#Window_0)) 
      
    EndIf 
  EndIf 
EndProcedure 


;- debut du prog 

Open_Window_0() 
ClicDroit = 0 

Repeat 
  Event = WaitWindowEvent() 
  
  If ClicDroit 
    X = WindowMouseX(#Window_0)-PositionX 
    Y = WindowMouseY(#Window_0)-PositionY 
    ResizeWindow(#Window_0,WindowX(#Window_0)+X,WindowY(#Window_0)+Y,#PB_Ignore,#PB_Ignore) 
  EndIf 

  If Event = #WM_RBUTTONDOWN ; clic droit avec la souris 
    ClicDroit = 1 - ClicDroit 
    If ClicDroit 
      PositionX = WindowMouseX(#Window_0) 
      PositionY = WindowMouseY(#Window_0) 
      ;Debug PositionX 
      ;Debug PositionY 
    EndIf 
  EndIf 
  
Until Event = #PB_Event_CloseWindow 

End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -