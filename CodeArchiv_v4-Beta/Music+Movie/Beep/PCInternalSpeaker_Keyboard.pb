; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7604&highlight=
; Author: Dreglor
; Date: 20. September 2003
; OS: Windows
; Demo: No

; Use key 0-9 for playing, Esc to quit...

;******************************** 
;*Name: PC speaker keyboard     * 
;*By: Dreglor                   * 
;*last updated: 9-20-03 1:58pm  * 
;******************************** 

InitKeyboard() 
InitSprite() 
OpenScreen(1024,768,32,"") 
Repeat 
  ExamineKeyboard() 
  If KeyboardPushed(#PB_Key_1) 
    Beep_(500,1) 
  EndIf 
  If KeyboardPushed(#PB_Key_2) 
    Beep_(600,1) 
  EndIf 
  If KeyboardPushed(#PB_Key_3) 
    Beep_(700,1) 
  EndIf 
  If KeyboardPushed(#PB_Key_4) 
    Beep_(800,1) 
  EndIf 
  If KeyboardPushed(#PB_Key_5) 
    Beep_(900,1) 
  EndIf 
  If KeyboardPushed(#PB_Key_6) 
    Beep_(1000,1) 
  EndIf 
  If KeyboardPushed(#PB_Key_7) 
    Beep_(1100,1) 
  EndIf 
  If KeyboardPushed(#PB_Key_8) 
    Beep_(1200,1) 
  EndIf 
  If KeyboardPushed(#PB_Key_9) 
    Beep_(1300,1) 
  EndIf 
  If KeyboardPushed(#PB_Key_0) 
    Beep_(1400,1) 
  EndIf 
Until KeyboardPushed(#PB_Key_Escape) 
CloseScreen() 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
