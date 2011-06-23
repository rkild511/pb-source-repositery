; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9188&highlight=
; Author: PB
; Date: 17. January 2004
; OS: Windows
; Demo: No

Procedure SetLEDKey(key$,newstate)
  Select LCase(key$)
  Case "c" : keycode=#VK_CAPITAL : oldstate=GetKeyState_(keycode)
  Case "n" : keycode=#VK_NUMLOCK : oldstate=GetKeyState_(keycode)
  Case "s" : keycode=#VK_SCROLL : oldstate=GetKeyState_(keycode)
  EndSelect
  If oldstate<>newstate
    keybd_event_(keycode,1,0,0)
    keybd_event_(keycode,1,#KEYEVENTF_KEYUP,0)
  EndIf
EndProcedure
;
SetLEDKey("c",1) ; Caps Lock on.
SetLEDKey("c",0) ; Caps Lock off.
;
SetLEDKey("n",1) ; Num Lock on.
SetLEDKey("n",0) ; Num Lock off.
;
SetLEDKey("s",1) ; Scroll Lock on.
SetLEDKey("s",0) ; Scroll Lock off.

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
