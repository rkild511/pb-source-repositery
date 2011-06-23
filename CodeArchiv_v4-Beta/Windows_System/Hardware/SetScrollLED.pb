; English forum: http://www.purebasic.fr/english/viewtopic.php?t=4130&highlight=
; Author: gnozal
; Date: 26. September 2003
; OS: Windows
; Demo: No

Procedure SetScrollLED(VKkey.l, bState.b) 

;Turn on And off caps lock, scroll lock And num lock 
;VKkey = #VK_CAPITAL, #VK_SCROLL, #VK_NUMLOCK 
;bState = #TRUE For on, #FALSE For off 

Dim keyState.b(256) 
GetKeyboardState_(@keyState(0)) 

If (bState = #True And keyState(VKkey) = 0) Or (bState = #False And keyState(VKkey) = 1) 
  keybd_event_(VKkey, 0, #KEYEVENTF_EXTENDEDKEY, 0) 
  keybd_event_(VKkey, 0, #KEYEVENTF_EXTENDEDKEY + #KEYEVENTF_KEYUP, 0) 
  keyState(VKkey) = bState 
  SetKeyboardState_(@keyState(0)) 
EndIf 

EndProcedure 


;- Example
SetScrollLED(#VK_NUMLOCK,#False)    ; turn off the NumLock LED


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
