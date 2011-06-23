; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8472&highlight=
; Author: Codemonger (updated for PB 4.00 by Andre)
; Date: 24. November 2003
; OS: Windows
; Demo: No

;   ------------------------------------ 
;   WindowEx Library Written by Roger Beausoleil, download on www.PureArea.net
;   Example of MDI by Codemonger 
;   ------------------------------------ 

Enumeration 
  #MainWindow 
  #ChildWindow 
EndEnumeration 


     ;//Create the Parent Window 
        OpenWindow( #MainWindow, 0, 0, 640, 480, "Main Window", #PB_Window_SystemMenu | #PB_Window_ScreenCentered) 
      
     ;//Create the Child 
        OpenWindow( #ChildWindow, 10, 10, 200, 275, "Child Window", #PB_Window_SystemMenu) 
      
     ;// Get the styles of the child window 
        ChildStyle.l = WindowStyles( #ChildWindow ) 
        ChildEXStyle =WindowExStyles( #ChildWindow )  
      
     ;// Set the style of the child window and set the parent window 
        SetWindowStyles( #ChildWindow, ChildStyle.l, ChildEXStyle.l | #WS_EX_MDICHILD) 
        SetWindowParent( #ChildWindow, #MainWindow) 

      
      Repeat: Until WaitWindowEvent() =  #PB_Event_CloseWindow : End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
