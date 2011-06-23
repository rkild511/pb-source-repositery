; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=718&highlight=
; Author: dige
; Date: 09. October 2003
; OS: Windows
; Demo: Yes

InitSprite() 
If ExamineScreenModes() 
  While NextScreenMode() 
    Debug Str(ScreenModeWidth())+"x"+Str(ScreenModeHeight())+"x"+Str(ScreenModeDepth())+"@"+Str(ScreenModeRefreshRate())+"Hz" 
  Wend 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
