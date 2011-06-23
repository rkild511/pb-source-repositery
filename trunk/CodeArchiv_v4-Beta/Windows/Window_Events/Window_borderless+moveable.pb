; French forum: (http://www.serveurperso.com/~cederavic/forum/)
; Author: KarLKoX (updated for PB4.00 by blbltheworm)
; Date: 01. July 2003
; OS: Windows
; Demo: No

; This example show how to move a window without title bar. Use 
; left click and keep it down to start move. You will not see the window moving, but its shape. 

; NOTE by André: You need debugger enabled, to "kill" the window, as the example has no close button!


;- Window Constants 
; 
#Window_0 = 0 
#SizeWindowX = 300 
#SizeWindowY = 200 

Procedure DeplaceFenetre() 
   ReleaseCapture_() 
   ; Léger bug sous NT (il faut cliquer une fois pour que ca marche...)    
   ;SendMessage_(WindowID(), #WM_NCLBUTTONDOWN, #HTCAPTION, 0) 
   ; OK : génére un événement WM_LBUTTONDOWN + WM_MOUSEMOVE 
   SendMessage_(WindowID(#Window_0), #WM_SYSCOMMAND, #SC_MOVE + #HTCAPTION, 0) 
EndProcedure 

Procedure Open_Window_0() 

  If OpenWindow(#Window_0, 366, 211, #SizeWindowX , #SizeWindowY, "New window ( 0 )", #PB_Window_BorderLess) 
    If CreateGadgetList(WindowID(#Window_0)) 
      
    EndIf 
  EndIf 
EndProcedure 

Open_Window_0() 

Repeat 
  Event.l = WaitWindowEvent() 
  
  Select Event 
    Case #WM_LBUTTONDOWN 
      DeplaceFenetre() 
  EndSelect 
  
Until Event = #PB_Event_CloseWindow 

End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP