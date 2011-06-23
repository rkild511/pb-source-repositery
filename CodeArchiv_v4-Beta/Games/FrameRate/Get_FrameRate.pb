; English forum: 
; Author: waffle
; Date: 29. May 2003
; OS: Windows
; Demo: No


; Example for calculating the actual FrameRate
; This code does NOT run directly, it must be included in the main loop of your own program/game...
TimeDelay.l=100 
MasterTimer.l=GetTickCount_() 
;game loop 
Repeat 
  FlipBuffers() 
  ;and other code... 

  TimeDelay=GetTickCount_()-MasterTimer 
  MasterTimer=GetTickCount_() 
  FrameRate.f=1000/TimeDelay 
Until quit

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -