; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2786&highlight=
; Author: cnesm (updated for PB4.00 by blbltheworm)
; Date: 09. November 2003
; OS: Windows
; Demo: No

If OpenWindow(0, 100, 200, 195, 260, "Beispiel: AVI Abspielen", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) 

Buffer$=Space(128) 
Filename$="test.avi"  ; here the path + name of the avi file must be given
mciSendString_("PLAY "+ Filename$ + " FULLSCREEN",0,0,0) 

Repeat 
   EventID.l = WaitWindowEvent() 

    If EventID = #PB_Event_CloseWindow  ; If the user has pressed on the close button 
       mciSendString_("CLOSE FILM",0,0,0) 
       Quit = 1 
    EndIf 

  Until Quit = 1 
EndIf 

End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
