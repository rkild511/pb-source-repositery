; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7066&highlight=
; Author: AngelSoul (updated for PB4.00 by blbltheworm)
; Date: 30. July 2003
; OS: Windows
; Demo: Yes


; catch keys in a form....

Main = OpenWindow(1, 0, 0, 320, 200, "My Form", #PB_Window_MinimizeGadget)

Repeat
  Event=WindowEvent()
  If Event=256 ;Keypress detected
    kk=EventwParam() ;Value of the key in ascii
  EndIf
  If kk=27 ;if ESC key is pressed, terminate application
    End
  EndIf
  
  Delay(1) ;don't take all CPU power
ForEver

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
